# Ejercicio con Parámetros

Iniciar la instancia previamente creada.

```console
SET ORACLE_SID=tst
```

Iniciar la base de datos con el `PFILE` previamente creado.

```console
startup pfile=D:\\app\\jerem\\admin\\tst\\pfile\\init.ora
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
Database mounted.
Database opened.
```

Crear el `SPFILE`.

```sql
CREATE SPFILE FROM PFILE='D:\\app\\jerem\\admin\\tst\\pfile\\init.ora';

File created.
```

Esto crea el `spfile` en la ruta predeterminada `product/11.2.0/dbhome_1/database`.

```
.
├── PWDorcl.ora
├── PWDtst.ORA
├── SPFILEORCL.ORA
├── SPFILETST.ORA <-- Tiene el SID que creamos
├── archive
├── hc_orcl.dat
├── hc_tst.dat
├── oradba.exe
└── oradim.log
```

Ya se puede levantar entonces la instancia sin tener que especificar un `PFILE`, ya que oracle lo encuentra en la ruta esperada.

```
startup
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
Database mounted.
Database opened.
```

Podemos adicionalmente verificar si estamos trabajando con `SPFILE`.

```sql
SHOW PARAMETER spfile;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      D:\APP\JEREM\PRODUCT\11.2.0\DB
                                                 HOME_1\DATABASE\SPFILETST.OR
```
_Nota:_ Si el resultado viniera en blanco, significa que estamos trabajando con `PFILE`.

Para iniciar la instancia en modo restringido, se altera el siguiente parámetro.

```sql
ALTER SYSTEM ENABLE RESTRICTED SESSION;

System altered.
```

Siguiente se crearan los usuarios para acceder a la instancia en modo restringido.

```sql
CREATE USER jeremy IDENTIFIED BY "root";

User created.

CREATE USER jeremy2 IDENTIFIED BY "root";

User created.
```
Acá se le habilitara el acceso restringido solo al usuario `jeremy`.

```sql
GRANT CREATE SESSION, RESTRICTED SESSION TO jeremy;
Grant succeeded.

GRANT CREATE SESSION to jeremy2;
Grant succeeded.
```

Siguiente se bajara la instancia para iniciarla en modo restringido y se intentara conectar a ambos usuarios.

```sql
SHUTDOWN IMMEDIATE
Database closed.
Database dismounted.
ORACLE instance shut down.

STARTUP RESTRICT
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
Database mounted.
Database opened.
```

Ahora con dos lineas de comando adicionales con los dos nuevos usuarios creados se intentara conectar a la instancia.

Salida de consola para el usuario `jeremy` con privilegios de acceso restringido:

```
sqlplus

SQL*Plus: Release 11.2.0.1.0 Production on Sat Oct 2 17:08:09 2021

Copyright (c) 1982, 2010, Oracle.  All rights reserved.

Enter user-name: jeremy
Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
```

Salida de consola para el usuario `jeremy2` sin privilegios de acceso restringido:

```console
sqlplus

SQL*Plus: Release 11.2.0.1.0 Production on Sat Oct 2 17:08:29 2021

Copyright (c) 1982, 2010, Oracle.  All rights reserved.

Enter user-name: jeremy2
Enter password:
ERROR:
ORA-01035: ORACLE only available to users with RESTRICTED SESSION privilege


Enter user-name:
```
