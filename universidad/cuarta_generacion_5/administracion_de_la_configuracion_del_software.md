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
