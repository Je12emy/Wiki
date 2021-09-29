# Creando una Base de Datos Manualmente

Esta guia sera escrita usando [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) con una instalación de [Ubuntu](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6#activetab=pivot:overviewtab) y se usara un poco de [bash](https://www.gnu.org/software/bash/), pero todos los pasos pueden ser replicados con Windows desde el explorador de archivos.

## 1. Estructura de Archivos

Iniciemos en nuestro directorio [Oracle Base](database_administration#Configurar Variables de Ambiente) `/d/app/jerem` con la creación de la estructura de archivos requerida.

```console
$ sid_name=tst

$  echo $sid_name
tst
```

En el directorio `admin` creamos los siguientes 3 directorios.

```console
$ mkdir admin/$sid_name
$ mkdir admin/$sid_name/adump
$ mkdir admin/$sid_name/dpdump
$ mkdir admin/$sid_name/pfile
$ mkdir flash_recovery_area/$sid_name
````

Se obtiene la siguiente estructura básica.

```
admin/tst/
├── adump
├── dpdump
└── pfile <-- Aca copiaremos un pfile ya existente

3 directories, 0 files

flash_recovery_area/
├── orcl
└── tst <-- Nuestra BD

2 directories, 0 files
```

Siguiente creamos los siguientes 3 directorios

```console
$ mkdir cfgtoollogs/dbca/$sid_name
$ mkdir oradata/$sid_name
```

Obtenemos la siguiente estructura de archivos.

```
cfgtoollogs/dbca/
├── orcl
└── tst <-- Nuestra BD

2 directories, 1 file

oradata/
├── orcl
└── tst <-- Nuestra BD

2 directories, 0 files
```

## 2. Clonar PFILE

Ocupamos de antemano clonar un `PFILE` ya existente, por suerte la base de datos que creamos al momento de instalar oracle ya trae uno que podemos utilizar.

```console
$ pwd
d/app/jerem/admin/orcl/pfile
$ ls
init.ora.692021231447
$ cp init.ora.692021231447 ../../tst/pfile/
```

Ahora editemos este `pfile` para adaptarlo a nuestra Base de Datos, en nuestro caso seria de la siguiente manera, presta atención a este simbolo: `<--!`

```
##############################################################################
# Copyright (c) 1991, 2001, 2002 by Oracle Corporation
##############################################################################

###########################################
# Cache and I/O
###########################################
db_block_size=8192

###########################################
# Cursors and Library Cache
###########################################
open_cursors=300

###########################################
# Database Identification
###########################################
db_domain=""
db_name=tst <--!

###########################################
# File Configuration
###########################################
control_files=("D:\app\jerem\oradata\tst\control01.ctl", "D:\app\jerem\flash_recovery_area\tst\control02.ctl") <--!
db_recovery_file_dest=D:\app\jerem\flash_recovery_area
db_recovery_file_dest_size=4102029312

###########################################
# Miscellaneous
###########################################
compatible=11.2.0.0.0
diagnostic_dest=D:\app\jerem
memory_target=6845104128

###########################################
# Network Registration
###########################################
local_listener=LISTENER_ORCL

###########################################
# Processes and Sessions
###########################################
# Por recomendación tambien podemos incrementar el valor predeterminado de aca <--!
processes=200

###########################################
# Security and Auditing
###########################################
audit_file_dest=D:\app\jerem\admin\tst\adump <--!
audit_trail=db
remote_login_passwordfile=EXCLUSIVE

###########################################
# Shared Server
###########################################
dispatchers="(PROTOCOL=TCP) (SERVICE=tstXDB)" <--!

###########################################
# System Managed Undo and Rollback Segments
###########################################
undo_tablespace=UNDOTBS1
```

Acá veras que nuestro `PFILE` esta multiplexando 2 `controlfiles` y que estos apuntas a las carpetas que creamos en el paso anterior, **recuerda la ruta de este archivo para el siguiente paso**, en este caso sera: `D:\\app\\jerem\\admin\\tst\\pfile\\init.ora`

## 3. Crear un SID con ORADIM

Con la utilidad [`oradim`](https://docs.oracle.com/en/database/oracle/oracle-database/19/ntqrf/creating-an-instance-using-oradim.html#GUID-BFE19571-26EE-41D2-B7E6-03C98C7C4452) podemos crear una nueva instancia de Oracle, desde Ubuntu podemos ejecutarla en el directorio `/product/11.2.0/dbhome_1/BIN`

```console
$ ls | grep oradim
oradim.exe
```

Acá tenemos acceso a varios comandos, simplemente el comando `oradim` podemos ver las banderas disponibles.

```console
$ oradim.exe
ORADIM: <command> [options].  Refer to manual.
Enter one of the following command:

Create an instance by specifying the following options:
     -NEW -SID sid | -SRVC srvc | -ASMSID sid | -ASMSRVC srvc [-SYSPWD pass]
 [-STARTMODE auto|manual] [-SRVCSTART system|demand] [-PFILE file | -SPFILE]
 [-SHUTMODE normal|immediate|abort] [-TIMEOUT secs] [-RUNAS osusr/ospass]
 
Edit an instance by specifying the following options:
     -EDIT -SID sid | -ASMSID sid [-SYSPWD pass]
 [-STARTMODE auto|manual] [-SRVCSTART system|demand] [-PFILE file | -SPFILE]
 [-SHUTMODE normal|immediate|abort] [-SHUTTYPE srvc|inst] [-RUNAS osusr/ospass]
 
Delete instances by specifying the following options:
     -DELETE -SID sid | -ASMSID sid | -SRVC srvc | -ASMSRVC srvc
     
Startup services and instance by specifying the following options:
     -STARTUP -SID sid | -ASMSID sid [-SYSPWD pass]
 [-STARTTYPE srvc|inst|srvc,inst] [-PFILE filename | -SPFILE]
 
Shutdown service and instance by specifying the following options:
     -SHUTDOWN -SID sid | -ASMSID sid [-SYSPWD pass]
 [-SHUTTYPE srvc|inst|srvc,inst] [-SHUTMODE normal|immediate|abort]
 Query for help by specifying the following parameters: -? | -h | -help
```

Creemos ahora una nueva instancia con la bandera `-NEW -SID`, para nuestro ejercicio podemos omitir las banderas para configurar `ASM`, pero vamos a ocupar las banderas `-SYSPWD` para preparar una contraseña para el usuario `SYS`, la bandera `-STARTMODE auto|manual` para indicar cuando queremos que inicie la instancia donde `auto` indica que inicie con el Sistema Operativo o `manual` donde nosotros lo haremos manualmente.

Acá tenemos que utilizar la ruta hacia el nuevo `pfile` que creamos en el paso anterior, también se recomienda ejecutar este comando en una terminal de windows con permisos administrativos

```console
$ oradim -NEW -SID tst -SYSPWD root -STARTMODE auto -PFILE D:\app\jerem\admin\tst\pfile\init.ora
instance created
```

Según la [documentación oficial](https://docs.oracle.com/cd/B28359_01/server.111/b28310/create003.htm#ADMIN12481) de Oracle **no deberíamos iniciar automáticamente** al momento de crear la instancia.

> Do not set the -STARTMODE argument to AUTO at this point, because this causes the new instance to start and attempt to mount the database, which does not exist yet. You can change this parameter to AUTO, if desired, in Step 14.

Para saber si ha funcionado este comando podemos revisar los servicios de Windows y seguir con seguridad hacia el siguiente paso.

![Servicio tst](https://i.imgur.com/JT4xtOQ.png)

## 4. Levantar la Instancia

El siguiente paso sera mejor hacerlo desde una terminal nativa de windows, configuremos la variable de ambiente en nuestra terminal `ORACLE_SID` con el `sid` que creamos en el paso anterior.

```console
$ SET ORACLE_SID=tst
```

Ahora nos conectaremos con `SQLPLUS` y con el usuario `sysdba`.

```console
$ sqlplus /nolog
```

Ahora nos conectaremos a la instancia, en mi caso se produce el siguiente error.

```
conn / as sysdba
ERROR:
ORA-01031: insufficient privileges
```

Puesto que mi usuario no cuenta con permisos para constarse a pesar de ser administrador, para corregir esto, como vimos en la [lección pasada](database_administration) en Windows podemos abrir [`Users and Groups`](https://www.isunshare.com/windows-10/5-ways-to-open-local-users-and-groups-in-windows-10.html)
Si vuelvo a intentar el comando pasado para contarme a la instancia tendremos los privilegios suficientes.

```
SQL> CONNECT SYS AS SYSDBA
Enter password:
Connected to an idle instance. <-- Buena señal de que vamos bien.
```

_Nota:_ Es posible tanto iniciar sesión con nuestro usuario de Windows como vimos en el primer comando para conectarnos o como acabamos de ver, para conectarnos con la 2da opción es necesario proporcionar la bandera `-SYSPWD` al momento de crear la instancia.

Si el mensaje `Connected to an idle instance` no es mostrado es posible que:

1. La instancia no fue creada exitosamente (Prueba corriendo el comando de creación como administrador).
2. Que ya haya se haya iniciado la instancia, por esto se debería iniciar con modo manual
3. No se ha cambiado la variable de ambiente `ORACLE_SID`

Siguiente tenemos que iniciar la instancia sin montar o sea solo levantamos la instancia, para esto le proporcionamos la ruta hacia nuestro `pfile`.

```
startup nomount pfile=D:\\app\\jerem\\admin\\tst\\pfile\\init.ora

ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
```

## 5. Ejecutar el Script de Creación

Siguiente podemos ejecutar el script de creación de nuestra base de datos, acá nos tenemos que asegurar que las rutas coinciden con la configuración en nuestro `init.ora`.

A continuación se presenta un script base.

```sql
CREATE DATABASE tst
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE 'D:\app\jerem\oradata\tst\system01.dbf' SIZE 700M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE 'D:\app\jerem\oradata\tst\sysaux01.dbf' SIZE 600M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE 'D:\app\jerem\oradata\tst\temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE 'D:\app\jerem\oradata\tst\undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET WE8MSWIN1252
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('D:\app\jerem\oradata\tst\redo01.log') SIZE 51200K,
GROUP 2 ('D:\app\jerem\oradata\tst\redo02.log') SIZE 51200K,
GROUP 3 ('D:\app\jerem\oradata\tst\redo03.log') SIZE 51200K
USER SYS IDENTIFIED BY root USER SYSTEM IDENTIFIED BY root;
```

Podemos ejecutarlo de la siguiente manera desde `SQLPLUS`

```
@D:\create_tst.sql
```

Ahora podemos conectarnos a esta base de datos con el usuario `SYS`, su contraseña ya fue especificada en el script de creación.

## 6. Ejecutar los scripts de Catálogos y Diccionario de Datos

Siguiente tenemos que ejecutar los siguientes scripts.

* CATALOG.SQL
* CATPROC.sql
* catexp.sql

Todos estos los encontraremos en `product/ver/home/rdbms/admin`.

```
@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/catexp.sql
```
_Nota:_ Con `@?` le indicamos a SQLPlus que busque estos scripts usando a `Oracle Home` como base.

Siguiente tenemos que ejecutar unos cuantos scripts con los dos usuarios de `SYS` y `SYSTEM`. 

Como `SYS` vamos a ejecutar los siguientes scripts.

```
@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catblock.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/catoctk.sql
@?/rdbms/admin/owminst.plb
```

Como `SYSTEM` vamos a ejecutar los siguientes scripts.

```
@?/sqlplus/admin/pupbld.sql
@?/sqlplus/admin/help/hlpbld.sql
@?/sqlplus/admin/help/helpus.sql
```

Podemos ahora ver que ya tenemos archivos físicos para nuestra base de datos nueva.

```
tst/
├── CONTROL01.CTL
├── REDO01.LOG
├── REDO02.LOG
├── REDO03.LOG
├── SYSAUX01.DBF
├── SYSTEM01.DBF
├── TEMP01.DBF
└── UNDOTBS01.DBF

0 directories, 8 files
```

También podemos ver los servicios activos del `LISTENER` con `LSNRCTRL.EXE services`.

```
Service "tst" has 1 instance(s).
  Instance "tst", status READY, has 1 handler(s) for this service...
    Handler(s):
      "DEDICATED" established:0 refused:0 state:ready
         LOCAL SERVER
Service "tstXDB" has 1 instance(s).
  Instance "tst", status READY, has 1 handler(s) for this service...
    Handler(s):
      "D000" established:0 refused:0 current:0 max:1022 state:ready
         DISPATCHER <machine: DESKTOP-CC5EFTK, pid: 15168>
         (ADDRESS=(PROTOCOL=tcp)(HOST=DESKTOP-CC5EFTK)(PORT=56665))
The command completed successfully
```

Así como consultar información de nuestro diccionario

```
SELECT name from v$database;

NAME
---------
TST
```

Crear objetos.

```sql
CREATE TABLE foo (id number);

Table created.

SELECT table_name FROM user_tables WHERE table_name LIKE 'FOO';

TABLE_NAME
------------------------------
FOO
```

Insertar datos.

```sql
INSERT INTO foo (id) values (1);

1 row created.

SELECT * FROM foo;

        ID
----------
         1
```

Para más información puedes revisar la [documentación oficial de Oracle](https://docs.oracle.com/cd/B28359_01/server.111/b28310/create003.htm#ADMIN11073)
