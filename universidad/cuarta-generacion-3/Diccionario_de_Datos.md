# El Diccionario de Datos

Es un conjunto de tablas que proporción información acerca de como esta construida, asociada y funcionando su base de datos relacional y nadie puede escribir sobre estas tablas, adicionalmente contiene todos los objetos y esquemas contenidos en la base de datos. El Diccionario de Datos brinda información acerca de:

- El espacio asignado o consumido por usuario, table space o data file.
- El espacio restante a un data file.
- El tamaño de una tabla.
- Cuantos bloques ha tomado una tabla.
- Datos predeterminados de una columna en una tabla.
- Constrains de una tabla.
- Roles, permisos y privilegios asignados a un usuario.
- Información de auditoria.
- Otra información general de la base de datos.

Un diccionario de datos se crea en el momento que se utiliza el comando `CREATE DATABASE` y así es generado, un diccionario se compone por 2 elementos:

- Tablas del diccionario.
- _Tablas de rendimiento dinámico_ (son básicamente vistas) que se llaman así por que muestran información en tiempo real de que es lo que esta sucediendo actualmente en la base de datos.

Entonces se puede decir que un diccionario es el conjunto de tablas y vistas de lectura que graban, verifican y proveen información sobre su asociada Base de Datos

- Al realizar un `query` este queda en memoria y puede ser visto en el diccionario de datos.
- Se pueden ver cuales son los `queries` mas utilizados.
- Se pueden ver cuales son los `queries` de mayor consumo.
- Se pueden ver los usuario activos.
- Se pueden ver los usuario que están ejecutando algo.
- Se pueden ver bloqueos en la base de datos.

Entonces **todo lo que ocurra en la base de datos, se puede ver en el diccionario**.

> All the data dictionary tables and views for a given database are stored in that database's `SYSTEM` tablespace

**Nota:** Cada base de datos, tiene su propio diccionario de datos.

## Estructura de un Diccionario de Datos

Se puede dividir al diccionario de dos maneras:

- **Tablas Base**: Son las tablas primarias o de guia, que son creadas inicialmente y que son almacenadas en el script encrestado `sql.bsq`, son creadas junto con el comando `CREATE DATABASE`
- **Vistas de Diccionario de Datos:** Sumarizan y despliegan la información en las tablas base y son creadas mediante el script `catalog.sql`.

**Pregunta:** Si según vimos: _un diccionario tiene dos tipos de tablas: las tablas de diccionario y las de rendimiento dinámico_, entonces, ¿estas son `vistas del diccionario de datos` que sumarizan a las tablas base?

## Contenido de un Diccionario de Datos

El diccionario de datos propociona información sobre:

- Estructuras lógicas y físicas: Cuales son los datafiles que componen a un tablespace, cuales son los control file que cuenta una base de datos, la asignación del espacio de un objeto.
- Definición y alocalizacion de objetos.
- Usuarios.
- Roles.
- Privilegios.
- Auditoria.

## Como es Usado el Diccionario de Datos

El diccionario de datos cuenta con 3 usos principales:

- Oracle accede al diccionario de datos para obtener información sobre los usuarios, objetos de esquema y estructuras de almacenamiento.
- Oracle modifica al diccionario de datos cada vez que Language de Definición de Datos (DDL) es ejecutado.
- Cualquier usuario puede usar al diccionario para obtener información de referencia sobre la base de datos.

En el momento que usamos un comando como `CREATE TABLE STUDENTS`, `ALTER TABLES EMPLOYEES` o `DROP VIEW SALARY` se están creando objetos mediante language DDL y cuando se ejecuta,** este tiene que verse registrado** en el diccionario de datos para que posteriormente pueda ser accesible y leído .

**Nota:** El diccionario no guarda información del sistema, como seria el nombre de los clientes.

### ¿Quien debería acceder a un Diccionario de Datos?

**Todos** tienen acceso a un diccionario de datos, en el momento que se crea un usuario, este tiene acceso al diccionario de datos pero aun así hay vistas del diccionario de datos a las cuales no tendrá acceso. Acá entonces entra en juego el nivel de acceso del usuario, por ejemplo un administrador podrá ver resultados distintos a un usuario de bajo nivel.

## Como los usuarios puede acceder al Diccionario de Datos

El diccionario se compone con un conjunto de vistas, usualmente en 3 capas de vistas de acceso que se distinguen basado en un prefijo.

| Prefijo | Alcance                                                                          |
| ------- | -------------------------------------------------------------------------------- |
| USER    | La vista de usuario (Que se encuentra en el esquema de usuario actual)           |
| All     | La vista publicamente accesible (Que otras vistas pueden acceder los usuario)    |
| DBA     | La vista de administrador (Que se encuentra en las vistas de todos los usuarios) |


A continuación se esta viendo información sobre las tablas de un usuario, este es el diccionario de datos del usuario como tal.

### Vistas con el Prefijo USER

- Hacen referencia al ambiente del usuario, incluye información sobre los objetos de un esquema como serian los objetos creados por el usuario y los `GRANTS` proporcionados.
- Tienen columnas idénticas a otras vistas pero el dueño es implícito.
- Retorna un subgroup de las vistas ubicadas en `ALL`.

```sql
SELECT object_name, object_type FROM USER_OBJECTS;
```

### Vistas con el Prefijo ALL

Hacen referencia a la perfectiva publica de la base de datos, en donde el usuario tiene acceso a estos objetos mediante `GRANTS` sobre privilegios o roles, ya sean públicos o explícitos, junto a objetos que sean de propiedad del usuario.

```sql
SELECT owner, object_name, object_type FROM ALL_OBJECTS;
```

### Vistas con el Prefijo DBA

Hacen referencia a la perspectiva global de la base de datos completa.

```sql
SELECT owner, object_name, object_type FROM SYS.DBA_OBJECTS;
```

## Vistas de Diccionario de Datos en Detalle

El nombre del objeto que queramos consultar en el diccionario es bastante implícito, si queremos ver las tablas de mi usuario usaríamos `USER_TABLES`, si quiero ver mis indices usaría `USER_INDEXES`, si quiero ver mis constrains usaría `USER_CONSTRAINS`.

Acá estaremos viendo las tablas que son propiedad del usuario SCOTT, puesto que estamos usando al prefijo **USER**.

```sql
SELECT TABLE_NAME FROM USER_TABLES;

TABLE_NAME
------------------------------
SALGRADE
BONUS
EMP
DEPT

SHOW USER;
USER is "SCOTT"
```

Acá estamos viendo las vistas con que con propiedad del usuario SCOTT, no existen vistas bajo su propiedad.

```sql
SELECT VIEW_NAME, TEXT FROM USER_VIEWS;

no rows selected
```

Entonces si fuéramos a crear una vista para el usuario scott (recordar [proporcionar el privilegio](https://stackoverflow.com/questions/20595701/grant-create-view-on-oracle-11g) en caso de obtener un error en la creación) y volvemos a ejecutar esta consulta para ver sus vistas obtendríamos un nuevo resultado.

```sql

GRANT CREATE VIEW TO scott;

Grant succeeded.

CREATE VIEW EMP_VIEW AS SELECT * FROM EMP;

View created.

SELECT VIEW_NAME, TEXT FROM USER_VIEWS;

VIEW_NAME
------------------------------
TEXT
--------------------------------------------------------------------------------
EMP_VIEW
SELECT "EMPNO","ENAME","JOB","MGR","HIREDATE","SAL","COMM","DEPTNO" FROM EMP
```

Por otro lado encontraremos pequeñas diferencias entre las vistas segun su prefijo, tal seria el caso entre `USER_TABLES` y `ALL_TABLES`.

```sql
DESC USER_TABLES;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 TABLE_NAME                                NOT NULL VARCHAR2(30)

DESC ALL_TABLES;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 OWNER                                     NOT NULL VARCHAR2(30)
 TABLE_NAME                                NOT NULL VARCHAR2(30)
```

En el siguiente comando como scott veremos que puede ver al consultar las tablas y sus dueños en `ALL_TABLES`.

```sql
SELECT OWNER, TABLE_NAME FROM ALL_TABLES;

OWNER                          TABLE_NAME
------------------------------ ------------------------------
SYS                            DUAL
SYS                            SYSTEM_PRIVILEGE_MAP
SYS                            TABLE_PRIVILEGE_MAP
SYS                            STMT_AUDIT_OPTION_MAP
```

Por otro lado, el usuario scott no tendra acceso a todas las vistas tal seria el caso de `DBA_TABLES`.

```sql
SELECT OWNER, TABLE_NAME FROM DBA_TABLES;
SELECT OWNER, TABLE_NAME FROM DBA_TABLES
                              *
ERROR at line 1:
ORA-00942: table or view does not exist
```

Pero si nos conectaramos con un usuario que si tiene acceso a estas vistas, el resultado cambiaria

```sql
> disc
dsconnected

> conn SYS/********** as sysdba
Connected.

SELECT OWNER, TABLE_NAME FROM DBA_TABLES;

OWNER                          TABLE_NAME
------------------------------ ------------------------------
SYS                            TYPE_MISC$
SYS                            ATTRCOL$
SYS                            ASSEMBLY$
SYS                            LIBRARY$
```

Aca como sys veremos las tablas de scott.

```sql
> set lines 150
SELECT SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME FROM DBA_SEGMENTS WHERE OWNER ='SCOTT';

SEGMENT_NAME                                                                      SEGMENT_TYPE       TABLESPACE_NAME
--------------------------------------------------------------------------------- ------------------ ------------------------------
DEPT                                                                              TABLE              USERS
EMP                                                                               TABLE              USERS
SALGRADE                                                                          TABLE              USERS
PK_DEPT                                                                           INDEX              USERS
PK_EMP                                                                            INDEX              USERS

show user

USER IS 'SYS'
```

Este tipo de consultas son esenciales para un DBA, por ejemplo para monitor ear el rendimiento, matar usuario, ver conexiones, realizar operaciones administrativas, etc.

## Tablas de Rendimiento Dinámico

Permiten monitor ear **la actividad** actual en una base de datos por ejemplo ver quienes están conectados, uso de la memoria de la base de datos, etc... Esto es logrado mediante vistas que son continuamente actualizadas. Estas tablas son **únicamente** accesibles para el usuario `SYS` y no se puede usar `DML` sobre estas osea `INSERT`, `UPDATE` ni `DELETE`

Estas no son tablas reales, en realidad son tablas o vistas 'virtuales' y puede ser accesibles mediante el prefijo `V_$` y cuentan con un alias que inicia con `V$`, digamos `V$DATAFILE` contiene información sobre los `datafiles` de la base de datos.

> `SYS` owns the dynamic performance tables; their names all begin with `V_$`. Views are created on these tables, and then public synonyms are created for the views. The synonym names begin with `V$`.

Cuando se consulta la tabla de un diccionario de datos se usa el nombre en plural, si se quiere acceder a la vista se usa la vista el singular ej.`DBA_INDEXES` y `V$INDEX`.

> Cuando se baja una instancia se limpian estas tablas.

### ¿Que se puede saber con las tablas dinámicas?

Estas permiten saber aspectos como:

- Si el objeto esta disponible o encina.
- Si un objeto esta abierto o bloqueado.
- Que usuarios estas activos o inactivos.
- Como trabaja cada usuario.

A continuacion se muestra una lista de tablas dinámicas disponibles.

| General OverView         | Schema Objects                                           | Space Allocation            | Database Structure              |
| ------------------------ | -------------------------------------------------------- | --------------------------- | ------------------------------- |
| DICTIONARY, DICT_COLUMNS | DBA_TABLES, DBA_INDEXES, DBA_TAB_COLUMNS, DBA_CONSTRAINS | DBA_SEGMENTS, DBA_EXTENDSTS | DBA_TABLESPACES, DBA_DATA_FILES |

Y a continuación se puede ver de mejor manera la estructura entre las capas del diccionario de datos.

![Data Dictionary Tutorial](https://w2.syronex.com/jmr/edu/db/oracle-data-dictionary/dict-struct.png)

* `user_tab_privs` muestra los privilegios sobre las tablas. 
* `user_col_privs` muestra los privilegios sobre las columnas.
* `user_source` muestra el contenido de un procedimiento almacenado.
* `user_secuence` muestra las secuencias.

A continuación se muestran un conjunto de queries para obtener información sobre las vistas que podemos usar.
* `SELECT * FROM dict` muestra el nombre del objeto y el comentario
* `SELECT * FROM cat` muestra cuales son los objetos y el tipo de un usuario.
* `SELECT * FROM tab` muestra las tablas y vistas de un usuario.
* `SELECT * FROM col` muestra el nombre de la tabla y sus columnas (ancho, tipo, presión, escala, comentarios, acepta nulos, valores por default, numero de columna dentro de la tabla).

## Como el Diccionario Lee una Sentencia SQL

Para un consulta normal como:

```sql
SELECT * FROM emp WHERE sal > 2000;
```

El diccionario de datos realiza los siguientes datos:
* Verifica que la tabla `emp` existe (**Pregunta:** Lo deberia de hacer en USER_TABLES?).
* Verifica si el usuario tiene el privilegio para acceder a este objeto. (**Pregunta:** Lo deberia hacer con USER_TAB_PRIVS?)
* Verifica si la columna `sal` esta definida en esta tabla (**Pregunta:** Lo deberia de hacer con [USER_TAB_COLS](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/USER_TAB_COLS.html#GUID-B6443C20-7450-4D1A-8E35-7546C1137B92)?)

## Queries en Detalle

Para obtener  los datafiles y su tamaño en MB

```sql
SELECT FILE_NAME DATA_FILE,TABLESPACE_NAME, BYTES/1024/1024 as MB FROM DBA_DATA_FILES;

DATA_FILE                                     TABLESPACE_NAME                                       MB
--------------------------------------------- --------------------------------------------- ----------
C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\USER USERS                                                  5
S01.DBF

C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\UNDO UNDOTBS1                                              55
TBS01.DBF

C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\SYSA SYSAUX                                               490
UX01.DBF

C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\SYST SYSTEM                                               680
EM01.DBF

DATA_FILE                                     TABLESPACE_NAME                                       MB
--------------------------------------------- --------------------------------------------- ----------

C:\APP\JEREMYZELAYARODRIGUE\ORADATA\ORCL\EXAM EXAMPLE                                              100
PLE01.DBF
```

Aca entonces el table space de SYSTEM tiene a un data file que se llama SYSTEM.DBF con un tamaño asignado de 680 mb.

Para obtener informacion sobre la sesion del usuario.

```sql
SELECT USERNAME, SID, SERIAL#, STATUS FROM V$SESSION;

USERNAME                              SID    SERIAL# STATUS
------------------------------ ---------- ---------- --------
                                        1          1 ACTIVE
                                        2          3 ACTIVE
DBSNMP                                  3         12 ACTIVE
                                       22          1 ACTIVE
SYSMAN                                 23         37 ACTIVE
                                       43          1 ACTIVE
                                       44          1 ACTIVE
                                       64          1 ACTIVE
                                       65          1 ACTIVE
SYSMAN                                 66         18 INACTIVE
                                       85          1 ACTIVE

```

Acá encontraremos unas filas sin nombre, estos son procesos de background de oracle ya que en el momento en el que se están ejecutando requieren de una sesión.

Y si únicamente queremos a los usuario, simplemente quitamos a los procesos.

```sql
SELECT USERNAME, SID, SERIAL#, STATUS FROM V$SESSION WHERE USERNAME IS NOT NULL;

USERNAME                              SID    SERIAL# STATUS
------------------------------ ---------- ---------- --------
DBSNMP                                  3         12 ACTIVE
SYSMAN                                 23         37 ACTIVE
SYSMAN                                 66         18 INACTIVE
DBSNMP                                 88         13 INACTIVE
SYSMAN                                109          9 INACTIVE
SYS                                   129        391 ACTIVE
DBSNMP                                191         17 INACTIVE
SYSMAN                                235          1 INACTIVE
```

