# Backup and Recovery

Los respaldos y recuperaciones son un tema importante, esperemos no hacer respaldos con frecuencia pero idealmente no tendremos que hacer muchas recuperaciones. Acá es muy importante el tipo de respaldo, también hay que asegurarse que aquellos respaldos que hagamos, estén correctos

## Error vs. Fallo

Hay que diferenciar entre los conceptos de Errores y Fallos 

> El error es producto de la manipulación humana, un software hace lo que el programador indico por lo cual puede llegar a toparse errores.

Por otro lado el fallo:

> Un fallo es aquel causado por error en su programación

## Tipos de Fallos

Vamos a encontrar a los siguientes tipos de fallos.

* Errores de usuario.
* Fallos del Medio: Errores en un disco o en la red, es físico.
* Fallo en un Proceso.
* Fallo en una Sentencia: Consultas que no se ejecutaron como se esperaba a causa del usuario.
 
### Errores de Usuario

Errores causados directamente por el usuario, como seria hacer un `DROP` a una tabla, esto no es algo que la BD hace por si sola... Estos pueden ser reducidos mediante medios de recuperación como `Oracle Flashback` y la administración correcta de privilegios de la base de datos.

### Fallos del Medio 

Estos ocurren cuando a nivel físico se genera un error al momento de leer o escribir un archivo en el disco, acá suelen estar involucrados archivos como los `Control Files`, `Data Files`, `Redo Logs`, `Archive Redo Logs`, etc.

Estos fallos entonces se dividen en dos tipos adicionales: 
 
* Escritura 
* Lectura 

**Nota:** Los fallos de escritura suelen ser raros en Linux <3.

### Fallos de Instancia de la Base de Datos

Ocurren cuando a nivel de memoria, se generan errores para acceder a la BD y suelen estar asociados a problemas de software y hardware, por ejemplo un error en el sistema operativo que impida acceder a la instancia, por ejemplo que un proceso se quede congelado y no permita hacer consultas, daño en un DIM de la memoria RAM, etc.

Cuando se produce este tipo de errores, lo correcto o adecuado es realizar una recuperación, este tipo de errores también puede presentarse al momento de realizar un `SHUTDOWN ABORT`o `STARTUP FORCE` ya que no cierra la conexión con los archivos físicos.

### Fallos de Sentencias

Cuando una sentencia no se puede llevar a cabo, un ejemplo común es intentar exceder la cantidad de `EXTENTS` máximos asignados en una tabla con un `INSERT`, sobre pasar la cuota asignada en el `TABLESPACE`.

### Fallos de Proceso

Cuando falla un proceso a nivel de servidor, usuario o de fondo, por ejemplo que no se pueda ejecutar el `Database Writer`, que no se pueda ejecutar el proceso `ARCn`... La caída de estos procesos no suelen provocar que la BD se caiga sino que serán reportados en el `Alert Trace` y es el `Process Monitor` quien intenta recuperarlos.

### Fallos de Red

Fallos de comunicación entre procesos de usuario y el servidor, digamos una escritura del `DATA FILE`, con proceso de usuario nos referimos a una conexión.

## Modos de Operación

Una BD puede operar de dos manera:

* `ARCHIVELOG` 
* `NOARCHIVELOG`
 
En `ARCHIVELOG` se generan los archivos log que pueden ser útiles para recuperar la base de datos (ya que guardan todos los pasos para deshacer las transacciones y cambios a la BD), nos protege contra errores de medio. Esto significa que si se opera en modo `NOARCHIVELOG`, no sera posible recuperar a la base de datos.

El archivado ocurre cuando se llenan los `Online Redologs` y varios procesos de fondo se encargan de archivar sus transacciones en archivos `.arc` para liberar espacio en estos y guardar nuevas transacciones.

![Modo Archivado](https://i.imgur.com/VOz4ksr.png)

En `NOARCHIVELOG` el archivado de los `ONLINE REDO LOGS` se encuentra deshabilitado, recordemos se encuentran los `ONLINE REDO LOGS` y los `ARCHIVE RED LOGS`, los `ONLINE REDO LOGS` son rotados y archivados por el proceso de fondo `ARCn`. Este modo únicamente nos protege de fallos de la instancia.

[Modo de NoArchivado](https://i.imgur.com/W4lhcha.png)

## Respaldos

Vamos a encontrar varios tipos de respaldos: 

* Respaldos Físicos. 
* Respaldos Lógicos.

El **respaldo físico** ocurre cuando copiamos a un archivo físico manualmente en otra ubicación, el **respaldo lógico** es aquel que no genera una copia sino que extrae estructuras o datos de la BD y los copia a un archivo especializado de respaldo. Acá encontramos respaldos "en frió" y "en caliente", como es de espera el primero requiere bajar a la BD y el segundo permite que esta se encuentre online.

![Respaldo Físico vs. Lógico](https://i.imgur.com/e7T1qNF.png)

## Respaldo offline

* En los respaldos físicos o "fríos" tenemos que detener a la BD para realizar las copias de los archivos físicos.
* Contar con un usuario (del sistema usuario) con la capacidad de realizar el copiado de dichos archivos.
* Suelen ser más pesados puesto que se esta copiando **todo el archivo**.

Estos respaldos deberíamos de hacerlos en ventanas de mantenimiento para bajar a la base de datos y suelen llevar bastante tiempo debido al tamaño de los archivos, idealmente para archivos como el `CONTROL FILES` y del `SPFILE`.

## Respaldos online 

Se realizan cuando la BD se encuentra online, se debe de tener en cuenta que debería de realizarle cuando la carga sobre la BD sea pequeña ya que el respaldo puede encontrarse des actualizado al momento de finalizarle debido a transacciones intermedias durante su proceso. Consiste en copiar los archivos correspondientes de un `TABLESPACE` determinado hacia otro.

La herramienta `IMPORT/EXPORT` nos permite realizar respaldos de objetos en archivos de exportación, esto habilita una gran movilidad entre bases de datos o incluso de reblados.

* Es recomendado respaldar los archivos `REDO` en el disco, pero en ubicaciones distintas.
* Los archivos copia no deberían de estar en el mismo dispositivo que los originales.
* Se debería mantener diferentes copia, o sea multiplexar, idealmente estas copias se encontraran en ubicaciones distintas.
* Mínimo se debería de mantener dos a tres copias de los archivos `REDO LOG`.
* Siempre que se haga un `DLL` se modifica al `CONTROL FILE`, por lo cual se deberia de mantener una copia de este.
    * `ALTER DATABASE BACKUP CONTROL FILE TO '<destino>'`.

### Realización de Respaldos

1. Activar el modo `ARCHIVELOG`.
2. Realizar un respaldo por lo menos una vez a la semana, en otro caso respaldos en caliente cada día (esto varia según las necesidades del negocio).
3. Copiar todos los archivos `REDO LOG` archivados cada 4 horas, el tamaño y frecuencia de estos depende de la tasa de transacciones.

#### Realización de Respaldos Online

1. Con el comando `ALTER TABLESPACE <tablespace_name> BEGIN BACKUP;`, se bloquean los `DATAFILES` del `TABLESAPCE` de `USERS` para realizar el respaldo.
2. Con el comando `ALTER TABLESPACE <tablespace_name> END BACKUP;`, se desbloquean los `DATAFILES` del `TABLESPACE` especificado.

#### Cambiar Entre Modos de Archivado

Para pasar entre modos de archivado usamos el siguiente comando.

```sql
ALTER DATABASE ARCHIVELOG;          -- Habilita el modo de archivado 
ALTER DATABASE ARCHIVELOG MANUAL;   -- Tenemos que dar la orden para archivar
ALTER DATABASE NOARCHIVELOG;        -- Deshabilita el modo de archivado
```
Estas operaciones requieren bajar a la base de datos, para que los archivos de `REDO` y `ARCHIVE` no se vean modificados. Podemos verificar con el siguiente comando:

```sql
ARCHIVE LOG LIST;

Database log mode              No Archive Mode
Automatic archival             Disabled
Archive destination            USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     4
Current log sequence           6

SELECT log_mode FROM v$database;

LOG_MODE
------------
NOARCHIVELOG
```

Con la siguiente consulta iniciamos el modo de archivado:

```sql
STARTUP MOUNT                       -- Se inicia en MOUNT por que es nectario leer la configuración de los control files para modificar la configuración de la BD.
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
SELECT LOG_MODE FROM V$DATABASE;
```

Encontramos los siguientes parámetros de inicio relevantes:
* `LOG_ARCHIVE_DEST_N`: Destino en donde se guardan los `ARCHIVE REDO LOGS`


| Archive                                                     | No Archive                                                 |
| ----------------------------------------------------------- | ---------------------------------------------------------- |
| Puede respaldar partes de la BD                             | Requiere respaldar a toda la BD                            |
| Permite realizar respaldos online                           | La BD debe de ser apagada.                                 |
| Partes de la BD pueden ser restauradas                      | Requiere restaurar a toda la BD                            |
| Todas las transacciones son recuperables                    | Todos los cambios desde el ultimo respaldo son recuperados |
