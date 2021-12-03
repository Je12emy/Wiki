# Oracle DB

> Oracle Database es un sistema de administración de bases de datos relacionales de objetos desarrollado y comercializado por Oracle Corporation. La base de datos Oracle se conoce comúnmente como Oracle RDBMS o simplemente Oracle.

Este es un sistema de bases de datos relacional, ha sido uno de los primeros motores y con cada versión se introducen nuevas características. Según avanza cada versión se agregan nuevos procesos y componentes.

## La Instancia y la Base de Datos

Un base de datos de Oracle se encuentra compuesta por una base de datos y **por lo menos** una Instancia de Oracle.

En términos más sencillos entonces:

* Una instancia consiste en estructuras de memoria y procesos de fondo, entonces esta corre en la memoria del sistema y reside en la memoria principal o RAM.
* Una base de datos consiste en archivos (sean Control Files, Redo Log Files, Data Files, etc...) entonces esta reside en el almacenamiento del sistema.

Por otro lado es posible que una instancia exista sin una base de datos y viceversa

Vamos a encontrar 2 configuraciones para una instancia de RDBMS:

* **No clusterizada:** Es la configuración básica, donde se cuenta con un servidor, una instancia y un unico servidor de base de datos.
* **Clusterizada:** Se cuenta con *n* cantidad de instancias con un único sistema de almacenamiento, esto permite una mayor redundancia comparada con una configuración no clusterizada, por otro lado las instancias pueden estar en múltiples ubicaciones cada una. Aun así existe el riesgo de contar con un único punto de fallo, que es la base de datos.

![Oracle Instance Database](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2F3.bp.blogspot.com%2F-4UKoEyG9uwc%2FVHgzZ7LqXII%2FAAAAAAAAAcY%2FWFpKeYmI_os%2Fs1600%2F4.%252BInstance%252BDatabaseConiguration.png&f=1&nofb=1)

### Instancia

Al momento de  [[Instancia de Oracle#Etapas de Inicio de una Instancia de Oracle DB|iniciar una instancia]] de la base de datos, se levanta una instancia de datos para acceder a esta, las aplicaciones (usuarios) entonces se conectan a esta instancia para llegar a la base de datos casi como un puente entonces.

Una instancia se compone de dos estructuras de memoria, donde los procesos de fondo hacen uso de las dos en conjunto.

* System Global Área (SGA): Memoria pública.
* Process Global Área (PGA): Memoria privada.

Acá entonces los procesos de fondo utilizan a la SGA en conjunto y por otro lado cada proceso puede contar con su propia memoria privada específica o PGA, donde el **conjunto** de todas estas es conocido como una instancia de PGA.

![Memory Architecture](https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fdocs.oracle.com%2Fcd%2FB28359_01%2Fserver.111%2Fb28318%2Fimg%2Fcncpt151.gif&f=1&nofb=1)

#### El SGA

Él `SGA` es el encargado de administrar la memoria compartida, cada vez que una base de datos es instanciada, buscara un archivo de parámetros para saber cuantos recursos asignar a esta instancia, una parte de los recursos son asignados al `SGA` o `System Global Area`.

> El SGA es una estructura de memoria compartida que se asigna cuando la instancia se inicia y se libera cuando se cierra. El SGA es un grupo de estructuras de memoria compartida que contienen datos e información de control para una instancia de base de datos.

### Procesos de una Instancia

Un proceso es un mecanismo en un sistema operativo para ejecutar un conjunto de etapas o módulos de código y un proceso normalmente corre en su propia área de memoria privada.

En el mundo de Oracle, los procesos ejecutan un rol muy importante y encontraremos dos tipos de procesos:

* Procesos de *usuario*, que ejecuta código de aplicación (para establecer una conexión) o `Oracle Tool Code` (ejemplo SQL PLUS que nos permite conectarnos a una base de datos) y este es iniciado en el sistema del cliente y es acá donde su código es ejecutado. Cabe a recalcar que clientes de la base de datos, pueden acceder a la base de datos desde distintos sistemas.
* *[[Procesos de Oracle]]*, que son los procesos del servidor que operan en el fondo y ejecutan el código de instancia de la base de datos como tal.

## Base de Datos

La base de datos es simplemente almacenamiento y esta es su función principal, Oracle utiliza dos estructuras de almacenamiento para almacenar y manejar datos:

* Estructuras Lógicas: Son estructuras especializadas para obtener un control granular sobre el almacenamiento utilizado por una base de datos de Oracle.
* Estructuras Físicas: Simplemente son archivos y se pueden almacenar en distintos sistemas de almacenamiento digamos SAN, File System, ASM (Automatic Storage Management).

![https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Oracle_Logical_and_Physical_storage_diagram.svg/1556px-Oracle_Logical_and_Physical_storage_diagram.svg.png](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Oracle_Logical_and_Physical_storage_diagram.svg/1556px-Oracle_Logical_and_Physical_storage_diagram.svg.png)

**Nota:** Leer más [acá.](https://www.oracletutorial.com/oracle-administration/oracle-database-architecture/)

### Estructuras Físicas de Almacenamiento

Son llamadas Estructuras Físicas porque **se pueden ver** en el de sistema operativo (mientras que las lógicas no se puede ver) y son simplemente archivos que son almacenados por el sistema.

Al momento de crear una base de datos con el comando `CREATE` la base de datos crea a los 3 siguientes tipos de archivos:

* *Data Files:* Almacena los datos de la base de datos y son los archivos principales de toda base de datos, se ven asociados a una sola base de datos y se le asigna un tamaño definido en el momento de crear la base de datos.
* *Control Files:* Dentro de este se incluye meta data, como sería las ubicaciones de los data files, la secuencia en la que se encuentra la base de datos, estos entonces **no almacenan datos** sino información sobre la base de datos como tal como sería el *nombre de la base de datos, el ID de la base de datos, el momento de creación de la base de datos, el modelo de operación de la base de datos, información sobre los data files, informacion sobre los Redo Log Files*, etc. por esta misma razón son tan críticos para que opere la base de datos, es por esto que al momento de iniciar una base de datos, estos son los primeros archivos usados por Oracle.
* *Redo Logs Files:* Su función es grabar todos los cambios que se hacen en la base de datos, por esta razón son críticos para recuperar datos. Se cuentan con dos o más y puede trabajar en grupo. Tienen un tamaño limitado y por esto no graban todos los movimientos de forma permanente.

### Estructuras Lógicas de Almacenamiento

Oracle utiliza espacio lógico para todos los datos en la base de datos, entonces el espacio físico es acomodado en unidades lógicas, estas estructuras son únicamente conocidas por Oracle y no para el sistema operativo. Entonces los datos son almacenados en archivos físicos (data files) a nivel físico y en bloques de Oracle a nivel lógico:

* *Database:* Únicamente interactuamos con este, con el resto de los componentes de las estructuras lógicas no vamos a interaccionar.
* *Tablespace:* Corresponde a la división lógica del almacenamiento en la base de datos, compuesta por 1 o más segmentos. Los segmentos se encuentran localizados en un `tablaspace` y este tendrá un o más `data files` (que se mide en `extents` y `data blocks`)
* *Segment:* Corresponde a una agrupación de `extends` dedicados a almacenar un tipo de objeto en la base de datos, digamos\* tablas, indices, clusters,\* etc. Al momento de crear una tabla, Oracle proporciona espacio en memoria en forma de extents, digamos 1 `extent` con un tamaño de 64 kb o 8 `data blocks` de 8 kb, una vez este espacio es consumido Oracle proporciona otro `extent` de 100 kb o 12.5 `data blocks`, entonces tendremos 2 `extents` uno de 64 kb y otro de 100 kb, esto seria entonces un `segment` con un tamaño de 64 kb + 100 kb, todos los `extents` asociados a un objeto en particular son conocidos como el segmento del objeto.
* *Extent:* El conjunto de bloques de la base de datos, que proporciona Oracle para almacenar un tipo específico de información.
* *Oracle Data Block:* Un bloque corresponde a un número de bytes utilizados para almacenar datos y es la unidad más pequeña de almacenamiento, al crear una base de datos, se define el tamaño del bloque y no se puede alterar, este tamaño está definido por Oracle basado en el sistema operativo huésped y que se puede alterar al momento de creación. Este tiene un tamaño mínimo de 8 kb (por predeterminado), entonces al momento de crear una tabla no puede tener un tamaño menor a este. Por otro lado estos bloques se componen de bloques del sistema operativo, ya que este usa estos para manejar su almacenamiento.

Si entonces queremos hacer una relación con la vida real, al momento de comprar un apartamento este será el espacio físico como tal (data file) pero este cuenta con una medida lógica, metros cuadrados (data block) donde entonces compraremos un una *n* cantidad de metros cuadrados (extend).

![Logical Data Structures in Oracle Database](https://www.oracletutorial.com/wp-content/uploads/2015/12/Segments-Extents-and-Data-Blocks-Within-a-Tablespace.gif)

Acá el tablespace cuenta con un `segment` the 96 kb (no mostrado), este `segment` está compuesto por dos `data files` que se miden con `extents`, uno de 24 kb y otro de 72 kb. Aca los `data blocks` cuentan con un tamaño definido de 2 kb al momento de crear la base de datos.

Poniéndolo todo junto tenemos el siguiente diagrama

![An Overview of Oracle Database Architecture](https://www.oracletutorial.com/wp-content/uploads/2019/07/Oracle-Database-Architecture-database-instance.png)

* Para conectarnos a la instancia usamos (usando una aplicación de cliente como SQL PLUS) un proceso de usuario para ejecutar código SQL.
* Este código SQL será procesado por el servidor (procesos de servidor), mediante la instancia que se mantiene operacional mediante procesos de fondo, acá estos dos procesos usan estructuras lógicas de la instancia como SGA y PGA para procesar la consulta y acceder a la base de datos.
* Se presenta la respuesta de nuevo mediante los procesos del servidor.

Pero también centraremos otras estructuras

* *Schemas:* Es una colección de objetos de la base de datos, sean: tablas, indices, vistas, paquetes, y esta colección le pertenecen a un usuario (cada usuario es dueño de un esquema).
* *Segments:*
  * *Data Segment:* Son las tablas creadas en cada `squema`, al crear una tabla se genera un segmento de data. Para averiguar cuanto pesa una tabla, se busca la vista **(según el segmento que se desea buscar)** que hace referencia a esta tabla y se busca el valor del campo `byte`
  * *Index Segments:* Indices creados, foráneos, no foráneos, etc.
  * *Undo Segments:* Usados para hacer `rollback` a una transacción.
  * *Temporary Segments:* Segmentos usados por la base de datos de forma temporal, digamos  el`order by`.

Video de Referencia: https://youtu.be/cvx9wCQZnKw
