# Ejercicio Oracle Flashback

Vamos primero a habilitar Oracle Flashback en nuestra base de datos.

Empecemos habilitando `Automatic Undo Management`

```sql
ALTER SYSTEM SET undo_management=auto SCOPE=spfile;
```

Después de esto sera necesario reiniciar nuestra instancia.

En mi caso este ya se encontraba habilitado.

```sql
SHOW PARAMETER undo_management;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_management                      string      AUTO
```

También podemos verificar el tiempo de retención con el que estamos trabajando.

```sql
SHOW PARAMETER undo_retention;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_retention                       integer     900
```

## Primera Parte

Siguiente creemos la tabla `empleados` y `departamentos`.

```sql
CREATE TABLE empleados (
    empno NUMBER PRIMARY KEY NOT NULL,
    empname VARCHAR2(16) NOT NULL,
    salary NUMBER NOT NULL
);

CREATE TABLE departamentos (
    deptno NUMBER PRIMARY KEY NOT NULL,
    deptname VARCHAR(32) NOT NULL
);
```

Ahora insertemos registros en ambas tablas, esto ocurre aproximadamente a las `22:36` del `13/10/2021`

```sql
INSERT INTO departamentos (deptno, deptname) VALUES (50, 'Accounting');
INSERT INTO empleados (empno, empname, salary) VALUES (111, 'Mike', 555);
COMMIT;
```

Vamos ahora a modificar al empleado `Mike`.

```sql
UPDATE empleados SET salary = 666 WHERE empno = 111;
INSERT INTO departamentos (deptno, deptname) VALUES (20, 'Finance');
DELETE FROM empleados WHERE empno = 111;
COMMIT;
```

Insertamos un nuevo registro en la tabla de empleados.

```sql
INSERT INTO empleados (empno, empname, salary) VALUES (111, 'Tom', 777);
UPDATE empleados SET salary = 888 WHERE empno = 111;
UPDATE empleados SET salary = 927 WHERE empno = 111;
COMMIT;
```

Usemos un `flashback version query` ahora para ver el historia de esta columna.

```sql
SELECT  versions_starttime,
        versions_xid,
        versions_startscn,
        versions_operation,
        empno, empname,
        salary 
        FROM empleados
        VERSIONS BETWEEN TIMESTAMP 
        TO_TIMESTAMP('13-10-2021 22:30:06', 'DD-MM-YYYY HH24:MI:SS')
        AND
        SYSTIMESTAMP
        WHERE empno = 111 
        ORDER BY versions_starttime ASC;

     EMPNO EMPNAME              SALARY VERSIONS_XID     VERSIONS_STARTSCN VERSIONS_ENDSCN VERSI
---------- ---------------- ---------- ---------------- ----------------- --------------- -----
       111 Mike                    555 080001001D060000           4118964                 D
       111 Tom                     927 0A002100B4130000           4118988                 I
       111 Mike                    555                                            4118964
        
```
Siguiente veremos el detalle de una transacción, usaremos el `XID` que obtuvimos para ejecutar un `Transaction Query` asumiendo que el error fue eliminar al usuario Mike entonces usaremos al `XID` de `0900070016060000`.

```sql
SELECT  xid,
        operation,
        start_scn,
        commit_scn,
        logon_user,
        undo_sql 
FROM flashback_transaction_query
WHERE xid = HEXTORAW('080001001D060000');


XID                  OPERATION   START_SCN COMMIT_SCN LOGON_USER UNDO_SQL
-------------------- ---------- ---------- ---------- ---------- ---------------------------------------------
0900070016060000     DELETE        3920484    3920485 SCOTT      insert into "SCOTT"."EMPLEADOS"("EMPNO","EMPN
                                                                 AME","SALARY") values ('111','Mike','666');

0900070016060000     INSERT        3920484    3920485 SCOTT      delete from "SCOTT"."DEPARTAMENTOS" where ROW
                                                                 ID = 'AAASw8AAEAAAAItAAD';

0900070016060000     UPDATE        3920484    3920485 SCOTT      update "SCOTT"."EMPLEADOS" set "SALARY" = '55
                                                                 5' where ROWID = 'AAASw6AAEAAAAI9AAA';

0900070016060000     BEGIN         3920484    3920485 SCOTT
```

## Segunda Parte

Acá vamos a trabajar con una copia de la tabla `employees` veamos primero con cual esquema trabajar.

```sql
SELECT owner FROM dba_tables WHERE table_name = 'EMPLOYEES';

OWNER
-------
HR
```

Y creemos la copia de la tabla, yo llamara a esta copia `employees_copy`.

```sql
CREATE TABLE employees_copy AS (
        SELECT * FROM hr.employees
);
```

Ahora eliminaremos los registros dentro de esta tabla en donde la columna `department_id` sea igual a 80, en mi caso esto ocurre aproximadamente a las `23:07:17` del `13/10/2021`.

```sql
DELETE FROM employees_copy WHERE department_id=80;
```

Ahora veamos cuales fueron los registros borrados usando un `Flashback Query`, acá podremos ver los registros borrados.

```sql
SELECT employee_id, first_name, last_name, department_id FROM employees_copy
AS OF TIMESTAMP
TO_TIMESTAMP('2021/10/13 23:09:17', 'YYYY/MM/DD HH24:MI:SS')
ORDER BY department_id DESC;

EMPLOYEE_ID FIRST_NAME           LAST_NAME                 DEPARTMENT_ID
----------- -------------------- ------------------------- -------------
        178 Kimberely            Grant
        205 Shelley              Higgins                             110
        206 William              Gietz                               110
        102 Lex                  De Haan                              90
        ...
        ... Omitido
        ...
        145 John                 Russell                              80 <-- Registros removidos en ese timestamp
        179 Charles              Johnson                              80
        147 Alberto              Errazuriz                            80
        148 Gerald               Cambrault                            80
        149 Eleni                Zlotkey                              80
        150 Peter                Tucker                               80
```

Podemos entonces juntar a este `Flashback Query` con un minus para ver la diferencia con el estado actual de la tabla `employees_copy`.

```sql
SELECT  employee_id,
        first_name,
        last_name,
        department_id
FROM employees_copy
AS OF TIMESTAMP
TO_TIMESTAMP('2021/10/13 23:09:17', 'YYYY/MM/DD HH24:MI:SS')
MINUS
SELECT employee_id, first_name, last_name, department_id FROM employees_copy
ORDER BY department_id DESC;

EMPLOYEE_ID FIRST_NAME           LAST_NAME                 DEPARTMENT_ID
----------- -------------------- ------------------------- -------------
        145 John                 Russell                              80
        146 Karen                Partners                             80
        147 Alberto              Errazuriz                            80
        148 Gerald               Cambrault                            80
        149 Eleni                Zlotkey                              80
        150 Peter                Tucker                               80
        151 David                Bernstein                            80
        152 Peter                Hall                                 80
        ...
        ... Omitido
        ...
34 rows selected.
```

Ahora restauremos a estos registros, usando un `INSERT` junto a esta consulta.

```sql
INSERT INTO employees_copy
(
        SELECT  *
        FROM employees_copy
        AS OF TIMESTAMP
        TO_TIMESTAMP('2021/10/13 23:09:17', 'YYYY/MM/DD HH24:MI:SS')
        MINUS
        SELECT * FROM employees_copy
);
```

Podremos ahora ver los registros eliminados.

```sql
SELECT  employee_id,
        first_name,
        last_name,
        department_id
        FROM employees_copy
        ORDER BY department_id DESC;

EMPLOYEE_ID FIRST_NAME           LAST_NAME                 DEPARTMENT_ID
----------- -------------------- ------------------------- -------------
        178 Kimberely            Grant
        205 Shelley              Higgins                             110
        206 William              Gietz                               110
        109 Daniel               Faviet                              100
        108 Nancy                Greenberg                           100
        110 John                 Chen                                100
        113 Luis                 Popp                                100
        112 Jose Manuel          Urman                               100
        111 Ismael               Sciarra                             100
        101 Neena                Kochhar                              90
        100 Steven               King                                 90

EMPLOYEE_ID FIRST_NAME           LAST_NAME                 DEPARTMENT_ID
----------- -------------------- ------------------------- -------------
        102 Lex                  De Haan                              90
        145 John                 Russell                              80
        146 Karen                Partners                             80
        147 Alberto              Errazuriz                            80
        148 Gerald               Cambrault                            80
        149 Eleni                Zlotkey                              80
        150 Peter                Tucker                               80
        151 David                Bernstein                            80
        152 Peter                Hall                                 80
        153 Christopher          Olsen                                80
        154 Nanette              Cambrault                            80

```
