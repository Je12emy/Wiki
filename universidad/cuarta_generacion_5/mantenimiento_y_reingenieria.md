<!-- LTeX: language=es -->

# Mantenimiento y Reingeniería

La etapa de mantenimiento del software empieza inmediatamente desde que este entra en producción, donde cientos de usuarios proporcionan retroalimentación sobre cambios y mejoras que necesita la aplicación según sus necesidades. Eventualmente se invertirán muchos recursos en el mantenimiento del software envés de desarrollar nuevos aplicativos. El cambio es inevitable y es un tema complejo de manejar, gracias a las etapas de análisis para entender el problema para desarrollar una solución bien estructurada (diseño) y es con estas dos etapas que se obtiene software mantenible.

> La mantenibilidad es un indicio cualitativo de la facilidad con la que el software existente puede corregirse, adaptarse o aumentarse.

## Soportabilidad del Software

La soportabilidad puede ser definida como la capacidad de dar soporte a un producto de software durante toda su vida operativa, esto implica satisfacer cualquier necesidad o requisito, así como aprovisionamiento de equipo, infraestructura, software adicional, instalaciones, mano de obra o cualquier otro recurso para mantener al software operativo.

## Reingeniería

La reingeniería es un tema controversial que puede generar resultados positivos y negativos, esta impulsa a empresa a realizar un legítimo esfuerzo para obtener mayor competitividad, pero otras apuestan a la reducción y subcontratación, lo cual por lo general resulta en organizaciones con poco potencial para crecimiento futuro.

### Reingeniería de Procesos de Empresa

La reingeniería de procesos de empresa o RPE se extiendo afuera del mundo de la tecnología, se puede definir como:

> La búsqueda, e implementación, de cambios radicales en los procesos de las empresas para lograr resultados innovadores


#### Procesos Empresariales

Un proceso empresarial es

> Un conjunto de tareas lógicamente relacionadas, que se realizan para lograr un resultado empresarial definido

Acá todo proceso empresarial tiene un cliente definido quien recibe el resultado y requiere de diferentes grupos participen en las tareas que definen al proceso. Un sistema empresarial está compuesto por uno a más procesos empresariales, este sistema cuenta con la siguiente jerarquía.

![Jerarquía de un Sistema Empresarial](https://i.imgur.com/x59pSyJ.png)

La RPE se puede aplicar a cualquier nivel de la jerarquía, pero entre más alto se aplique en la jerarquía, mayor es su riesgo.

### Un Modelo RPE

La reingeniería es un proceso iterativo, las metas y procesos de la empresa deben adaptarse a un entorno cambiante. El modelo de la RPE cuenta con 6 actividades:

* Definición de la empresa: Las metas de la empresa se identifican en 4 contextos: reducción de costo, reducción de tiempo, mejora de la calidad y desarrollo y fortalecimiento del personal. Estas metas se pueden definir para toda la empresa o para un componente especifico.
* Identificación de procesos: Se identifican a los procesos críticos para cumplir con las metas identificadas.
* Evaluación de procesos: Los procesos existentes se analizan y se miden. Se identifican a las tareas de estos, se anotan sus costos y el tiempo consumido por ellas y se aíslan los problemas de calidad/desempeño.
* Especificación y diseño de procesos: Se preparan casos de uso para cada proceso que deba someterse a reingeniería.
* Prototipo: Se pone a prueba el proceso para realizar refinamiento antes de que se integre plenamente en la empresa.
* Refinamiento y ejemplificación: Con base en el prototipo el proceso empresarial se refina y luego se ejemplica dentro del sistema empresarial.

## Reingeniería de Software

Es común toparse con una aplicación que continúa operando 10 o 15 años después de su inserción original, esta ha recibido mantenimiento, pero no se han seguido las buenas prácticas de ingeniería de software. Esta todavía funciona, pero cuando se intenta realizar un cambio se dan efectos inesperados, aun así este debe continuar operando.

### Un modelo de proceso de reingeniería de software

La reingeniería es un proceso costoso que absorbe recursos que de otro modo pueden ocuparse en preocupaciones inmediatas. Debido a esto la reingeniería no se logra en pocos meses, sino que es algo se suele lograr a lo largo de varios años, por lo cual se debe de adaptar una estrategia pragmática para afrontar este desafío.

![Modelo de Reingeniería de software](https://i.imgur.com/BMlEp1M.png)

### Actividades de reingeniería de software

#### Análisis de Inventarios

En el contexto de software, puede decirse que el inventario son los aplicativos. Acá entonces se identifica a cada a una y se obtiene toda la información posible acerca de esta sea su edad, tamaño e importancia empresarial. Luego se puede organizar esta lista según su importancia empresarial, longevidad, mantenibilidad actual, so portabilidad y otros importantes, así se pueden encontrar candidatos para la reingeniería y asignar recursos a cada una.

#### Restructuración de Documentos

Débil documentación es una característica común en sistemas heredados, por lo cual se tienen varias opciones:

* No generar nueva documentación debido a su gran costo, esta puede ser una opción válida si el sistema es relativamente estático.
* Documentar según modifica el software, acá se genera una base sólida de documento sutil y relevante según evoluciona el aplicativo.
* Documentar por completo al sistema debido a su importancia empresarial

#### Ingeniería Inversa

Este es un proceso común en el mundo del hardware, en el mundo del software corresponde a realizar una representación abstracta o de alto nivel de como funciona el código fuente, la ingeniería inversa es entonces un proceso de recuperación del diseño.

#### Restructuración de Código

Aunque la mayoría de sistemas heredados cuentan con una arquitectura relativamente sólida, sus módulos individualmente pueden contener código difícil de entender, difícil de mantener y poner a prueba. Esta actividad se puede apoyar con herramientas de análisis de código, en donde las violaciones en el código son anotadas para estructurar al código. El código resultante debe de revisarse y ponerse a prueba.

#### Restructuración de Datos

Esta es una actividad a gran escala, esta usualmente inicia con la ingeniería inversa en donde la arquitectura de datos existente se diseca y se definen los modelos de datos necesarios, se identifican los objetos y atributos de datos así como la calidad de los datos existentes. Cuando la arquitectura de datos es decil, los datos se someten a la reingeniería.

#### Ingeniería Hacia Adelante

Acá se toma a la funcionalidad existente del sistema por modificar con la intención de alterar o reconstruirlo con la intención de mejorar su calidad global, añadiendo nuevas funciones y mejorar su rendimiento global

## Ingeniería Inversa

Esta es la tarea de generar estructura a partir de una fuente no estructurada, se extrae información de diseño a partir del código fuente, pero el nivel de abstracción, completitud de la documentación, grado en el que las herramientas y el analista trabajan en conjunto y la direccionalidad del proceso son enormemente variables.

El nivel de abstracción debe permitir generar una imagen de alto nivel sobre el funcionamiento interno de un sistema, esto permitirá facilitar la compresión del programa. La completitud se refiere al nivel de detalle que se proporciona en la abstracción del sistema, entre mayor sea la abstracción disminuye la completitud y aumenta según el análisis realizado por el encargado de la reingeniería.

![Proceso de Ingeniería Inversa](https://i.imgur.com/WvVtK5o.png)

El proceso de reingeniería empieza con el código fuente no estructurado o sucio, este es sometido a una restructuración para obtener constructos de programación estructurados. Así dando la base para el resto de actividades. El núcleo de la reingeniería es la extracción de abstracciones, donde se evalúa el programa antiguo para desarrollar una especificación del procesamiento que se realiza, de la interfaz de usuario y las estructuras de datos.

### Ingeniería Inversa para Comprender Datos

Esta es una de las primeras tareas de la reingeniería, por lo general las estructuras de datos globales se someten a la reingeniería para acomodar nuevos paradigmas de administración de bases de datos. 

* Estructuras de Datos Internas: Se enfoca en identificar clases dentro del código fuente, agrupando aquellas variables y funcionen que operan dentro de un mismo contexto.
* Estructura de Base de Datos: Corresponde en identificar y entender a las entidades de la base de datos.

### Ingeniería Inversa para Entender el Procesamiento

Se analiza el proceso de procesamiento donde cada programa que constituye el aplicativo representa una abstracción funcional en un nivel alto de detalle. Se crea un diagrama de bloques, que representa la interacción entre dichas abstracciones funcionales.

### Ingeniería Inversa de Interfaces de Usuario

Para comprender una interfaz de usuario debe de especificarse la estructura y el comportamiento de la interfaz.

* ¿Cuáles son las acciones básicas (por ejemplo, golpes de tecla y clics de ratón) que debe procesar la interfaz?
* ¿Cuál es la descripción compacta de la respuesta de comportamiento del sistema a dichas acciones?
* ¿Qué se entiende por “reemplazo” o, más precisamente, qué concepto de equivalencia de interfaces es relevante aquí?

## Restructuración

La restructuración de software modifica a código fuente y/o datos con la intención de hacerlos sensibles a cambios futuros, esta reestructuración no modifica la arquitectura del programa, sino que se enfoca en los detalles del diseño de los módulos individuales.

### Restructuración de Código

En esta se busca producir un diseño que produzca la misma función, pero con mayor calidad que el programa original, existen varias técnicas para realizar esta actividad.

### Reestructuración de Datos

Esta inicia con un análisis del código fuente en donde se evalúa todos los enunciados del lenguaje de programación donde se contienen definiciones de datos, descripciones de archivos I/O y descripciones de interfaz, se busca extraer información acerca del flujo de datos y entender la estructura de datos existente. Siguiente en el rediseño de datos en donde se busca la estandarización de registro de datos en donde se clarifica las definiciones de los datos para lograr consistencia entre los nombres y formatos. Con el análisis y rediseño listo, se pueden realizar modificaciones físicas a las estructuras de datos existentes para hacer que el diseño sea más efectivo.
