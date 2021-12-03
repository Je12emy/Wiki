# Practica de Auditoria de Oracle DB

1. Activar la auditoria.
2. Crear un usuario llamado "semana 5" con cualquier contraseña.
3. Sobre  las siguientes operaciones aplicaremos auditoria para que al realizar estas operaciones podamos determinar que realizo el usuario.
    1. En este usuario vamos a crear una copia de la tabla regions de HR.
    2. Agregar una llave primaria al campo region_id.
    3. Insertar una región llamada: "America Central" con un código 5.
    4. Actualizar el nombre de la region con código 2 y ponerle "Norte America".
    5. Eliminar las regiones con código par.
    6. Hacer un query para leer los datos de la región con código 3.
    7. Borrar la tabla.

## Solución

Empecemos verificando si la auditoria se encuentra activa o no en nuestra base de datos.

```sql
SHOW PARAMETER AUDIT;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest                      string      D:\APP\JEREM\ADMIN\ORCL\ADUMP
audit_sys_operations                 boolean     FALSE
audit_trail                          string      DB
```

En mi caso se encuentra activa pero las operaciones del usuario sys no son auditadas.

Ahora creemos al usuario "Semana 5", con una contraseña de "root".

```sql
CREATE USER semana5 IDENTIFIED BY "root";
GRANT CREATE SESSION TO semana5;
```

Conecte monos como este usuario y creemos la copia de la tabla `regions` de `hr`.

```sql
CREATE TABLE regions_copy AS (
    SELECT * FROM hr.regions
);
ALTER TABLE regions_copy ADD CONSTRAINT regions_copy_pk PRIMARY KEY (region_id);
```

Auditemos las acciones de INSERT, UPDATE, DELETE y SELECCIONAR sobre la tabla `regions_copy`, con auditoria por objeto nos aseguramos de no saturar la vista enfocándonos en la vista de interés.

```sql
AUDIT SELECT, UPDATE, INSERT, DELETE ON semana5.regions_copy BY ACCESS;
```
Siguiente realizamos las operaciones deseadas sobre la tabla `regions_copy`.

```sql
INSERT INTO regions_copy (region_id, region_name) VALUES (5, 'America Central');
UPDATE TABLE regions_copy SET region_name='Norte America' WHERE region_id=2;
DELETE FROM regions_copy WHERE MOD(region_id, 2) = 0;
SELECT * FROM regions_copy;
DELETE FROM regions_copy;
```

Con el comando con el cual habilitamos la auditoria para esta tabla, se obtiene la siguiente salida en donde se pueden ver estas operaciones.

```sql
SELECT username, obj_name, action_name, timestamp FROM dba_audit_trail WHERE username = 'SEMANA5' ORDER BY timestamp DESC;

USERNAME        OBJ_NAME        ACTION_NAME     TIMESTAMP
--------------- --------------- --------------- -------------------
SEMANA5         REGIONS_COPY    DELETE          2021-10-17 23:30:37
SEMANA5         REGIONS_COPY    SELECT          2021-10-17 23:28:24
SEMANA5         REGIONS_COPY    DELETE          2021-10-17 23:28:15
SEMANA5         REGIONS_COPY    UPDATE          2021-10-17 23:25:37
SEMANA5         REGIONS_COPY    INSERT          2021-10-17 23:20:24
SEMANA5                         LOGON           2021-10-17 21:39:23
SEMANA5                         LOGON           2021-10-16 10:52:38
```

