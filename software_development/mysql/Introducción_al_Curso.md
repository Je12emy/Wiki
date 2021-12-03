# La Consola de MySQL 

Existen muchas formas de conectarse a MySQL, contamos con ORM's e interfaces gráficas pero para este curso vamos a hacer esto desde la consola para poder entender lo que hariamos con cliente gráfico.

Para conectarnos podemos usar el comando `mysql`

```
root@9aee110a3f26:/# mysql -uroot -h <localhost> -p   
Enter password:
```

Opcionalmente podemos introducir la contraseña de manera directa pero esto es menos seguro por que estariamos enviando la contraseña en texto plano.

```
root@9aee110a3f26:/# mysql -uroot -p123
```

**Nota** Con `ctrl+l` se puede limpiar la interfaz.

Uno de los primeros comandos que podemos utilizar es `show databases;`

```sql
 show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```

Aca encontramos una base de datos muy particular:
- `information_schema` que es una de las bases de datos principales, que MySQL utiliza para ejecutar MySQL y esto lo hace recursivo. En esta base de datos vemos toda la meta información sobre las bases de datos, tablas y columnas.

Podemos cambiarnos a utilizar una de estas bases de datos utilizando el comando `use`.

```sql
use mysql;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> 
```

Y como ahora estamos utilizando esta base de datos podemos utilizar sentencias SQL dentro de esta como seria `show tables;`

```
+------------------------------------------------------+
| Tables_in_mysql                                      |
+------------------------------------------------------+
| columns_priv                                         |
| component                                            |
| db                                                   |
| default_roles                                        |
| engine_cost                                          |
| ... more                                             |
+------------------------------------------------------+
35 rows in set (0.00 sec)
```

Si no supieramos en que base de datos nos encontramos podemos utilizar la sentencia `select database();`

```sql
select database();
+------------+
| database() |
+------------+
| mysql      |
+------------+
1 row in set (0.00 sec)
```

De nuevo, podriamos utilizar el comando `use` para movernos entre las distintas bases de datos.

# ¿Qué es una base de datos? 

Una base de datos es un lugar en donde podemos almacenar datos puntuales de cualquier naturaleza para luego manipularlos como queramos. 

Antes de pensar en como vamos a manupular los datos tenemos que pensar en el diseño, nosotros vamos a utilizar el modelo relacional donde las distintas tablas se encuentran relacionadas o dependen entre si. Al momento de relacionar estos datos conseguir más información para posteriormente mostrar en una aplicación.

