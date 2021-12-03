# Su majestad el SELECT

El comando `SELECT` es el más importante en cualquier base de datos, la syntaxis básica es la siguiente.

```sql
SELECT field1, field2 FROM table WHERE fieldID = "condition"
```

Junto a estos selects se puede utilizar funciones proporcionadas por mysql.

```sql
SELECT YEAR(birthdate) FROM clients limit 10;
+-----------------+
| YEAR(birthdate) |
+-----------------+
|            1971 |
|            1970 |
|            1957 |
|            1992 |
|            1960 |
|            1981 |
|            1971 |
|            1964 |
|            1954 |
|            1966 |
+-----------------+
```

Podemos realizar operaciones aritmeticas en nuestro select.

```sql
SELECT name, YEAR(NOW()) - YEAR(birthdate) FROM clients limit 10;
+---------------------+-------------------------------+
| name                | YEAR(NOW()) - YEAR(birthdate) |
+---------------------+-------------------------------+
| Maria Dolores Gomez |                            50 |
| Adrian Fernandez    |                            51 |
| Maria Luisa Marin   |                            64 |
| Pedro Sanchez       |                            29 |
| Pablo Saavedra      |                            61 |
| Marta Carrillo      |                            40 |
| Javier Barrio       |                            50 |
| Milagros Garcia     |                            57 |
| Carlos Quiros       |                            67 |
| Carmen De la Torre  |                            55 |
+---------------------+-------------------------------+
10 rows in set (0.00 sec)
```

Podemos utilizar condicionales y "wildcards" en nuestro select.

```sql
SELECT * from clients WHERE name like '%Saave%'\G
*************************** 1. row ***************************
 client_id: 5
      name: Pablo Saavedra
     email: Pablo.93733268B@random.names
 birthdate: 1960-07-21
    gender: M
    active: 1
created_at: 2018-04-09 16:51:30
1 row in set (0.00 sec)
```

Incluso podemos asignar un alias para las columnas de un select.

```sql
SELECT name, email, YEAR(NOW()) - birthdate AS age, gender FROM clients WHERE gender='F' and name like '%Lop%';
+-------------------+------------------------------------+-----------+--------+
| name              | email                              | age       | gender |
+-------------------+------------------------------------+-----------+--------+
| Juana Maria Lopez | Juana Maria.51072683X@random.names | -19898694 | F      |
| Carmen Lopez      | Carmen.09399409E@random.names      | -19868286 | F      |
+-------------------+------------------------------------+-----------+--------+
2 rows in set (0.00 sec)
```

# Comando JOIN

Mediante un comando `JOIN` es posible seleccionar información de n cantidad de tablas al mismo tiempo y asi presentar información con mayor valor. El comando `JOIN` por defecto es de tipo `INNER JOIN`

```sql
SELECT b.book_id, a.name, b.title FROM books AS b JOIN authors AS a ON a.author_id =
b.author_id WHERE a.author_id BETWEEN 1 AND 5;
+---------+--------------------+---------------------------------------+
| book_id | name               | title                                 |
+---------+--------------------+---------------------------------------+
|       1 | Sam Altman         | The Startup Playbook                  |
|       2 | Sam Altman         | The Startup Playbook                  |
|       3 | Arthur Conan Doyle | Estudio en escarlata                  |
|      12 | Juan Rulfo         | El llano en llamas                    |
|      41 | Arthur Conan Doyle | The - Vol I Complete Sherlock Holmes  |
|      42 | Arthur Conan Doyle | The - Vol II Complete Sherlock Holmes |
+---------+--------------------+---------------------------------------+
6 rows in set (0.00 sec)
```

Es muy util para presentar información con los datos que hemos almacenado.

```sql
SELECT c.name, b.title, a.name, t.type FROM transactions AS t JOIN books AS b ON t.book_id = b.book_id JOIN clients AS c   ON t.client_id = c.client_id JOIN authors AS a   ON
b.author_id = a.author_id WHERE c.gender = 'M'   AND t.type IN ('sell', 'lend')\G;
*************************** 1. row ***************************
 name: Luis Saez
title: Tales of Mystery and Imagination
 name: Edgar Allen Poe
 type: lend
*************************** 2. row ***************************
 name: Jose Maria Bermudez
title: Estudio en escarlata
 name: Arthur Conan Doyle
 type: sell
*************************** 3. row ***************************
 name: Rafael Galvez
title: The Startup Playbook
 name: Sam Altman
 type: sell
3 rows in set (0.00 sec)

ERROR: 
No query specified
```

# Left JOIN

El `LEFT` y el `INNER` join abarcan la mayoria de casos de uso al momento de cruzar tablas, un `INNER` join va a traer solo aquellos datos en donde se cumpla el condicional mientras que en un `LEFT` join se van a traer los datos de la tabla principal y la tabla con la cual cruzar.

```sql
SELECT a.author_id, a.name, a.nationality, b.title FROM authors AS a LEFT JOIN books
AS b ON a.author_id = b.author_id WHERE a.author_id BETWEEN 1 AND 5 ORDER BY a.author_id ASC\G;
*************************** 1. row ***************************
  author_id: 1
       name: Sam Altman
nationality: USA
      title: The Startup Playbook
*************************** 2. row ***************************
  author_id: 1
       name: Sam Altman
nationality: USA
      title: The Startup Playbook
*************************** 3. row ***************************
  author_id: 2
       name: Freddy Vega
nationality: COL
      title: NULL
*************************** 4. row ***************************
  author_id: 3
       name: Arthur Conan Doyle
nationality: GBR
      title: The - Vol II Complete Sherlock Holmes
*************************** 5. row ***************************
  author_id: 3
       name: Arthur Conan Doyle
nationality: GBR
      title: The - Vol I Complete Sherlock Holmes
*************************** 6. row ***************************
  author_id: 3
       name: Arthur Conan Doyle
nationality: GBR
      title: Estudio en escarlata
*************************** 7. row ***************************
  author_id: 4
       name: Chuck Palahniuk
nationality: USA
      title: NULL
*************************** 8. row ***************************
  author_id: 5
       name: Juan Rulfo
nationality: MEX
      title: El llano en llamas
8 rows in set (0.00 sec)
```

Note como en la fila numero 3, se muestra que el autor no cuenta con un libro pero aun asi se muestra su información.

A continuación se presentan los tipos de JOIN que existen en SQL.

![https://www.queryhome.com/tech/?qa=blob&qa_blobid=833553226211556172](https://www.queryhome.com/tech/?qa=blob&qa_blobid=833553226211556172)

Siguiente queremos mostrar en una columna la cantidad de libros con los cuales cuenta un autor.

```sql
SELECT a.author_id, a.name, a.nationality, COUNT(b.book_id) AS book_registered FROM a
uthors AS a LEFT JOIN books AS b ON a.author_id = b.author_id WHERE a.author_id BETWEEN 1 AN
D 5 GROUP BY a.author_id  ORDER BY a.author_id ASC;
+-----------+--------------------+-------------+-----------------+
| author_id | name               | nationality | book_registered |
+-----------+--------------------+-------------+-----------------+
|         1 | Sam Altman         | USA         |               2 |
|         2 | Freddy Vega        | COL         |               0 |
|         3 | Arthur Conan Doyle | GBR         |               3 |
|         4 | Chuck Palahniuk    | USA         |               0 |
|         5 | Juan Rulfo         | MEX         |               1 |
+-----------+--------------------+-------------+-----------------+
5 rows in set (0.00 sec)
```

# Tipos de JOIN

En la clase anterior estuvimos hablando de dos tipos de joins que podemos usar cuando estemos trabajando con consultas a nuestras bases de datos.

Existen diferentes formas en las que se pueden unir las tablas en nuestras consultas y de acuerdo con esta unión se va a mostrar información, y es importante siempre tener clara esta relación. En esta clase te voy a mostrar gráficamente 7 diferentes tipos de uniones que puedes realizar.

Usar correctamente estas uniones puede reducir el tiempo de ejecución de tus consultas y mejorar el rendimiento de tus aplicaciones.

Como yo lo veo cuando hacemos uniones en las consultas para seleccionar información, estamos trabajando con tablas, estas tablas podemos verlas como conjuntos de información, de forma que podemos asimilar los joins entre tablas como uniones e intersecciones entre conjuntos.

Supongamos que contamos con dos conjuntos, el conjunto A y el conjunto B, o, la tabla A y la tabla B. Sobre estos conjuntos veamos cuál es el resultado si aplicamos diferentes tipos de join.

## Inner Join

Esta es la forma mas fácil de seleccionar información de diferentes tablas, es tal vez la que mas usas a diario en tu trabajo con bases de datos. Esta union retorna todas las filas de la tabla A que coinciden en la tabla B. Es decir aquellas que están en la tabla A Y en la tabla B, si lo vemos en conjuntos la intersección entre la tabla A y la B.

![BadgesMesa de trabajo 2.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202-5d5d1171-efd6-4f0a-88ad-a4c82b836427.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n> 
FROM Tabla_A A
INNER JOIN Tabla_B B
ON A.pk = B.pk
```

## Left Join

Esta consulta retorna todas las filas que están en la tabla A y ademas si hay coincidencias de filas en la tabla B también va a traer esas filas.

![BadgesMesa de trabajo 2 copia.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia-af253277-22c6-4d8f-a005-5a0158471af8.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n> 
FROM Tabla_A A
LEFT JOIN Tabla_B B
ON A.pk = B.pk
```

## Right Join

Esta consulta retorna todas las filas de la tabla B y ademas si hay filas en la tabla A que coinciden también va a traer estas filas de la tabla A.

![BadgesMesa de trabajo 2 copia 2.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia%202-182a2b23-4949-4e88-8118-bec2cc654943.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n>
FROM Tabla_A A
RIGHT JOIN Tabla_B B
ON A.pk = B.pk
```

## Outer Join

Este join retorna TODAS las filas de las dos tablas. Hace la union entre las filas que coinciden entre la tabla A y la tabla B.

![BadgesMesa de trabajo 2 copia 3.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia%203-07f9edcc-54fa-4be4-ad32-3613b79f0815.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n>
FROM Tabla_A A
FULL OUTER JOIN Tabla_B B
ON A.pk = B.pk
```

## Left excluding join

Esta consulta retorna todas las filas de la tabla de la izquierda, es decir la tabla A que no tienen ninguna coincidencia con la tabla de la derecha, es decir la tabla B.

![BadgesMesa de trabajo 2 copia 4.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia%204-8bed8f2c-6338-491e-b81f-119027ad8a9c.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n>
FROM Tabla_A A
LEFT JOIN Tabla_B B
ON A.pk = B.pk
WHERE B.pk IS NULL
```

## Right Excluding join

Esta consulta retorna todas las filas de la tabla de la derecha, es decir la tabla B que no tienen coincidencias en la tabla de la izquierda, es decir la tabla A.

![BadgesMesa de trabajo 2 copia 5.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia%205-abeea9a6-964f-4b52-b0a5-4f790101695a.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```sql
SELECT <columna_1> , <columna_2>,  <columna_3> ... <columna_n>
FROM Tabla_A A
RIGHT JOIN Tabla_B B
ON A.pk = B.pk
WHERE A.pk IS NULL
```

## Outer excluding join

Esta consulta retorna todas las filas de la tabla de la izquierda, tabla A, y todas las filas de la tabla de la derecha, tabla B que no coinciden.

![BadgesMesa de trabajo 2 copia 6.jpg](https://static.platzi.com/media/user_upload/BadgesMesa%20de%20trabajo%202%20copia%206-fa9ef4f5-1475-4e54-8b33-ebbdfb29df29.jpg)

Esto lo podemos implementar de esta forma cuando estemos escribiendo las consultas:

```SQL
SELECT <select_list>
FROM Table_A A
FULL OUTER JOIN Table_B B
ON A.Key = B.Key
WHERE A.Key IS NULL OR B.Key IS NULL
```

# 5 Casos de Negocio

Vamos a estar practicando con 5 casos de prueba para practicar el conocimiento adquirido hasta el momento.

**¿Qué nacionalidades hay?**

```
SELECT DISTINCT nationality from authors;
+-------------+
| nationality |
+-------------+
| USA         |
| COL         |
| GBR         |
| MEX         |
| SWE         |
| RUS         |
| IND         |
| JAP         |
| ESP         |
| FRA         |
| AUT         |
| ENG         |
| DEU         |
| NULL        |
| AUS         |
+-------------+
15 rows in set (0.00 sec)
```

**¿Cuántos escritores hay de cada nacionalidad?**

```
SELECT DISTINCT nationality, COUNT(nationality) AS c_authors FROM  authors WHERE nationality IS NOT NULL  GROUP BY nationality ORDER BY c_authors DESC, nationality ASC;
+-------------+-----------+
| nationality | c_authors |
+-------------+-----------+
| USA         |        27 |
| ENG         |        10 |
| IND         |         6 |
| RUS         |         4 |
| FRA         |         3 |
| AUT         |         2 |
| SWE         |         2 |
| AUS         |         1 |
| COL         |         1 |
| DEU         |         1 |
| ESP         |         1 |
| GBR         |         1 |
| JAP         |         1 |
| MEX         |         1 |
+-------------+-----------+
14 rows in set (0.00 sec)
```

Tambien se pueden excluir valores usando `NOT IN`

```
SELECT DISTINCT nationality, COUNT(nationality) AS c_authors FROM  authors WHERE nationality IS NOT NULL AND nationality  NOT IN('JAP')  GROUP BY nationality ORDER BY c_authors
DESC, nationality ASC;
+-------------+-----------+
| nationality | c_authors |
+-------------+-----------+
| USA         |        27 |
| ENG         |        10 |
| IND         |         6 |
| RUS         |         4 |
| FRA         |         3 |
| AUT         |         2 |
| SWE         |         2 |
| AUS         |         1 |
| COL         |         1 |
| DEU         |         1 |
| ESP         |         1 |
| GBR         |         1 |
| MEX         |         1 |
+-------------+-----------+
13 rows in set (0.00 sec)
```

**¿Cuál es el promedio/desviación estandard del precio de libros?**

```
SELECT a.nationality, COUNT(b.book_id) AS c_books, AVG(price) AS avg, STDDEV(price) AS std FROM books AS b JOIN authors AS a on b.author_id = a.author_id GROUP BY a.nationality
ORDER BY c_books DESC;
+-------------+---------+-----------+--------------------+
| nationality | c_books | avg       | std                |
+-------------+---------+-----------+--------------------+
| NULL        |     100 | 18.151400 |  6.267859127325693 |
| USA         |      36 | 15.727500 | 4.2106600003905434 |
| ENG         |      16 | 19.316875 |  5.822852306591247 |
| SWE         |      11 | 15.696364 | 1.2190254880419302 |
| RUS         |       9 | 17.065556 |  4.747806771110475 |
| IND         |       8 | 16.923750 |  4.226635593175736 |
| AUT         |       4 | 14.545000 | 1.9411530078795958 |
| GBR         |       3 | 16.666667 |  8.289886743630591 |
| FRA         |       3 | 16.900000 |  4.931531202375181 |
| AUS         |       2 | 15.820000 | 0.5199999999999996 |
| MEX         |       1 | 10.000000 |                  0 |
| JAP         |       1 | 12.300000 |                  0 |
| ESP         |       1 | 15.200000 |                  0 |
| DEU         |       1 | 10.200000 |                  0 |
+-------------+---------+-----------+--------------------+
14 rows in set (0.00 sec)
```

**¿Cuál es el precio máximo/mínimo de un libro?**

```
SELECT a.nationality, MAX(price), MIN(price) FROM books as b JOIN authors AS a on b.author_id = a.author_id GROUP BY a.nationality ORDER BY nationality;
+-------------+------------+------------+
| nationality | MAX(price) | MIN(price) |
+-------------+------------+------------+
| NULL        |      45.40 |       8.60 |
| AUS         |      16.34 |      15.30 |
| AUT         |      15.98 |      11.20 |
| DEU         |      10.20 |      10.20 |
| ENG         |      28.70 |      10.60 |
| ESP         |      15.20 |      15.20 |
| FRA         |      22.50 |      10.50 |
| GBR         |      23.50 |       5.00 |
| IND         |      23.60 |      10.50 |
| JAP         |      12.30 |      12.30 |
| MEX         |      10.00 |      10.00 |
| RUS         |      26.34 |      10.99 |
| SWE         |      18.58 |      15.00 |
| USA         |      27.00 |      10.00 |
+-------------+------------+------------+
14 rows in set (0.00 sec)
```


**¿Cómo quedaría el reporte de préstamos?**

```
SELECT c.name, t.type, b.title,    CONCAT(a.name, " (", a.nationality, ")") AS autor,   TO_DAYS(NOW()) - TO_DAYS(t.created_at) FROM transactions AS t LEFT JOIN clients AS c   ON c.client_id = t.client_id LEFT JOIN books AS b   ON b.book_id = t.book_id LEFT JOIN authors AS a   ON b.author_id = a.author_id \G;
*************************** 1. row ***************************
                                  name: Maria Teresa Castillo
                                  type: sell
                                 title: El llano en llamas
                                 autor: Juan Rulfo (MEX)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 2. row ***************************
                                  name: Luis Saez
                                  type: lend
                                 title: Tales of Mystery and Imagination
                                 autor: Edgar Allen Poe (USA)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 3. row ***************************
                                  name: Jose Maria Bermudez
                                  type: sell
                                 title: Estudio en escarlata
                                 autor: Arthur Conan Doyle (GBR)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 4. row ***************************
                                  name: Rafael Galvez
                                  type: sell
                                 title: The Startup Playbook
                                 autor: Sam Altman (USA)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 5. row ***************************
                                  name: Antonia Giron
                                  type: lend
                                 title: El llano en llamas
                                 autor: Juan Rulfo (MEX)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 6. row ***************************
                                  name: Antonia Giron
                                  type: return
                                 title: El llano en llamas
                                 autor: Juan Rulfo (MEX)
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
*************************** 7. row ***************************
                                  name: Juana Maria Lopez
                                  type: sell
                                 title: Vol 39 No. 1 Social Choice & Welfare
                                 autor: NULL
TO_DAYS(NOW()) - TO_DAYS(t.created_at): 0
7 rows in set (0.00 sec)

ERROR: 
No query specified
```

# Comandos UPDATE y DELETE

El comando `DELETE` requiere de gran atención, incluso es buena idea no borrar un registro sino "desactivarlo" mediante una bandera booleana. Aun asi sigue la siguiente syntaxis

```sql
DELETE FROM Aauthors WHERE author_id = 161;
```

Es buena idea agregar un `LIMIT` en nuestro `DELETE` para asi eliminar a un unico registro en caso de que nuestro condicional llegue a estar erroneo.

```sql
DELETE FROM Aauthors WHERE author_id = 161 LIMIT 1;
```

Para desactivar a un cliente podemos utilizar el comando `UPDATE` y tiene la siguiente syntaxis.

```sql
UPDATE clients SET active = 0 WHERE client_id = 80 LIMIT 1;
```

## Aporte de Transacciones

Es mejor hacer pruebas antes de ejecutar instrucciones que puedan afectar la integridad de nuestra data

*Iniciamos una transacción*

```sql 
BEGIN
```

Ahora supongamos que elimino información de una tabla y se me olvida el WHERE

```sql
DELETE FROM authors;
```

Rayos ya perdí todo, haa pero como estoy dentro de una transacción debo confirmar las operaciones hechas a la base de datos, de lo contrario no se ejecutarán.

Si confirmo, entonces no hay vuelta atras. Se eliminarían todos los datos de dicha tabla

```sql
COMMIT
```

Pero si hago un retroceso de dichos cambios. Entonces es como si nunca hubiese pasado nada.

```sql
ROLLBACK
```
