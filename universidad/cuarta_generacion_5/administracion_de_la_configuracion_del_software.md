<!-- LTeX: language=es -->

# Administración de la Configuración del Software

La administración de la configuración del software o ACS es una actividad que se aplica a lo largo del ciclo de vida de un producto de software.

> El arte de coordinar el desarrollo de software para minimizar [...] la confusión se llama administración de la configuración, que es el arte de identificar, organizar y controlar las modificaciones que se hacen al software que construirá un equipo de programación. La meta es maximizar la productividad al minimizar los errores.

Puesto que el cambio puede ocurrir en cualquier momento, se desarrollan actividades ACS con el objetivo de:

* Identificar el cambio.
* Controlar el cambio.
* Garantizar que el cambio se implementó de manera adecuada.
* Reportar los cambios a otros que puedan estar interesados.

Se tiene que distinguir entre el apoyo al software y la ACS. El apoyo es un conjunto de actividades de ingeniería de software que ocurren **después de que este se entregó al cliente**. La AS es un conjunto de actividades de rastreo y control que inicia cuando el proyecto de desarrollo inicia y solo termina cuando el software se retira por completo.

La salida del proceso de desarrollo de software se puede categorizar en 3 grupos.

* Programas de cómputo.
* Productos de trabajo que describen a los programas de cómputo.
* Datos o contenido (incluidos dentro del programa o externos a él).

Los ítems que comprenden toda la información producida como parte del proceso de software, se llaman configuración del software. Conforme se avanza en el desarrollo, se crea una jerarquía de ítems de configuración del software o ICS. Estos ICS pueden ser tan pequeños como un simple diagrama UML hasta un documento de diseño completo. Por desgracia en todo este proceso existe el cambio y es el ACS el conjunto de actividades que se desarrollan para administrar el cambio a lo largo del ciclo de vida del software.

## Elementos de un Sistema de Administración de la Configuración

Se encuentran 4 elementos clave:

* Elementos Componentes: Conjunto de herramientas acopladas dentro de un sistema de administración de archivos que permite el acceso a cada ítem de configuración del software, así como su gestión.
* Elementos de Proceso: Colección de acciones y tareas que definen un enfoque efectivo de gestión de cambio para todos los elementos constituyentes involucrados en la administración, ingeniería y uso del software.
* Elementos de Construcción: Conjunto de herramientas que automatizan la construcción de software al asegurarse de que se ensambló el conjunto adecuado de componentes validados, o sea su versión correcta.
* Elementos humanos: Conjunto de herramientas y características de proceso utilizado por el equipo de software para implementar ACS efectiva.

## Líneas de Referencia

> Una especificación o producto que se revisó formalmente y con el que se estuvo de acuerdo, que a partir de entonces sirve como base para un mayor desarrollo y que puede cambiar solo a través de procedimientos de control de cambio formal.

Una línea de referencia puede ser establecida una vez se entrega uno o más ítems de configuración del software (por ejemplo elementos de un modelo que fueron documentados) que fueron aprobados mediante una revisión técnica, después de este hito, nuevos cambios son posibles solo si estos son evaluados con anterioridad para su aprobación.

* La definición de una línea de referencia inicia con la entrega de uno o más ICS.
* Con la aprobación de los ICS mediante revisión técnica, estos serán ingresados en una base de datos (conocida como librería de proyecto o repositorio de software).
* Cuando un miembro desea introducir modificaciones sobre una línea base, esta se copia hacia un espacio de trabajo privado para el desarrollador.
* Este ICS puede ser modificado si se siguen los controles ICS.

![Líneas de Referencia](https://i.imgur.com/kOwKwwc.png)

## Ítems de Configuración de Software

Un ítem de configuración puede ser visto como la información creada como parte del proceso de ingeniería, un ICS puede considerarse como una sola sección de una gran especificación de diseño o como un caso de prueba de una suite de pruebas por ejemplo, un documento, toda una suite de casos de prueba o un componente de programa nominado

Aparte de estos ICS, muchas organizaciones agrupan herramientas de software bajo controles de configuración, por ejemplo versiones específicas de editores, compiladores, navegadores y otras herramientas se congelan como parte de la configuración del software. Ya que estos generan código fuente y datos, deben de estar disponibles cuando se tengan que realizar cambios sobre la configuración del software. Es debido a estos que estas mismas herramientas pueden convertirse en líneas base.

En realidad, los ICS se pueden organizar en objetos para que así puedan categorizarse con un solo nombre en la base de datos. Un objeto de configuración tiene un nombre y atributo y se conecta a otros objetos.

![Objetos de Configuración](https://i.imgur.com/R3KnaY7.png)

## El Repositorio ACS

Se puede definir al repositorio como una base de datos donde se almacenan los ítems de configuración del software, en el pasado podían ser simples carpetas con los documentos de papel o incluso las tarjetas perforadas con el código fuente. Esta solución no era escalable y difícil de mantener, ya que el mismo programador era el responsable de mantener y extraer la información necesaria. En la actualidad el repositorio es una base de datos que actual como el centro de acumulación y almacenamiento de la información de ingeniería de software. El papel del ingeniero es interactuar con el repositorio, usando las herramientas que se integran a él.

![Contenido del Repositorio ACS](https://i.imgur.com/aH56r65.png)


### Características ACS

El repositorio debe de contar con conjunto de herramientas para apoyar el ACS.

* Control de versión: Debe contar con la capacidad de controlar las versiones de los distintos documentos y archivos que sean almacenados en este, permitiendo al equipo revisar versiones anteriores de ser necesario.
* Rastreo de dependencias y gestión del cambio: Debe contar con la capacidad de gestionar la relaciones entre objetos almacenados entre estos, sean simples asociaciones, dependencias o relaciones obligatorias. Rastrear la relación entre estos objetos es vital para la integridad de la información almacenada en el repositorio.
* Auditoria: Debe contar con la capacidad de identificar, cuando, quien y porque se han realizado cambios en los objetos dentro del repositorio.

## El Proceso ACS

El proceso de administración de la configuración del software define una serio de tareas con 4 objetivos clave:

* Identificar todos los ítems que de manera colectiva definen la configuración del software.
* Administrar los cambios a uno o más de estos ítems.
* Facilitar la construcción de diferentes versiones de una aplicación.
* Garantizar que la calidad del software se mantiene conforme la configuración evoluciona con el tiempo.

El proceso debe lograr estos 4 objetivos de tal manera que permita resolver las siguientes 5 preguntas.

* ¿Cómo identifica un equipo de software los elementos discretos de una configuración de software?
* ¿Cómo gestiona una organización las muchas versiones existentes de un programa (y su documentación) de manera que permita que el cambio se acomode eficientemente?
* ¿Cómo controla una organización los cambios antes y después de que el software se libera a un cliente?
* ¿Quién tiene la responsabilidad de aprobar y clasificar los cambios solicitados?
* ¿Cómo puede garantizarse que los cambios se realizaron adecuadamente?
* ¿Qué mecanismo se usa para enterar a otros acerca de los cambios que se realizaron?

En realidad estas 5 preguntas dan raíz a las 5 etapas del proceso ACS, donde se parte desde una capa interna hacia el exterior.

![Capas del Proceso ACS](https://i.imgur.com/VQQ4INC.png)

### Identificación de objetos en la configuración del software

Para controlar y administrar los ítems de configuración del software, cada uno debe ser nombrado y organizarse con un enfoque orientado a objetos. Acá se van a encontrar dos tipos de objetos:

* Objetos básicos: Unidad básica de información por ejemplo un simple diagrama UML, un diseño, una prueba de código, etc.
* Objetos agregados: Estos están compuestos por varios objetos básicos, por ejemplo una suite de pruebas o un diseño arquitectónico.

Todos estos objetos cuentan con atributos, sea su nombre, descripción, recursos y criterios de aceptación.

### Control de Versión

Este combina los procedimientos y herramientas para administrar diferentes versiones de los objetos de configuración que sé crear a lo largo del desarrollo del software, un sistema de control de versión generalmente cumple con 3 capacidades:

* Almacena todos los objetos de configuración relevantes.
* Cuenta con la capacidad de administrar la versión de todos los objetos de configuración, permitiendo así usar versiones viejas de un objeto.
* Facilidad para reconstruir versiones antiguas de objetos de configuración para así compilar una versión específica del software.

### Control de Cambio

Este es el proceso necesario para controlar el cambio en el repositorio ACS, este debe de ser balanceado, ya que mucho o poco cambio pueden conducir al caos dentro del proyecto.

![Proceso del Control del Cambio](https://i.imgur.com/N07CvmP.png)

### Auditoria de Configuración

El control únicamente gestionar el proceso bajo el cambio se integra al proyecto, aun así es necesario asegurarse de que el cambio se ha implementado adecuadamente, esto es logrado mediante dos mecanismos.

* Revisiones técnicas.
* Auditoria de la revisión del cambio.

La revisión técnica se enfoca en la exactitud técnica del objeto de configuración que se modificó, los revisores valoran el ICS para determinar su constancia con otros ICS, así como omisiones o potenciales efectos colaterales.

La auditoria de configuración del software complementa a la revisión técnica al valorar un objeto de configuración acerca de las características que por lo general no se consideran durante la revisión.

1. ¿Se realizó el cambio especificado en la OCI? ¿Se incorporó alguna modificación adicional?
2. ¿Se llevó a cabo una revisión técnica para valorar la exactitud técnica?
3. ¿Se siguió el proceso del software y se aplicaron adecuadamente los estándares de ingeniería de software?
4. ¿El cambio se “resaltó” en el ICS? ¿Se especificaron la fecha del cambio y el autor del cambio? ¿Los atributos del objeto de configuración reflejan el cambio?
5. ¿Se siguieron los procedimientos ACS para anotar, registrar y reportar el cambio?
6. ¿Los ICS relacionados se actualizaron adecuadamente?

### Reporte de Estado

El reporte de estado de la configuración (llamado también contabilidad de estado) es una tarea que responde a las siguientes preguntas.

* ¿Qué ocurrió?
* ¿Quién lo hizo?
* ¿Cuándo ocurrió?
* ¿Qué más se afectará?

Cada cambio en un ICS debe quedar registrado en el reporte del estado de la configuración (REC), la salida de este debe ser accesible para todo el equipo.
