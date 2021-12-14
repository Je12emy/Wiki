<!-- LTeX: language=es -->

# Oracle Datapump

Esta es una extensión del tema de [respaldo y recuperación](respaldo_y_recuperacion), previamente en [respaldos lógicos](respaldos_logicos) estuvimos utilizando la herramienta de `export` e `import`, estas utilerías se han visto deprecadas desde Oracle 10g, por lo cual se ha visto reemplazado por la utilería de Oracle `Datapump`, esta proporciona las siguientes mejoras.

* Mejor considerablemente sobre la versión anterior.
* Gestiona mejor el tema de "mapeo" de esquemas y `tablespaces`, por ejemplo los parámetros de `FROMUSER` y `TOUSER`, en donde la herramienta `imp` extraería los objetos del esquema origen hacia el esquema con el cual se realiza la operación, este ahora incluye un único parámetro para esto.
* Permite la compresión de los datos **en el momento*** (de los datos), ya que no es necesario exportar y comprimir.
* Provee un control granular sobre que objetos por exportar y como hacerlo, así se indica que objetos se quieren, cuáles no se quieren así como los registros dentro de estos.
* Si se detiene por problemas, en ciertos casos, no se aborta la operación, se pone en pausa y permite resolver el problema para continuar.
* Se pueden realizar exportaciones desde otras bases de datos mediante `database-links`.
* Permite exportar datos desde un `scn` o un `timestamp`.
* Tiene la habilidad de calcular el espacio que consumirá el trabajo del `export`, sin ejecutarlo previamente.
* Permite especificar la versión de los objetos de base de datos a mover.
* Trabaja con un grupo de archivos (`dump file set`), envés de un único archivo `dump`, previamente se generaba un solo archivo `dmp` que podría llegar a ser bastante pesado, con `datapump` se puede dividir en partes.
* Permite la ejecución de operaciones paralelas, en donde se pueden realizar varias operaciones al mismo tiempo.
* Cuenta con el beneficio de exportar los objetos en documentos `xml`.

Aun así, esta utilería cuenta con los siguientes requisitos.

* Se debe crear un directorio en el sistema operativo para colocar las operaciones de exportación.
* Es necesario proporcionar permisos de lectura y escritura sobre este directorio para el usuario de la base de datos.
* Se debe de contar con permisos de administrador, significa que estas operaciones se realizan con un usuario con privilegios elevados.
* Al momento de realizar las operaciones de exportación, se debe de apuntar al directorio creado en el primer requerimiento.

En `datapump`, se configura a la base de datos para utilizar un directorio fijo para exportar e importar objetos, idealmente el nombre que le damos al directorio en la base de datos, será igual al nombre del directorio en la base de datos, esto significa que el usuario (con privilegios elevados) debe de contar con permisos de escritura y lectura sobre este, lo cual igualmente se configura desde la base de datos.

![Oracle Datapump](https://i.imgur.com/wVGmdsJ.png)

Esta es la cláusula para configurar el destino de los respaldos lógicos desde la base de datos.

```sql
-- Configurar ruta y nombre del directorio
CREATE OR REPLACE DIRECTORY backups AS 'c:\backups';
-- Proporcionar permisos de escrutura y escritora para un usuario con permisos elevados
-- estos pueden varias dependiendo de que tipo de operaciones que queremos que el usuario realice
GRANT READ, WRITE ON DIRECTORY backups TO usuario;
```

## Expdmp

Con este comando se pueden exportar objetos de la base de datos, igual a la utilería de `exp`, encontraremos varios tipos igualmente.

`Export Full` que exporta a toda la base de datos.

```console
expdp system/pwd DIRECTORY=backups DUMPFILE=backup.dmp FULL=y LOGFILE=expfull.log
```

`Export Tablespace` que exporta los objetos dentro de un [tablespace](../cuarta_generacion_3/tablespaces_y_data_files)

```console
expdp system/pwd DIRECTORY=backups DUMPFILE=backup.dmp TABLESPACES=users
```

`Export Schema` que exporta los objetos de un esquema especificado.

```console
expdp system/pwd DIRECTORY=backups DUMPFILE=schema.dmp SCHEMAS=hr
```

`Export Tables` que permite exportar tablas específicas.

```console
expdp system/pwd TABLES=hr.employees DIRECTORY=backups DUMPFILE=backup_tablas.dmp LOGFILE=backup_tabla.log
```

Note que no es necesario indicar el parámetro de `FILE` como se solía hacer con la utilería `imp`, ya que utiliza la configuración de la base de datos para saber cuál ruta debe de utilizar siempre, el parámetro de `directory` se puede alternas con otras rutas que se configuren en la base de datos. Por otro lado, el parámetro `DUMPFILE` es el nombre del archivo con los objetos exportados, este ahora se encuentra separado del parámetro `FILE`.

Veamos otros ejemplos adicionales.

Exportar toda la base de datos, incluidos los privilegios, indices y los datos.

```console
-- Con exp
export username/password FULL=y FILE=dba.dmp GRANTS=y INDEXES=y ROWS=y
-- Con dmpdp
expdp username/password FULL=y INCLUDE=grant iNCLUDE=index DIRECTORY=respaldos DUMPFILE=dba.dmp CONTENT=ALL
```

Exportar **solamente la estructura**, sin incluir los datos del esquema `SCOTT`.

```console
expdp system/password@ORCL DUMPFILE=scott.dmp LOGFILE=scott.log content=metatada_only SCHEMAS=scott DIRECTORY=respaldos
```

Exportar del esquema `SCOTT`, los registros de las tablas `PAISES` y `CIUDADES` cuyo nombre comience con la letra A.

```console
expdb system/password@ORCL
DUMPFILE=scott.dmp
LOGFILE=scott.log
CONTENT=data_only
SCHEMAS=scott
INCLUDE=table:"IN('PAISES', 'CIUDADES')"
QUERY="WHERE NOMBRE LIKE 'A%'"
DIRECTORY=respaldos
```

Si se quiere que el `query` se aplique únicamente sobre una tabla específica se puede especificar el esquema y tabla.

```console
expdb system/password@ORCL
DUMPFILE=scott.dmp
LOGFILE=scott.log
CONTENT=data_only
SCHEMAS=scott
INCLUDE=table:"IN('PAISES', 'CIUDADES')"
QUERY=scott.paises:"WHERE NOMBRE LIKE 'A%'"
DIRECTORY=respaldos
```

En ocasiones puede que sea necesario escapar ciertos caracteres, en este caso puede que sea necesario divido a las comillas simples.

```console
expdb system/password@ORCL
DUMPFILE=scott.dmp
LOGFILE=scott.log
CONTENT=data_only
SCHEMAS=scott
INCLUDE=table:"IN('PAISES', 'CIUDADES')"
QUERY=scott.paises:\"WHERE NOMBRE LIKE 'A%'\"
DIRECTORY=respaldos
```

## Impdb

Las operaciones de importación pueden ser un poco distintas como tal, veamos unos cuantos ejemplos.

Importar las tablas del esquema `scott`, hacia el esquema `abc`.

```console
-- Con la utileria de imp
imp username/password FILE=scott.dmp FROMUSER=scott TOUSER=abc
-- Con datapump
impdp username/password DIRECTORY=backups DUMPFILE=scott.dmp TABLES=scott.emp REMAP_SCHEMA=scott:abc
```

Note que acá ya no se están utilizando los parámetros de `FROMUSER` ni `TOUSER`

## Parfile

El archivo `parfile` permite configurar los parámetros de cada operación en un archivo por separado, estos archivos cuentan con una extensión `.par`

```text
DIRECTORY=respaldos
DUMPFILE=ht_dataonly.dmp
CONTENT=data_only
SCHEMAS=hr,oe
EXCLUDE=TABLE:"IN('COUNTRIES','LOCATIONS','REGIONS')"
QUERY=hr.employees:"WHERE department_id != 20 ORDER BY employee_id"
FLASHBACK_TIME="TO_TIMESTAMP('2020-09-15 17:22:00', 'YYYY-MM-DD HH24:MI:SS')"
```

Este archivo puede entonces ser reutilizado en varias operaciones.

```console
expdp usuario/pwd PARFILE=exp.par
```

De este `parfile`, note que se está usando el parámetro `EXCLUDE` para excluir objetos de la operación, igualmente se está usando al parámetro `FLASHBACK_TIME` para especificar desde cuál periodo deseamos obtener los datos.

Como ya vimos, para filtrar objetos de las operaciones de `datapump` se cuentan con parámetros como `CONTENT`, `EXCLUDE/INCLUDE` y `QUERY`, acá el parámetro `CONTENT` permite filtrar el contenido a exportar en el archivo `dump`, puede tener uno de los siguientes valores: `ALL`, `DATA`, `METADATA_ONLY`.

```console
impdp hr/hr DIRECTORY=respaldos DUMPFILE=expfill.dmp CONTENT=data_only
```

El parámetro `INCLUDE` permite forzar la inclusión de solo una lista de objetos en las operaciones por realizar.

```console
-- Incluir solo la siguiente lista de tablas
INCLUDE=table:"IN('EMPLOYEES', 'DEPARTMENTS')"
-- Incluir solo procedimientos almacenados
INCLUDE=procedure
```

El parámetro `QUERY` permite especificar cuáles registros se desean exportar

```console
QUERY=oe.orders:"WHERE order_id > 1000"
```
