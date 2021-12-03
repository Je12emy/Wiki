# Respaldos Lógicos

Vamos a continuar el tema de respaldo y recuperación, pero nos vamos a enfocar en los respaldos lógicos con la herramienta `Import/Expot`. Con un respaldo lógico es posible respaldar objetos específicos de la base de datos, sin crear una copia física del archivo como tal, esto se realiza con la herramienta `Export` que genera un archivo de tipo `.dmp`. Para realizar este tipo de operación  es necesario tener a la base de datos abierta pero esta herramienta no comprueba la validez de las relaciones.

* Asegura la consistencia en la tabla, aunque no entre tablas, osea que verifica que los bloques de datos de una table se encuentren bien pero no hace eso para sus tablas relaciones.
    * No se debería de realizar ninguna transacción durante el proceso de exportación, si se desea asegurar la consistencia entre todas las tablas relacionadas. 
* Los respaldos son bastante rápidos.
* Se puede detectar la corrupción en los bloques, ya que el proceso de exportación fallara.
* Protege de fallos de usuarios, por ejemplo si se borra una fila o toda la tabla, es fácil recuperarla por medio del comando `Import`.
* Se puede determinar los datos a exportar con gran  "flexibilidad", desde la versión 10 se introdujo el comando `EXP` que para entonces proporcionaba funcionalidad limitada.
* Se pueden hacer exportaciones completas, incrementales o acumulativas.
* Son portables que se pueden llevar de una base de datos a otra, pero se debe de tener cuidado con el formato, por ejemplo la configuración del lenguaje y configuración de región del sistema operativo huésped, por lo cual es ideal que ambas bases de datos cuenten con la misma configuración regional.

## Export

Nos permite exportar a un objeto específico de la base de datos.

### Parámetros del Comando Export

El comando `export` o `exp` cuenta con la siguiente lista de comandos:

| Parámetro            | Defecto        | Descripción                                                                                                               |
| ---------            | -------------- | -----------------------------------------------------------------------------------------------------                     |
| USERID               | `undefined`    | El username/password del usuario que realiza el export                                                                    |
| BUFFER               | Depende del SO | El tamaño en bytes del buffer utilizado, indica cuanto espacio en memoria se realiza la operación                         |
| FILE                 | `expdat.dmp`   | Nombre del destino para la exportación, la extensión `.dmp` es importante                                                 |
| GRANTS               | YES            | Indica si se exportan los permisos sobre el objeto por exportar, si es un usuario se indica si nos llevamos sus permisos. |
| INDEXES              | YES            | Indica si se quieren exportar los indices.                                                                                |
| ROWS                 | YES            | Permite llevarse la estructura y los datos, si solo se quiere llevar la estructura se usa el valor no                     |
| COMPRESS             | YES            | Comprime los bloques de datos, los compacta                                                                               |
| PARFILE              | `undefined`    | Archivo de parametros para la operación                                                                                   |
| INCTYPE              | `undefined`    | Tipo de importación incremental                                                                                           |

Los siguientes parámetros especifican el tipo de exportación por realizar, estos **no pueden ser combinados**

| Parámetro            | Defecto        | Descripción                                                                                                               |
| -------------------- | -------------- | -----------------------------------------------------------------------------------------------------                     |
| FULL                 | NO             | Indica que se exporta toda la base de datos                                                                               |
| OWNER                | usuario actual | Indica que se exporta el contenido dentro de un esquema                                                                   |
| TABLES               | `undefined`    | Indica que se exporta una lista especifica de listas                                                                      |

Uso: `exp [parametros]`

### Modos de Exportación

Se puede usar esta utilidad con 3 modos de exportación disponibles:

* Modo Tabla: Exporta todas las definiciones de la tabla (o sea  su estructura), los datos, los derechos del propietarios, los indices, las restricciones y los `triggers` asociados a una tabla.
* Modo Usuarios/Owner: Exporta todos los objetos del modo tabla, más los clusters, enlaces de la BD, vistas, sinónimos, secuencias, procedimientos **de un usuario** o de una lista de usuarios.
* Modo Full: Incluye al modo tabla, el modo usuario y todo el contenido de la base de datos como serian los roles, sinónimos, privilegios del sistema, definiciones de `TABLESPACES`, definiciones de segmentos de `rollback`, opciones de [auditoria](auditoria_oracle_db), los disparadores y los perfiles.
    * En este se divide en 3 casos adicionales: Completo, Acumulativo o Incremental, donde los 2 ultimos toman menos tiempo y solo exportan los cambios realizados.

Veamos unos ejemplos:

_Exportar todas las tablas de la BD e inicializar la información sobre la exportación incremental de cada tabla_, aca despues de una exportación completa, no se necesitan los archivos de exportación acumulativas e incrementales previas ya que contempla todos los cambios hasta el momento.
    
```console
exp userid=system/manager full=y inctype=complete constraints=y file=full_export_filename;
```

_Exportar solo las tablas que han sido modificadas desde la **ultima exportación acumulativa o completa**_, y registra los detalles de exportación (sus cambios) para cáda tabla exporta, aca despues de cada exportación acumulativa, no se necesitan las exportaciones incrementales de la BD anteriores, ya que el acumulativo incluye todos los cambios realizados hasta el momento.

```console
exp userid=system/manager full=Y inctype=cumulative constraints=y file=cumulative_export_filename;
```
_Exportar todas las tablas modificadas o creadas desde la **ultima exportación incremental, acumulativa o completa**_ y registrar los detalles de exportacion (sus cambios) para cada tablas exportada, este tipo de operación es interesante en entornos en donde las tablas permanecen estaticas por largos periodos de tmepo, mientras que otras varian y necesitan ser copiadas. Este tipo de operación es util cuando hay que recuperar una tabla borrada por accidente rapidamente.

```console
exp userid=system/manager full=y inctyp=incremental constrains=y file=incremental_export_filename;
```
## Import

Nos permite importar a un objeto específico desde un archivo `.dmp`.

### Parametros de Import

El comando de importación es muy similar y los parametros son iguales

| Parametro | Defecto      | Descripción                                                                                                                                  |
| --------- | ----------   | -------------------------------------------------------------------------------------------------------------------------------------------- |
| USERID    | `undefined`  | El username/password del usuario que realiza el import                                                                                       |
| SHOW      | NO           | Hace una previsualización del contenido por importar, sin importarlo.                                                                        |
| IGNORE    | YES          | Indica si ingorar errores al importar un objeto, asi no se escribe sobre objetos que se encuentran en el destino                             |
| FILE      | `expdat.dmp` | El nombre del archivo de exportación, por importar                                                                                           |
| GRANTS    | YES          | Indica si se importan tambien los privilegios                                                                                                |
| INDEXES   | YES          | Indica si se importan tambien los indices                                                                                                    |
| ROWS      | YES          | Indica si se importan las filas de las tablas                                                                                                |
| PARFILE   | `undefined`  | Este es un archivo de parametro, pero no es como los de la base de datos, es un archivo nombre-par que le indica parametros al import-export |
| TABLES    | `undefined`  | Indica una lista de tablas por importar                                                                                                      |
| FULL      | NO           | Indica si se importa todo el archivo para una importación completa                                                                           |
| INCTYPE   | `undefined`  | Tipo de importación incremental: system o restore                                                                                            |


Aca igualmente tenemos que lidiar con varios parametros importantes al momento de importar.

| Parametro | Defecto      | Descripción                                                                                                                                  |
| --------- | ----------   | -------------------------------------------------------------------------------------------------------------------------------------------- |
| FROMUSER  | `undefined`  | Indica de donde se van a extraer los datos                                                                                                     |
| TOUSER    | `undefined`  | A donde se va a dejar el contenido por importar, si se omite se usara al usuario realizando la importación, que suele ser sys.               |

![Parametros FROMUSER y TOUSER](https://i.imgur.com/xNklnYg.png)

Uso: `exp [parametros]`

Veamos unos ejemplos:


Realizar una importación completa.

```console
imp userid=sys/passwd inctype=system full=Y file=export_filename;
```

Realizar una importación incremental.

```console
imp userid=sus/passwd inctype=restore full=y file=export_filename;
```

## Poniendolo en Practica

Es posible realizar una de esta operaciones de manera interactica simplemente ingresando el nombre del comando sea: `exp` o `imp`. Al realizar una exportación debemos de prestar atención al juego de caracteres usado por el servidor ej:

```console
el servidor utiliza el juego de caracteres AL62UTF8
```

Si no se utiliza un formato universal, entonces no sera posible usar esta herramienta entre sistemas operativos.

Creemos un respaldo del esquema `OE`, nos vamos a traer los registros.

```console
EXP OWNER=oe FILE=c:\respaldos\bkp02.dmp ROWS=y;
```

Este ultimo fallo para el profesor debido a que su base de datos utilizaba `PDB` por lo cual tiene entrar a una de estas y no en la raiz.

```console
EXP SYSTEM/dba@localhost:1522/XEPDB OWNER=oe FILE=c:\respaldos\bkp02.dmp ROWS=y;
```

Para este ultimo con el parametro `LOG` podemos guardar un log de lo que hemos hecho (si es que fallo o no).

```console
EXP SYSTEM/dba@localhost:1522/XEPDB OWNER=oe FILE=c:\respaldos\bkp02.dmp ROWS=y LOG=c\respaldos\bkp02.log;
```

Si queremos exportar varios esquemas podemos pasar una lista.

```console
EXP SYSTEM/dba@localhost:1522/XEPDB OWNER=oe,hr FILE=c:\respaldos\bkp02.dmp ROWS=y;
```

Con una exportación de tipo tabla solo indicamos el nombre de estas.

```console
EXP SYSTEM/dba@localhost:1522/XEPDB tables=(oe.customers,oe.orders) FILE=c:\respaldos\bkp03.dmp ROWS=y LOG=c\respaldos\bkp02.log;
```

El modo tabla permite que nos llevemos tablas de esquemas diferentes.

```console
EXP SYSTEM/dba@localhost:1522/XEPDB tables=(oe.customers,hr.employees) FILE=c:\respaldos\bkp03.dmp ROWS=y LOG=c\respaldos\bkp02.log;
```

Para importar asumiendo que hemos creado a un usuario llamado `SEMANA9` podemos importar estos `.dmp` en nuesto esquema (No olvida proporcionar cuota ilimitada con `GRANT UNLIMITED TABLESPACE TO SEMANA9`)

```console
IMP SYSTEM/dba@localhost:1522/XEPDB FILE=c:\respaldos\bkp02.dmp FROMUSER=oe TOUSER=semana9;
```

Este comando fallo para este nuevo usuario debido a que no contaba con los privilegios necesarios para insertar datos sobre el `tablespace` de `users`.

```sql
CREATE USER semana9 identified by s9;
GRANT CONNECT, CREATE TABLE, CREATE VIEW TO semana9;
GRANT UNLIMITED TABLESAPCE TO semana9;
```

Podemos importar solo una de las tablas en este `.dmp`.

```sql
IMP SYSTEM/dba@localhost:1522/XEPDB FILE=c:\respaldos\bkp02.dmp FROMUSER=oe TOUSER=semana9 TABLES=oe.customers;
```

