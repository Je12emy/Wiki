# Super Querys

Es posible utilizar condicionales y funciones en nuestros `SELECT` para proporcionarle inteligencia a nuestras columnas.

```
mysql> SELECT nationality, COUNT(book_id),   SUM(IF(year < 1950, 1, 0)) AS"<1950",   SUM(IF(year >= 1950 and year < 1990, 1, 0)) AS"<1990",   SUM(IF(year >= 1990 and year < 2000, 1, 0)) AS"<2000",   SUM(IF(year >= 2000, 1, 0)) AS"<hoy" FROM books AS b JOIN authors AS a ON a.author_id = b.author_id WHERE a.nationality IS NOT NULL GROUP BY nationality;
+-------------+----------------+-------+-------+-------+------+
| nationality | COUNT(book_id) | <1950 | <1990 | <2000 | <hoy |
+-------------+----------------+-------+-------+-------+------+
| USA         |             36 |    34 |     0 |     0 |    2 |
| GBR         |              3 |     3 |     0 |     0 |    0 |
| SWE         |             11 |     3 |     0 |     8 |    0 |
| MEX         |              1 |     0 |     1 |     0 |    0 |
| RUS         |              9 |     9 |     0 |     0 |    0 |
| IND         |              8 |     8 |     0 |     0 |    0 |
| JAP         |              1 |     1 |     0 |     0 |    0 |
| ESP         |              1 |     1 |     0 |     0 |    0 |
| FRA         |              3 |     3 |     0 |     0 |    0 |
| AUT         |              4 |     4 |     0 |     0 |    0 |
| ENG         |             16 |    16 |     0 |     0 |    0 |
| DEU         |              1 |     1 |     0 |     0 |    0 |
| AUS         |              2 |     2 |     0 |     0 |    0 |
+-------------+----------------+-------+-------+-------+------+
13 rows in set (0.00 sec)
```

# Comando mysqlDump

Podemos alterar nuestras tablas con el comando `ALTER`.

```sql
ALTER TABLE authors ADD COLUMN birth_year INTEGER DEFAULT 1930 AFTER name;

ALTER TABLE authors MODIFY COLUMN birth_year `year` DEFAULT 1930;

ALTER TABLE authors DROP COLUMN `year`;
```

Podemos generar un respaldo de nuestra base de datos mediante `mysqldump`, que no forma parte de mysql forma parte del sistema.

Aca podemos generar 2 salidas: traer toda nuestra base de datos a un archivo `.sql` o traer unicamente el esquema de la base de datos a un `.sql`

Un practica comun es versionar el esquema de una base de datos en Github y es buena idea usar el control de versión con este.

```
mysqldump -u root -p pruebaplatzi
```

Este genera como salida a toda la base de datos, podemos agregar una bandera adicional para obtener unicamente el esquema de la base de datos.

```
mysqldump -u root -p -d pruebaplatzi
```

Podemos hacer que escriba en un archivo el script completo y lo va a crear en el directorio actual.

```
mysqldump -u root -p -d pruebaplatzi > esquema.sql 
```

