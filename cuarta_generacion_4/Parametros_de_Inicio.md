# Parámetros de Inicio

Ya tuvimos que lidiar con modificar ciertos parámetro de inicio al momento de crear una base de datos manualmente, acá vamos a encontrar dos tipos de archivos de inicio, el  `SPFILE` o `Pfile` que difieren en el tipo de cambios que podemos realizar.

## Parámetros Básicos

Parámetros para especificar el nombre de la base de datos:

* `DB_NAME`: Este parámetro tiene que coincidir con el `SID` que vamos a asignarle a nuestra instancia, este es leído al momento en el que la base de datos realizar un `STARTUP`
* `DB_DOMAIN`: Esta es una cadena de texto que especifica un dominio de red al cual pertenece la base de datos. Esto nos permitiría acceder al base de datos mediante un dominio web,

Parámetros para especificar la ubicación de los `CONTROL FILES`

* `CONTROL_FILES`: Al momento de ejecutar la sentencia `CREATE DATABASE`, las archivos especificados con este parámetro con los `CONTROL FILES` serán entonces creados, debido a esto la ejecución de esta sentencia es bastante rápida. Si no especificamos este parámetro, Oracle usa la ubicación predeterminada. En caso de que se de un error, el archivo aun así sera creado y sera necesario borrar el archivo.

Parámetros para controlar el tamaño de los bloques.

* `BLOCK_SIZE`: Tamaño del bloque de Oracle, se pueden utilizar múltiplos de 4k u 8k.

Aparte a estos parámetros trabajamos con dos parámetros para controlar estructuras de memoria.

* `SGA_TARGET`: Determina el **tamaño total** de todas las estructuras que componen al SGA, si este parámetro es especificados, todos sus componentes automáticamente se auto-gestionan en donde cada uno puede crecer o decrecer según necesite, esto puede ser sobreescrito si indicamos que queremos manualmente gestionar la memoria.
    * Buffer Cache: db_cache_size.
    * Shared Pool: shared_pool_size.
    * Large Pool: large_pool_size.
    * Java Pool: java_pool_size.
    * 
* `SGA_MAX_SIZE`: Determina el tamaño máximo de las estructuras que componen al SGA, si no se especifica, se tomara como tamaño la suma de todos sus componentes.
* `MEMORY_TARGET`: Este es el total de memoria asignada al sistema, la base de datos tunea el uso de memoria reduciendo e incrementando el SGA y PGA según sea necesario. Si no se configura el parámetro `MEMORY_MAX_TARGET` y se incluye el parámetro `MEMORY_TARGET`, la base de datos definiría al `MEMORY_MAX_TARGET` con el valor del `MEMORY_TARGET`, esto significa que el no habrá espacio disponible para que los recursos de la instancia crezcan, pues ya están a su máximo. Por otro lado si se proporciona un `MEMORY_TARGET` y no se proporciona un `MEMORY_MAX_TARGET` entonces el valor de `MEMORY_TARGET` sera 0.

![SGA TARGET y Memory Target](https://i.imgur.com/2c7qjRY.png)

Parámetros para ajustar el tamaño del `Shared Pool` y `Large Pool`

* `SHARED_POOL_SIZE`: Permite ajustar el tamaño del componente `Shared Pool` que pertenece al SGA.
* `LARGE_POOL_SOZE`: Permite ajustar el tamaño del componente `Large Pool` que pertenece al SGA.

Otros parámetros de inicio.

* `PROCESS`: Este parámetro especifica la cantidad de procesos simultáneos que se pueden ejecutar en total. Un proceso es creado cuando ejecutamos una consulta e incluso son creados por un proceso de fondo, estos procesos individuales puede ser eliminados con su `PID`.
* `LICENSE_MAX_USERS`:Para limitar la cantidad de usuarios se puede utilizar el parámetro `LICENSE_MAX_USERS`, aunque esto ya no se suele usar ya que ahora el licenciamiento se basa en procesamiento.

## Buscar Parámetros

Con la vista `V$PARAMETER` podemos seleccionar cada parámetro y su valor.

```sql
SELECT name, value FROM v$parameter;

NAME                      VALUE
------------------------- -------------------------
parallel_threads_per_cpu  2
parallel_automatic_tuning FALSE
parallel_io_cap_enabled   FALSE
optimizer_index_cost_adj  100
optimizer_index_caching   0
```

Otra opción más sencilla, es con el alias `SHOW PARAMETER <name>`,

```sql
SHOW PARAMETER SHARED_POOL_SIZE

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
shared_pool_size                     big integer 0

SHOW PARAMETER PARA

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
cell_offload_parameters              string
fast_start_parallel_rollback         string      LOW
parallel_adaptive_multi_user         boolean     TRUE
parallel_automatic_tuning            boolean     FALSE
parallel_degree_limit                string      CPU
```

## Cambiar Parámetros de Inicio

Encontraremos dos tipos de parámetros de inicio, estáticos y dinámicos.

* Los parámetros ***estáticos* son aquellos que se encuentran en un archivo, como el `init.ora`. Estos requieren un reinicio de la instancia para tomar efecto.
* Los parámetros **dinámicos** son aquellos que se puede cambiar mientras la base de datos esta operando, encontramos entonces dos tipos: `Session Level` que afectan por sesión de usuario y `System Level` que afectan a todos en la base de datos, estos se puede modificar con las sentencias `ALTER SESION` y `ALTER SYSTEM`. Estos adicionalmente tienen un "alcance" con 3 posibles valores: memoria, `SPFILE` O ambos.

### Alcance

Al cambiar estos parámetros de inicio tenemos acceso a varios tipos de alcance.

* `SPFILE`: Va al archivo físico y lo modifica, pero requiere reiniciar la instancia.
* Memory: Se realiza el cambio a nivel de memoria e inmediatamente, cuando alguien se conecta lee el cambio. Al bajar la base de datos, estos parámetros desaparecen, ya que el archivo no fue modificado.
* Both: Se aplica el cambio, tanto en memoria y en el archivo físico

```sql
ALTER SESSION SET NLS_DATE_FORMAT = 'mon dd yyyy';
Session altered.

SELECT SYSDATE FROM dual;

SYSDATE
-----------
oct 02 2021 <-- Nuevo formato
```

## Vistas Útiles

Podemos revisar las operaciones del SGA con las siguientes vistas.

* `V$SGA_CURRENT_RESIZE_OPS`: Nos permite ver las operaciones de crecimiento o decrecimiento en proceso del `SGA`.
* `V$SGA_RESIZE_OPS`: Muestra las ultimas 100 operaciones de ajuste en el SGA.
* `V$SGA_DYNAMIC_FREE_MEMORY`: Nos permite ver la cantidad de memoria disponible del SGA para operaciones de ajuste.

Podemos ver información sobre los parámetros de inicio con las siguientes vistas.

* `V$SPPARAMETER`: Muestra información sobre el contenido del `SPFILE`.
* `V$PARAMETER2`: Muestra información de los parámetros del `SPFILE` que se encuentran en función **durante la sesión actual**, un ejemplo de estos seria el formato de las fechas.
* `V$SYSTEM_PARAMETER`: Muestra información sobre los parámetros de inicio que tienen efecto sobre la instancia actual.

## Automatic Memory Management (AMM)

Desde la version 9 de Oracle, Oracle introduce varios parámetros para facilitar el manejo de estructuras de memoria como el `PGA_TARGET_AGGREGATE` para gestionar al PGA, en la version 10 introducen al `SGA_TARGET` para gestionar al SGA y en la versión 11 introducen un campo en memoria usado por Oracle para gestionar estos dos parámetros previamente mencionados.

Al usar este modo de gestión de memoria el `SGA_TARGET` y el `PGA_AGGREGATE_TARGET` trabajan con un tamaño "mínimo" base, esto permite a Oracle tener un control total de la memoria. 

Habilitar `AMM` es una tarea sencilla, asumiendo que se desea usar  la misma cantidad de recursos actuales se usa la siguiente formulara para calcular un `MEMORY_TARGET`.

```
MEMORY_TARGET = SGA_TARGET + GREATEST(SGA_AGGREGATE_TARGET, "maximum PGA allocated")
```

Se pueden obtener estar variables con la siguiente consulta SQL.

```sql
SELECT name, value
FROM v$parameter
WHERE name IN ('pga_aggregate_target', 'sga_target')
UNION
SELECT 'maximum PGA allocated' AS name, TO_CHAR(value) AS value
FROM v$pgastat
WHERE name = 'maximum PGA allocated';

NAME                      VALUE
------------------------- ---------------
maximum PGA allocated     161382400
pga_aggregate_target      0
sga_target                0
```

## Los Archivos de Parámetros

Vamos a encontrar 2 tipos archivos de parámetros `PFILE` o "Parameter File" y `SPFILE` o "Server Parameter File". El `PFILE` se encuentra compuesto por parámetros estáticos, el `SPFILE` en encuentra compuesto por parámetros dinámicos. Normalmente las bases de datos deberían de estar trabajando con un `SPFILE`.

El `PFILE` es un archivo de texto que puede ser editado con cualquier editor de texto, lo encontraremos por predeterminado en `$ORACLE_HOME/dbs` con el nombre `initSID.ora`. El `SPFILE` es un archivo binario que no podemos manipular directamente, sino que debemos modificar los parámetros desde la base de datos. Al crear una base de datos, esta no trae un `SPFILE` y se usa un `PFILE` como base para crearlo.

```sql
CREATE SPFILE FROM PFILE='u01/oracle/dbs/init.ora'; --Usa la ruta predeterminada para guardarlo

CREATE SPFILE FROM='u01/oracle/dbs*test_spfile.ora' FROM PFILE='u01/oracle/dbs/init.ora'; -- Se genera una copia hacia una ruta especifica
```

El `SPFILE` entonces es un archivo de tipo binario, sobre el cual podemos realizar cambios sin la necesidad de reiniciar nuestra instancia de Oracle y para modificar un parámetro dentro de este se usa la siguiente sintaxis sobre los cuales podemos especificar si son temporales o permanentes (con el scope, por ejemplo `spfile`).

```sql
ALTER SYSTEM SET undo_tablespace = 'UNDO2';
```

Al mismo tiempo es posible crear un `PFILE` desde un `SPFILE`.

```sql
CREATE PFILE FROM SPFILE;

CREATE PFILE='/u01/oracle/dbs/test_init.ora' FROM SPFILE='/uo1/oracle/dbs/test_spfile.ora';
```

Al momento de iniciar la BD, Oracle buscara en los siguientes archivos sus parámetros de inicio (O sea no ocupamos nosotros indicarle cual leer):

1. `spfileSID.ora`
2. `SPDILE` predeterminado.
3. `initSID.ora`
4. `PFILE` predeterminado

Podemos saltarnos este orden con el siguiente comando.

```sql
STARTUP PFILE=init.ora
```
