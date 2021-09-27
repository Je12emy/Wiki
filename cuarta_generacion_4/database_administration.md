# Database Administration

Muchas tareas de un DBA han sido automatizadas con el tiempo mediante tecnologías como `machine learning`, la tarea del DBA ha sido reestructurada a temas de architectura en donde este se enfoca en arquitectura, envés de temas como infraestructura.

Veremos que el DBA cuenta con varias tareas por ejecutar.

## Evaluar el Hardware del Servidor

El DBA debe de conocer bien los requerimientos del servidor para definir las licencias necesarias para poner a la base de datos en producción esto incluye:

* Cuantos discos están disponibles para Oracle y sus bases de datos.
* Cuanta memoria estará disponible para las instancias de Oracle.

El tema de licenciamiento suele ser uno de los temas históricamente más complejos, pero con el tiempo se ha venido con simplificando con versionamiento más simplificado.

Se consideran temas como

* ¿Que software de Oracle se esta instalando?
* ¿Cuales son los requerimientos de hardware específicos?
* ¿Cual es el orden recomendado de instalación de los componentes?

## Instalación de Software de Oracle

Con los requerimientos ya definidos el DBA se encarga de la instalación de todo el software necesario desde componentes de BD, Red y dependencias como componentes de Grid. Es importante también la secuencia en la cual se instala cada componente.

* Instalar el servidor de Oracle Database y toda herramienta de `frontend` y aplicativo que pueda acceder a la base de datos.
* Instalar componentes de Oracle Net para acceder a la base de datos.

## Planeación de la Base de Datos

* Definición de las estructuras lógicas.
* Diseño general de la base de datos.
* Estrategia de respaldos, esta debería ser definida desde el inicio debido a temas como costos, almacenamiento, ubicación, dependencias de software de terceros.


## Creación y Construcción de la Base de Datos



## Respaldar la Base de Datos

Una vez creada la base de datos, es necesario que el DBA se encarga de respaldar la Base de Datos para contar con una configuración base.

## Enrolar los Usuarios.

* Creación de usuarios, privilegios, roles.
* Administración de recursos mediante políticas de uso.

## Implementación del Diseño

* Implementar las estructuras como `tablespaces`.

## Respaldar la Base de Datos Completa

* Crear un respaldo completo de la base de datos con la configuración de producción.

## Tunear el Rendimiento

* Ya en producción el DBA puede encargarse de optimizar el rendimiento de base de datos alrededor de consultas.

## Instalación de Parhes

* Descargar y aplicar parches continuamente, esto ha sido automatizado por la base de datos con el tiempo.

## Otras Tareas

### Preparar el Sistema Operativo

Crear los usuarios y grupos de sistema operativo (usualmente en Linux).
* Oinstall
* dba
* Grupos opcionales como:
    * Oper
    * Asmdba
    * Asmoper
    * Asmadmin
    
## Configurar Variables de Ambiente

Configurar variables de ambiente para el proceso de instalación.

* `ORACLE_BASE`: Directorio base de Oracle, se recomiendo configurarlo antes de la instalación.
* `ORACLE_HOME`: La variable en donde se van a poner los componentes de Oracle, no es requerido antes de la instalación of `ORACLE_BASE` ha sido configurado.
* `ORACLE_SID`: Indica cual es la BD por predeterminado, no es necesaria para la instalación.
* `NLS_LANG`: Controla el language, territorio y configuración de caracteres de terminal.

## Identificación de Oracle Database.

11.2.0.1.0

* 11: Version mayor que introduce nuevas funciones significantes.
* 2: Mantenimiento a la versión mayor, indica que nuevas funciones pudieron ser agregadas o mejoradas.
* 0: Versión de servidor de aplicación, refleja el nivel de Oracle Application Server u OracleAS, su explicación suele ser omitida en nuevas versiones.
* 1: Versión de parches aplicados o componentes a la versión de mantenimiento.
* 0: Versión específica de sistema operativo, especifica lanzamientos específicos para distintos sistemas operativos.

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
Oracle Database 11g Enterprise Edition   11.2.0.1.0      64bit Production
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

## Instancia y Base de Datos

Recordemos que una instancia es un conjunto de procesos de memoria, esta cuenta on un `Listener` que escucha las consultas de usuario y dirigirse a la base de datos que corresponde. La base de datos se encarga de almacenar los datos como tal.

# Database Creation

Se tienen que seguir los siguientes pasos.

## Planificación

* Seleccionar el tamaño del bloque.
* Utilizar un undo tablespace.
* Desarrollar una estrategia de respaldo para proteger a la base de datos contra caidas.
* Familizarizarse con las operaciones para bajar y levantar la instancia de Oracle.

### Consideraciones Antes de crear la Base de Datos

* Se debería decidir como crear la base de datos, sea de manera manual o mediante el asistente.
* Definir la ubicación de la base de datos y sus archivos.
* Contar por lo minimo con dos copas activa de los `control files`, o sea multiplezarlos.
* Multiplexar los `red log files`.

#### Creación con el Asistente DBCA

* Seleccionar una plantilla.
* Incluir los datafiles, o sea definir en donde guardarlos.
* Especificar el variables de ambiente como el SID.
* Especificar caracteristicas  de la BD.
* Especificar parametros de la BD.
