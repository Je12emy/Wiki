# Comando INSERT

Por el momento unicamente tenemos el cascaron de nuestra base de datos, es hora de popularla con datos con el comando `INSERT`

```sql
-- Puede retornar un aviso o error, puesto que author_id es entero y no varchar

-- 
INSERT INTO authors (author_id,`name`, nationality) VALUES ('', 'Juan Rulfo', 'MEX');

-- 
INSERT INTO authors (`name`, nationality) VALUES ('Gabriel García Marquez', 'COL');

-- Puede generar un error similar al primer caso
INSERT into authors VALUES ('', 'Juan Gabriel Vasquez', 'COL');
```

Podemos verificar los datos con un `SELECT`

```
select * from authors;
+-----------+-------------------------+-------------+
| author_id | name                    | nationality |
+-----------+-------------------------+-------------+
|         1 | Juan Rulfo              | MEX         |
|         2 | Gabriel García Marquez  | COL         |
|         3 | Juan Gabriel Vasquez    | COL         |
+-----------+-------------------------+-------------+
3 rows in set (0.00 sec)
```

Adicionalmente podemos insertar multiples datos de forma simultanea.

```sql
INSERT INTO authors(`name`, nationality) VALUES 
    ('Julio Cortázar', 'ARG'), 
    ('Isabel Allende', 'CHI'), 
    ('Octavio Paz', 'MEX'),
    ('Juan Carolos Onetti', 'URU');
```

Es preferible que estas inserciones en grupo tengan un maximo de 50, que aunque no es un numero objetivo mantiene un buen balance.

```
select * from authors;
+-----------+-------------------------+-------------+
| author_id | name                    | nationality |
+-----------+-------------------------+-------------+
|         1 | Juan Rulfo              | MEX         |
|         2 | Gabriel García Marquez  | COL         |
|         3 | Juan Gabriel Vasquez    | COL         |
|         4 | Julio Cortázar          | ARG         |
|         5 | Isabel Allende          | CHI         |
|         6 | Octavio Paz             | MEX         |
|         7 | Juan Carolos Onetti     | URU         |
+-----------+-------------------------+-------------+
7 rows in set (0.00 sec)
```

Como dato curioso podemos nosotros mismos agregar el valor para el id de autor de forma manual y este dato sera guardado en la base de datos.

```
INSERT INTO authors (author_id, name) VALUES (16, 'Pablo Neruda');
Query OK, 1 row affected (0.08 sec)
```

```
select * from authors;
+-----------+-------------------------+-------------+
| author_id | name                    | nationality |
+-----------+-------------------------+-------------+
|         1 | Juan Rulfo              | MEX         |
| 				..................					|
|        16 | Pablo Neruda            | NULL        |
+-----------+-------------------------+-------------+
8 rows in set (0.00 sec)

```

Podemos trabajar con la base de datos para que no se de el choque entre esta llave y el valor auto incremental.

## Comando on Duplicate Key

Usando la siguiente sentencia vamos a insertar en la tabla de clientes los siguientes datos.

```sql
INSERT INTO`clients`(client_id, name, email, birthdate, gender, active) VALUES
	(1,'Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F',1),
	(2,'Adrian Fernandez','Adrian.55818851J@random.names','1970-04-09','M',1),
	(3,'Maria Luisa Marin','Maria Luisa.83726282A@random.names','1957-07-30','F',1),
	(4,'Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1);
```

Si fueramos a insertar un autor nuevo con un email coreo vamos a toparnos con un error `DUPLICATE KEY`

```sql
INSERT INTO`clients`(client_id, name, email, birthdate, gender, active) VALUES
	(4,'Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1);
```

Es posible soltarnos este error usando `IGNORE ALL` junto a `ÒN DUPLICATE KEY`

```sql
INSERT INTO`clients`(name, email, birthdate, gender, active) 
VALUES ('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1) 
ON DUPLICATE KEY IGNORE ALL;
```

Aun asi, esto es una mala practica y conlleva miles de problemas futuros. Aun asi esta sentencia `IGNORE ALL` resulta muy util para alterar los registros originales, como ejemplo vamos a intentar insertar el mismo registro duplicado pero en el valor `active` pasaremos un 0.

Vamos a hacer que el gestor de base de datos, actualice el registro original con el valor proporcionado por el registro duplicado en el `active`

```sql
INSERT INTO`clients`(name, email, birthdate, gender, active) 
VALUES ('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M', 0) 
ON DUPLICATE KEY UPDATE active = VALUES (active);
```

Antes de ejecutar esto veamos como esta el registro por actualiar.

```
SELECT * FROM clients WHERE client_id = 4\G;
*************************** 1. row ***************************
 client_id: 4
      name: Pedro Sanchez
     email: Pedro.78522059J@random.names
 birthdate: 1992-01-31 00:00:00
    gender: M
    active: 1
created_at: 2021-01-26 15:43:41
updated_at: 2021-01-26 15:43:41
1 row in set (0.01 sec)
```
**Nota** Al usar `\G` en un select que romperia el layout de la consola nos presenta un formato en columna.


Ejecutamos esa sentencia y veremos que ahora el valor de `active` es 0.

```
SELECT * FROM clients WHERE client_id = 4\G;
*************************** 1. row ***************************
 client_id: 4
      name: Pedro Sanchez
     email: Pedro.78522059J@random.names
 birthdate: 1992-01-31 00:00:00
    gender: M
    active: 0
created_at: 2021-01-26 15:43:41
updated_at: 2021-01-26 16:02:12
1 row in set (0.00 sec)
```

# Selección de Datos Usando Queries Anidados

Imaginemos un caso hipotetico en donde tenemos una fuente de datos con los siguientes libros.

```
El Laberinto de la Soledad, Octavio Paz, 1952
Vuelta al Laberinto de la Soledad, Octavio Paz, 1960
```

Podemos con esto hacer un `INSERT` normal y corriente de la siguiente manera en la tabla de libros (recordemos que esto requiere el id de autor.)

```sql
INSERT INTO books(title, author_id) VALUES ('El Laberinto de la Soledad', 6);
```

Esto funcionara, pero podemos cargar nuestro `INSERT` con un `SELECT` a la tabla de autores con el valor del autor que deseamos buscar.

```sql
INSERT INTO books(title, author_id, `year`) VALUES(
    'La Vuelta al Laberinto de la Soledad',
    ( SELECT author_id FROM authors WHERE `name` = 'Octavio Paz' LIMIT 1),
    1960
);
```

Esto buscara dentro de la entidad de autores y devolvera el id del autor con nombre 'Octavio Paz', esto tipo de queries son muy potentes pero al mismo tiempo requiere procesar dos tuplas al mismo tiempo por lo cual la utilización del CPU puede incrementar significativamente.
