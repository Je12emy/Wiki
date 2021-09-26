# Architectura de Memoria

Dentro de la instancia de Oracle tenemos al System Global Area (SGA) que es un área compartida en donde pasan todas las solicitudes de los usuarios para pasar hacia otras areas de la instancia.

-   Apartir de ella podemos tomar o procesar transacciones
-   Podemos controlar las transacciones
-   Podemos cuales queries se han ejectuado.

Cada sesión tiene su propio PGA, la base de datos entonces genera un espacio de memoria para gestionar dichos PGA, este parámetro es llamado `pga_aggregate_target`

Esta instancia a su vez se encuentra compuesta por distintas estructuras de memoria
![ Proceos Principales ](https://i.pinimg.com/736x/5e/12/0e/5e120e34bac9f454839b792d0cd481d3.jpg)

Encontramos las siguientes.

## Database Buffer Cache

Esta estructura se encarga de **leer bloques** de datos en los data files y traerlos a memoria, de esta manera el usuario leería los bloques desde memoria. Este entonces mantiene copias de bloques de datos, que se leen desde los `datafiles`, esta copia se realiza para los bloques que han sido requeridos previamente. Por ser un buffer tiene un limite, por lo cual constantemente se esta limpiando y llenando.

> Una base de datos no se debería bajar cuando se encuentra en producción, esto se debe a que el cache vendrá limpio y las consultas serán lentas al inicio por que tienen que leer desde el disco.

Este cache se divide entonces en otras dos areas (principales):

-   **Dirty List**: Contiene datos que han sido modificados pero aun no se han escrito en disco, entonces modificaciones que aun no han tenido un `commit` se quedaran en esta estructura.
-   **Least Recently Used (LRU) List**: Esta lista almacena los buferes libres, que no han sido tocados y los buferes que no han sido movidos aun al `dirty list` (o sea que hubo una modificación sin un commit). Entonces almacena los bloques que aun no han sido movidos al dirty list para que cuando se haga un commit, estos quedaran libres.

Acá entonces sucede lo siguiente

![Proceso de LRU](https://i.imgur.com/zGcfxPI.png)

1. La primera vez que un proceso de usuario (los procesos mediante los cuales los usuarios se conectan a la instancia), el dato es buscando en el cache y si lo encuentra, lo lee desde ahi. Si no encuentra el dato debe de ir a buscar el bloque y traerlos desde el DF y entonces subirlo al cache en el LRU.
2. Cuando un usuario realizar alguna modificación esta modificación sera realizada en la memoria cache y el campo sera movido al dirty puesto que no ha sido guardado con un `commit`,
3. Si se realiza un `commit` el dato en `Dirty List` sera libreado y movido al LRU.

## Redo Log Buffer

Es muy parecido pero diferente al `Cache Buffer`, pero este maneja las estructuras de los datos que se cambiaron, este es un buffer circular (constantemente se llena y limpia) que se encarga de almacenar la información acerca de los cambios que se han hecho en la base de datos. Dentro de este buffer se estaran generando constantemente `redo records` o `redo entries` que tienen la información necesaria para poder deshacer una transacción.

Cuando un dato pasa de LRU a Dirty List, una copia o un `redo reccord` es movido al Redo Buffer para poder deshacer dicho cambio, si se hace un rollback el dato es simplemente traido desde este `Redo Log Buffer` hacia el `Dirty List`.

-   El proceso de memoria `Log Writter` o LGWR escribe lo que se encuentra en este buffer hacia los `Redo Log Files`.
-   El tamaño de este buffer es definido mediante la clausula `Automatic Management Memory` que indica como queremos administrar las estructuras de memoria, se puede hacer de forma manual o que sea automaticamente gestionado por la base de datos (esta es la configuración recomendada).

## Shared Pool

Se almacenan **consultas SQL** recientemente ejecutadas y las mas recientes definiciones de datos (estructuras), esto es clave para el `parsing` de una sentencia o compilación de una sentencia, entonces puede ser que se vuelva a ejecutar una sentencia que ya fue compilada que se encuentra en memoria.

Cuenta con dos estructuras clave:

-   Library Cache: Se compone por otras areas de almacenamiento:
    -   Shared SQL Area.
    -   PL Procedures and Packages.
    -   Control Structures: Bloqueos, librerias.
-   Data Dicctionary Cache: Almacena las estructuras utilizadas por el diccionario para verificar una consulta.

El parametro que determina el tamaño asignado a esta estructura se conoce como `SHARED_POOL_SIZE`.

### Library Cache

Almacena informacion sobre las sentencias SQL y PL/SQL recientemente utilizadas, este como tal cuenta con dos estructuras.

-   Shared SQL Area.
-   Shared PL/SQL Area (Incluye paquetes).

Ademas se cuentan con areas privadas de cada uno para cada instancia.

-   Shared SQL Area: Contiene el `parsing` de una sentencia, el plan de ejecución (Todos los pasos que necesita hacer el motor para llevar a cabo esta sentencia, es la planificación para llegar a los datos solicitados) para sentencias SQL identicas significa que cualquier cambio causara que el motor vea a la sentencia como una totalmente distinta.
-   Private SQL Area: Información exclusiva de una sesión, recordemos que se identifica a una sesión con el `SID` y el `SERIAL#`.


> Los paquetes cuentan con un encabezado y cuerpo que agrupa o encapsula procedimientos y funciones que tienen que ver con un tema específico ej clientes.[funcion]. Un ejemplo de un paquete que hemos usado antes seria el dbms_stats que incluye funciones como el dbms_stats.gather_table_stats.

## Dictionary Cache

Información que hace referencia a los objetos usados en el `parsing` de sentencias por parte del diccionario de datos, asi esta es leida desde memoria y no desde el disco.

## Large Pool

Para no restar espacio ni procesos a las demas estructuras en medio de respaldos, la memoria se extrae del `Large Pool`

## Vistas Utiles

Vistas relacionadas al SGA.

| Vista          | Descripción                              |
| -------------- | ---------------------------------------- |
| V$SYSSTAT      | Estadísticas básicas de la instancia     |
| V$SGASTAT       | Estado de uso del SGA.                   |
| V$PROCESS      | Procesos de Oracle                       |
| V$SESSION      | Información de los usuarios o procesos   |
| V$SORT_SEGMENT | Ordenamiento de los segmentos temporales |
| V$PGASTAT      | Estadisticas de uso del PGA              |

Vistas de Memoria

| Vista          | Descripción                                                                                                                                                                                                                                                                   |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| V$LIBRARYCACHE | Rendimiento del library cache (o sea las consultas SQL), combinado con otras vistas este deberia ser mayor que %90 (donde el uso de los objetos esta sobre el 90%) y si cae significa que esta faltando memoria o simplemente se esta llendo mucho a disco para leer bloques. |

## Ajustes del SGA

Deberiamos prestar atención a los siguientes sintomas para empezar a realizar ajustes al SGA.

-   Alta contención en el latch que son microbloqueos para evitar que se accedan a los mismos por varias sesiones.
-   `Parse Time` o tiempos de compilación, tiene que ser bajo.
-   Muchas recargas, cuantas veces se tuvo que ver la misma tabla para consultar datos.

### Ejecución de una Sentencia

La ejecución de una sentencia tiene varias fases.

1. Analisis sintactico y semantico, y calculo del plan de ejecución.
2. En el `Library Cache` se guardan las sentencias SQL ya compiladas (que se ejecutaron).
3. En el `Sql Area` se guardan los planes de ejecución de cada sentencia.

Vamos a encontrar dos tipos de compilación de sentencias.

-   **Hard Parse**: La sentencia no existe en el `Shared SQL Area` ( en el `Library Cache`), es una compilación costosa en terminos de CPU y latches, es la primera vez que se ejecuta una sentencia.
-   **Soft Parse**: La sentencia ya existe en el `Shared SQL Area` y se puede volver a usar.

Dos sentencia son iguales si:

-   Tiene exactamente el mismo texto.
-   Los nombres de los objetos apuntas a los mismos objetos reales (esto hace referencia a las vistas y sinonimos).
-   El modo de optimizador es el mismo.
-   Los tipos y longitues de las variables `bind` son los mismos.
-   El entorno NLS (idioma y país) es el mismo

# Poniendolo en Practica

Como vimos el `Library Cache` en el `Shared SQL Area` encontraremos al plan de ejecución, supongamos que queremos realizar la siguiente consulta.

```sql
SELECT e.employee_id, e.first_name, e.salary, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;

EMPLOYEE_ID FIRST_NAME               SALARY DEPARTMENT_NAME
----------- -------------------- ---------- ------------------------------
        200 Jennifer                   4400 Administration
        201 Michael                   13000 Marketing
        202 Pat                        6000 Marketing
        114 Den                       11000 Purchasing
        115 Alexander                  3100 Purchasing
        116 Shelli                     2900 Purchasing
        117 Sigal                      2800 Purchasing
```

Y queremos ver el plan de ejecución de esta sentencia, para esto podemos usar el comando `EXPLAIN PLAN FOR <statement>`.

```sql
EXPLAIN PLAN FOR
SELECT e.employee_id, e.first_name, e.salary, d.department_name
FROM hr.employees e, hr.departments d
WHERE e.department_id = d.department_id;

Explained
```

Entonces para verlo lo realizamos de la siguiente manera.

```sql
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 1343509718

--------------------------------------------------------------------------------------------
| Id  | Operation                    | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |             |   106 |  3604 |     6  (17)| 00:00:01 |
|   1 |  MERGE JOIN                  |             |   106 |  3604 |     6  (17)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| DEPARTMENTS |    27 |   432 |     2   (0)| 00:00:01 |
|   3 |    INDEX FULL SCAN           | DEPT_ID_PK  |    27 |       |     1   (0)| 00:00:01 |
|*  4 |   SORT JOIN                  |             |   107 |  1926 |     4  (25)| 00:00:01 |
|   5 |    TABLE ACCESS FULL         | EMPLOYEES   |   107 |  1926 |     3   (0)| 00:00:01 |

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")
       filter("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID")

18 rows selected.
```

Acá podemos ver todos los pasos necesario para llegar al resultado de la consulta, en este caso la base de datos utilizo un total de 5 pasos.

-   Realizo un `INDEX FULL SCAN` usando a la llave `DEPT_ID_PK` o sea la llave primaria de `HR.Deparments`, en donde proceso un total de 27 filas y consumio 0 Bytes, esto tuvo un costo de 0.


> Podemos consultar esta misma información desde PLAN_TABLE, pero la salida no sera tan leible como lo acabamos de ver con el paquete de DBMS_XPLAN.

Al mismo tiempo podremos ver que en `PLAN_TABLE` encontraremos a los campos `STATEMENT_ID` y `PLAN_ID` para consultar otros planes de ejecución, aun asi el paquete `DBMS_XPLAN` muestra el ultimo `EXPLAIN` ejecutado.

Podemos mostrar el plan de ejecución despues de realizar cualquier consulta con el comando `SET AUTOTRACE ON EXPLAIN` y asi podremos ver el plan alfinal de cada consulta.

```sql
SELECT * FROM hr.employees;

...
107 rows selected.


Execution Plan
----------------------------------------------------------
Plan hash value: 1445457117

-------------------------------------------------------------------------------
| Id  | Operation         | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |           |   107 |  7383 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| EMPLOYEES |   107 |  7383 |     3   (0)| 00:00:01 |
-------------------------------------------------------------------------------
```

```ad-attention

Hay que tener cuidado con los TABLE ACCESS FULL, en donde es posible que no se esten utilizando indices (que hayamos definido) para leer la tabla.

```

Enfoquemonos ahora en la vista del diccionario `V$SQLAREA`, vimos que en la estructura `Shared Sql Area` del `Library Cache` encontraremos información sobre las sentencias SQL identicas, entre los campos relevantes encontraremos los siguientes.

| Campo          | Descripción                                                                                                                      |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| SQL_TEXT       | Los primeros mil caracteres de la sentencia.                                                                                     |
| SQL_FULLTEXT   | Muestra todo el texto de una sentencia, por esto es de tipo [`CLOB`](https://docs.oracle.com/javadb/10.10.1.2/ref/rrefclob.html) |
| SORTS          | Muestra los ordenamientos realizados                                                                                             |
| EXECUTIONS     | Cantidad de veces que se ejecuto una sentencia                                                                                   |
| FETCHES        | Cantidad de fetches usados cuando usamos cursores                                                                                |
| DISK_READS     | Cantidad de lecturas a disco                                                                                                     |
| BUFFER_GETS    | Cuando fue tomado de memoria                                                                                                     |
| OPTIMIZER_MODE | Optimizador utilizado en la sentencia, vimos esto al momento de mostrar la fragmentación de una tabla                            |
| OPTIMIZER_COST | El costo de cada optimizador                                                                                                     |
| CPU_TIME       | Costo para el CPU                                                                                                                |
| ELAPSED_TIME   | Tiempo que tomo la sentencia                                                                                                     |

Veamos un poco de información sobre el `SELECT` a la tabla `HR.employees`.

```sql
SELECT executions, disk_reads, optimizer_mode, cpu_time FROM v$sqlarea WHERE sql_text LIKE '%SELECT * FROM hr.employees%';

EXECUTIONS DISK_READS OPTIMIZER_   CPU_TIME
---------- ---------- ---------- ----------
         2          2 ALL_ROWS            0
         4          0 ALL_ROWS        46875
         2          0 ALL_ROWS            0
         2          0 ALL_ROWS            0
         1          0 ALL_ROWS            0
```

Acá es clave recordar, que si realizamos cualquier cambio a la sentencia sql, el motor lo vera como una sentencia completamente distinta.

Digamos que deseamos ver las estadísticas de cada consulta, podemos realizarlo con la misma vista de `v$sqlarea`, pero en el caso de estadísticas básicas como la cantidad de bloques leídos podemos adicionalmente habilitar la traza de esto.

```sql
SET AUTOTRACE ON STATISTICS;
SELECT * FROM hr.employees;

...
107 rows selected.


Statistics
----------------------------------------------------------
          0  recursive calls
          0  db block gets
         15  consistent gets
          0  physical reads
          0  redo size
      10427  bytes sent via SQL*Net to client
        597  bytes received via SQL*Net from client
          9  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
        107  rows processed
```

Estas estadísticas son guardadas en el la estructura `SQL Area` del `Library Cache`, esta es un simple manera de imprimir por pantalla unas cuantas de forma automática.

En este caso veamos lo siguiente:

-   Hay un total de 0 lecturas física, esto significa que estamos leyendo desde memoria (LRU en este caso).
-   Hay 0 ordenamientos en memoria y 0 ordenamientos en disco, entonces agregamos una clausula de ordenamiento para ver como cambia el resultado

```sql
SELECT * FROM hr.employees ORDER BY salary,department_id;

...
107 rows selected.

Statistics
----------------------------------------------------------
          1  recursive calls
          0  db block gets
          7  consistent gets
          0  physical reads
          0  redo size
      10269  bytes sent via SQL*Net to client
        597  bytes received via SQL*Net from client
          9  SQL*Net roundtrips to/from client
          1  sorts (memory)
          0  sorts (disk)
        107  rows processed

```

Ahora el resultado de las estadísticas ha cambiado:

-   Hay un ordenamiento en memoria, el query fue utilizado desde memoria y solo se aplico el ordenamiento necesario.
-   Existen menos `consistent gets`, no tuvo que leer tantos bloques por que encontró la consulta en memoria.
-   Hay una llamada recursiva, el query ya había sido ejecutado y se volvió a usar desde la memoria.
