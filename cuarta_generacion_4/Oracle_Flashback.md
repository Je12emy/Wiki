# Oracle Flashback

Oracle Flashback nos permite volver a un punto **previo a una transacción**, esto es ideal en caso de que se haga `commit` en una transacción, se pierdan datos y se desee deshacer estos cambios. Esto aun seria posible con un backup de la base de datos pero implica una gran perdida, tanto monetaria, de tiempo, ventas, continuidad, etc por el tiempo fuera de linea. Aun así `flashback` **no es un remplazo** para los métodos tradicionales de recuperación de datos, sino un complemento que nos permite recuperar datos de forma más rápida y sensilla. 

| Tipo        | Información Usada | Escenario de Ejemplo                                                |
| ----------  | ----------------- | ------------------------------------------------------------------- |
| Database    | Flashback logs    | Deshacer un `TRUCATE TABLE` y cambios no deseados en muchas tablas. |
| Drop        | Recycle bin       | Deshacer un `DROP TABLE`.                                           |
| Table       | Datos undo        | Deshacer un `UPDATE` con un mal `WHERE`.                            |
| Query       | Datos undo        | Comparar datos de una table entre dos puntos en el tiempo.          |
| Version     | Datos undo        | Comparar versiones de una fila.                                     |
| Transaction | Datos undo        | Investigar varios estados de los datos históricamente               |

### Automatic Undo Management

Para hacer uso de `Oracle Flashback` es necesario configurar los siguientes parámetros de inicio.

* `UNDO_MANAGEMENT` con un valor de "auto".
* Asegurar que el `UNDO_TABLESPACE` cuenta con espacio suficiente.
* Configurar el `UNDO_RETENTION` que indica el tiempo (en segundo) en el cual guardamos imágenes de los datos.

_Nota:_ Con la vista `V$UNDOSTAT` podemos ver el tiempo especificado en el parámetro `UNDO_RETENTION`

```sql
ALTER SYSTEM SET UNDO_MANAGEMENT=AUTO SCOPE=spfile;

ALTER SYSTEM SET UNDO_RETENTION=<secconds>;

GRANT FLASHBACK ANY TABLE TO USER; -- Dar la posibilidad de recuperar tablas con Flashback a un esquema.
```
## Flashback Query

Permite ver una imagen de la tabla como era en un punto determinado en el pasado, lo podemos usar para:

* Recuperar información que perdimos o a la cual no podemos hacer `rollback`.
* Comparar datos actuales con datos históricos.
* Verificar el estado transaccional de una tabla en un periodo en el pasado.

Todo esto se puede hacer en vivo dentro de la base de datos, pero esto no es eterno, este hace uso de un area con un tamaño limitado y tenemos que resolver estos problemas lo antes posible ya que puede ser que los cambios ya no estén disponibles.

En `version` o `version query` nos referimos a los datos de una fila concreta por ejemplo todas las versiones de las transacciones que le han aplicado.

### ¿Cómo funciona Flashback Query?

Oracle guarda una imagen de los datos previo a una modificación y estos cambios son guardados en el `UNDO tablesplace`. Como tal es posible definir el periodo de tiempo en el cual flashback guarda dichas imágenes.

Para que funcione `flashback`, tiene que estar activado el `Automatic Undo Management` que permite definir por cuanto tiempo queremos retener los fragmentos de información `UNDO`, este es un parámetro de inicio llamado `undo_retention`


Usando `flashback query`.

```sql
SELECT * FROM <SCHEMA>.<TABLE> AS OF TIMESTAMP  -- Se usa la clausula "AS OF TIMESTAMP <TIMESTAMP>" para indicar un punto inicial de tiempo 
TO_TIMESTAMP('DD-MM-YYYY HH:MM:SS'); 

SELECT * FROM SCHEMA.TABLE AS OF SCN(#);        -- Un SCN es un identificador de una transacción, el "current" se obtiene de V$DATABASE.
                                                -- SELECT current_scn FROM v$database;
```

Pongamos esto en practica, asumiendo que borramos registros de una tabla y ejecutamos un `commit`, ya no podemos hacer uso de un `rollback` para recuperar dichos datos.

```sql
ALTER SYSTEM SET undo_retention = 1200;
DELETE FROM empleados WHERE deptno = 10;    -- 11:16:04
COMMIT;                                     -- 11:16:14
```
Podemos ver estos datos, asumiendo que aun nos encontramos dentro del tiempo de retención que especificamos.

```sql
SELECT * FROM empleados 
aS OF TIMESTAMP
TO_TIMESMTAP ('13-03-2009 11:16:14')        -- Especificamos desde cuando queremos traer datos, debemos tener cuidado con el tiempo de flashback.
```

Junto a esto podemos ver la diferencia entre los datos históricos y los actuales.

```sql
SELECT * FROM empleados 
AS OF TIMESTAMP
TO_TIMESMTAP ('13-03-2009 11:16:14')        
MINUS
SELECT * FROM empleados;
```

Podemos incluso insertar la diferencia entre las tablas.

```sql
INSERT INTO empleados
(
    SELECT * FROM empleados 
    aS OF TIMESTAMP
    TO_TIMESMTAP ('13-03-2009 11:16:14');
    MINUS                                   
    SELECT * FROM empleados;
);
```

Tampoco nos encontramos limitados a usar queries sin la clausula `WHERE`.

```sql
SELECT * FROM empleados 
aS OF TIMESTAMP
TO_TIMESMTAP ('13-03-2009 11:16:14')        
WHERE last_name = 'Chung'.
```

### Consejos para Usar Flashback Query

* Se puede especificar u omitir la clausula `AS OF`.
* Se recomienda usar `SNC` sobre un timestamp, en tablas que sean muy transaccionales.
* Es posible crear una vista para consultar esta información histórica.
* Podemos especificar un lapso estático basado en nuestro tiempo actual.
 
```sql
CREATE VIEW hour_ago AS
SELECT * FROM employees
AS OF TIMESTAMP (SYSTEMSTAMP - INTERVAL '60' MINUTE); -- Siempre obtenemos los últimos 60 minutos
```
* Para conocer el ultimo `SCN` podemos usar el siguiente paquete.

```sql
DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
```
* Podemos obtener el `SCN` con la pseudo-columa `ORA_ROWSCN`.

```sql
SELECT ora_rowscn, lastname, salary 
FROM employees
WHERE employee_id = 7788;

ORA_ROWSCN  NAME   SALARY 
----------  ----   ------
202553      Joe     3000
```

## Flashback Data Archive

Nos permite hacer flashbacks más completos o un bien un "flashback total", permite registrar **todos** los cambios que se producen en un juego de tablas, ademas se pueden consultar los datos de estas tablas en cualquier punto del tiempo hasta un máximo determinado por nosotros (mediante en `undo_retention`). Esto por defecto viene deshabilitado y tenemos que cumplir con las siguientes condiciones.

* Contar con el privilegio `FLASHBACK ARCHIVE` sobre dicha tabla.
* No se puede hacer esta operación sobre tablas de tipo `NESTED`, `CLUSTERED` ni `EXTERNAL` (Una tabla externa es aquella lee datos de una fuente externa por ejemplo de un excel).
* La tabla no puede contener columnas de tipo `LONG` ni `Nested`

Deberíamos crear un `tablespace` especial para Flashback Data Archive.

```sql
CREATE TABLESPACE FBA DATAFILE 'u02/app/oracle/oradata/OCM/fba01.dbf' SIZE 500M;
```

Creamos un archivo de recuperación defecto para el Flashback DATA Archive.

```sql
CREATE FLASHBACK ARCHIVE DEFAULT FLA1 TABLESPLACE FBA QUOTA 500M RETENTION 1 YEAR.
```

Activamos Flashback Data Archive para una tabla deseada.

```sql
ALTER TABLE hr.employees FLASHBACK ARCHIVE;
```

Veamos esto en practica, asumamos que vamos a ejecutar un conjunto de operaciones sobre una tabla en particular.

```sql
-- Preparación para obtener el timestamp actual
ALTER SESSION SET nls_date_format='YYYY/MM/DD HH24:MI:SS';
SELECT sysdate FROM dual;
SELECT dbms_flashback.get_system_change_number FROM dual;
-- Operaciones
DELETE FROM hr.employees WHERE employee_id = 1;
COMMIT;
UPDATE hr.employees SET salary = 12000 WHERE employee_id = 168;
COMMIT;
UPDATE hr.employees SET salary = 12500 WHERE employee_id = 168;
COMMIT;
UPDATE hr.employees SET salary = 12550 WHERE employee_id = 168;
COMMIT;
```

¿Ahora como hacemos estas transacciones?

Podemos empezar con el usuario que fue removido usando un `flashback query` para comparar las diferencias de la tabla basado en un periodo.

```sql
SELECT employee_id, fist_name, last_name
FROM employees
AS OF TIMESTAMP 
TO_TIMESTAMP('2013/06/21 08:31:36', 'YYYY/MM/DD HH24:MI:SS')
MINUS
SELECT employee_id, fist_name, last_name
FROM employees;
```

Para obtener las versiones del registro con un id de 168, esto se hace con un `version query`.

```sql
SELECT  versions_starttime,
        versions_startscn,
        first_name,
        last_name,
        salary
FROM hr.employees 
VERSIONS BETWEEN TIMESTAMP
TO_TIMESTAMP('2018/11/10 09:45:30', 'YYYY/MM/DD HH24:MI:SS') -- Es posible omitir el formato de nuestro timestamp, mientras que encaje con el definido en nls_date_format.
AND SYSTIMESTAMP WHERE employee_id = 168;
```

Adicionalmente podemos usar el `SCN` que obtenemos de esta consulta previa.

```sql
SELECT first_name, last_name, salary
FROM hr.employees AS OF SCN 4686793 
WHERE employee_id = 168; -- 
```
_Nota:_ En esta consulta obtenemos el cambio generado con este `SCN`, podemos usar un `BETWEEN` también.

## Flashback Version Query

Nos retorna las versiones por las que ha pasado una columna en especifico, acá una versión nueva es generada por cada `commit` que se ejecuta, este nos permite utilizar varias pseudo-columas.

```sql
SELECT  versions_startscn
        versions_starttime,
        versions_endscn,
        versions_endtime,
        versions_xid, -- Nos indica cual transacción en cuestión genero esta versión, con esto podemos hacerle un rollback.
        versions_operations,
        last_name,
        salary
FROM hr.employees
VERSIONS BETWEEN
TO_TIMESTAMP('2008-12-18 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
AND
TO_TIMESTAMP('2008-12-18 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
WHERE first_name = 'John';
```

## Flashback Transaction Query

Nos retorna información sobre una transacción puede Utilizar el `xid` de una operación para obtener **la consulta exacta** para deshacer dicha transacción.

```sql
SELECT  xid,
        operation,
        startscn,
        commit_scn,
        logon_user,
        undo_sql -- Esta columna nos retorna el SQL necesario para deshacer la transacción con el XID que extrajimos
FROM flashback_transaction_query
WHERE xid = HEXTORAW('00020003000002D');
```

Veamos ahora al `flashback version` y `flashback transaction` queries juntos en una sola consulta.

```sql
SELECT  xid,
        logon_user,
FROM flashback_transaction_query
WHERE xid IN (
    SELECT  versions_xid 
    FROM hr.employees VERSIONS 
    BETWEEN TIMESTAMP
    TO_TIMESTAMP('2003-07-18 14:00:00', 'YYYY-MM-DD HH24:MI:SS')
    AND
    TO_TIMESTAMP('2003-07-18 17:00:00', 'YYYY-MM-DD HH24:MI:SS')
);
```

### Requerimientos

Para este tipo de flashback, debemos primero asegurarnos de cumplir con los siguientes requerimientos.

* Habilitar datos de depuración adicionales.

```sql
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
```

* Proporcionar los permisos necesarios para usar este tipo de consulta.

```sql
GRANT SELECT ANY TRANSACTION TO <user> ON <schema>;
```

## Flashback Table

Permite recuperar una tabla directamente, por ejemplo que se haya borrado por accidente.

```sql
FLASHBACK TABLE <tabla> TO SCN 5607547;
```

Se puede usar la papelera incluida en Oracle (Esta es similar a la papelera de Windows)

```sql
FLASHBACK TABLE employees TO BEFORE DROP;
```

Ahora recuperemos esta misma tabla pero con otro nombre.

```sql
FLASHBACK TABLE employees TO BEFORE DROP RENAME TO new_employes;
```

En este proceso de recuperación los indices y triggers de esta tabla aun estarán en la papelera, por lo cual tenemos que recuperarlos junto a esta con otra consulta usando a la papelera.

Primero tenemos que buscar a estos dos objetos dentro de la papelera.

```sql
SELECT  object_name,        -- "BIN$04LhcpnganfgMAAAAAANPw==$0"
        original_name,      -- "tigger_employess..."
        type                -- trigger
FROM user_recyclebin        -- También tenemos v$recyclebin y dba_recyclebin
WHERE base_object = (       -- Obtenemos el campo base_object usando el nombre original en un subquery
    SELECT base_object
    FROM user_recyclebin
    WHERE original_name = '%table'
)
AND ORIGINAL_NAME != '%table';
```

Siguiente recuperamos los objetos, renombrándolos desde la papelera con su nombre original

```sql
ALTER TRIGGER "BIN$04LhcpnganfgMAAAAAANPw==$0" RENAME TO <nombre>;
ALTER INDEX "BIN$04LhcpnganfgMVVVVBBBNPw==$0" RENAME TO <nombre>;
```

Ademas estos objetos tienen que ser re-compilados ya que traen PL/SQL, esto se puede hacer desde una herramienta gráfico o con el siguiente commando.

```sql
ALTER TRIGGER "<name>" COMPILE;
```

### Requisitos para Pluggable Database

Para usar este tipo de flashback en un ambiente con `Pluggable Database` tenemos que cumplir con los siguientes requerimientos.

* Configurar el `Fast Recovery Area`.

```sql
ALTER SYSTEM SET db_recovery_file_dest = '/uo3/app/oracle/fast_recovery_area' SCOPE=both;
```

* Configurar la retención de los `Flashback Logs`.

```sql
ALTER SYSTEM SET db_flashback_retention_target =4320 SCOPE=both;
```

* Habilitar flashback a nivel del contenedor.

```sql
ALTER DATABASE FLASHBACK;
```

* Verificar si el contenedor tiene habilitado flashback.

```sql
SELECT flashback_on FROM v$database;

FlASHBACK_ON
-------------
YES
```

#### Tips para Usar Flashback en PDB

En ambientes con `Pluggable Databases` se recomiendan las siguientes buenas practicas.

* Utilizar `FORCE LOGGING` en la PDB individual, ya que puede ser que no todas hagan uso de esto.

```sql
SELECT pdb_name, force_loggin, force_nologging FROM cdb_pdbs;

PDB_NAME    FORCE_LOGGIN    FORCE_NOLOGGIN
----------  ------------    --------------
PDB$SEED    NO              NO
NUVOLAPDB1  YES             NO
NUVOLAPDB2  NO              NO
```

* Verificar que el `tablespace` de la `PDB` donde se usara flashback, tenga esta característica habilitada

```SQL
SHOW con_name;

CON_NAME
--------
NUVOLAPDB1

SELECT ts#, flashback_on FROM v$tablespace;

TS#     FLASHBACK_ON
---     ------------
0       YES
1       YES
2       YES
3       YES
```

* Para activar esto seguimos el siguiente proceso.

```sql
-- A nivel de contenedor
ALTER DATABASE FLASHBACK;
ALTER SESSION SET CONTAINER = pdb5;
-- A nivel de PDB
ALTER PLUGGABLE DATABASE pdb5 OPEN READ WRITE RESTRICTED FORCE; -- Se pone el PDB en modo restringido
ALTER PLUGGABLE DATABASE pdb5 LOGGIN;                           -- Se habilita el loggin
ALTER PLUGGABLE DATABASE pdb5 OPEN READ WRITE FORCE;            -- Se abre la escritura
-- Verificar
SELECT tablespace_name, logging
FROM dba_tablespaces
ORDER BY tablespace_name;

TABLESPACE_NAME     LOGGING
-----------------   ---------
SYSAUX              LOGGING
SYSTEM              LOGGING
TEMP                NOLOGGING
TESTT1_TS           LOGGING
```

### La Papelera de Reciclaje

A continuación veremos unos cuantos comandos útiles para interactuar con la papelera de reciclaje.

* Para ver el contenido de la papelera de reciclaje.

```sql
SHOW RECYCLEBIN;
SELECT * FROM recyclebin;
```

* Limpiar el contenido de la papelera.

```sql
-- Remover todo el contenido.
PURGE RECYCLEBIN;
PRUGE DBA_RECYCLEBIN;
-- Remover un objeto en específico.
PURGE TABLE BIN$04LhcpnganfgMAAAAAANPw==$0;
PURGE TABLE employees;
PURGE TABLESAPCE x USER y;
```

_Nota:_ La papelera dura lo mismo que tengamos configurado en nuestro `undo_retention`.
