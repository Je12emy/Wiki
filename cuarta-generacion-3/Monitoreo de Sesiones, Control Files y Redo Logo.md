# Monitoreo de Sesiones, Control Files y Redo Logs

En una base de datos de Oracle encontraremos a la vista [`v$session`](https://docs.oracle.com/cd/B19306_01/server.102/b14237/dynviews_2088.htm#REFRN30223) para ver información relacionada a los usuarios con sesiones abiertas en la base de datos, de esta manera podemos obtener información sobre los siguientes aspectos:

- Quien esta usando la base de datos.
- Quien esta inactivo.
- Bloqueos.

Podemos entonces relacionar la información de la vista `v$session` con las vista `v$lock` para obtener el detalle de dichos bloqueos.

```sql
 SELECT s.username, s.sid, l.type, l.block FROM v$session s, v$lock l WHERE s.sid = l.sid AND s.username IS NOT NULL;

USERNAME                              SID TY      BLOCK
------------------------------ ---------- -- ----------
DBSNMP                                 48 AE          0
DBSNMP                                 66 AE          0
DBSNMP                                191 AE          0
```

De esta misma manera, con vista `v$session` se puede combinar con otras vistas utiles para monitorear la actividad de la base de datos como:

| View                                                                                                             | Description                                                                                                                                                                        |
| ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [v$proceses](https://docs.oracle.com/cd/B19306_01/server.102/b14237/dynviews_2022.htm#REFRN30186)                | Permite ver cuales son los procesos activos que esta ejecutando una sesion en especifico.                                                                                          |
| [v$sess_io](https://docs.oracle.com/database/121/REFRN/GUID-FF94D0C9-80A4-419B-A8AA-961A452B2851.htm#REFRN30231) | Las entradas y salidas de una sesion.                                                                                                                                              |
| [v$sqlarea](https://docs.oracle.com/cd/B19306_01/server.102/b14237/dynviews_2129.htm)                            | Conteine la información de las sentencias SQL que estan en memoria o que se han ido ejecutando en memoria y asi conocer cuales consultas son usadas comunmente y lecturas al disco |
| [v$session_longops](https://docs.oracle.com/cd/B19306_01/server.102/b14237/dynviews_2092.htm#REFRN30227)         | Mostrar el estado de operaciones que toman mas de 6 segundos, incluye operaciones de respaldo, recuperación y ejecución de sentencias.                                             |
| [v$session_wait](https://docs.oracle.com/cd/B28359_01/server.111/b28320/dynviews_3023.htm)                       | Muestra los recursos o eventos con sesiones activas que se encuentran en espera.                                                                                                   |
| [v$systatat](https://docs.oracle.com/cd/B28359_01/server.111/b28320/dynviews_3086.htm#REFRN30272)                | Muestra estadisticas sobre sesiones.                                                                                                                                               |
| [v$resource_limit](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/refrn/V-RESOURCE_LIMIT.html)  | Proporciona información sobre el limita actual y global de utilización de recursos del systema.                                                                                    |

No todas las vistas contaran con campos para enlazarce entre si y sera necesario unir varias vistas para llegar a un dato en especifico.

## Sesiones

Ya concemos bastante sobre las sesiones gracias a `v$session` pero aun así es necesario conocer bien los estados básicos de una sesión.

- **Activo:** Una sesión esta activa cuando esta sesión esta ejecutando algo en este momento.
- **Inactivo:** Una sesión esta inactiva cuando no esta ejecutando nada en este momento.

Esta por ser una vista de rendimiento dinámico se encuentra constantemente actualizada, si un usuario cierra sesión no sera mostrado en esta vista.

```sql
SELECT sid, serial#, status
FROM v$session
WHERE user = '&user';

       SID    SERIAL# STATUS
---------- ---------- --------
         1          1 ACTIVE
         2          9 INACTIVE
         3        244 ACTIVE
        22          1 ACTIVE
        23        113 ACTIVE
        24        109 INACTIVE
```

**Nota:** Acá no se esta usando al campo username, esto de debe a que un aplicativo puede abrir varias sesión con el mismo usuario pero el SID y serial# son únicos para una sesión.

Aparte de estos dos estados básicos encontraremos a los siguientes 4:

- **Locked**: Cuando un usuario o su sesion se encuentra pegado, una sesion se puede pegar por una mala construcción en las llaves forraneas.
- **Killed**: La sesion del usuario fue terminada y fue expulsado de la base de datos, tal seria un caso donde una sesión esta bloqueado a un objeto y otros usuarios no puede accederlo.
- **Sniped**: Esta es una sesión que mediante perfiles se configura para expirar automáticamente después de cierto tiempo de inactividad.
- **Cached**: Es un estado menos común, depende de la configuración de la BD.

Para matar una sesión encontramos el siguiente comando.

```sql
ALTER SYSTEM KILL SESSION '<sid>, <serial#>';

SELECT sid, serial#, status
FROM v$session
WHERE user = '&user';

       SID    SERIAL# STATUS
---------- ---------- --------
         1          1 ACTIVE
         2          9 INACTIVE
         3        244 ACTIVE
        22          1 ACTIVE
        23        113 ACTIVE
        24        109 INACTIVE

ALTER SYSTEM KILL SESSION '1, 1';
```

Esto sacara de la base de datos esa sesión en específico, actualizara el estado en la vista y eventualmente se limpiara la memoria para que no sea visto en la vista. 

```
ORA-00028: your session has been killed
````

Tambien se puede usar la palabra clave `IMMEDIATE` para librerar el espacio en memoria de inmediato, por lo cual no va a aparecer en la vista.

```sql
ALTER SYSTEM KILL SESSION '1, 1' IMMEDIATE;
```

Veamos ahora las sesiones actuales en la base de datos.

```sql
SELECT sid, serial#, username FROM v$session WHERE username IS NOT NULL;

       SID    SERIAL# USERNAME
---------- ---------- ------------------------------
         2          9 DBSNMP
         3        244 SYS
        24        109 DBSNMP
        45         17 DBSNMP
        89         26 DBSNMP
       109         13 DBSNMP
       149         13 DBSNMP
       214          1 DBSNMP
       233          5 DBSNMP
```

Ahora abramos una sesión aparte con el usuario `SCOTT`.

```sql
SELECT sid, serial#, username FROM v$session WHERE username IS NOT NULL;

       SID    SERIAL# USERNAME
---------- ---------- ------------------------------
         2          9 DBSNMP
         3        244 SYS
        24        109 DBSNMP
        45         17 DBSNMP
        89         26 DBSNMP
       109         13 DBSNMP
       149         13 DBSNMP
       212       1485 SCOTT <--
       214          1 DBSNMP
       233          5 DBSNMP
```

Ahora veamos el estado junto a esto.

```sql
SELECT sid, serial#, username, status FROM v$session WHERE username IS NOT NULL;

       SID    SERIAL# USERNAME                       STATUS
---------- ---------- ------------------------------ --------
       ...       .... .....                          ....
       212       1485 SCOTT                          INACTIVE
       ...       .... .....                          ....
```

Ahora matemos la sesión del usuario `SCOTT`, su sid actual es 121 y serial# 1485.

```sql
ALTER SYSTEM KILL SESSION '212, 1485';

System altered.
```

Podemos ver que el estado de `SCOTT` refleja esto.

```sql
SELECT sid, serial#, username, status FROM v$session WHERE username IS NOT NULL;

       SID    SERIAL# USERNAME                       STATUS
---------- ---------- ------------------------------ --------
       ...       .... .....                          ....
       212       1485 SCOTT                          KILLED
	   ...       .... .....                          ....

```

Eventualmente se limpiara la memoria y `SCOTT` ya no sera visto en esta vista, si volvemos a iniciar sesión con `SCOTT` y usamos el modificador `IMMEDIATE` no sera visto en esta vista al momento de ejecutar la sentencia.

```sql
ALTER SYSTEM KILL SESSION '212, 1487' IMMEDIATE;

System altered.
```

## Control Files

Como ya hemos visto los control files son unos de los archivos de la estructura física de la base de datos más importantes por que son leídos al momento para determinar:

- Nombre de la base de datos.
- Nombre y ubicaciones de los datafiles y online redo log files.
- El momento de creación de la base de datos.
- La secuencia de los log files.
- Puntos de restauración.
- Nombre de los tablespaces.
- Información de respaldo

Un control file es un archivo binario (no puede ser leido) que controla el estado de la base de datos, si se pierde sera necesario aplicar una restauración de la base de datos.

- Es leído en la etapa de `MOUNT` para iniciar la base de datos.
- Es requerido para operar la base de datos.
- Se encuentra vinculado a una base de datos.
- Tiene que estar multiplexado, tener copias síncronas (copias exactas) del archivo en varias ubicaciones pero la base de datos requiere solo a un control file para operar.
- Su tamaño se define al momento de creación de la base de datos.

### Creación de Nuevos Control Files

Encontraremos la sentencia `CREATE CONTROLFILE` para crear un nuevo control file.

```sql
CREATE CONTROLFILE SET DATABASE prod
LOGFILE GROUP 1 ('prod/redo01_01.log', -- Grupos de redo log files, estos se encuentran multiplexados
				 'prod/redo01_02.log'),
		GROUP 2 ('prod/redo02_01.log',
				 'prod/redo02_02.log'),
	 	GROUP 3 ('prod/redo03_01.log',
				 'prod/redo03_02.log')
NORESETLOG -- Resetea la secuenca de los redo
DATAFILE 'oracle/prod/system01.dbf' SIZE 3M, -- Los datafiles asociados a este control file
         'oracle/prod/rbs01.dbf' SIZE 5M
MAXLOGFILES 50
MAXLOGMEMBERS 3
MAXLOGHISTORY 400
MAXDATAFILES 6
MAXDATABASES 6
ARCHIVELOG;
```
**Nota**: Toda esta información en la sentencia es necesaria.

Para ejecutar esta sentencia sera necesario obtener información sobre otras vistas, tal seria el caso de la ubicación de los log files y los data files

- Valores de nombre y síncronas de los log files con `v$logfile`.
- Nombre y ubicación de los datafiles con `v$dafile`.
- Ubicación en donde ubicar el control file con `v$parameter`.

### Respaldando Control Files

Encontramos varias formas de realizar un respaldo de los control files

La **primera opción** usando la sentencia `ALTER DATABASE BACKUP CONTROLFILE`, esta es una copia del control file en un momento exacto.

```sql
ALTER DATABASE BACKUP CONTROLFILE TO '/oracle/backup/control.bkp';
```

El problema es que si se realiza una transacción, este respaldo se encuentra des actualizado e incluso la secuencia de los log files estará incorrecta. Para esto sera necesario restaurar la secuencia de los logs files esto causaría que no sea posible hacer rollback.

```sql
ALTER DATABASE OPEN;
ALTER DATABASE OPEN RESETLOGS; -- Se pierde o reinicia la secuencia de las transacciones.
```

La **segunda forma** seria de nuevo con `ALTER DATABASE`, pero esta vez no sera generando un archivo binario y este contendrá con todos los pasos para restaurar el control file en su totalidad con incluso la secuencia de log adecuada.

```sql
ALTER DATABASE BACKUP CONTROL FILE TO TRACE; -- Usa una ruta predeterminada
ALTER DATABASE BACKUP CONTROL FILE TO TRACE AS 'path'; -- Usa una ruta determinada por el usuario
```

### Multiplexación de un Control File

Al momento de levantar la instancia de la base de datos, los archivos de parámetros son leídos y traen la ubicación de los data files, este campo puede ser alterado para agregar más campos en la variable que indica cuales con los control files.

```
COTNROL_FILES = ('prod/controlf01.ctl', 'prod/controlf01.ctl')
```

Estas copias las podemos realizar a nivel de sistema operativo, pero **primero** tenemos que verificar con cual archivo de parámetro esta trabajando la base de datos, esto lo podemos realizar con el alias `SPFILE`.

Con esta consulta podemos ver con cual de los 2 tipos de archivos se esta trabajando y asi definir cual tipo de respaldo y multiplexación realizar, aca `SHOW PARAMETER` es un alias o like para `V$PARAMETER`, en este caso buscamos para SPFILE

```sql
SHOW PARAMETER SPFILE;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      C:\APP\JEREMYZELAYARODRIGUE\PR
                                                 ODUCT\11.2.0\DBHOME_1\DATABASE
                                                 \SPFILEORCL.ORA
```

Si esto saliera en nulo significa que estamos trabajando con un `PFILE` (Que es de texto plano) pero aca estamos usando un `SPFILE` (binario) y podemos ver la ubicación de los control files con este mismo alias.


Este es el contenido del `SPFILE`.

```
orcl.__java_pool_size=16777216
orcl.__large_pool_size=16777216
orcl.__oracle_base='D:\app\jerem'#ORACLE_BASE set from environment
orcl.__pga_aggregate_target=2751463424
orcl.__sga_target=4093640704
orcl.__shared_io_pool_size=0
orcl.__shared_pool_size=754974720
orcl.__streams_pool_size=0
*.audit_file_dest='D:\app\jerem\admin\orcl\adump'
*.audit_trail='db'
*.compatible='11.2.0.0.0'
*.control_files='D:\app\jerem\oradata\orcl\control01.ctl','D:\app\jerem\f☺CC"♥☺♦]glash_recovery_area\orcl\control02.ctl' <--
*.db_block_size=8192
*.db_domain=''
*.db_name='orcl'
*.db_recovery_file_dest='D:\app\jerem\flash_recovery_area'
*.db_recovery_file_dest_size=4102029312
*.diagnostic_dest='D:\app\jerem'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=orclXDB)'
*.local_listener='LISTENER_ORCL'
*.memory_target=6845104128
*.open_cursors=300
*.processes=150
*.remote_login_passwordfile='EXCLUSIVE'
*.undo_tablespace='UNDOTBS1'
```

Ahora veamos en donde se encuentran los control files.

```sql
SHOW PARAMETER CONTROL;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_file_record_keep_time        integer     7
control_files                        string      D:\APP\JEREM\ORADATA\ORCL\CONT
                                                 ROL01.CTL, D:\APP\JEREM\FLASH_
                                                 RECOVERY_AREA\ORCL\CONTROL02.C
                                                 TL
control_management_pack_access       string      DIAGNOSTIC+TUNING
```

Aca podemos concluir que por contar con dos control files, este se encuentra multiplexado y la copia reflejara todos los cambios que sufra el original.

```sql
ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS 'C:\\APP\\FLASH_RECOVERY_AREA\\ORCL\\CONTROL09.TXT';

Database altered.
```
**Nota**: Nuestros respaldos por binario deberian tener la extensión `.CTL`, los que usan archivos de texto podrian simplemente ser en txt y ejecutamos las sentencias de poco a poco.

Ahora, creemos un nuevo respaldo para este control file.

```sql
ALTER DATABASE BACKUP CONTROLFILE TO 'D:\app\jerem\flash_recovery_area\orcl\CONTROL03.CTL';

Database altered.
```
Este es un simple archivo en nuestro sistema operativo, pero tenemos que indicarle a la base de datos la ubicación de este control file y que lo use junto a los ya existentes y multiplexados. Para esto proceso primero deberíamos bajar a la base de datos, **antes** de bajar a la base de datos.

```sql
ALTER SYSTEM SET CONTROL_FILES='D:\\APP\\JEREM\\ORADATA\\ORCL\\CONTROL01.CTL','D:\\APP\\
JEREM\\FLASH_RECOVERY_AREA\\ORCL\\CONTROL02.CTL','D:\\APP\\JEREM\\FLASH_RECOVERY_AREA\\ORCL\\
CONTROL03.CTL' SCOPE=spfile;
```
Ahora podemos apagar la base de datos y realizar una copia a nivel de sistema operativo del control file.

```sql
ALTER DATABASE SHUTDOWN IMMEDIATE;
```
Ahora solo es necesario iniciar la base de datos y podemos verificar la unicación del control files.

```sql
SHOW PARAMETER CONTROL;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
control_file_record_keep_time        integer     7
control_files                        string      D:\APP\JEREM\ORADATA\ORCL\CONT
                                                 ROL01.CTL, D:\APP\JEREM\FLASH_
                                                 RECOVERY_AREA\ORCL\CONTROL02.C
                                                 TL, D:\APP\JEREM\FLASH_RECOVER
                                                 Y_AREA\ORCL\CONTROL03.CTL <--
control_management_pack_access       string      DIAGNOSTIC+TUNING
```
