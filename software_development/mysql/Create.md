# Comando CREATE

Llego la hora de crear nuestra base de datos, vamos a utilizar un diagrama de entidad relación como base para el diseño de nuestra base de datos.

Un punto muy importante al momento de crear una base de datos, es saber que existen dos tipos de tablas.
- InnoDB: Un tipo de tabla nueva, mas robusta y recuperable pero más lenta
- ISAM: Muy directa, sencilla y rapida, donde las transacciones son de 1 a 1 por lo cual la velocidad es superior.

En nuestra base de datos tendremos 2 tipos de tablas en nuestra arquitectura: 
- Una tabla de catálogo que crecera una velocidad relativamente lenta.
- Una tabla de operaciones con muchas operaciones diarias.

Al contectualizar esto podemos identificar como utilizaremos estos dos tipos de tablas en nuestra base de datos.

# Tipos de Columnas / Creación de la tabla books

Lo primero que vamos a necesitar es claramente crear una nueva base de datos para trabajar.

```sql
CREATE DATABASE platzi_operation;
```

Esto esta bien, pero podemos ser un poco mas cuidadosos al momento de crear una base de datos mediante un poco de verificación.

```sql
CREATE DATABASE IF NOT EXISTS platzi_operation;
```

Curiosamente ambos comandos no retornan casi la misma salida.

```
mysql> create database platzi_operation;
Query OK, 1 row affected (0.23 sec)

mysql> CREATE DATABASE IF NOT EXISTS platzi_operation;
Query OK, 1 row affected, 1 warning (0.04 sec)
```

Con el segundo comando obtuvimos una advertencia, la cual podemos inspeccionar con `show warnings;`

```
mysql> SHOW warnings;
+-------+------+-----------------------------------------------------------+
| Level | Code | Message                                                   |
+-------+------+-----------------------------------------------------------+
| Note  | 1007 | Can't create database 'platzi_operation'; database exists |
+-------+------+-----------------------------------------------------------+
1 row in set (0.02 sec)
```

Y si no utilizaramos este comando para verificar, no obtendremos un `Query OK`

```
mysql> CREATE DATABASE platzi_operation;
ERROR 1007 (HY000): Can't create database 'platzi_operation'; database exists
mysql> 
```

Tambien podemos verificar la existencia de nuestra base de datos nueva.

```
mysql> SHOW databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| platzi_operation   |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```

Y nos podemos mover a esta base de datos.

```
mysql> use platzi_operation;
Database changed
```

En caso de mostrar las tablas obtendremos un `Empty set` que simplemente es la salida cuando consultamos algo que no existe.

```
mysql> SHOW tables;
Empty set (0.00 sec)
```

Empezemos crando nuestra primera tabla para nuestros libros, como buena practica deberiamos utilizar un sustantivo en plural y deberiamos hacerlo en ingles.


```sql
CREATE TABLE IF NOT EXISTS books (
);
```

Aca de nuevo nos estamos resguardando con el condicional.

Otro aspecto importante es que **siempre** vamos a ocupar a un identificador que deberia de ser un entero y sera auto incremental.

```sql
CREATE TABLE IF NOT EXISTS books(
	book_id INTEGER PRIMARY AUTO_INCREMENT
);
```
El problema con utilizar un `INTEGER` es que su capacidad puede llegar a llenarce en casos como Twitter, por lo cual agregar la palabra reservada `UNSIGNED` que nos permite hacer que este numero sea unicamente positivo o sea no almacenar en el campo de byte el signo lo cual incrementa la capacidad para esta columna.

```sql
CREATE TABLE IF NOT EXISTS books(
	book_id INTEGER PRIMARY KEY UNSIGNED AUTO_INCREMENT
);
```

Aun asi existen muchos tipos numericos para definir un `primary` que distintos tamaños. Podemos guardar una referencia a un futuro autor, pero dejaremos esto para el futuro.

```sql
CREATE TABLE IF NOT EXISTS books(
    book_id INTEGER UNSIGNED PRIMARY AUTO_INCREMENT,
    author ,
);
```

Siguiente vamos a trabajar uno de los tipos más comunes, el `VARCHAR` nos permite almacenar cadenas de texto pero tenemos que indicar la cantidad máxima de caracteres permitidos. 

Aun asi tenemos que recordar que lo ideal es utilizar el menor tamaño posible para que las busquedas basadas en texto sean lo más rapido posible.

Un punto importante es que todo libro siempre va a tener a titulo, lo cual deberiamos restringir para requerir dicho parametro usando `NOT NULL`.

```sql
CREATE TABLE IF NOT EXISTS books(
    title VARCHAR(100) NOT NULL,
);
```

Siguiente vamos a crear una columna para el año de publicación, podeos prepararnos para aquellos libros para los cuales posiblemente no se cuenta con un año de publicación utilizando `DEFAULT` que implica que si el dato no es proporcionado se utilizara el valor especificado.

```sql
CREATE TABLE IF NOT EXISTS books(
    year  INTEGER UNSIGNED NOT NULL DEFAULT 1900,
);
```

Para el lenguaje del libro podemos limitar la columna a dos caracteres para representar los distintos lenguajes bajo la ISO 639-1, podemos agregar un comentario que sera unicamente visto para aquella persona que vea la estructura de la tabla.

```sql
CREATE TABLE IF NOT EXISTS books(
    language VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT 'ISO 639-1 Language',
);
```
Un recurso binario como una imagen, no deberia venir en nuestra base de datos sino deberiamos de almacenar estos recursos en una ubicación externo y guardar el enlace a estos en nuestra columna.

```sql
CREATE TABLE IF NOT EXISTS books(
    cover_url VARCHAR(500),
);
```
Para un tipo flotante contamos con el `DOUBLE` y con el `FLOAT`, `FLOAT` resulta ideal para calculos matematicos (con 6 numeros decimales) por lo cual utilizaremos `DOUBLE` que no requiere una presición tan profunda. `DOUBLE` toma dos parametros primero el numero de especios numericos y la cantidad de decimales.

```sql
CREATE TABLE IF NOT EXISTS books(
    price DOUBLE(6,2) NOT NULL DEFAULT 10.0,
);
```
**Nota** Aca tenemos 4 campos para numeros y 2 para decimales.

Siguiente crearemos un campo para indicar si el libro es vendible para lo cual usaremos `TINYINT` de tamaño 1 esto signidica que puede almacenar un 1 o un 0 o sea `true` o `false` y para el resto usaremos campos que ya hemos visto, el tipo `TEXT` permite ingresar todo el texto deseado.

```sql
CREATE TABLE IF NOT EXISTS books(
    sellable TINYINT(1) DEFAULT 1,
    copies INTEGER NOT NULL DEFAULT 1,
    description TEXT
);
```

Quedamos finalmente con la siguiente sentencia SQL.

```sql
CREATE TABLE IF NOT EXISTS books(
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author ,
    title VARCHAR(100) NOT NULL,
    year  INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    language VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT 'ISO 639-1 Language',
    cover_url VARCHAR(500),
    price DOUBLE(6,2) NOT NULL DEFAULT 10.0,
    sellable TINYINT(1) DEFAULT 1,
    copies INTEGER NOT NULL DEFAULT 1,
    description TEXT
);
```

# Tipos de Columnas / Creación de la Tabla Authors

Ocupamos empezar a relacionar estas tablas, una tabla de libros y una de autores donde vamos a ver como se relacionan logicamente mediante un ID. Asi es como se vera nuestra entidad de authors.

```sql
CREATE TABLE IF NOT EXISTS authors(
    author_id INTEGER UNSIGNED PRIMARY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(3)
);
```

Con estas dos tablas ya podemos popular nuestra base de datos con estructuras, simplemente las copiamos en nuestra terminal.

Desde aca podemos ver las tablas en nuestra base de datos

```
mysql> show tables;
+----------------------------+
| Tables_in_platzi_operation |
+----------------------------+
| authors                    |
| books                      |
+----------------------------+
2 rows in set (0.00 sec)
```

**Si queremos borrar** una tabla podemos utilizar `DROP`, este es un comando peligroso por que borrar **todo el contenido y la tabla** de manera permanente.

```sql
DROP TABLE books;
```

Más adelante veremos `TRUNCATE` para borrar una estructura de manera más segura.

Un comando util para ver la estructura de nuestras tablas es `DESCRIBE` o `DESC`.

```
mysql> DESC authors;
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| author_id   | int unsigned | NO   | PRI | NULL    | auto_increment |
| name        | varchar(100) | NO   |     | NULL    |                |
| nationality | varchar(3)   | YES  |     | NULL    |                |
+-------------+--------------+------+-----+---------+----------------+
3 rows in set (0.00 sec)
```

Previamente insertamos comentarios en una de nuestras tablas el cual no aparece al utilizar `DESC` para esto podemos utilizar `SHOW FULL COLUMNS`

```
mysql> SHOW FULL COLUMNS FROM books;
```

Eso va a retornar la tabla completa, no sera mostrado aca por que toma mucho espacio.

# Tipos de Columnas Usando Date / Creación de la Tabla Clientes

Vamos a empezar creando una entidad para nuestros clientes, aca la palabra reservada `UNIQUE` indica que la columna sera unica alrededor de toda la base de datos y nos permitira hacer un `catch` relacionado en nuestra capa de negocio.

```sql
CREATE TABLE clients (
    client_id INTEGER UNSIGEND PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
);
```

En MySQL vamos a majear dos tipos de datos al momento de trabajar con fechas, muy similares pero que al mismo tiempo tienen aspectos muy diferentes:
- `DATETIME`: Un valor que se puede asignar segun sea deseado y deberiamos usarlo al momento de almacenar fechas, puesto que claro no todas las personas habran nacido despues de 1970.
- `TIMESTAMP`: Basado en la cantidad de segundos que han pasado desde el 1ro de enero de 1970 hasta la fecha y todas las computadoras cuentan con este reloj funcionando. Esto es un numero entero sobre el cual podemos trabajar.

Ambos siguen el formate `yyyy-mm-dd hh:mm:ss`, difieron en la manera en la cual cada uno es almacenado. El `DATETIME` puede hacer todo lo del `TIMESTAMP` pero no es tan rapido y `TIMESTAMP` no puede hacer lo mismo que `DATETIME`

```sql
CREATE TABLE clients (
    birthdate DATETIME NULL, 
);
```

Para almacenar el genero vamos a utilizar un tipo muy especial `ENUM` en donde podemos indicarle a la base de datos que tipo de datos pueden ser ingresados.

```sql
CREATE TABLE clients (
    gender ENUM('M', 'F', 'ND') NOT NULL,
);
```

Como una **buena practica**, una tupla no se borra jamas sino se activa o no se activa. Esto nos permite dar de baja a un usuario sin necesariamente borrar sus datos

```sql
CREATE TABLE clients (
    active TINYINT(1) NOT NULL DEFAULT 1,
);
```

Para nuestro `TIMESTAMP` que indicara cuando el registro fue creado podemos utilizar la palabra reservada `CURRENT_TIMESTAMP` para que la BD cree el dato de forma automatica con su reloj interno.

```sql
CREATE TABLE clients (
    created_at TIMESTAMP NOT NULL DEFAULT  CURRENT_TIMESTAMP 
);
```

Para un `TIMESTAMP` que nos indique cuando una tupla se vio modificada podemos utilizar `ON UPDATE` para que la BD altere la columna cuandos se realice una modificación.

```sql
CREATE TABLE clients (
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

Con todo esto nos quedamos con la siguiente estructura para crear nuestra tabla de `clients`.

```sql
CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthdate DATETIME NULL,
    gender ENUM('M', 'F', 'ND') NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT  CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

Finalmente nos han dejado un ejercicio para practica, una entidad para registrar las transacciones con libros y clientes, esta fue mi solución.

```sql
CREATE TABLE IF NOT EXISTS operations (
    operation_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    book_id INTEGER UNSIGNED,
    client_id INTEGER UNSIGNED,
    type ENUM('prestado', 'devuelto', 'vendido'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    finished TINYINT(1) NOT NULL
);
```