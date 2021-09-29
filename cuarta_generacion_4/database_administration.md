# Database Administration

Muchas tareas de un DBA han sido automatizadas (en el sentido de que la base se ha vuelto más inteligente) con el tiempo mediante tecnologías como `machine learning`, la tarea del DBA ha sido reestructurada a temas de arquitectura y no de datos, en donde este se enfoca en conocer los productos, arquitectura de la base de datos, procesos para definir diseñar y dar mantenimiento a una infraestructura de datos (configuración del servidor, instalación de las BD, instalación del software, networking, almacenamiento, respaldos, integración con terceros). Entonces las tareas de DBA ahora van más allá del manejo de los datos (tuneo de consultas, procedimientos, actualizaciones, etc).

El DBA debe de conocer bien la [arquitectura básica de una base de datos de Oracle](../cuarta-generacion-3/cuarta_gen_3), así como arquitecturas como [Multitenant](./oracle_multitenant).

## Tareas del DBA para Instalar una Base de Datos

Veremos entonces que el DBA cuenta con varias tareas por ejecutar.

### Evaluar el Hardware del Servidor

El DBA debe de conocer bien los requerimientos del servidor para definir las licencias necesarias para poner a la base de datos en producción esto incluye:

* ¿Cuantos discos y almacenamiento están disponibles para Oracle y sus bases de datos?
* ¿Con cuantos núcleos cuenta el servidor?
* ¿Cuanta memoria estará disponible para las instancias de Oracle?

El tema de licenciamiento suele ser uno de los temas históricamente más ***complejos*, pero con el tiempo se ha venido con facilitando con versionamiento más simplificado.

### Instalación de Software de Oracle

Con los requerimientos ya definidos el DBA se encarga de la instalación de todo el software necesario desde componentes de BD, Red y dependencias como componentes de Grid. Es importante también la secuencia en la cual se instala cada componente.

* Instalar el servidor de Oracle Database y toda herramienta de `frontend` y aplicativo que pueda acceder a la base de datos.
* Instalar componentes de Oracle Net para acceder a la base de datos.
* ¿Cual es el orden recomendado de instalación de los componentes?
* Creación de usuarios para la instalación del software y uso de la base de datos.
* Preparación de estructuras de carpetas y permisos de usuarios para estas.

### Planeación de la Base de Datos

Incluye tareas de preparación como:

* Definición de las estructuras lógicas.
* Diseño general de la base de datos.
* Estrategia de respaldos, esta debería ser definida desde el inicio debido a temas como costos, almacenamiento, ubicación, dependencias de software de terceros.
* Considerar como las estructuras lógicas afectan:
    * Rendimiento de la base de datos para ejecutar la instancia de Oracle.
    * Rendimiento de la base de datos para leer información.
    * La eficiencia del respaldo y recuperación de la base de datos.

### Creación y Construcción de la Base de Datos

Con el diseño ya completado, el DBA puede crear la base de datos, ya se de forma manual o con el asistente incluido por Oracle.

### Respaldar la Base de Datos

Una vez creada la base de datos, es recomendado que el DBA se encargue de respaldar la Base de Datos para contar con una configuración base.

### Enrolar los Usuarios.

* Creación de usuarios, privilegios y roles.
* [Administración de recursos](../cuarta-generacion-3/Resource_Management) mediante políticas.

### Implementación del Diseño

Con la creación de la base de datos y con los usuarios de la misma ya lista, ya es posible implementar las estructuras lógicas planificadas mediante la creación de los [tablespaces](../cuarta-generacion-3/Tablespace). Una vez esto este completado, se puede continuar con la creación de los objetos de la base de datos.

### Respaldar la Base de Datos Funcional

Ya con una base de datos funcional y casi lista para producción, es ideal que el DBA cree un respaldo completo con la configuración de producción.

### Tunear el Rendimiento

Este es un punto _relativo_ en el sentido de que la Base de Datos puede proporcionar sugerencias sobre posibles modificaciones, en el pasado esta era una tarea activa para el DBA mediante la [evaluación de trazas](../cuarta-generacion-3/Architectura_de_Procesos#Archivos de Traza) y [planes de ejecución](../cuarta-generacion-3/Architectura_de_Memoria#Poniendolo en Practica). Esta tarea suele ser ideal para verificar que los aplicativos (como sera un backend) hacen consultas optimizados.

> La culpa recae tanto en el programador y en el DBA en caso de que una consulta no este optimizada en producción, el programador por crear dicha consulta y el DBA por publicar un objeto con un mal rendimiento (ya que el programador no tiene derecho a esto).

### Instalación de Parches

En una base de datos autónoma, esta tarea ya se encuentra automatizada, antes era necesario sacar a todos los usuarios para aplicar actualizaciones.

## Planificación de una Instalación

Para instalar una base de Datos de Oracle el DBA debe de tomar en cuenta las siguientes tareas.

## Preparar el Sistema Operativo

Crear los usuarios y grupos de usuarios (usualmente lidiamos con esto en Linux) necesarios para la instalación, encontramos los siguientes grupos.
* Oinstall
* Dba
* Grupos opcionales como:
    * Oper
    * Asmdba
    * Asmoper
    * Asmadmin

Entre los usuarios usualmente encontramos al usuario Oracle, pero podemos crear usuarios distintos para otras instalaciones.
  
Podemos ver estos grupos en Windows así
  
![Grupos de Usuarios de Oracle en Windows](https://i.imgur.com/j8VQP08.png)

Entonces por ejemplo el usuarios "Administrador" debería de pertenecer a uno de estos grupos, sino Oracle nos avisara que este usuario tiene "privilegios insuficientes"

![Grupo de usuarios para el usuario "Administrador" en Windows](https://i.imgur.com/xsTtqbz.png)

## Configurar Variables de Ambiente

Configurar variables de ambiente para el proceso de instalación, así no sera necesario memorizar las rutas de instalación

* `ORACLE_BASE`: Directorio base de Oracle, se recomiendo configurarlo antes de la instalación.
* `ORACLE_HOME`: La variable en donde se van a poner los componentes de Oracle, no es requerido antes de la instalación of `ORACLE_BASE` ha sido configurado.
* `ORACLE_SID`: Indica cual es la BD por predeterminada, no es necesaria para la instalación.
* `NLS_LANG`: Controla el language y territorio.

En Windows se ven de la siguiente manera,

```
SET ORACLE
```

Al abrir una sesión nueva puede ser que estas variables no se encuentren configuradas, podemos configurarlas de la siguiente manera.

```
SET ORACLE_SID=xe
```
_Nota:_ La capitalización y espacios acá son importantes, `= xe` seria un sid completamente distinto.

Podemos buscar estas variables en el Windows Registry si queremos cambiarlas segun la instancia de Oracle.

![Windows Registry Variables de Oracle](https://i.imgur.com/ttAZQEL.png)

Entonces podemos configurar estas variables de forma global con el `PATH` de nuestro sistema operativo

```
SET ORACLE

ORACLE_HOME=C:\app\user\product\11.2
ORACLE_SID=xe
ORACLE_BASE=C:\app\user\11.2\dbhomeXE
```

## Identificación de Oracle Database.

La nomenclatura de versionamiento es la siguiente.

![Versionamiento de Oracle](https://i.imgur.com/c0oKXdT.png)

Viendolo en detalle se compone de la siguiente manera:

* Version Mayor: Introduce nuevas funciones significantes.
* Mantenimiento a la Versión Mayor: Indica que nuevas funciones pudieron ser agregadas o mejoradas.
* Versión de servidor de aplicación: Refleja el nivel de Oracle Application Server u OracleAS, su explicación suele ser omitida en nuevas versiones.
* Versión de Parches: Parches aplicados o componentes a la versión de mantenimiento.
* Versión Específica de Sistema Operativo: Especifica lanzamientos específicos para distintos sistemas operativos.

Para conocer la versión se puede usar la siguiente consulta.

```sql
SELECT * FROM v$version;
BANNER
--------------------------------------------------------------------------------
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
PL/SQL Release 11.2.0.1.0 - Production
CORE    11.2.0.1.0      Production
TNS for 64-bit Windows: Version 11.2.0.1.0 - Production
NLSRTL Version 11.2.0.1.0 - Production

SELECT * FROM product_component_version;

PRODUCT                                  VERSION         STATUS
---------------------------------------- --------------- --------------------
NLSRTL                                   11.2.0.1.0      Production
Oracle Database 11g Enterprise Edition   11.2.0.1.0      64bit Production <-- *
PL/SQL                                   11.2.0.1.0      Production
TNS for 64-bit Windows:                  11.2.0.1.0      Production

SELECT comp_id, comp_name, version, status, modified FROM dba_registry.
```

En la versión enterprise, SQLPlus siempre nos indicara que estamos usando esta edición.

```
Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
```

## Creación de una Base de Datos

Recordemos que [una instancia](../cuarta-generacion-3/Instancia_de_Oracle) es un conjunto de procesos de memoria, esta cuenta on un `Listener` que escucha las consultas de usuario y dirigirse a la base de datos que corresponde y la base de datos se encarga de almacenar los datos como tal.

![Oracle Listener](https://www.oracletutorial.com/wp-content/uploads/2019/07/Oracle-Listener.png)

Podemos ejecutar comandos sobre este `Listener` directamente, para abrir la linea de comando de este se utiliza el commando `LSNRCTRL`, en donde tendremos acceso a comandos como `stop`, `start`, `status`, `version` y `quit`.

Para crear una base de datos se cuentan con los siguientes pasos.

### Planificación de la Instalación

* Seleccionar el tamaño del bloque.
* Utilizar un `UNDO` tablespace.
* Desarrollar una estrategia de respaldo para proteger a la base de datos contra caidas.
* Familizarizarse con las operaciones para [bajar y levantar la instancia de Oracle](../cuarta-generacion-3/Instancia_de_Oracle).

### Decidir como crear una Base de Datos de Oracle

* Se debería decidir como crear la base de datos, sea de manera manual o mediante el asistente `Database Configuration Assistant (DBCA)`.
* Crear los nuevos `control files` y `redo logs` para la base de datos.
* Crear los nuevos `data files` o borrando los datos previos en estos.
* Definir la ubicación de la base de datos y sus archivos.
* Contar por lo mínimo con dos copias activa de los `control files`, o sea [multiplexarlos](../cuarta-generacion-3/Monitoreo_de_Sesiones#Multiplexación de un Control File).
* Multiplexar los `red log files`.
* Separa los `datafiles` de sistema y los de usuario.

#### Creación de Base de Datos con el Asistente DBCA

* Seleccionar una plantilla.
* Incluir los `datafiles`, o sea definir en donde guardarlos.
* Especificar el variables de ambiente como el SID.
* Especificar características  de la BD.
* Especificar parámetros de la BD como modo, parámetros de inicio y `datafiles`.
