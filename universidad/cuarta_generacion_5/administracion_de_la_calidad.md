<!-- LTeX: language=es -->

# Administración de la Calidad

## ¿Qué es la calidad?

Definir que es calidad es una tarea compleja, que ya cada individuo tiene una percepción distintas sobre esta cualidad, según _David Garvin_:

> La calidad es un concepto complejo y de facetas multiples


Acá se identifican 5 puntos de vista:

* El punto de vista trascendental en donde la calidad es algo que se reconoce de inmediato, pero no es posible de definir explícitamente.
* El punto de vista del usuario donde la calidad se define en términos de metas específicas del mismo, si son cumplidas entonces el producto es de calidad.
* El punto de vista del fabricante donde esta se define basado en sus especificaciones originales.
* El punto de vista del producto donde se basa en las características del producto.
* El punto de vista de valor que se basa en cuanto el cliente está dispuesto a pagar por el producto.

La calidad es todo esto y más...

* La calidad del diseño se refiere a las características que los diseñadores especifican para un producto, factores como materiales, tolerancias y desempeño influyen en la calidad del producto. En el desarrollo de software, la calidad del diseño es el grado con el cual se cumplen las funciones y características especificadas en los requerimientos.
* La calidad de la conformidad se enfoca en el grado con el cual el producto se apega al diseño y que el sistema cumpla con sus requerimientos y desempeño

¿Son entonces la calidad de diseño y conformidad los únicos aspectos por considerar? La satisfacción del usuario es el factor más importante por tomar en cuenta.

```
satisfacción del usuario = producto que funciona + buena calidad + entrega dentro del presupuesto y plazo
```

## Calidad del Software

La calidad de software se puede definir de la siguiente manera:

> Proceso eficaz de software que se aplica de manera que crea un producto útil que proporciona valor medible a quienes lo producen y a quienes lo utilizan.

Partir de esta definición se puede hacer énfasis en 3 puntos clave.

1. Un proceso eficaz de software establece la infraestructura que brinda apoyo a cualquier esfuerzo de elaboración de un producto de software. La administración genera la verificación y equilibrio para evitar que el proyecto caiga en el caos, las prácticas de ingeniería proporcionan los mecanismos para analizar y proponer una solución a un problema y las actividades sombrilla como la gestión del cambio y revisiones técnicas caen en esta definición.
2. Un producto útil entre contenido, funcione y características al usuario final, la entrega libre de errores desigual de importante.
3. Agregar valor para el productor y para el usuario del producto implica que el elaborador obtiene valor porque el software de alta calidad requiere un menor esfuerzo de mantenimiento, tiene menores errores que corregir y poca asistencia al cliente. La comunidad de usuarios obtiene valor porque la aplicación agiliza algún proceso de negocio.

### Dimensiones de la Calidad de Garvin

David Garvin define varias dimensiones de calidad, estas no aplican para el software, pero aun así son relevantes:

* Calidad del desempeño: El software entrega todo el contenido, funciones y características especificados en el modelo de requerimientos, de manera que genera valor para el usuario.
* Calidad en las características: El software cuenta con características que sorprenden y agrandan por primera vez al usuario.
* Confiabilidad: El software proporciona todas las características y capacidades sin falla alguna, este se encuentra disponible cuando se necesita y se encuentre libre de errores.
* Conformidad: El software se apega a los estándares locales y externos relevantes para la aplicación, la fuente se apega a un estándar o convención.
* Durabilidad: El software puede recibir mantenimiento o corregirse sin eventos colaterales.
* Servicio: Es posible que el software reciba mantenimiento o correcciones en un tiempo aceptable.
* Estética: El software o la interfaz tiene una buena estética objetiva.
* Percepción: El software es entregado por una entidad con buena reputación y con buen historia.

Se dice que las dimensiones de Garvin son una visión suave sobre la calidad del software, por esto se considera que se necesita un conjunto de factores duros sobre la calidad de software, estos se clasifican en dos categorías:

* Factores que pueden medirse de manera directa, como la cantidad de defectos descubiertos durante pruebas.
* Factores que pueden medirse indirectamente, como la usabilidad y facilidad de mantenimiento.
* 
### Dimensiones de la Calidad de McCall

Los autores McCall, Richards y Walters proponen una clasificación útil de **los factores que afectan la calidad del software**, estos se centran en 3 factores importantes: 

* Características operativas.
* Capacidad de ser modificado.
* Adaptabilidad a nuevos ambientes.

Estas se pueden apreciar en el siguiente diagrama.

![Dimension de la Calidad de McCall](https://i.imgur.com/E7d2YUJ.png)

Alrededor de estos 3 se encuentran los siguientes conceptos:


* Corrección. Grado en el que un programa satisface sus especificaciones y en el que cumple con los objetivos de la misión del cliente.
* Confiabilidad. Grado en el que se espera que un programa cumpla con su función y con la precisión requerida debe notarse que se han propuesto otras definiciones más completas de la confiabilidad
* Eficiencia. Cantidad de recursos de cómputo y de código requeridos por un programa para llevar a cabo su función.
* Integridad. Grado en el que es posible controlar el acceso de personas no autorizadas al software o a los datos.
* Usabilidad. Esfuerzo que se requiere para aprender, operar, preparar las entradas e interpretar las salidas de un programa.
* Facilidad de recibir mantenimiento. Esfuerzo requerido para detectar y corregir un error en un programa (esta es una definición muy limitada).
* Flexibilidad. Esfuerzo necesario para modificar un programa que ya opera.
* Susceptibilidad de someterse a pruebas. Esfuerzo que se requiere para probar un programa a fin de garantizar que realiza la función que se pretende.
* Portabilidad. Esfuerzo que se necesita para transferir el programa de un ambiente de sistema de hardware o software a otro.
* Reusabilidad. Grado en el que un programa (o partes de uno) pueden volverse a utilizar en otras aplicaciones se relaciona con el empaque y el alcance de las funciones que lleva a cabo el programa).
* Interoperabilidad. Esfuerzo requerido para acoplar un sistema con otro.

### Factores de Calidad según la ISO 9126

Es estándar ISO 9126 se desarrolló con la intención de identificar los atributos clave de un software de calidad.

* Funcionalidad: Grado en el que el software cumple las necesidades planteadas.
* Confiabilidad: Cantidad de tiempo en el cual software se encuentra disponible para su uso.
* Usabilidad: Facilidad de uso del software.
* Eficiencia: Grado en el que el software utiliza óptimamente los recursos del sistema.
* Facilidad de recibir mantenimiento: Facilidad con la cual se le puede dar mantenimiento al software.
* Portabilidad: Facilidad con la que el software puede llevarse de un ambiente a otro.

## El Dilema de la Calidad del Software

El dilema de la calidad se centra en el esfuerzo entre desarrollar software de calidad, tiempo de entrega o entrada al mercado y daño a la marca a raíz de errores. 

* Si se entrega software de la mala calidad llena de errores nadie querrá comprarlo.
* Si se invierte mucho en la calidad nunca se lograra entrar al mercado a tiempo, además esto implica mucho esfuerzo y dinero

### El Software es Suficientemente Bueno

Esta es la práctica de entregar el software con fallas ya identificadas, con la meta de introducir las características faltantes o soluciones a los errores presentes, este software suficientemente bueno contiene las funciones y características de alta calidad que desea el usuario, pero tiene otras funciones con errores conocidos.

La meta de esta técnica es capturar al mercado... Aun así dependiendo de la industria puede ser que esto no sea viable por ejemplo el software automotor o de telecomunicaciones, en este caso, esto es conocido como negligencia.


### El Costo de la Calidad

Ya que se entiende tanto el costo de no invertir en la calidad, es hora conocer el costo de la calidad.

> El costo de la calidad incluye todos los costos en los que se incurre al buscar la calidad o al realizar actividades relacionadas con ella y los costos posteriores de la falta de calidad

El costo de esta se puede dividir entonces en los costos asociados a la prevención, la evaluación y la falla.

* Costos de Prevención:
    * Actividades de administración para planear las actividades de control y aseguramiento de la calidad.
    * El costo de las actividades *técnicas* para desarrollar modelos completos de requerimientos.
    * El costo de planear pruebas.
* Costos de Evaluación: Las actividades de investigación de la condición del producto por primera vez, por ejemplo:
    * El costo de realizar evaluaciones técnicas.
    * El costo de recolectar datos.
    * El costo de realizar pruebas y depurar.
* Costos de Falla: Estos son aquellos costos que hubieran sido eliminados antes o después de entregar el producto final, acá se encuentran dos tipos de costos adicionales:
    * Costos Internos: Costos por repetir el esfuerzo.
    * Costos Externos: Asociados a defectos encontrados después de que el producto se envió a los consumidores, por ejemplo las quejas, devoluciones y ayuda en línea, así como el daño a la reputación.

### Riesgos, Negligencia y Seguridad

Pasarse por alto a la calidad puede tener serias repercusiones legales, desde encarcelamiento, litigaciones legales o simplemente perder un pago importante, la calidad no solo busca asegurar que el producto final cumpla con expectativas, sino proteger al desarrollador de cualquier repercusión contra su persona. 

Otro factor aún no mencionado es la seguridad de un sistema, este es un factor que debe ser tomado en cuenta lo antes posible en la etapa de desarrollo, más ahora debido a la importancia de los sistemas actuales de los cuales miles de personas dependen a diario y a los cuales les confían sus datos personales.

> El software que no tiene alta calidad es fácil de penetrar por parte de intrusos y, en consecuencia, el software de mala calidad aumenta indirectamente el riesgo de la seguridad, con todos los costos y provee más que eso conlleva


### Efecto de las acciones de la Administración

* Decisiones de Estimación: En muchos casos existen etapas de refinamiento para ajustar la fecha de entrega de un producto de software, esto ayuda establecer un filtro unitario para asegurar la entrega oportuna del producto final. En ciertos casos la presión es muy alta para cumplir con una fecha determinada, por lo cual se toman atajos para llegar a esta, claro a cambio de la calidad el producto.
* Decisiones de Programación: Entender la dependencia entre componentes de software es una tarea importante para entender como cada uno debe de ser probado, si un componente A depende en los componentes B, C y D, entonces este no puede ser probado en su totalidad para asegurar su calidad.
* Decisiones Orientadas al Riesgo: No contar con un plan de contingencia ante los riesgos del proyecto únicamente invita a que este se materialice e impacte profundamente a proceso de desarrollo.
