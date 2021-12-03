# Instancias de Oracle

Recordemos que una instancia se encuentra compuesta por estructuras lógicas y procesos de fondo del servidor, esta es asignada a la base de datos cuando el servidor es iniciado, cuenta con archivos de parámetros (PFILE de Texto y SPFILE que es binario) para saber cuanta memoria utilizar para sus estructuras de memoria y sus procesos de fondo.

Estos archivos de parámetros incluyen lo siguiente:
- Parámetros del nombre de archivos.
- Parámetros de modo de operación de la base de datos (modo archive o modo no archivo).
- Parámetros que afectan la memoria asignada al SGA.
- Parámetros de limites de memoria asignada a la instancia.
- Parámetros del nombre de la base de datos (SID).
- Ubicación de los control files.

Al momento de iniciar el servidor de la base de datos, esta busca los archivos de parámetros para proporcionar la configuración necesaria e incluso conectarse a la base de datos como tal, esto es conocido como montar.

## Etapas de Inicio de una Instancia de Oracle DB

Encontramos los siguientes pasos en el proceso de inicio de un servidor de base de datos de Oracle.

1. Levantar la instancia.
2. Montar la base de datos, o sea unir a la instancia (memoria) y a la base de datos (Físico)
3. Abrir la base de datos, o sea permitir que un usuario o aplicativo puedan acceder mediante consultas a los datos.

![Como levantar una Instancia](https://i.imgur.com/z2NqtsR.png)

### Levantar la Instancia

Oracle lee los archivos de parámetros para determinar los parámetros de iniciación y asignar la memoria necesaria al SGA y al PGA para entonces crear los procesos de fondo.

Encontraremos al PFILE y a SPFILE, pero Oracle únicamente accede a uno en el momento de iniciación.

> Si se hiciera un cambio en los archivos de parámetros sera necesario reiniciar la base de datos (PFILE) o hacerlo en caliente (SPFILE)

### Montar la Base de Datos

Una vez se ha levantado la instancia, se realiza la conexión entre la memoria con lo físico. Después de montar la base de datos la instancia encuentra los control files y redo files para entonces Abrirlos para saber donde y cuales son los data files que corresponden a la base de datos.

#### Montando una Base de Datos en Estado Standby

Esto es usado para contar con sitios de respaldo o contingencia, en donde, en caso de caer la instancia principal, entrara en linea una instancia de respaldo para que las consultas de los usuarios lleguen a esta. Es posible que varias instancias se comuniquen entre si para balancear las cargas y proporcionar mayor disponibilidad, esto es conocido como RAC o *Real Application Cluster.*

Esta instancia debe ser idéntica a la instancia principal, tanto en sistema operativo, configuración, parches, etc

#### Montando una Base de Datos clonada

Corresponde a una copia de la base de datos principal, pero es una copia en un momento dado.

### Abrir la Base de Datos

Al momento de abrir todos los aplicativos pueden acceder a la base de datos, se entra en estado open para que los aplicativos puedan realizar sus consultas. Si el tablespace se encontraba fuera de linea permanecerá así aunque se levante la base de datos nuevamente.

#### Abrir la Base de Datos en modo lectura

En este modo se permite realizar consultas, pero no se permite modificar datos y no se puede escribir sobre los data files, aun así se podrían poner a los data files o tablespaces fuera de linea y el control file continuara operando normalmente en este modo de operación de la base de datos.

## Etapas de Apagado de una Instancia de Oracle DB

El proceso para bajar una instancia sera el mismo pero en orden inverso.

- Cerrar la Base de Datos: Cerrar el lado fisico y no permitir más transacciones ni operaciones.
- Desmontar la Instancia: Cerrar la conexión con la base de datos o desasociar a la base de datos y a la instancia, la instancia se queda en memoria.
- Cerrar la Instancia: Libera y destruye todo lo relacionado a los procesos de memoria de Oracle.

![Bajar una instancia de Oracle](https://i.imgur.com/eXh8Qjl.png)

Encontramos el siguiente comando principal para levantar una instancia.

```sql
STARTUP [FORCE] [RESTRICT] [PFILE=filename] [OPEN*|MOUNT|NOMOUNT] [RECOVER] [database] 
```

_Nota:_ `OPEN` es el parametro predeterminado, este realizar las 3 etapas osea leventa la instancia, monta la instancia y realiza el open.
Aca cada palabra indica hasta cual etapa quedarnos, por ejemplo con solo `MOUNT` no abrimos los archivos y

![STARTUP MOUNT](https://i.imgur.com/HxJzkV8.png)

Por otro lado solo  con `NOMOUNT` nos quedamos en levantar la instancia.

![STARTUP NOMOUNT](https://i.imgur.com/DumSuIg.png)

Tenemos que considerar la forma en la cual hemos iniciado a la base de datos, por ejemplo si iniciamos con `NOMOUNT` o sea no abrimos la BD podemos alterar el estado con la clausula `MOUNT` y luego a `OPEN` con el `ALTER`, o sea no podemos saltarnos pasos, pero si ya hicimos un `STARTUP` no se podremos volver a otras etapas.

![Secuencia de Inicio](https://i.imgur.com/7EEo4cI.png)

Con el `READ ONLY` o `READ WRITE`, unicamente se puede hacer en la etapa de `MOUNT`

```sql
ALTER DATABASE (MOUNT|OPEN);
ALTER DATABASE OPEN (READ WRITE|READ ONLY);
```

Con el comando `RESTRICT` limitamos el acceso a usuarios especiales, así no todos los usuarios podrán acceder a la BD.

```sql
-- Iniciar la instancia en modo restringido
STARTUP RESTRICT;
-- Poner la instancia en modo restringido
ALTER SYSTEM ENABLE RESTRICTED SESSION;
```

> El modo de solo lectura resulta útil cuando se quiere preparar un respaldo para la BD y evitar que se vea alterada.

## Modos de Apagado

Encontraremos 4 formas para apagar una instancia de Oracle cada una con especificaciones distintas.

### Shutdown Normal 

Al momento que se usa este comando **no se permiten nuevas conexiones a la BD**, el servidor entonces esperara a que todos los usuarios se desconecten antes de completar el shutdown (Si alguien se desconecta entonces no podrá volver a conectarse) y por esto es la opción más lenta de las 4. 

Una vez todos se desconectan los procesos de background dejan de trabajar y se remueve el SGA, entonces se desmontada la base de datos para de bajar la instancia. La siguiente iniciación no requiere recuperación de la instancia, o sea no se generan errores en la instancia.

### Shutdown Transaccional

Este asegura que los no usuarios pierdan su trabajo, **espera a que terminen todas las transacciones** para entonces desconectar a todos los usuario e iniciar el proceso de apagado. El siguiente proceso de inicio no requiere recuperación de la instancia.

### Shutdown Inmediato

Los procesos, comandos o transacciones en ejecución son perdidos, o sea no espera a que terminan y cierra, bloquea, hace rollback, aborta las operaciones y empieza el proceso de apagado. Este no requiere recuperación en el proceso de inicio siguiente.

### Shutdown Abort

Las instrucciones o sentencias son terminadas inmediatamente y no le hace rollback a nada, la instancia es terminada sin cerrar los arhivos, la base de datos no es desmontada y el siguiente proceso de inicio requiere del proceso de recuperación.

A continuación un resumen de los cuatro modos de apagado:

| Shutdown Mode                                     | Abort | Immediate | Transactional | Normal |
| ------------------------------------------------- | ----- | --------- | ------------- | ------ |
| Permite nuevas conexiones                         | No    | No        | No            | No     |
| Espera a que la sesion actual termine             | No    | No        | No            | Si     |
| Espera a que las transacciones terminen           | No    | No        | Si            | Si     |
| Fuerza un punto de recuperación y cierra archivos | No    | Si        | Si            | Si     |

## Poniendo en Practica los Modos de Encendido y Apagado de una Instancia

Primero, para verificar el estado de la base de datos podemos usar la siguiente sentencia.

```sql
SELECT host_name, instance_name, startup_time, status FROM v$instance;

HOST_NAME       INSTANCE_NAME    STARTUP_T STATUS
--------------- ---------------- --------- ------------
DIO             orcl             19-JUN-21 OPEN
```

Para ver quienes se encuentran conectados a la instancia podemos usar la siguiente sentencia.

```sql
SELECT username from v$session WHERE username is not null;

USERNAME
------------------------------
DBSNMP
SYS
```

Entonces si fuéramos usar el modo de apagado normal, nos toparemos el problema en que no sabemos en que momento estos usuarios cerraran su sesión. Por esta razón usaremos usaremos un modo de apagado que cierre la sesión de todos de forma inmediata.

```sql
shutdown immediate

Database closed.
Database dismounted.
ORACLE instance shut down.
```

Como vimos en la teoría, todo el trabajo de los usuarios se vera abortado en este modo de apagado. Notemos que se están siguiente los 3 pasos de apagado que hemos visto en donde.

1. Se cierran los archivos de la base de datos.
2. Se cierra la conexión entre la instancia y la base de datos.
3. Se apaga a la instancia.

Ahora para levantar esta instancia podemos usar simplemente el comando  `STARTUP` cuyo parámetro predeterminado es `OPEN`, esto significa que serán realizados los 3 pasos de inicio que ya hemos visto.

```sql
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

Aca notemos que se siguen los 3 pasos de inicio de una instancia.

1. La instancia es iniciada y los archivos de parámetros son leídos para saber cuanta memoria debería de ser asignada a las distintas estructuras lógicas de la instancia, tal serial el caso del SGA.
2. Luego la base de datos es montada, o sea se conecta a la instancia y a la base de datos.
3. Se abren los archivos de la base de datos.

Veamos ahora con otro modo de inicio, el `NOMOUNT`, simplemente usamos el mismo comando con este modificador.

```sql
startup nomount
ORACLE instance started.

Total System Global Area 6814535680 bytes
Fixed Size                  2188688 bytes
Variable Size            3539995248 bytes
Database Buffers         3254779904 bytes
Redo Buffers               17571840 bytes
```

Notemos que acá únicamente se realiza un paso de los tres que vimos hasta el momento.
1. La instancia es iniciada y los archivos de únicamente son leídos para saber cuanta memoria leídos de ser asignada a las distintas estructuras lógicas de la instancia, tal serial el caso del SGA.
2. La base de datos no es montada.
3. La base de datos no es abierta.

Este método de inicio fue más leídos, ya que leídos la memoria fue asignada y los otros pasos no fueron ejecutados. Si vemos el estado de la instancia obtenemos el siguiente resultado.

```sql
SELECT host_name, instance_name, startup_time, status FROM v$instance;

HOST_NAME       INSTANCE_NAME   STARTUP_T     STATUS
--------------  -------------- ------------- -----------
DIO 		 	orcl             22-JUN-21 	 STARTED
```

Aun podemos pasar a un estado open, pero el proceso de inicio siempre sera **lineal** por lo cual tenemos que montar y **luego** abrir la base de datos.

Primero vamos a montar la base de datos.

```sql
ALTER DATABASE MOUNT;

Database altered.
```

Ahora vamos a abrir la base de datos.

```sql
ALTER DATABASE OPEN;

Database altered.
```

Este es el estado de la base de datos ahora.

```sql
SELECT host_name, instance_name, startup_time, status FROM v$instance;

HOST_NAME       INSTANCE_NAME   STARTUP_T     STATUS
--------------  -------------- ------------- -----------
DIO 		 	orcl             22-JUN-21 	 OPEN
```
