# BASH y archivos SQL

Vamos a utilizar archivos de tipo `.sql` para crear e insertar datos. Esto es logrado mediante la funcionalidad nativa de la linea de comando estandard de UNIX.

```
mysql -u root -p < all.sql     
```

Incluso es posible seleccionar la base de datos sobre la cual utilizar el script de sql en caso de que este no especifique la base de datos por utilizar.

```
mysql -u root -p -D cursoplatzi < all.sql     
```
