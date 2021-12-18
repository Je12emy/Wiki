# Auditoria Oracle DB

Veremos los comandos y configuraciones necesarias para extraer información de auditoria de una base de datos de Oracle, con auditoria nos referimos a verificar las operaciones que se han realizado sobre la base de datos.

La auditoria no es la misma en todas las bases de datos, en Oracle tiene la las siguientes características.

* Busca controlar y registrar acciones de determinados usuarios de la base de datos, "determinados" por que no podemos registrar las acciones de los cientos de usuarios que hacen uso de la base de datos, ya que las tablas de auditoria pueden crecer en gran manera. Esto va de la mano con nuestro plan de auditoria, en donde definimos a aquellos usuarios de interés por auditar.
* La información de auditoria se puede ver a nivel de Sistema Operativo y al nivel de la base de datos, podemos escoger en donde la queremos guardar.
* La información sobre el evento auditado se almacenará en la vista `Audit Trail`, esta "concentra" todos los datos de la auditoria pero debemos definir que queremos generar para este.

**¿Qué ventajas nos da aplicar auditoria?**

* Control.
* Administrar mejor la información.
* Seguridad.

**¿Qué desventajas existen?**
 
* El almacenamiento puede ser un tema complicado, pero esto depende mucho de como generamos los datos de auditoria. Acá los vistas de auditoria pueden crecer mucho y debemos definir como queremos guardar esta información.

## ¿Como Iniciar una Auditoria?

Primero tenemos que asegurarnos que el parámetro `AUDIT TRAIL` este en `true`, este prepara a la BD para empezar a guardar la información de los comandos.

```sql
SHOW PARAMETER AUDIT_TRAIL;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
audit_trail                          string      DB
```

_Nota:_ Acá `DB` es lo mismo que `true`, esto lo veremos más adelante.

Toda la información de la auditoria se genera dentro de una vista, llamada `SYS.AUD$`, si por alguna razón al momento de crear la BD y esta vista no fue creada debemos ejecutar el script `@cataudit.sql` (en `admin/rdbms`) para crear las vistas relacionadas.

## Información Obtenible

Al hacer uso de la auditoria, podemos obtener la siguiente información de nuestra base de datos.

* Que operación realizo un usuario _determinado_, para el cual definimos que operación queremos obtener en especifico.
* El objeto o los objetos a los que accedió dicho usuario.
* Fecha y hora del proceso.
* Código de la acción, todos los eventos se encuentran clasificados.
* **No se refleja la información que se modificó.**

## Que se debe de Auditar

* Decidir cual sera el objetivo de la auditoria sobre la base de datos.
* Mantener la información de la auditoria en forma manejable.
* Establecer guías para actividades sospechosas, ej un usuario que se conecta afuera de su horario de trabajo.
* Establecer guías para actividades normales de la base de datos, ej CRUD sobre una tabla específica digamos actualizaciones sobre una tabla de créditos, conectarse y desconectarse.

## Recomendaciones al usar Auditoria

* Mantener la información de auditoria manejable: Mediante un plan de auditoria definimos que información es relevante para auditar y para que esquema especifico, así evitamos que esta vista crezca exponencialmente.

## Tipos de Auditoria

Vamos a encontrar varios tipos de auditoria según el tipo de información que deseamos recolectar.

### Statement Auditing/Nivel de Sentencia

Podemos aplicar la auditoria a nivel de sentencia, en donde auditamos la sentencia `dll` o comando que se aplica sobre la BD

### Privilege Auditing/Nivel de Privilegio

Aplicamos la auditoria sobre los permisos de cada usuario, así saber quien esta intentando hacer por ejemplo un `CREATE TABLE` y si tiene dicho permiso.

### Schema Auditing/Nivel de Objeto de Esquema

Aplicamos la auditoria sobre un objeto digamos una tabla, vista y las operaciones realizadas sobre este.

### Fine-Grained Auditing/Nivel Granular

Este tipo adicional se basa en el contenido, se centra en el acceso o los cambios en una columna en específico.

## Aplicando la Auditoria

Para activar la auditoria usamos el siguiente commando.

```sql
AUDIT <commando por auditar>    
BY <usuario>                    -- Escogemos el tipo de auditoria
BY SESSION                      
BY ACCESS                       
WHENEVER SUCCESFULL             -- Indicamos si deseamos mostrar operaciones exitosas o fallidas
WHENEVER NOT SUCCESFULL;
```
_Nota:_ Si no se especifica si se quieren operaciones exitosas o fallidas, Oracle auditara ambas.

Acá hay que diferenciar entre las clausulas `BY SESSION` y `BY ACCESS`.

* `BY SESSION`: Por la sesión que establece un usuario solo quedara un registro en la vista de auditoria.
* `BY ACCESS`: Cada vez que el usuario haga algo, se genera un registro en la vista de auditoria.

Entonces si se audita `BY SESSION` y se usara un `CREATE TABLE` 5 veces, en la vista de auditoria solo se generara un solo registro, pero usando `BY ACCESS` quedaran las 5 acciones en la vista.

```
ACTION_NAME OBJ_NAME SESSION_ID USERNAME TIMESTAMP
----------- -------- ---------- -------- -------------------
SESSION REC EMP       328523    SCOTT    14-NOV-13 14:28:12
SESSION REC DEPT      328523    SCOTT    14-NOV-13 14:28:17
SESSION REC DEPT      328549    SCOTT    14-NOV-13 14:28:45
SESSION REC DEPT      328551    SCOTT    14-NOV-13 14:27:12
SESSION REC DEPT      328551    HR       14-NOV-13 14:26:30 <-- BY SESSION: Las operaciones de un tipo de HR son registradas bajo un solo registro
INSERT      PRODUCT   328552    HR       14-NOV-13 14:26:01 <-- BY ACCESS: Cada operación de HR es registrada
DELETE      PRODUCT   328552    HR       14-NOV-13 13:45:44
INSERT      PRODUCT   328552    OE       14-NOV-13 13:45:15
INSERT      PRODUCT   328553    SCOTT    14-NOV-13 14:45:05 <-- BY ACCESS: Cada operación de SCOTT es registrada
INSERT      PRODUCT   328553    SCOTT    14-NOV-13 14:44:55
```

Veamos unos ejemplos de auditoria.

```sql
AUDIT SESSION;                          -- Auditar las conexiones y desconexiones.
AUDIT CREATE TABLE BY SESSION;          -- Auditar los comandos de CREATE TABLE en todas las sesiones, no solo para un usuario.
AUDIT TABLE WHENEVER NOT SUCCESSFUL;    -- Auditar los commandos asociados a tablas.
```

**Auditar un privilegio del sistema**

```sql
AUDIT CREATE ANY INDEX;
AUDIT CREATE ANY INDEX WHENEVER NOT SUCCESSFULL;
```

**Auditoria sobre objetos**, como vimos esto aplica para todos los usuarios de la BD, se usa la palabra clave `ON`.

```sql
AUDIT SELECT ON hr.employees;   -- Auditamos cualquier tipo de SELECT sobre la tabla employees;
```

Para desactivar una auditoria usamos casi el mismo comando.

```sql
NOAUDIT SESSION;
NOAUDIT DELETE ANY TABLE;
NOAUDIT SELECT TABLE, INSERT TABLE, DELETE TABLE, EXECUTE PROCEDURE;
NOAUDIT ALL;
NOAUDIT ALL PRIVILEGES;
NOAUDIT DELETE ON emp;
NOAUDIT SELECT, INSERT, DELETE ON jward.dept;
NOAUDIT CREATE ANY INDEX;
```

Podemos auditar adicionalmente a los usuarios que se conectan como `sys`.

```
AUDIT_SYS_OPERATIONS = TRUE
```

Podemos ver que comandos de auditoria se encuentran activos en la vista de `dba_audit_trail`.

```sql
SELECT  obj_name,
        sessionid,
        username,
        ses_actions,
        timstamp
FROM dba_audit_trail;

OBJ_NAME SESSIONID  USERNAME SES_ACTIONS    TIMESTAMP
EMP      328223     SCOTT    ---S--S---S--- 14-NOV-13 14:28:12
```

En la columna `SES_ACTIONS` se marca la acción de la sesión según el siguiente orden: `ALTER|AUDIT|COMMENT|DELETE|GRANT|INDEX|INSERT|LOCK|RENAME|SELECT|UPDATE|REFERENCES|EXECUTE|READ`, en donde `S` significa "successful",`F` significa "failed" y `B` significa "both"


### Borrar Datos de la Auditoria

Para borrar o limpiar la vista con información de auditoria llamada `sys.aud$` usamos los siguientes comandos.

```sql
DELETE FROM sys.aud$;
DELETE FROM sys.aud$ WHERE obj$ame='EMP';
```

Podemos ver que esta es una simple vista común y corriente, así que los comandos de `DELETE` funcionan sobre esta. Para proteger esta vista, simplemente podemos auditarla.

```sql
AUDIT INSERT, UPDATE, DELETE
ON sys.aud$
BY ACCESS;
```

## El Parámetro Audit Trail

El parámetro `AUDIT_TRAIL` puede tener los siguientes valores.

* `none` o `false`: La auditoria esta deshabilitada.
* `db` o `true`: La auditoria esta habilitada y se guarda dentro de la BD.
* `db extended`: Muestra **la sentencia realizada** por el usuario.
* `xml`: La auditoria esta habilitada y los registros son guardados en un archivo con formato `xml`.
* `xml extended`: La auditoria esta habilitada y los registros son guardados en un archivo con formato `xml` pero se guardan las sentencias SQL.
* `os`: La auditoria esta habilitada pero los registros son enviados a la traza de auditoria del sistema operativo

Podemos ver en donde se guardan los archivos físicos con el command audit.

```sql
SHOW PARAMETER AUDIT;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
audit_file_dest                      string      D:\APP\JEREM\ADMIN\ORCL\ADUMP <-- Destino en donde se guardarían archivos físicos xml
audit_sys_operations                 boolean     FALSE <-- No se auditan las acciones de SYS
audit_trail                          string      DB <-- Mis registros de auditoria son guardados dentro de la BD.
```

Este es un parámetro de inicio estático por lo cual sera necesario bajar a la instancia de Oracle para que entre en funcionamiento.

```sql
ALTER SYSTEM SET audit_trail=db SCOPE=spfile;
SHUTDOWN IMMEDIATE;
```
