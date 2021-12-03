# Tablespaces y Data Files

Como ya vimos el tablespace permite separar y organizar el almacenamiento en la base de datos, estos tablespaces cuentan con datafiles y no es posible que un datafile se encuentre solo. Estos tablespaces luego se dividen en *segments*, que se dividen en *extents*, que se dividen en *oracle blocks*.

El *tablespace*  de *system* contiene al [[Diccionario de Datos]], que se genera al momento de crear la base de datos y no debemos permitir que un usuario cree objetos en este *tablespace*, este  siempre se encuentra en linea.

Existe la posibilidad de usar multiples *tablespaces* para conseguir un mejor criterio de manejo de la base de datos, osea no quedarnos con los 5 *tablespaces* que son generados por la base de datos. Contar con múltiples tablespaces nos permite:

* Manejar granularmente el espacio.
* Manejar características de acceso al almacenamiento.
* Manejar cuotas de almacenamiento de usuario.
* Manejara la disponibilidad de la información, según el estado del `tablespace`, para darle mantenimiento a unas tablas específicas, así no sería necesario poner toda la base de datos `offline`, sino a un solo `tablespace`.
* Realizar respaldos u operaciones de recuperación sobre un solo `tablespace` sin afectar a los demás.
* Colocar un tablespace alrededor de multiples sistemas (sus datafiles).

Al momento de construir los `tablespaces`  se puede manejar su almacenamiento con dos métodos:
* Usando el manejo mediante el diccionario de datos (**Discontinuado** requiere leer multiples veces el diccionario y es muy lento).
* El uso y manejo de los `extents` mediante el `tablespace`, conocido como Manejo Local de Tablespaces.

### Manejo Local de Tablespaces

Acá el tablespace cuenta con un una estructura conocida como *bitmap* (no confundir con el BMB del manejo por segmentos) para cada *datafile* para monitor ear el estado del espacio libre o usado de cada bloque en este data file. Cada *bit* en este *bitmap* representa a un bloque o grupo de bloques, entonces cuando un *extent*  es consumido o liberado, Oracle cambia el valor de los *bits* para indicar el nuevo estado de cada bloque. Aun así estos cambios no son registrados para hacer *rollback* puesto que no genera un cambio en la tablas.

* Evita el uso de procesos recursivos, lo cual lo hace más ágil y directo.
* Maneja las extensiones de forma automática, trata de juntar las extensiones ocupadas y dejar libre las extensiones con espacio.
* Elimina la necesidad de unir extensiones libres.

*Encontramos las siguientes sentencias de SQL para crear un nuevo tablespace:*

Siempre se va de la mano con un datafile, de define el espacio por asignar al datafile, finalmente viene el método/sabor de creacion.

Aca el `AUTOALOCATE` le indica a la base de datos que defina una espacio variable de los `extents` para cada segmento, si un espacio es grande se hacen segmentos grantes. Entonces si una tabla es pequeña, las extensiones son pequeñas y sin afectar a otras tablas.

```sql
CREATE TABLESPACE ltbsb DATAFILE '/u02/oracle/data/ltbsb01.dbf' SIZE 50M EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
```

Acá todas las extensiones se construyen con un tamaño uniforme de 128k, se entra en peligro de fragmentar el espacio al generar inserciones de menor tamaño. 

```sql
CREATE TABLESPACE ltbsb DATAFILE '/u02/oracle/data/ltbsb01.dbf' SIZE 50M EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K;
```

Aca se utiliza Automatic Segment Space Management o ASSM, este elimina la necesidad de manejar las listas del bitmap mediante bloque especial para el manejo de estado del espacio en la extensión.

```sql
CREATE TABLESPACE ltbsb DATAFILE '/u02/oracle/data/ltbsb01.dbf' SIZE 50M EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;
```

Para poner fuera de linea un tablespace utilizamos la siguiente sentencia.

```sql
ALTER TABLESPACE userdata OFFLINE;
```

Para poner un tablespace en linea usamos la siguiente sentencia.

```sql
ALTER TABLESPACE userdata ONLINE;
```

Si un `tablespace` esta compuesto por más de un `datafile` es posible poner fuera de linea a uno solo, para que los otros no se vean afectados pero es usualmente usado para recuperar o respaldar `datafiles`, esto se hace a nivel de base de datos.

Nota: Si se crea un tablespace nuevo y el datafile por asignar ya existe, no es necesaria la clausula `SIZE`.

```sql
CREATE TABLESPACE tbs_prueba DATAFILE 'C:\\ORADATA\\ORCL\\TBS_prueba.DBF' EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
```

### Manejo por Diccionarios de Datos

Acá Oracle actualiza las tablas apropiadas cuando espacio es liberado o consumido en los bloques, esto le permite registrar información para realizar *rollbacks* sobre cada cambio en la tabla del diccionario de datos.

## Tablespaces Encriptados

Permite encriptar un `tablespace` para restringir el acceso mediante otros medios menos el acceso por la base de datos, se niega el acceso al archivo a nivel de sistema operativo.

La siguiente sentencia crea un tablespace con la encriptación predeterminada.
```sql
CREATE TABLESPACE ltbsb DATAFILE '/u02/oracle/data/ltbsb01.dbf' SIZE 50M
ENCRIPTION
DEFAULT STORAGE(ENCRYPT);
```

La siguiente sentencia crea un tablespace con encriptación usando el algoritmo AES256.
```sql
CREATE TABLESPACE ltbsb DATAFILE '/u02/oracle/data/ltbsb01.dbf' SIZE 50M
ENCRIPTION USING 'AES256'
DEFAULT STORAGE(ENCRYPT);
```

Estas clausulas de encriptación vienen antes del modo de manejo de las extensiones.

```sql
 CREATE TABLESPACE tbs_encriptado DATAFILE 'C:\\ORADATA\\ORCL\\TBS_ENCRIPTADI01.DBF' SIZE 50M ENCRYPTION USING 'AES256' DEFAULT STORAGE(ENCRYPT) EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
 
 CREATE TABLESPACE tbs_encriptado DATAFILE 'C:\\ORADATA\\ORCL\\TBS_ENCRIPTADI01.DBF' SIZE 50M ENCRYPTION USING 'AES256' DEFAULT STORAGE(ENCRYPT) SEGMENT SPACE MANAGENEMT AUTO;
````

Pero requieren de configuración adicional, como seria [crear un billetera](https://oracle-base.com/articles/11g/tablespace-encryption-11gr1#wallet_creation)
## Manejo de Espacio en la BD

Para asignar más espacio a un tablespace encontraremos las siguientes 3 formas:

Agregar nuevos *datafiles* a un *tablespace* según se consume espacio.

```sql
ALTER TABLESPACE system ADD DATAFILE '/oracle/data/DATA2.dbf' SIZE 50M;
```

Agregar nuevos *tablespaces* según se consume espacio, esto claro genera nuevos *datafiles* como efecto secundario.

```sql
CREATE TABLESPACE users DATAFILE 'DATA3.ORA' SIZE 50M;
```

Definir el tamaño de un *datafile*, si se llega al limite de un `datafile`, se altera para crecer en tamaño.

```sql
ALTER DATABASE DATAFILE '/oracle/data/DATA3.dbf' AUTOEXTEND ON NEXT 20M MAXSIZE 1000M;
```

Para borrar espacio usamos simplemente la clausula `DROP` y se borra la `tablespace`, aca se borra tanto la estructura logica como la estructura fisica.

```sql
DROP TABLESPACE userdata INCLUDING CONTENTS AND DATAFILES;
```

## Tablespaces Temporales
Un tablespace temporal contiene información transitoria la cual sera almacenada por la duración de la sesión, estas puede mejorar el rendimiento de multiples operaciones de ordenamiento y agrupamiento.

* Usado para llevar a cabo operaciones con un tiempo determinado, mientras dura la sesión.
* Son utiles para un uso mas eficiente de la base de datos.
* Siempre encontraremos un tablespace temporal en nuestra base de datos.
* Usualmente contaremos con el tablespace temporal `TEMP`, pero podemos crear nuestros propios tablespaces temporales.
* Son compartidos, pero se puede crear uno y asignarlo a un solo usuario.

Con la siguiente sentencia se define un tablespace distinto como tablespace temporal.

```sql
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE tablespace_name;
```

Para verificar se encuentra la siguiente sentencia:

```sql
SELECT PROPERTY_NAME, PROPERTY_VALUE FROM DATABASE_PROPERTIES WHERE PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';

PROPERTY_NAME             PROPERTY_VALUE
------------------------- --------------------
DEFAULT_TEMP_TABLESPACE   TEMP
```

Primero se tiene que crear un tablespace temporal

```sql
CREATE TEMPORARY TABLESPACE tbs_prueba TEMPFILE 'C:\\ORADATA\\ORCL\\tbs_prueba.dbf' SIZE 50M;
```
Nota: No es posible usar `AUTOALLOCATE`, los [tablespace temporales](https://docs.oracle.com/cd/B10501_01/server.920/a96540/statements_75a.htm) siempre son uniformes.

Ahora es posible definir un nuevo tablespace temporal.

```sql
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE tbs_prueba;
```

Y verificamos que se encuentre asignado.


```sql
SELECT PROPERTY_NAME, PROPERTY_VALUE FROM DATABASE_PROPERTIES WHERE PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';

PROPERTY_NAME             PROPERTY_VALUE
------------------------- --------------------
DEFAULT_TEMP_TABLESPACE   TBS_PRUEBA
```

Adicionalmente se puede ver en donde se encuentran estos temp files.

```sql
SELECT name FROM v$tempfile;

NAME
--------------------------------------------------------------------------------
C:\ORADATA\ORCL\TEMP01.DBF
C:\\ORADATA\ORCL\TBS_PRUEBA.DBF
```

Para poner al `TEMP` denuevo como tablesapce predeterminado usamos el mismo comando.

```sql
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;
````

Podemos igualmente borrar a este tablespace temporal con el commando que ya hemos visto.

```sql
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;
```

## Estado de un Tablespace

El DBA tiene la posibilidad de poner otros tablespaces aparte de `SYSTEM` en linea o fuera de linea, un tablespace usualmente se encuentra en linea para que sus datos sean accesibles por los usuarios de la base de datos, el DBA debe tener en cuenta lo siguiente:

* Si un tablespace cuenta con segmentos de rollback o sea esta escribiendo sobre el redo log file, este espera hasta que se haga un commit, por esto no podremos poner fuera de linea el tablespace.
* Oracle no permite sentencias SQL sobre el tablespace apagado.
* Si dos tablespaces son usados para separar la información de una tabla y sus indices entonces:
	* Se puede acceder a la data aunque el tablespace con los indices este fuera de linea, puesto que se puede acceder a los datos sin los indices puesto que el campo como tal pertenece a la tabla, el indice ayuda a acceder el objeto con mayor eficiencia por lo cual la lectura sera mas lento.
	* No el tablespace que contiene la información se encuentra fuera de linea, la información no sera accesible.

### Consideraciones
Un tablespaces de solo lectura elimina la posibilidad de realizar operaciones de escritura o borrado.

```sql
ALTER TABLESPACE tbs_prueba READ ONLY

SELECT tablespace_name, status FROM dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
...
TBS_PRUEBA                     READ ONLY

CREATE TABLE table_lectura_prueba (id NUMBER PRIMARY KEY) TABLESPACE tbs_prueba;

ERROR at line 1:
ORA-01647: tablespace 'TBS_PRUEBA' is read-only, cannot allocate space in it
```

No se pueden apagar los siguientes tablespaces: SYSTEM (diccionario), UNDO (operaciones de redo), TEMPORARY (donde se llevan operaciones de agrupado y ordenamiento).

```sql
ALTER TABLESPACE TEMP OFFLINE;

ERROR at line 1:
ORA-03217: invalid option for alter of TEMPORARY TABLESPACE
```

### Apagar tablespaces

Encontramos 3 formas de poner un tablespace fuera de linea: 

**Offline Normal:** Verifica si no existe una condición de error en un datafile de antemano.

```sql
ALTER TABLESPACE tbs_prueba OFFLINE;

SELECT tablespace_name, status FROM dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
...
TBS_PRUEBA                     OFFLINE
```

**Offiline Temporary:** Baja el datafile aunque se den condiciones de error o lo mantiene offline.

```sql
ALTER TABLESPACE tbs_prueba OFFLINE TEMPORARY;
```

**Offiline Immediate:** No se realiza una verificación de error en los datafiles, el medio de recuperación es necesario y no es posible apagarlo si la Base de Datos opera en modo *no archivado*.

```sql
ALTER TABLESPACE tbs_prueba OFFLINE IMMEDIATE;

ERROR at line 1:
ORA-01145: offline immediate disallowed unless media recovery enabled
```

Para poner al tablespace en linea usamos el mismo comando.

```sql
ALTER TABLESPACE tbs_prueba ONLINE;

SELECT tablespace_name, status FROM dba_tablespaces;

TABLESPACE_NAME                STATUS
------------------------------ ---------
...
TBS_PRUEBA                     ONLINE
```
