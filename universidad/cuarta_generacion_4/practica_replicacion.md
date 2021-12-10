# Practica de Replicación de Datos

## Enunciado

- [x] Replicar a las tablas `employees` y `deparments` del esquema `HR` en una segunda instancia de Oracle.
    - [x] Si no cuenta con una segunda base de datos, creela con el `dbca` 
- [x] Configurar la duplicación cada 2 minutos.

## Solución

Configurar enlace entre instancias.

```sql
-- Sitio principal
GRANT CONNECT TO hr;

-- Sitio secundaria
GRANT UNLIMITED TABLESPACE TO hr;
CREATE PUBLIC DATABASE LINK orcl_link CONNECT TO hr IDENTIFIED BY root USING 'orcl';
```

Crear los `snapshots` en el sitio principal.

```sql
-- Sitio principal
CREATE SNAPSHOT LOG ON hr.employees;
CREATE SNAPSHOT LOG ON hr.departments;
```

Crear los `snapshots` en el sitio secundario.

```sql
-- Sitio secundaria
CREATE SNAPSHOT hr.employees_snap AS SELECT * FROM hr.employees@orcl_link;
CREATE SNAPSHOT hr.departments_snap AS SELECT * FROM hr.departments@orcl_link;
```

Configurar el `refresh group` para los `snapshots` creados

```sql
-- Solución propia
EXEC DBMS_REFRESH.MAKE ( name => 'hr.two_min', list => 'hr.employees_snap,hr.departments_snap', next_date => SYSDATE, interval => 'SYSDATE/24/120' );

-- Ejemplo enlinea
EXEC DBMS_REFRESH.MAKE ( name => 'hr.two_min', list => 'hr.employees_snap,hr.departments_snap', next_date => SYSDATE, interval => '/*2:Mins*/ sysdate + 2/(60*24)');
COMMIT;
```
*Nota:* Arreglar el tiempo de actualización, este no funciona.

Verificación

```sql
SELECT OWNER, NAME, TABLE_NAME, MASTER_VIEW, master_link FROM dba_snapshots WHERE OWNER = 'HR';

OWNER           NAME                 TABLE_NAME           MASTER_VIEW     MASTER_LINK
--------------- -------------------- -------------------- --------------- --------------------
HR              DEPARTMENTS_SNAP     DEPARTMENTS_SNAP                     @"ORCL_LINK"
HR              EMPLOYEES_SNAP       EMPLOYEES_SNAP                       @"ORCL_LINK"
```
