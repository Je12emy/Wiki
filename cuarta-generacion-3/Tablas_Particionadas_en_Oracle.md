# Tablas Particionadas en Oracle

Una tabla particionada es aquella tabla que se encuentra divida, este es un proceso físico en donde se toma una tabla y partirla físicamente, al crear una tabla creamos un segmento de tipo tabla y a este segmento lo vamos a partir en otros segmentos más pequeños.

-   Esto facilita el manejo de tablas e indices muy grandes usando la lógica _divide y vencerás_.
-   Puede poseer una o más particiones, en las cuales cada una almacena filas con características definidas.
-   Una tabla puede ser particionadas en 64.000 particiones
-   Cualquier tabla puede particionarse, exepto aquellas que usen tipos `LONG` o `LONG RAW` puesto que este es un tipo de dato viejo y grande que usa encadenamiento por lo cual no se pueden separar.
-   Cada partición es su propio segmento, que a su vez, puede estar ubicado en un tablespace diferente

Gracias al particionamiento se obtienen los siguientes beneficios:

-   Mejora la disponibilidad de datos, ya que cada partición tendrán su propia disponibilidad.
-   Facilita la administración de segmentos grandes.
-   Mejora el rendimiento en ciertas consultas.
-   Reduce la contención, repartiendo la carga de consultas entre las particiones.

Cuando hablamos de contención nos referimos a poder dividir las consultas realizadas a los datafiles mediante un particionamiento que promueva la separación de los datos, en este caso se esta particionando a una tabla basado en años en donde se maneja a un tablespace con datos históricos y otro para datos actuales.


Se _recomienda_ implementar la particionamiento cuando se cumplen los siguientes casos.

-   La tabla tiene un tamaño superior a 2 GB, aun asi se debe de tomar en cuenta el tipo de datos que se almacenan ej. almacenar audio o video.
-   Las tablas mantienen registros históricos.


> En cada partición puede darse fragmentación, por lo cual tendremos que desfragmentar al objeto completo.


## Métodos de Particionamiento

Los siguientes son los métodos básicos de particionamiento, pero en versiones mas recientes de Oracle Database encontraremos otras formas.

-   **Particionamiento por rango**: Genera los datos para el particionamiento basado en un rango de valores, ej enero de 1976 a 1986, de enero 1987 a 1997, etc.
-   **Particionamiento por hash**: Un hash es una función que genera un valor único (para cada registro), aca la base de datos se encarga por si sola de guardar un registro en una partición, es un método que busca distribuir la carga alrededor de la tabla.
-   **Particionamiento por lista**: Este es cuando explícitamente se indica que si un campo cuenta con valor, pertenece a una partición específica. ej si el cliente vive en _x_ ubicación, guardar el registro en _y_ partición.
-   **Particionamiento compuesto:** Combinación de varios métodos de particionamiento, en versiones superiores a 12 se pueden hacer mas combinaciones que en version 11.

Es posible particionar a una tabla despues de crear una tabla, pero se debe de tener cuidado por que puede ser los datos sean movidos a una particion en la cual no esperábamos, por esto debemos de conocer bien que datos tiene la tabla como tal.

### Particionamiento por Rango

Se hace particionamiento haciendo uso de rangos de valores de la clave de particionamiento, tenemos que tener en cuenta lo siguiente:

-   Se usa la clausula `VALUES LESS THAN`, que índica un **límite superior** no inclusivo, entonces si creamos una partición con rango mayor a Enero a Marzo los registros con un valor mayor o igual a Enero **no serán** incluidos en esta partición.

-   Un `MAXVALUE` puede ser definido para la última partición, representa un limite virtual de infinito.

```sql
CREATE TABLE empleados (
    employee_id NUMBER(3),
    first_name VARCHAR2(30),
    hire_date DATE,
    salary NUMBER(7, 2),
    department_id NUMBER(3)
)
PARTITION BY RANGE (salary)
(
    PARTITION EMP_PART1 VALUES LESS THAN (5000) tablespace tbs1
    PARTITION EMP_PART2 VALUES LESS THAN (10000) tablespace tbs2,
    PARTITION EMP_PART3 VALUES LESS THAN (15000) tablespace tbs3,
    PARTITION EMP_PART4 VALUES LESS THAN (MAXVALUE) tablespace tbs4
);
```

Acá entonces sucederá lo siguiente:

-   Un valor de 4800 quedara en `tbs1`.
-   Un valor de 5000 quedara en `tbs2`.
-   Un valor de 7000 quedara en `tbs2`.
-   Un valor de 15001 quedara en `tbs4`

### Particionamiento por Hash

El particionamiento se realiza mediante la función hash, dejando que la Base de datos defina donde almacenar los registros, es útil cuando:

-   Se desconoce la correspondencia de los rangos, no se sabe como se distribuir las particiones.
-   Es difícil balancear la carga sobre la tabla, puede ser que una partición termine siendo muy grande y otras queden pequeñas.

En el particionamiento por `Hash` encontraremos dos consultas similares.

```sql
CRETE TABLE sales_hash (
    salesman_id NUMBER(5),
    sales_name VARCHAR2(30),
    sales_ammount NUMBER2(10),
    week_no NUMBER(2)
)
PARTITION BY HASH(salesman_id)
PARTITIONS 4
STORE IN (data1, data2, data3, data4);
```

También se puede usar la siguiente consulta en donde se especifica en cual `tablespace` almacenar.

```sql
CREATE TABLE sales_hash (
    s_productid NUMBER,
    s_salesdate DATE,
    s_custid NUMBER,
    s_totalprice NUMBER
)
PARTITION BY HASH(s_productid)
(
    PARTITION p1 TABLESPACE tbs1,
    PARTITION p2 TABLESPACE tbs2,
    PARTITION p3 TABLESPACE tbs3,
    PARTITION p4 TABLESPACE tbs4
);
```

### Particionamiento por Lista

Permite especifica en cual particion quedemos que quede un registro basado en un valor específico.

-   Usa valores fijos para realizar el particionamiento, por ejemplo un código postal, código de canton, código de provincia, código de país, etc, tienen que ser datos consistentes.
-   No se permiten datos compuestos o sea combinar campos para el criterio de particionamiento.
-   Una vez que se particiona la tabla por lista, se tendrá una partición `default` y no sera posible crear nuevas particiones, sino se tendría que borrar la partición `default` para agregar nuevas particiones por lista.

```sql
CREATE TABLE sales_list (
 salesman_id NUMBER(5),
 sales_name VARCHAR2(30),
 sales_state VARCHAR2(20),
 sales_amount NUMBER(10),
 sales_date DATE
)
PARTITION BY LIST(sales_state)
(
    PARTITION sales_west VALUES ('California', 'Hawai'),
    PARTITION sales_east VALUES ('New York', 'Virginia', 'Florida'),
    PARTITION sales_central VALUES ('Texas', 'Ilinios'),
    PARTITION sales_other VALUES (DEFAULT)
);
```

Acá entonces si el estado no es uno de los especificados, quedaran en la partición `sales_other`y no seria posible crear una partición nueva, puesto que los datos que no encajaron caerán en la partición predeterminada, por lo cual sera necesario borrar la partición `DEFAULT` y crear la nueva partición.

### Particionamiento Compuesto

-   En el particionamiento compuesto el primer nivel de división es siempre primero por rango, esto solo aplica de versión 11 hacia abajo de 12 hacia arriba se puede iniciar con lo que se quiera.
-   En el nivel secundario de particionamiento puede ser por lista o por hash, claro en versión 11.
-   Cuando se utiliza este **método no habrán segmentos de partición**, sólo habrá segmentos de subpartición de la partición principal, esto significa que solo se puede obtener información de la subpartición como tal y no de la partición completa.

En este caso una tabla fue perticionada en 3, en donde cada particion fue subparticionada en otras 3, entonces se obtienen 12 subsegmentos y los segmentos de las 3 particiones originales no serán accesibles que serán vistos como segmentos normales en la base de datos.

Es posible usar el particionamiento compuesto de la siguiente manera usando una plantilla para cada subpartición.

```sql
CREATE TABLE sales_composite
(
    salesman_id NUMBER(5),
    sales_name VARCHAR2(30),
    sales_ammount NUMBER(10),
    sales_date DATE
)
PARTITION BY RANGE (sales_date)
SUBPARTITION BY HASH(salesman_id)
SUBPARTITION TEMPLATE (
    SUBPARTITION sp1 TABLESPACE data1,
    SUBPARTITION sp2 TABLESPACE data2,
    SUBPARTITION sp3 TABLESPACE data3,
    SUBPARTITION sp3 TABLESPACE data4
) (
    PARTITION sales_jan2000 VALUES LESS THAN (TO_DATE('01/01/2000', 'DD/MM/YYYY')),
    PARTITION sales_feb2000 VALUES LESS THAN (TO_DATE('02/01/2000', 'DD/MM/YYYY')),
    PARTITION sales_mar2000 VALUES LESS THAN (TO_DATE('03/01/2000', 'DD/MM/YYYY')),
    PARTITION sales_apr2000 VALUES LESS THAN (TO_DATE('04/01/2000', 'DD/MM/YYYY'))
);
```
Esta sentencia también es valida.

```sql
CREATE TABLE composite_example (
    range_key_column DATE,
    hash_key_column INT,
    data VARCHAR2(20)
)
PARTITION BY RANGE (range_key_column)
SUBPARTITION BY HASH (hash_key_column)
SUBPARTITIONS 2
(
    PARTITION part1 VALUES LESS THAN (TO_DATE('01/01/2005'), 'DD/MM/YYYY')
    (
        SUBPARTITION part_1_sub_1,
        SUBPARTITION part_1_sub_2
    ),
    PARTITION part2 VALUES LESS THAN (TO_DATE('01/01/2006', 'DD/MM/YYYY'))
    (
        SUBPARTITION part2_sub_1,
        SUBPARTITION part2_sub_2
    )
);
```
Acá realizar un `INSERT` no require de lógica adicional, ya que la base de datos por si sola identifica en cual de las particiones debería de ser almacenado cada registro.

## Consultar Tablas Particionadas

Al consultar una partición encontraremos la clausula `PARTITION` en el `SELECT`.

```sql
SELECT * FROM <table_name> PARTITION (<partition_name>);
```

## Vistas Relevantes

Podemos utilizar a las siguientes consultas para obtener información sobre cada tabla y si se encuentra particionada.

```sql
SELECT table_name, tablespace_name, partitioned FROM user_tables:

TABLE_NAME                     TABLESPACE_NAME                PAR
------------------------------ ------------------------------ ---
ICOL$                          SYSTEM                         NO
CON$                           SYSTEM                         NO
UNDO$                          SYSTEM                         NO
PROXY_ROLE_DATA$               SYSTEM                         NO
FILE$                          SYSTEM                         NO
UET$                           SYSTEM                         NO
IND$                           SYSTEM                         NO
SEG$                           SYSTEM                         NO
```

Obtener el nombre de cada partición, el `tablespace` en el cual fue creada y su criterio de particionamiento.

```sql
SELECT partition_name, tablespace_name, high_value FROM user_tab_partitions;

PARTITION_NAME                 TABLESPACE_NAME HIGH_VALUE
------------------------------ --------------- -------------------------
PART_TABLES                    SYSTEM          'TABLE', 'VIEW'
PART_PROCEDURES                SYSTEM          'PROCEDURE', 'FUNCTION',
                                               'PACKAGE', 'PACKAGE BODY'

PART_INDEX                     SYSTEM          'INDEX'
PART_TRIGG                     SYSTEM          'TRIGGER'
PART_OTHER                     SYSTEM          DEFAULT
WRH$_FILEST_1605272330_0       SYSAUX          1605272330, 29
WRH$_FILEST_1605272330_29      SYSAUX          1605272330, 59
```

Acá en la partición `PART_INDEX` el criterio podemos ver que es por lista donde el valor sea `INDEX`.
