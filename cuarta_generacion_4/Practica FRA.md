# Practica FRA

- [x] Configurar el FRA
- [x] Espacio va ser de 500 megas
- [x] Configurar arc cada 10 min
- [x] Realizar un full backup
- [x] Crear un tablespace llamado TBS_PRUEBAS con un DF llamado: Pruebas01.dbf tamaño 10 megas
- [x] Crear tabla Estudiantes en tablespace TBS_PRUEBAS
        cedula varchar2(20)
        nombre varchar2(20)
- [x] Realizar backup del tablespace con TAG : tbs_pruebas_bk
- [x] Realizar un incremental de la base de datos
- [x] Corrompa el tablespace TBS_PRUEBAS
- [x] Pruebe que realmente lo corrompió
- [x] Restaure y recupere el tablespace tbs_pruebas
- [x] Muestre la información de los backups realizados
- [x] Realice otro backup completo con el TAG: Full_BACKUP
- [x] Borre el backup hecho en el paso 4.

## Solución

Para configurar el `Flash Recovery Area` se debe primero poner a la base de datos a operar en modo `ARCHIVELOG`, podemos verificar están con el siguiente comando.

```sql
archive log list;

Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     14
Next log sequence to archive   16
Current log sequence           16
```
Para este ejercicio se estará utilizando el directorio `flash_recovery_area` creado automáticamente en el `ORACLE_HOME`, si la base de datos no se encuentra operando en este modo es posible habilitarlo de la siguiente manera.

```sql
SHUTDOWN IMMEDIATE;
Database closed.
Database dismounted.
ORACLE instance shut down.

STARTUP MOUNT;
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
Database mounted.

ARCHIVE LOG START;
Statement processed.

ALTER DATABASE ARCHIVELOG;

Database altered.

ALTER DATABASE OPEN;

Database altered.
```

Vamos a modificar unos cuantos parámetros de inicio relacionados al `FRA`, primero vamos a verificar el tamaño actual del `FRA`

```sql
SHOW PARAMETER DB_RECOVERY_FILE_DEST_SIZE;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest_size           big integer 10G
```

Este lo vamos a cambiar a 500 MB con el siguiente comando.

```sql
ALTER SYSTEM SET db_recovery_file_dest_size=500MB SCOPE=BOTH;
```

Siguiente podemos verificar la ubicación de nuestros respaldos, si este esta bien podemos seguir adelante, acá también podemos ver el tamaño del `FRA`

```sql
SHOW PARAMETER db_recovery_file_dest;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest                string      D:\app\ZELAYARODRIGUEZJEREM\fl
                                                 ash_recovery_area
db_recovery_file_dest_size           big integer 500M
```

Siguiente vamos a modificar la regularidad según la cual se generan archive logs con el parámetro `ARCHIVE_LAG_TARGET`.

```sql
ALTER SYSTEM SET archive_lag_target=600 SCOPE=BOTH;

SHOW PARAMETER archive_lag_target;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
archive_lag_target                   integer     600
```

Siguiente vamos a realizar un backup completo incluyendo los archivos de inicio con el programa `RMAN`. Al momento de iniciar `RMAN` recordemos que tenemos que indicar el `target` o sea la base de datos a la cual se debe de conectar, le podemos indicar que se conecte a nuestra BD actual con el siguiente comando: `RMAN.EXE TARGET /`.

```console
BACKUP DATABASE;

Starting backup at 09-NOV-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting full datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
input datafile file number=00001 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSTEM01.DBF
input datafile file number=00002 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSAUX01.DBF
input datafile file number=00005 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\EXAMPLE01.DBF
input datafile file number=00003 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\UNDOTBS01.DBF
input datafile file number=00004 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\USERS01.DBF
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNNDF_TAG20211109T001314_JRN4CV97_.BKP tag=TAG20211109T001314 comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:26
channel ORA_DISK_1: starting full datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
including current control file in backup set
including current SPFILE in backup set
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NCSNF_TAG20211109T001314_JRN4DO5K_.BKP tag=TAG20211109T001314 comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:01
Finished backup at 09-NOV-21
```

Podemos entonces listar los respaldos disponibles en `RMAN` con el siguiente comando.

```console
LIST BACKUP SUMMARY;


List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
1       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T000937
2       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
3       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
```

Siguiente vamos a crear un tablespace llamado `TBS_PRUEBA` con un `DATAFILE` llamado: `pruebas01.dbf` y con un tamaño de 10 MB.

```sql
CREATE TABLESPACE tbs_prueba DATAFILE 'D:\app\ZELAYARODRIGUEZJEREM\oradata\orcl\pruebas.dbf' SIZE 10M EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
```

En este tablespace vamos a crear la tabla `estudiantes`.

```sql
CREATE TABLE estudiantes (
        cedula VARCHAR2(20),
        nombre VARCHAR2(20)
) TABLESPACE tbs_prueba;

SELECT table_name, tablespace_name FROM dba_tables WHERE table_name = 'ESTUDIANTES';

TABLE_NAME                     TABLESPACE_NAME
------------------------------ ------------------------------
ESTUDIANTES                    TBS_PRUEBA
```

Vamos entonces a respaldar este `TABLESPACE` con el tag `tbs_pruebas_bk`.

```console
BACKUP AS BACKUPSET TAG 'tbs_pruebas_bk' TABLESPACE TBS_PRUEBA;

Starting backup at 09-NOV-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting full datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
input datafile file number=00006 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNNDF_TBS_PRUEBAS_BK_JRN5SBJV_.BKP tag=TBS_PRUEBAS_BK comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:01
Finished backup at 09-NOV-21
```

Podemos entonces verificar que este respaldo ha sido creado.

```console
LIST BACKUP SUMMARY;


List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
1       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T000937
2       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
3       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
4       B  F  A DISK        09-NOV-21       1       1       NO         TBS_PRUEBAS_BK <-- Nuestro respaldo
```

Siguiente configuraremos un respaldo incremental para nuestra base de datos.

```console
BACKUP INCREMENTAL LEVEL 0 TAG 'INC_FULL' DATABASE;

Starting backup at 09-NOV-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting incremental level 0 datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
input datafile file number=00001 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSTEM01.DBF
input datafile file number=00002 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSAUX01.DBF
input datafile file number=00005 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\EXAMPLE01.DBF
input datafile file number=00003 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\UNDOTBS01.DBF
input datafile file number=00006 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF
input datafile file number=00004 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\USERS01.DBF
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND0_INC_FULL_JRN6OLSR_.BKP tag=INC_FULL comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:25
channel ORA_DISK_1: starting incremental level 0 datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
including current control file in backup set
including current SPFILE in backup set
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NCSN0_INC_FULL_JRN6PDLY_.BKP tag=INC_FULL comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:01
Finished backup at 09-NOV-21

BACKUP INCREMENTAL LEVEL 1 TAG 'INC_DIF' DATABASE;

Starting backup at 09-NOV-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting incremental level 1 datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
input datafile file number=00001 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSTEM01.DBF
input datafile file number=00002 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSAUX01.DBF
input datafile file number=00005 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\EXAMPLE01.DBF
input datafile file number=00003 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\UNDOTBS01.DBF
input datafile file number=00006 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF
input datafile file number=00004 name=D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\USERS01.DBF
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND1_INC_DIF_JRN6RYYS_.BKP tag=INC_DIF comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:15
channel ORA_DISK_1: starting incremental level 1 datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
including current control file in backup set
including current SPFILE in backup set
channel ORA_DISK_1: starting piece 1 at 09-NOV-21
channel ORA_DISK_1: finished piece 1 at 09-NOV-21
piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NCSN1_INC_DIF_JRN6SGV3_.BKP tag=INC_DIF comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:01
Finished backup at 09-NOV-21
```

Siguiente vamos a corrompler el tablespace `TBS_PRUEBAS` para eventualmente recuperarlo. Podemos borrar el datafile o bajamos la base de datos y editamos el `DATAFILE` borrando su contenido, en mi caso usare el segundo método, una vez volvemos a iniciar la BD se muestra el siguiente mensaje respecto al datafile `pruebas.tbs`

```console
ORA-01157: cannot identify/lock data file 6 - see DBWR trace file
ORA-01110: data file 6: 'D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF'
```

Siguiente vamos a restaurar el `TABLESPACE` `TBS_PRUEBAS` con los siguientes comandos:

```sql
SET PAGESIZE 20;
COLUMN name FORMAT A55;
SELECT file#, name FROM v$datafile;

     FILE# NAME
---------- -------------------------------------------------------
         1 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSTEM01.DBF
         2 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\SYSAUX01.DBF
         3 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\UNDOTBS01.DBF
         4 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\USERS01.DBF
         5 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\EXAMPLE01.DBF
         6 D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF <-- DF Corrupto con un file# de 6

6 rows selected.
```

Con este identidicador podemos entonces restaurar el `DATAFILE` de la siguiente manera en `RMAN`:

```console
-- BAJAR EL DF
sql 'alter database datafile 6 offline';
using target database control file instead of recovery catalog
sql statement: alter database datafile 6 offline

-- RESTAURAR EL DF
restore datafile 6;
Starting restore at 09-NOV-21
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=233 device type=DISK

channel ORA_DISK_1: starting datafile backup set restore
channel ORA_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_DISK_1: restoring datafile 00006 to D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF
channel ORA_DISK_1: reading from backup piece D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND0_INC_FULL_JRN6OLSR_.BKP
channel ORA_DISK_1: piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND0_INC_FULL_JRN6OLSR_.BKP tag=INC_FULL
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
Finished restore at 09-NOV-21

-- RECUPERAR EL DF
recover datafile 6;
Starting recover at 09-NOV-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: specifying datafile(s) to restore from backup set
destination for restore of datafile 00006: D:\APP\ZELAYARODRIGUEZJEREM\ORADATA\ORCL\PRUEBAS.DBF
channel ORA_DISK_1: reading from backup piece D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND1_INC_DIF_JRN6RYYS_.BKP
channel ORA_DISK_1: piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NNND1_INC_DIF_JRN6RYYS_.BKP tag=INC_DIF
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01

starting media recovery
media recovery complete, elapsed time: 00:00:01

Finished recover at 09-NOV-21

-- PONER ENLINEA EL DF
sql 'alter database datafile 6 online';
sql statement: alter database datafile 6 online
```

Despues de este proceso, si reiniciamos la BD no se mostrara el error.

```sql
STARTUP OPEN
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
Database mounted.
Database opened.
```

Veamos entonces los respaldos hechos hasta el momento.

```console
List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
1       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T000937
2       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
3       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
4       B  F  A DISK        09-NOV-21       1       1       NO         TBS_PRUEBAS_BK
8       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
9       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
10      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
11      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
```

Preparemos un nuevo backup completo con el tag `FULL_BACKUP`.

```console
BACKUP TAG 'FULL_BACKUP' DATABASE;
LIST BACKUP SUMMARY;

List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
1       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T000937
2       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
3       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
4       B  F  A DISK        09-NOV-21       1       1       NO         TBS_PRUEBAS_BK
8       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
9       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
10      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
11      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
12      B  F  A DISK        09-NOV-21       1       1       NO         FULL_BACKUP
13      B  F  A DISK        09-NOV-21       1       1       NO         FULL_BACKUP
```

Ahora vamos a borrar el respaldo que creamos al inicio del ejercicio, los respaldos por predeterminado tienen el prefijo `TAG` y un timestamp, por lo cual `TAG20211109T000937` es el respaldo que podemos eliminar.


```console
DELETE BACKUP TAG TAG20211109T000937;

using channel ORA_DISK_1

List of Backup Pieces
BP Key  BS Key  Pc# Cp# Status      Device Type Piece Name
------- ------- --- --- ----------- ----------- ----------
1       1       1   1   AVAILABLE   DISK        D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NCSNF_TAG20211109T000937_JRN45L33_.BKP

Do you really want to delete the above objects (enter YES or NO)? YES
deleted backup piece
backup piece handle=D:\APP\ZELAYARODRIGUEZJEREM\FLASH_RECOVERY_AREA\ORCL\BACKUPSET\2021_11_09\O1_MF_NCSNF_TAG20211109T000937_JRN45L33_.BKP RECID=1 STAMP=1088122194
Deleted 1 objects

LIST BACKUP SUMMARY;

List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
2       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
3       B  F  A DISK        09-NOV-21       1       1       NO         TAG20211109T001314
4       B  F  A DISK        09-NOV-21       1       1       NO         TBS_PRUEBAS_BK
8       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
9       B  0  A DISK        09-NOV-21       1       1       NO         INC_FULL
10      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
11      B  1  A DISK        09-NOV-21       1       1       NO         INC_DIF
12      B  F  A DISK        09-NOV-21       1       1       NO         FULL_BACKUP
13      B  F  A DISK        09-NOV-21       1       1       NO         FULL_BACKUP
```

