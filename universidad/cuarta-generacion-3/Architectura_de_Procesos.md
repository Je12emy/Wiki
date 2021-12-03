# Architectura de Procesos

Este tema va muy de la mano con la [[Architectura de Memoria]] debido a que ciertos procesos hacen uso de estas o se activan cuando una de estas es alterada. Ya hemos visto que en Oracle, las consultas pueden venir por parte de aplicativos (sea `SQLPlus` u otros) e internamente del motor de Oracle (que conocemos como `daemons`).

Recordemos que Oracle y cualquier otra base de datos son sistemas que trabajan con multiprocesamiento, en donde la base de datos puede trabajar con _n_ peticiones y a la vez puede estar haciendo _x_ cantidad de procesos, por _z_ cantidad de usuarios.

## Tipos de Procesos

Vamos entonces a encontrar dos tipos de procesos que van a estar interactuando en el fondo con nuestra base de datos:

-   Procesos Dedicados.
-   Procesos de Multiproceso

Por otro lado encontraremos dos tipos de servidores.

-   **Servidores Dedicados:** En donde los usuario se conectan a un único servidor (hardware) o sea una unica instancia de Oracle, de donde obtienen su información.
-   **Servidores Distribuidos:** Es una configuración en donde los usuarios se puede conectar hacia diferentes servidores (que se ven como uno).

## Conexión vs Sesiones

Estos son terminos distintos que usualmente confundimos entre si.

-   Una conexión es una **ruta** de comunicación entre un proceso de usuario y la instancia de Oracle, esto es logrado mediante un `Listener` (Que escucha las solicitudes de usuario) y el `TNS Names` o `TNS Network Names` (Es el descriptor de la base de datos a la cual nos vamos a conectar, guarda información sobre la base de datos como el SID y el IP).
-   Una sesión es una conexión específica de un usuario hacia una instancia de Oracle, de aca se obtiene el `SID` y el `Serial#`.

## Procesos de Servidor (OP)

Aca se manejan procesos simples (donde todo trabajan los procesos de usuario y servidor sobre el mismo servidor, en un mismo hilo) y multiprocesos (se trabaja en diferentes maquinas, los procesos de usuario y servidor se encuentran separados)

### Procesos de Fondo (OP)

Vamos a encontrar a los siguientes procesos (entre otros) de fondo.

-   Database Writter o DBWP o DBWn.
-   Log Writter.
-   Checkpoint.
-   System Monitor.
-   Process Monitor.
-   Archiver.
-   Recoveres.
-   Lock.
-   Job Queue.
-   Dispatches.
-   Server.

Aca hay procesos que comparten estructuras de memoria y otros que usan estructura de memoria exclusivamente.

![Procesos de Oracle](http://dbheart.com/oracle/about_oracle_images/Oracle_Architecture_Diagram.jpg)

#### Database Writter (DBwn)

Escribe el contenido desde el [[Architectura de Memoria#Database Buffer Cache|Buffer Cache]] hacia los Data Files, trae lo que se encuentre en memoria en el disco para que sea ya permanente.

-   Escribe el contenido del `Dirty List` a disco.
-   Su principal trabajo es mantener al `Buffer Cache` limpio, para registrar los nuevos bloquees en memoria por leer.
-   Si el `Buffer Cache` se llena, se tendra que leer directo desde disco y por esto este proceso es tan imporante.

Entontraremos varios `Database Writters` (por eso DBW*n*) y escribe en disco basado en las siguientes condiciones.

-   Cuando el servidor no encuentra espacio libre en el `Buffer Cache` (y se encuentra saturado), le enviara una señal a `Database Writter` para que escriba los `Dirty Buffers` a disco y el `LRU` pueda cargar bloques a memoria.
-   Escribira los buffers en disco para avanzar hacia un punto `Checkpoint`, esta posición de retorno es determinada por el dato en `Dirty List` más viejo.

El parametro `DB_WRITTER_PROCESESS` define la cantidad de procesos de `Database Writter`

#### Log Writter Process (LGWR)

Es el proceso responsable de escribir los bloques del `Red Log Buffer` hacia los `Red Log Files` escribe:

-   Los registros cuando un proceso de usuario hace un `commit` (si no se hace `commit`, se queda en el `Redo Log Buffer`).
-   `Redo Log Buffers`
    -   Cada 3 segundos.
    -   Cuando el `Redo Log Buffer` se encuentra 1/3 lleno.
    -   Cuando el `Database Writter` escribe en el disco.

#### Checkpoint (CKPT)

Es el responsable de actualizar los encabezados de los `data files` (en esta cabezera de los `control files` se encuentra el numero de secuencia de las transacciones). un checkpoint ocurre cuando oracle actualiza bloques desde la memoria, hacia el `data file`, entonces el `checkpoint` mantiene al buffer y a los `Data Files` sincronizados para asegurar que la base de datos podra ser recuperada. el `checkpoint` no escribe los bloques a disco (los data files), solo pone una marca en los archivos con la secuencia.

En el diagrama inicial se puede ver que al momento de escribir a disco, el checkpoint tambien escribe sobre estos con el encabezado.

```ad-caution

El checkpoint no escribe bloques a disco, sino deja una marca en el archivo.

```

#### Sytem Monitor (SMON)

Es el responsable de mantener limpia la base de datos de los segmentos temporales que ya no estan en uso, tal serian las operacioens de agrupamiento y ordenamiento, tambien se encarga de unir bloques adyacentes para resolver la fragmentación.

#### Process Monitor (PMON)

-   Es el encargado de recuperar procesos de usaurio que fallan, ya sea por bloqueos u otros, por ejemplo si un `commit` falla lo volvera a ejecutar por el usuario.
-   Por otro lado limpia el `Buffer Cache` con los bloques que el usuario estaba usando, por ejemplo cuando cerrabamos un proceso y hasta despues los recursos de la sesión seran liberados.
-   Libera bloqueos.
-   Remueve el ID de la lista de procesos activos, por ejemplo cuando cerramos una sesión y su id sigue en la vista de seiones.
-   Checkea el estado de los despachadores y procesos de servidor.

#### Recover Process (RECO)

Solo trabaja cuando la base de datos trabaja de forma distribuida, esto se puede verificar con el parametro `DISTRIBUTED_TRANSACTIONS`.

-   Si la conexión a un servidor remoto falla, este intentara restablecer la conexión despues de un intervalo de tiempo (aguanta as transacciones para que no sean perdidas).

#### Archiver Process (ARCn)

Toma lo que sale de los `Redo Logs` y los escribe a archivos de `redo` fuera de linea, para tenerlos como respaldo y solo trabaja cuando la base de datos opera en modo de respaldo o `archive`. Ya que los (`Online`)`Red Log` tienen un tamaño definido, botaran lo más viejo. Si no se trabaja en modo de respaldo se perderan dichas transacciones, para evitar esto las transacciones viejas seran traidas a los `Archive Redo Logo`.

Con el comando `ALTER SYSTEM SWITCH LOGFILE` se puede forzar a cambiar de `Redo Log` al momento de archivar.

#### Lock Process (LCK0)

Usado para evitar bloqueos en servidores con alto nivel de procesamiento de datos.

#### Job Queue Process (SNPn)

Usado cuando tenemos vistas materializadas que se generan con un query que se ejecuta cada cierto tiempo (para mantenerlas actualizadas), el `Job Queue` es la cola de trabajos y coordina cuando se ejecuta cada trabajo. Por otro lado, maneja los jobs para actualizar los `snapshots`.

#### Dispatcher Processes (Dnnn)

Ayuda a mejorar el servicio de los datos en servidores con multiprocesamiento o sea despachar más rapido la información, soporta multiples conexiones y dirige a cada una hacia un proceso compartido libre, si no llega a encontrar un proceso libre creara uno nuevo.

Se puede tener _n_ despachadores, pero si se tienen más despachadores de los que son necesarios entonces se tendran procesos ociosos y se desperdiciaran recursos de memoria.

> When running Oracle Multi-Threaded Server, one or more dispatcher processes (named D001, D002, and so on) are responsible for receiving connection requests from the listener and directing each request to the least busy Shared Server process. If the listener cannot find an available D_nnn_ process, a dedicated server process is created instead. The actual number of Dispatcher processes running is determined by the setting of the _INIT.ORA_ parameter MTS_MAX_DISPATCHERS.

# Archivos de Traza

> Trace File are trace (or dump) file that Oracle Database creates to help you diagnose and resolve operating problems.

Vamos a encontrar varios tipos de trazas.

## Background Trace Files

Estos archivos guardan trazabilidad de la información que surge de errores en procesos de fondo.

-   Son usados para diagnosticar y solucionar errores. usualmente el que más usamos es el `Alert`.
-   Son creados cuando un proceso de fondo encuentra un error.
-   Su ubicación es definida por el parametro `BACKGROUND_DUMP_DEST`
-   Cada proceso va a generar un archivo traza, estos so de extensión `.TRC`.


## User Trace Files

Permiten conocer la traza que hizo un usuario para un conjunto de sentencias SQL, asi permite que ver que utilizo, que genero y como lo genero. Estos son generados en el momento que los activamos o se generan errores en la sesión del usuario.

-   Se genera en el momento en que lo activamos o se generen errores en la sesión del usuario.
-   Deberiamos activarlas cuando queremos monitorear algo en específico, sino se generaran trazas gigantescas.
-   Su destino es definido por el parametro `USER_DUMP_DEST`.

## Alert Trace Files

Las alertas tienen una secuencia cronologica desde cuando se inicia la BD, seria bueno limpiarlo despues de cierto tiempo ya que puede generar archivos bastante grandes.

Si queremos ver en donde se encuentra cada archivo de traza usamos la siguiente sentencia

```sql
SELECT value FROM v$parameter WHERE name = 'background_dump_dest';

VALUE
--------------------------------------------------------------------------------
d:\app\jerem\diag\rdbms\orcl\orcl\trace
```

Las trazas de usuario sirven para mostrar sentencias SQL y su plan de ejecución, no es necesario conocer del código fuente ni la sentencia SQL para conocer que y como se ejecuto (puesto que graba todo lo que hace el usuario en la base de datos). Para activar las trazas de usuario usamos el siguiente paquete.

```sql
SYS.DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(SID, SERIAL#, TRUE/FALSE);
```
Claro ocupara que extraigamos el `SID` y el `SERIAL#` de la vista `v$session`.

Si queremos entonces habilitar una traza de usuario para una sesión del usuario `Scott` podemos hacerlo de la siguiente manera. Primero averiguemos la inforamción de la sesión.

```sql
SELECT username, sid, serial# FROM v$session WHERE username IS NOT NULL;

USERNAME                              SID    SERIAL#
------------------------------ ---------- ----------
DBSNMP                                 88          1
SYS                                   214         61
SCOTT                                 233          7 <--
```
Ahora usaremos el paquete `DBMS_SYSTEM` para habilitar la traza.

```sql
 EXECUTE DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(233, 7, TRUE);
```

Para encontrar cual es el archivo traza de un usuario usamos la siguiente sentencia.

```sql
SELECT lower(sys_context('userenv', 'instance_name')||'_ora_'||p.spid||'.trc') 
AS trace_file
FROM v$session s, v$process p 
WHERE s.paddr = p.addr
AND s.sid = <sid>
AND s.serial# = <serial>;
```

Entonces quedamos con la siguiente consulta

```sql
SELECT lower(sys_context('userenv', 'instance_name')||'_ora_'||p.spid||'.trc') 
AS trace_file
FROM v$session s, v$process p 
WHERE s.paddr = p.addr
AND s.sid = &sid
AND s.serial# = &serial;

TRACE_FILE
--------------------------------------------------------------------------------
orcl_ora_1916.trc
```
Este archivo podemos simplemente abrirlo pero sera un archivo dificil de leer pero aun asi podremos ver las consultas del usuario en este archivo si buscamos detenidamente.

```
=====================
PARSING IN CURSOR #3 len=17 dep=0 uid=84 oct=3 lid=84 tim=293942748299 hv=899955544 ad='7ffb8fddab98' sqlid='4ttqgu8uu8fus'
SELECT * FROM EMP <-- Consulta
END OF STMT
PARSE #3:c=0,e=567,p=0,cr=0,cu=0,mis=1,r=0,dep=0,og=1,plh=3956160932,tim=293942748298
EXEC #3:c=0,e=15,p=0,cr=0,cu=0,mis=0,r=0,dep=0,og=1,plh=3956160932,tim=293942749601
FETCH #3:c=0,e=440,p=0,cr=7,cu=0,mis=0,r=1,dep=0,og=1,plh=3956160932,tim=293942750087
FETCH #3:c=0,e=9,p=0,cr=1,cu=0,mis=0,r=13,dep=0,og=1,plh=3956160932,tim=293942750278
STAT #3 id=1 cnt=14 pid=0 pos=1 obj=73196 op='TABLE ACCESS FULL EMP (cr=8 pr=0 pw=0 time=0 us cost=3 size=532 card=14)' <-- Parte del plan de ejecución
CLOSE #3:c=0,e=14,dep=0,type=0,tim=293944011029
=====================
```

Para hacer que esta salida sea un poco mejor leible podemos utilizar una herramienta de utilizad que trae oracle para traducer dicha traza. Primero nos movemos a dicho directorio en donde se encuentra el archivo traza o le podemos dar la ruta completa hacia el archivo.

```sh
tkprof ./orcl_ora_1040 traza_scott.txt
```

Y obtendremos un archivo de texto mas leible.

```
********************************************************************************

SQL ID: 4ttqgu8uu8fus
Plan Hash: 3956160932
SELECT * 
FROM
 EMP


call     count       cpu    elapsed       disk      query    current        rows
------- ------  -------- ---------- ---------- ---------- ----------  ----------
Parse        2      0.00       0.00          0          0          0           0
Execute      2      0.00       0.00          0          0          0           0
Fetch        4      0.00       0.00          0         16          0          28
------- ------  -------- ---------- ---------- ---------- ----------  ----------
total        8      0.00       0.00          0         16          0          28

Misses in library cache during parse: 1
Optimizer mode: ALL_ROWS
Parsing user id: 84  

Rows     Row Source Operation
-------  ---------------------------------------------------
     14  TABLE ACCESS FULL EMP (cr=8 pr=0 pw=0 time=0 us cost=3 size=532 card=14)

********************************************************************************
```
