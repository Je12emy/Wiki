<!-- LTeX: language=es -->

# El Software y la Ingeniería de Software

En la actualidad el software es un recurso imprescindible para la supervivencia de miles de empresas y en nuestra vida cotidiana, apesar de la evolucion en el desarrollo de software siguen las mismas preguntas que se realizaban durante su incepcion original:

* ¿Por qué se requiere tanto tiempo para terminar el software?
* ¿Por qué son tan altos los costos de desarrollo?
* ¿Por qué no podemos detectar todos los errores antes de entregar el software a nuestros
clientes?
* ¿Por qué dedicamos tanto tiempo y esfuerzo a mantener los programas existentes?
* ¿Por qué seguimos con dificultades para medir el avance mientras se desarrolla y
mantiene el software?

## Definicion de Software

El software puede ser simplemente descrito como un conjunto de instrucciones que cuando se ejecutan proporcionan las caracteristicas, funcion y desempeño buscados. Aun asi este tipo de definiciones no es suficiente para entender sus caracteristicas nativas comparado al hardware:

### El software se desarrolla o modifica con intelecto; no se manufactura en el sentido clásico.

Comparado a un proyecto de hardware, los costos del software se centran en la ingenieria y no se pueden administrar como si fueran proyecto de manufactura.

### El Software no se "desgasta"

Se puede decir que el software se desgasta igual que un producto de hardware, solo que este se desgasta con la introduccion de cambios. Con cada cambio introducido en el software se incrementa la complegidad, lo cual al mismo tiempo puede incrementar la tasa de fallas. Debido a este principio se puede decir que el softare se desgasta.


### Aunque la industria se mueve hacia la construcción basada en componentes, la mayor parte del software se construye para un uso individualizado

La práctica de desarrollar componentes de software reutilizables entre productos es una practica que esta apenas empezando a agarrar tracción, comparado con su contraparte de hardware que lleva décadas en práctica.

## Dominios del Software

Encontraremos 7 categorías de software de computadora.

### Software de Sistemas 

Programas escritos para servicio a otros programas, este procesa estructuras de información complejas sean deterministas o indeterministas.

* Gran interacción con el hardware.
* Uso intensivo por parte de varios usuarios.
* Concurrencia.
* Recursos compartidos y administración de procesos.
* Estructuras complejas de datos.

Ejemplos:

* Compiladores.
* Editores.
* Utilerías de sistemas operativos.
* Software de redes.

### Software de Aplicación

Programas aislados que resuelven una necesidad especifica de negocio, procesan datos comerciales de forma que facilitan las operaciones de negocios o la toma de decisiones, adicionalmente puede controlar las funciones del negocio en tiempo real.

Ejemplos:

* Procesadores de transacciones.
* Controles de procesos de manufactura en tiempo real.

### Software de Ingeniería y Ciencias

Estos son los algoritmos devoradores de números, en la modernidad se ha abandonado a los algoritmos numéricos en favor de simulaciones en tiempo real.

Ejemplos:

* Astronomía.
* Vulcanología.
* Dinámica orbital espacial.
* Biología molecular.

### Software Incrustado

Software desarrollado para un producto o sistemas de hardware especializado, este se usa para implementar y controlar características y funciones para el usuario final, puede tener un alcance pequeño o grande dependiendo de los sistemas en el cual será puesto en producción.

Ejemplos:

* Controladores de microondas.
* Tableros de control.
* Controladores de combustible.

### Software de Línea de Producto

Diseñado para proporcionar una capacidad especifica para uso de muchos consumidores diferentes, este se centra en un mercado especializado y particular (control de inventarios) o se dirige a mercados masivos del consumidor (procesadores de texto y hojas de cálculo).

Ejemplos:

* Procesadores de texto.
* Hojas de cálculo.
* Gráficos por computadora.
* Administración de bases de datos.
* Aplicaciones de finanzas para negocios y de uso personal.

### Aplicaciones Web

Es el software centrado en la red, esta categoría agrupa a un gran volumen de aplicaciones, desde la web 2.0 las aplicaciones web se han convertido en aplicaciones altamente interactivas y con gran sofisticación.

### Software de Inteligencia Artificial

Utilizan algoritmos no numéricos para resolver problemas complejos que no pueden ser simplemente computados o con análisis directo.

Ejemplos:

* Robótica.
* Sistemas expertos.
* Reconocimiento de voz.
* Redes neuronales.

## Software Heredado

Este es el software que fue desarrollado hace varias décadas y ha sido modificado con el paso del tiempo para cumplir con las necesidades del negocio, estos suelen ser caracterizado por su longevidad e importancia para el negocio. Aun así suelen ser caracterizados por la mala calidad, donde estos sistemas pueden ser considerados difícil de extender, con código confuso, documentación inexistente, historia de cambios mal administrada, etc.

La respuesta común ante estos sistemas es simplemente no hacer nada, si este cumple con todas las necesidades actuales entonces no es necesario someterlo a cambios. Aun así con el tiempo la necesidad por el cambio puede surgir por una de las siguientes causas:

* El software debe adaptarse para que cumpla las necesidades de los nuevos ambientes
* El software debe ser mejorado para implementar nuevos requerimientos del negocio.
* El software debe ampliarse para que sea operable con otros sistemas o bases de datos modernos.
* La arquitectura del software debe rediseñarse para hacerla viable dentro de un ambiente
de redes.

## La Naturaleza de las Web Apps

Gracias a la red global de computadoras surgió un nuevo tipo de software, las web apps. En su etapa infantil, estos eran simples archivos de texto interconectados entre sí, pero con la revolución de las Web 2.0 estas empezaron a evolucionar hasta transformarse en herramientas sofisticadas de cómputo. Todas las web apps son distintas e involucran una mezclas entre varias áreas como la mercadotecnia, arte, publicación impresa, comunicación y la tecnología, aun así se puede decir que la mayoría de web apps comparten los siguientes atributos:

* Uso intensivo de redes: Debido a que es accesible mediante el internet, por lo cual debe responder ante las necesidades de esta comunidad.
* Concurrencia: Es accesible por múltiples usuarios al mismo tiempo.
* Carga impredecible: El tráfico varía cada día.
* Rendimiento: El rendimiento es imprescindible para la retención de usuarios.
* Disponibilidad: Se espera que estas se encuentren disponibles las 24 horas de día, los 365 días de año.
* Orientada a datos: Se encargan de consumir, procesar y presentar grandes cantidades de datos.
* Contenido sensible: Se espera que su contenido sea de alta calidad.
* Evolución continua: Estas evolucionan con el tiempo para cumplir con las necesidades del usuario.
* Seguridad: Debido a su accesibilidad mediante la red, se espera que estas cuenten con la capacidad de proteger contenido sencillo y brinden modos seguros de transmisión de datos.
* Estética: Se espera que su presentación sea estítica y atractiva para el usuario final.

## Ingeniería de Software

La definición de la ingeniería de software puede variar según el autor, en primera instancia se tiene la definición propuesta por Fritz Bauer:

> La ingeniería de software es el establecimiento y uso de principios fundamentales de la ingeniería con objeto de desarrollar en forma económica software que sea confiable y que trabaje con eficiencia en máquinas reales.

Aun así esta definición puede ser un poco corta y no menciona aspectos como la calidad, requerimientos de usuarios, medicion, metodologia, procesos etc. por lo cual está la definición de IEEE.

> La ingeniería de software es: 1) La aplicación de un enfoque sistemático, disciplinado y cuantificable al desarrollo, operación y mantenimiento de software; es decir, la aplicación de la ingeniería al software. 2) El estudio de enfoques según el punto 1

La ingenieria de softare es una tecnologia con varias capas que parte con el compromiso con la calidad.

![Capas de la ingenieria de softawre](https://i.imgur.com/L7PpgTI.png)

Aca se encuentran varios fundamentos o capas.

* El proceso de ingenieria permite el desarrollo racional y oportuno del software de computo, este permite el desarrollo racional y oportuno de software. Al mismo tiempo es la base para el control de la administracion de proyectos de software.
* Los metodos proporcionan la experiencia tecnica para elaborar softawre, incluye un conjunto amplio de tareas, como la comunicacion, analisis de los requerimientos, modelacion del diseño, construccion del programa, pruebas y apoyo.
* Las herramientas proporcionan un apoyo automatizado o semiautomatizado para el proceso y los metodos.

Cuando se integran las herramientas de modo que la informacion creada por una pueda ser utlizada por otra, queda establecido un sistema llamada ingenieria de software asistidu por computadora, que apoya al desarrollo de softare.

## El Proceso del Software

* El proceso es un conjunto de actividades, acciones y tareas que se ejecutan cuando va a crearse algun producto del trabajo.
* Una actividad busca lograr un objetivo amplio (por ejemplo la comunicacion con los participantes) y se desarrolla sin importar el dominio de la aplicacion, tamaño del proyecto, complegidad del esfuerzo o grado de rigor con el que se usara la ingenieria de software.
* Una accion es un conjunto de tareas que producen un producto importante del trabajo (por ejemplo un modelo de la arquitectura).
* Una tarea se centra en un objetivo pequeño pero bien definido (por ejemplo realizar una prueba unitaria).

El proceso no es una simple prescripcion para el desarrollo de software, sino un enfoque adaptable que permite al equipo de desarrollo seleccionar el conjunto de acciones y tareas para el trabajo. Este por lo general incluye a la siguientes 5 actividades.

* Comunicacion: Antes de iniciar cualquier trabajo, es importante comunicarse y colaborar con el cliente, con esto se busca entender los objetivos de los participantes respecto al proyecto y recolectar requerimientos.
* Planeacion: Esta busca la elaboracion de un "mapa", tambien conocido como "Plan del Proyecto de Software". Este define el trabajo de ingenieria de software al decribir las tareas tecnicas por realizar, los riesgos probables, las recursos requeridos, los productos del trabajo que se obtendran y una programmacion de las actividades
* Modelado: Esta es la creacion de un bosquejo con la meta de vizualizar como cada elemento encaja en producto final.
* Construccion: Esta actividad incluye la generacion de codigo y las pruebas para descubrir errores.
* Despliegue: Esta es la actividad de poner el sotware en produccion para el consumo del cliente.

Estas actividades estructurales se ejecutan en ciclos, obteniendo asi una iteracion del producto del software. Estos ciclos se pueden realizar durante actividades sombrilla, estas se ejecutan a lo largo de un proyecto de software y ayudan al equipo a administrar y controlar el avance, la calidad, el cambio y el riesgo:

* Seguimiento y control del proyecto de software: Permite que el equipo evalue el progreso, comprobandolo contra el plan del proyecto y tome cualquier accion necesaria para apegarse a la programacion de actividades.
* Administracion del riesgo: Evalua los riesgos que puedna afectar el resultado del proyecto o calidad del mismo.
* Aseguramiento de la calidad del software: Define y ejecuta las actividades requeridas para garantizar la calidad del software.
* Revisiones tecnicas: Evalua los productos del trabajo con el fin de descubrir y eliminar errores antes de que se propaguen a la siguiente actividad.
* Medicion: Define y reune mediciones del proceso, proyecto y producto para ayudar al equipo a entregar el software que cumpla las necesidades de los participantes.
* Administracion de la configuracion del software: Administra los efectos del cambio a largo del proceso del software.
* Administracion de las reutilizacion: Define criterios apra volver a usar el producto del trabajo y establece mecanismos para obtener componentes reutilizables.
* Preparacion y produccion del producto del trabajo: Agrupa las actividades requeridas para crear productos del trabajo, tales como modelos, documentos, registros, formatos y listas.


## Mitos del Software

Estas son creencias erroneas sobre este y proceso que se utiliza para obtenerlo,

### Mitos de la Administracion

* Mito: Tenemos un libro lleno de estándares y procedimientos para elaborar software.
    * Realidad: Puede que exista un libro, pero no se conoce de este o en ciertos casos no se pone en uso.
* Mito: Si nos atrasamos, podemos agregar más programadores y ponernos al corriente
    *  Realidad: Agregar mas personal implica esfuerzo por parte del equipo existente para ponerlo al dia con el desarrollo del producto, perdidiendo asi eficiencia en el desarrollo del sistema.
* Mito: Si decido subcontratar el proyecto de software a un tercero, puedo descansar y dejar que esa compañía lo elabore. 
    * Realidad: Si una empresa no sabe como administrar sus proyectos internos, no podra gestioanr un proyecto desarrollado por terceros.

### Mitos del Cliente

* Mito: Para comenzar a escribir programas, es suficiente el enunciado general de los
    * Realidad: Requerimientos ambiguos son la receta perfecta para el desastre, los requerimientos no ambiguos se desarrollan solo por medio de una comunicacion eficaz y continua entre el cliente y el desarrollador.
* Mito: Los requerimientos del software cambian continuamente, pero el cambio se asimila con facilidad debido a que el software es flexible objetivos.
    * Realidad: El efecto del cambio depende de que tan avanzado se encuentra en la etapa de desarrollo del software, entre mas tarde se haga, mayor sera su efecto. 

### Mitos del Profesional

* Mito: Una vez que escribimos el programa y hacemos que funcione, nuestro trabajo ha terminado
    * Realidad: La mayoria del esfuerzo se da despues de haber finalizado con el proyecto y haberlo entregado por primera vez.
* Mito: Hasta que no se haga “correr” el programa, no hay manera de evaluar su calidad.
    * Realidad: Uno de los mecanismos mas eficaces para asegurar la calidad del software puede aplicarse desde la concepcion del proyecto: la revision tecnica.
* Mito: El único producto del trabajo que se entrega en un proyecto exitoso es el programa que funciona
    * Realidad: Un programa funcional es solo uno de los entregables, aca se incluyen otros productos terminados como modelos, diagramas y planes, estos proporcionan la base para un proceso de ingenieria exitosa.
* Mito: La ingenieria de software hara que generemos documentacion voluminosa, e invariablemente nos retrasara.
    * Realidad: La ingenieria de softare con consiste en generar documentos, se trata de generar un producto de calidad. La mejor calidad evitara que hagamos menos repeticione y nos dara tiempos de entrega mas cortos. 
