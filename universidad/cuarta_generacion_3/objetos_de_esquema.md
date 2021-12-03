# Objetos de Esquema

Ya hemos visto varias las formas de almacenar información de usuario, sin embargo existen un conjunto de parámetros que permiten alterar la forma en la cual estas utilizan el espacio disponible. Cuando creamos una tabla, automáticamente se genera un segmento de tipo `table`, el tamaño de una tabla crece con operaciones como `INSERT` y `UPDATES`. Vamos a encontrar 2 parámetros al momento de crear una tabla `PCTFREE` y `PCTUSED`.

Oracle siempre intentara guardar una registros en un solo bloque de datos, aun así habrán casos en donde no sera posible y hara uso de encadenamiento de bloques. Un bloque contiene filas las cuales cuentan con un encabezado y los datos por guardar, acá cada fila cuenta con un identificador único en toda la base de datos.

![Fila en un Bloque de Oracle](https://docs.oracle.com/cd/B19306_01/server.102/b14220/img/cncpt043.gif)

Podemos entonces ver, que este encabezado cuenta con el identificador único `rowid` que es un identificador del registro dentro de toda la base de datos, este identificador cuenta con dos formatos.

![Formatos de rowid en Oracle Databse](https://i.imgur.com/XHDbtgr.png)

-   Formato Extendido, con el cual usualmente trabajamos.
    -   Nombre del Objeto: Primeros 6 dígitos
    -   Numero de Archivo Relativo: Siguientes 3 dígitos.
    -   Numero de Bloque: Siguientes 6 dígitos.
    -   Numero de Fila: Siguientes 3 dígitos
-   Formato Restringido.

Este puede ser agregado como una pseudo columna en cualquier consulta.

```sql
SELECT department_id, rowid FROM hr.departments;

DEPARTMENT_ID ROWID
------------- ------------------
           10 AAAR5fAAFAAAACtAAA <-- Formato extendido
           20 AAAR5fAAFAAAACtAAB
           30 AAAR5fAAFAAAACtAAC
           40 AAAR5fAAFAAAACtAAD
```

Acá en el primer registro vemos lo siguiente.

-   `AAAR5f` es el nombre del objeto
-   `AAF` es el numero relativo del archivo.
-   `AAAACt` es en número de bloque.
-   `AAA` es el número de fila.

Este ID sera borrado cuando se hace un `DELETE` o se haga un `IMPORT/EXPORT` donde no se exporta el rowid y entonces al reconstruir el bloque ciertos parámetros serán alterados como el numero relativo del archivo.

## PCTFREE Parameter

Este parámetro indica que cada bloque al insertar en un bloque, debe de reservar por lo mínimo un % libre para futuras actualizaciones. En un caso donde el tamaño de un bloque es de 8 kb y definimos un `PCTFREE` de 20%, entonces se debe de reservar por lo menos 1.6 kb de espacio para que los registros dentro de este sean actualizados. Si el bloque se llena pero aun cuenta con el 20% reservado, futuros registros ocuparan encadenamiento, pero si dentro de este bloque una fila requiere usar más espacio, hara uso del espacio reservado. Este parámetro puede ser alterado pero esto no es recomendado y es mejor definirlo desde que se crea la tabla.

Este espacio libre permite evitar el encadenamiento, ya que las actualizaciones al registro usaran el mismo bloque en donde fueron insertados originalmente.

![Parametro PCTFREE](https://docs.oracle.com/cd/B19306_01/server.102/b14220/img/cncpt029.gif)

## PCTUSED Parameter

Este parámetro es vagamente similar, define el porcentaje mínimo de espacio libre en un bloque hasta que nuevos registros puedan ser insertados. Una vez se consume un bloque, Oracle lo considera como ya no disponible para inserciones, acá sera posible insertar hasta que el porcentaje de uso baje según lo indicado por el `PCTUSED`. Básicamente indica un porcentaje de espacio libre en un bloque para que se pueda volver a insertar bloques. Este entra en acción una vez la tabla es marcada como no usable.

![Parametro PCTUSED](https://docs.oracle.com/cd/B13789_01/server.101/b10743/cncpt030.gif)

Ambos parámetros se usan juntos para tunear el almacenamiento, en este diagrama ocurre lo siguiente.

-   Asumiendo que el parámetro ``PCTFREE` indica que un 20% del bloque debe de quedar libre para actualizaciones, se podrán insertar registros libremente hasta llegar a este.
-   Cuando se consuma todo el espacio del bloque hasta llegar a un 80% (puesto que el otro 20% debe de quedar libre), Oracle marcara al bloque como no disponible (Aun sera posible realizar actualizaciones)
-   Según el parámetro `PCTUSED`, no sera posible insertar más registros sobre este bloque hasta que su utilización baje del 40%, entonces si se borraran registros hasta quedar a un 41% de utilización no sera posible utilizar este bloque.

El siguiente diagrama muestra esto en acción.

![Diagrama Completo de `PCTUSED`](https://docs.huihoo.com/oracle/database/9ir1/server.901/a88856/scn81031.gif)

## Consideraciones para Definir los Parámetros PCT

-   En una tabla log, estos deberían ser 0, ya que en registros históricos no se harán modificaciones.
-   Una tabla que se usa como dataware house, deberían ser 0 ya que los datos también son históricos.
-   Una tabla transaccional con inserciones y actualizaciones, debería configurarse sobre el 0.

## Ejemplo

Crear una tabla con un `PCTFREE` de 0%, donde se puede usar el 100% de la tabla.

```sql
CREATE TABLE pctfree_ejemplo_objetos_1 PCTFREE 0
AS SELECT * FROM all_objects;
```

Crear una tabla con un `PCTFREE` de 10%, este es el valor predeterminado.

```sql
CREATE TABLE pctfree_ejemplo_objectos2 PCTFREE 10
AS SELECT * FROM all_objects;
```

Veamos el resultado de crear estas tablas con porcentajes de `PCTFREE`

```sql
SELECT segment_name, bytes/1024/1024 mb, blocks FROM dba_segments
WHERE segment_name LIKE 'PCTFREE_EJEMPLO%'
AND segment_type = 'TABLE';

SEGMENT_NAME                      MB     BLOCKS
------------------------- ---------- ----------
PCTFREE_EJEMPLO_OBJECTOS2          9       1152 <-- PCT de 10
PCTFREE_EJEMPLO_OBJETOS_1          8       1024 <-- PCT de 0
```

Acá podemos ver lo siguiente.

-   La tabla con un `PCTFREE` de 0%, consume 1 MB menos que aquella con un 10%.
-   La tabla con un `PCTFREE` de 10%, require más bloques que aquella con 0%. 0%.

Estos dos a causa de que los bloques con un `PCTFREE` de tienen que guardar un 10% libre y esto puede generar encadenamiento **al momento de insertar nuevos registros**

## Tablas Temporales

Es importante diferenciar entre tablas temporales y tablas permanentes, una tabla temporal es aquella que esta hecha para que sus registros sean borrados, usualmente cometemos el error de utilizar a una tabla permanente como una tabla temporal, vamos a encontrar dos tipos de tablas temporales.

-   Tablas Temporales Globales, disponibles desde la version 8i.
-   Tablas Temporales Privadas, disponibles desde la version 18c.

Para crear una tabla temporal usamos el siguiente comando.

```sql
CREATE GLOBAL TEMPORARY TABLE My_temp_table (
    id NUMBER,
    description VARCHAR2(90)
) ON COMMIT DELETE ROWS; -- Indicamos la condición bajo la cual borrar la tabla.


CREATE GLOBAL TEMPORARY TABLE My_temp_table (
    id NUMBER,
    description VARCHAR2(90)
) ON COMMIT PRESERVE ROWS; -- Estos datos seran mantenidos en la sesión, si esta se cierra.
```

Cada usuario puede leer únicamente los registros generados por su sesión en la tabla temporal, entonces 2 usuarios estarán leyendo datos distintos en una tabla temporal. En las temporales privadas es posible que todas las sesiones bajo un usuario puedan leer los mismos datos.

Al usar esta tabla sobre una permanente que usamos como temporal encontramos los siguientes beneficios.

-   No genera bloqueos.
-   No genera redo logs.
-   Se pueden crear objetos como indices, vistas y triggers para las tablas temporales, no se pierda esta funcionalidad.
