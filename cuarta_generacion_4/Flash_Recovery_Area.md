# Flash Recovery Area

Siguiente el tema de [recuperación](Backup_and_Recovery), el `Flash Recovery Area` es una ubicación configurada mediante parámetros de la base de datos que nos permite de manera mas sencilla realizar y recuperar respaldos. El `FRA` es una ubicación específica para que la base de datos administre los archivos de respaldo, esto incluye archivos como backups, copia de `DATAFILES`, `CONTROLFILES`, `ARCHIVELOGS` y de esta manera permite recuperarse ante una falla más rápido, igualmente realiza funciones de limpiado sobre esta ubicación.

## Configuración del FRA

Para configurar el `FRA` en nuestra base de datos tenemos que cumplir con los siguientes pasos.

1. Colocar la base de datos en modo `ARCHIVELOG`.

```sql
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ARCHIVE LOG START;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
```

1. Crear un directorio para los archivos por medio del sistema operativo, por predeterminado se llama `Flash Recovery`.
2. Configurar los siguientes [parámetros de inicio](Parametros_de_Inicio).
    * `DB_RECOVERY_FILE_DEST_SIZE`: Este es el tamaño del area de recuperación, aparte de definir el tamaño máximo, es usado para las estadísticas del `FRA` como el espacio disponible.
    * `DB_RECOVERY_FILE_DEST`: Esta es la ubicación del `FRA` o en donde quedaran estos archivos.
    * `DB_FLASH_RETENTION_TARGET`: Tiempo de retención de [Oracle Flashback](Oracle_Flashback)
    * `ARCHIVE_LAG_TARGET`: Cantidad de segundos que dura la BD en generar un nuevo archivo, ej cada dos minutos se genera un `ARCHIVELOG`.
    * `LOG_ARCHIVE_DEST_1=LOCATION`: Rutas de los `ARCHIVELOG`, hace uso de otros parámetros por ejemplo: `LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST'`

### Parámetros de Inicio del `FRA`

#### DB_RECOVERY_FILE_DEST_SIZE

Especifica el tamaño total de todos los archivos que podrán ser almacenados en el area de recuperación, debe de contar con el espacio suficiente para almacenar una copia de todos los `DATAFILES`, respaldos incrementales, `ONLINE REDOLOG`, `ARCHIVELOG`. `BACKUPSETS`, `CONTROLFILES`, todo archivo respaldado suma al espacio consumido.

Lo modificamos con la siguiente sentencia:

```sql
ALTER SYSTEM SET db_recovery_file_dest_size = 10g SCOPE=BOTH;
```

No deberíamos modificar esta carpeta directamente desde nuestro sistema operativo, por ejemplo si fuéramos a liberar espacio borrando directamente, la base de datos no va a registrar este cambio y no nos permitirá almacenar nuevos respaldos, la única forma de que se refleje el cambio sera interactuando con la base de datos.

#### DB_RECOVERY_FILE_DEST

Especifica la ubicación física usada por el `FRA` en donde se depositan los respaldos, si estamos usando `ASM` o `Automatic Storage Management` se puede apuntar a la unidad manejada por este, sino podemos usar simplemente la ruta hacia la carpeta.

```sql
ALTER SYSTEM SET db_recovery_file_dest='/OFR1' SCOPE=BOTH;                      -- Configuración con ASM
ALTER SYSTEM SET db_recovery_file_dest='C:/app/usr/flash_recovery' SCOPE=BOTH;  -- Configuración normal
```

#### Otros Parámetros de Configuración de Recuperación

Los siguientes parámetros permiten configurar la recuperación y el respaldo de los `CONTROLFILES` y `REDOLOGS` de manera automática.

* `DB_CREATE_ONLINE_LOG_DEST_1`
* `DB_CREATE_ONLINE_LOG_DEST_n`
* `DB_RECOVERY_FILE_DEST`
* `DB_CREATE_FILE_DEST`

## Configuración de la Creación de `ARCHIVELOG`

* Si el modo `ARCHIVELOG` esta habilitado y los parámetros: `LOG_ARCHIVE_DEST` y `DB_RECOVERY_FILE_DEST` no están configurados, entonces los `ARCHIVELOGS` serán generados en la ruta `$PRACLE_HOME/dbs`.
* Si el parámetro `LOG_ARCHIVE_LOG_DEST` esta configurado pero el parámetro `DB_RECOVERY_FILE_DEST` no esta configurado, los `ARCHIVELOGS` serán generados en la ruta definida por `LOG_ARCIHVE_DEST`.
* Si se habilita `FRA` (osea se configura el parámetro `DB_RECOVERY_FILE_DEST` esta configurado), entonces los `ARCHIVELOGS` serán generados en el `FRA` y se ignoraran los parámetros `LOG_ARCHIVE_DEST` y `LOG_ARCHIVE_FORMAT`

![Destino de un ArchiveLog](https://i.imgur.com/0KRpXTl.png)

Se recomienda usar el `FRA` como una ubicación para almacenar los `ARCHIVELOGS`, puesto que estos serán manejados automáticamente por la base de datos

## Configuración del Parámetro `Backup Retention Policy`

El parámetro `Redundancy` del comando `CONFIGURE RETENTION POLICY` especifica cuantos respaldos de nivel 0 o completos deberían crearse para cada `CONTROLFILE` y `DATAFILE` por parte de `RMAN`. Si la cantidad de respaldos excede el valor del parámetro `Redundancy` entonces `RMAN` considerara a los respaldos adicionales como obsoletos, el valor predeterminado para este parámetro es 1.

> La retención indica cuando un archivo pasa a ser obsoleto y la base de datos ya no lo necesita para su recuperación. Esto puede ser causado por que los datos del respaldo están contemplados por otro respaldo.

![Politica basada en Redundancia](https://i.imgur.com/jm04f9t.png)

Podemos configurar este parámetro con la siguiente sentencia en `RMAN`

```console
RMAN> CONFIGURE RETENTION POLICY TO REDUNDANCY 3;
```

## Configuración del Parámetro `Recovery Window`

El parámetro `Recovery Window` especifica la cantidad de días entre el punto actual de respaldo y el punto de recuperación más cercano para que este quede como obsoleto, entonces `RMAN` no considerara como obsoleto a cualquier respaldo que caiga dentro de este lapso especificado.

![Politica Basada en `Recovery Window`](https://i.imgur.com/zNssSx2.png)

Esta política puede ser modificada con el siguiente comando de `RMAN`

```console
RMAN> CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
```

Esta política puede ser deshabilitada, de esta manera `RMAN` no considerara a ningún respaldo como obsoleto.

```console
RMAN> CONFIGURE RETENTION POLICY TO NONE;
```

Si no se utiliza el `FRA` los respaldos obsoletos serán mantenidos en el disco y consumirán espacio, ya que al marca un respaldo como obsoleto, lo borrara para liberar espacio para futuros respaldos.

## Información sobre el FRA

Tenemos dos vistas clave para obtener estadísticas sobre el `FRA`:

* `V$RECOVERY_FILE_DEST`.
* `V$FLASH_RECOVERY_AREA_USAGE`.

Si consultamos a la vista `V$RECOVERY_FILE_DEST` podemos descubrir estadísticas como:

* Ubicación actual.
* Espacio asignado.
* Espacio en uso.
* Espacio reclaimable mediante el borrado de archivos, esto va de la mano con los archivos que han sido marcados como obsoletos.
* Numero total de archivos en el `FRA`

Si consultamos a la vista `V$FLASH_RECOVERY_AREA_USAGE` podemos obtener estadísticas sobre el uso del `FRA`, así como cuanto espacio puede ser liberado por cada tipo de archivo.

## RMAN

Esta es una herramienta incluida por toda edición de Oracle, esta se especializa en operaciones de recuperación y respaldos, entramos a esta herramienta similar a como lo hacemos con el `SQLPLUS`.

Acá contamos con `n` bases de datos, sobre las cuales se configuran políticas de respaldo y recuperación, sobre las cuales se ejecutan las políticas o scripts sobre una ubicación

![RMAN](https://sxp.ezstationbnc.pw/img/nutanix-tutorials.png)

Es necesaria una infraestructura para almacenar los respaldos generados por `RMAN`, aca podemos indicarle a `RMAN` que guarde los respaldos sea en una nube o en discos convencionales.

![RMAN and Backups](https://i.imgur.com/Bpo0bE8.png)

Entonces para conectarnos a `RMAN` tenemos que indicar a cual instancia nos queremos conectar.

```console
RMAN.exe TARGET /
```

Podemos entonces ver todas las políticas de respaldo configuradas

```console
SHOW ALL;
```

Podemos cambiar acá las políticas según queramos.

```console
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS; -- Genera una nueva politica de retención basada en lapso, no remueve la de redundancia
```
Veamos entonces varios comandos básicos de respaldo.

```console
BACKUP DATABASE;                                            -- Respalda por completo la base de datos, sin parametros de inicio ni archivelogs, esta es una copia de los DF normal
BACKUP AS DATABASE DATABASE;                                -- Respalda por completo a la base de datos usando un formato específico de RMAN, este sera entonces más pequeño en un solo archivo

BACKUP AS BACKUPSET TABLESPACE <tablespace_name>;           -- Respalda un tablespace en específico, baja al tablespace automaticamente por nosotros
BACKUP AS BACKUPSET TAG 'TBS SYSTEM' TABLESPACE SYSTEM;     -- Respalda un tablespace en específico y nombra al respaldo

BACKUP AS COMPRESSED BACKUPSET TAG "TBS COMPRESSED" TABLESPACE <tablespace_name>;

LIST BACKUP SUMMARY;                                        -- Muestra información sobre los respaldos
BACKUP DATABASE spfile plus archivelog;                     -- Respalda a la base de datos incluyendos a los archivos de parametros y archives
```

### Tipos de Respaldos

Podemos realizar los siguientes tipos de respaldos con `RMAN`.

Primero veremos el respaldo incremental

```console
BACKUP INCREMENTAL LEVEL 0 TABLESPACE users;
```

Respaldo diferencial (es lo mismo que un respaldo incremental)

```console
BACKUP INCREMENTAL LEVEL 1 TABLESPACE users;
```

Respaldo acumulativo

```console
BACKUP INCREMENTAL LEVEL 1 CUMULATIVE TABLESPACE users;
```

Entre otros comandos encontramos los siguientes.

```console
BACKUP RECOVERY AREA;           -- Respaldar todos los respaldos del FRA
DELETE BACKUP;                  -- Borrar todos los respaldos
REPORT OBSOLETE;                -- Ver los respaldos obsoletos
DELETE OBSOLETE;                -- Elimintar los respaldos obsoletos
DELETE FORCE NOPROMPT OBSOLETE; -- Eliminar los respaldos obsoletos sin confirmación
```

Para generar reportes encontramos los siguientes.

```console
REPORT SCHEMA;
LIST BACKUP SUMMARY;            -- Muestra información general sobre todos los respaldos
LIST BACKUP BY DATAFILE; 
LIST BACKUP OF DATABASE;
LIST BACKUP OF ARCHIVELOG ALL;
LIST BACKUP OF CONTROLFILE;
REPORT OBSOLETE;
REPORT NEED BACKUP;             -- Indica que archives sufieron cambios y se requieren respaldar
```

A continuación se marcan las diferencia entre los 3 tipos de respaldos

![Respaldo Completo](https://i.imgur.com/iGNP4y5.png)

En el respaldo incremental, estaremos respaldando el contenido faltante entre un punto especifico y el pasado, por ejemplo el respaldo de Lunes tendrá el contenido faltante del respaldo completo, el Martes tendrá el respaldo del contenido faltante del Lunes. Esto significa que si se encuentra en el día Sábado y se desea recuperar contenido del día Martes, es necesario cargar los respaldos del miércoles a viernes. Estos son más rápidos que un respaldo completo y son más pequeños pero es necesario leer el contenido de los respaldos hasta el punto actual

![Respaldo Completo Incremental](https://i.imgur.com/ociji1M.png)

El respaldo acumulativo resuelve este problema, incluyendo el contenido de los días previos.

![Respaldo Completo Acumulativo](https://i.imgur.com/mzH3SjF.png)

### Otros Comandos

Para recuperar un respaldo simplemente usamos el comando `restore database`:

```console
RMAN> RESTORE DATABASE;
RMAN> RECOVER DATABASE;
```

Si queremos recuperar un solo `DATAFILE` corrupto usamos el siguiente script.

```console
SQL> SELECT file#, name FROM v$datafile;        -- Buscamos el identificador del DF
RMAN> sql 'ALTER DATABASE DATAFILE # OFFLINE'   -- Ponemos al DF fuera de linea antes de restaurarlo
RMAN> RESTORE DATAFILE #;                       -- Recuperamos al DF    
RMAN> RECOVER DATAFILE #;                       -- Recuperamos al DF
RMAN> sql 'ALTER DATABASE DATAFILE # ONLINE'    -- Ponemos al DF enlinea
```

Si queremos recuperar a un `TABLESPACE` con el siguiente script.

```console
RMAN> sql 'ALTER TABLESPACE users OFFLINE';
RMAN> RESTORE TABLESPACE users;
RMAN> RECOVER TABLESPACE users;
RMAN> sql 'ALTER TABLESAPCE users ONLINE';
```
