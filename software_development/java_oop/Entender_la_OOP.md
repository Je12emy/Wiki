
# Programación Orientada a Objetos en Java

> La programación orientada a objetos surge a partir de los problemas que tenemos y necesitamos plasmar en código

Java surge con este paradigma y es quien lidera en este paradigma. Un paradigma es una *teoría que suministra la base y modelo para resolver problemas*, la orientación a objetos se compone de 4 elementos.

* Clases.
* Propiedades.
* Métodos.
* Objetos.

Por otro lado cuenta con 4 pilares.

* Encapsulamiento.
* Abstracción.
* Herencia.
* Polimorfismo.

La orientación a objetos se relaciona mucho con UML o Unified Modeling Language que nos permite gráficar un problema mediante diagramas que describen la funcionalidad de un sistema, nos estaremos enfocado en los diagramas de clases.

# ¿Qué es un Objeto?

Un objeto es una cosa que tiene un conjunto de caracteristicas, estos podrian ser fisicos o conceptuales digamos a un usuario y la sesion de usuario.

Estas caracteristicas o propiedades pueden ser llamadas atributos, son sustantivos, digamos nombre, tamaño. forma y estado.

Los comportamientos son todas las operaciones del objetos, suelen ser verbos, sustantivos o verbos y sustantivos, digamos para el objeto user podriamos encontrar `login()`, `logout()` y `makeReport()`.

# Abstracción: ¿Qué es una Clase?

Las clases son aquellos modelos sobre las cuales nuestros objetos seran creados, la abstracción nos permite analizar un objeto para extraer su composición (propiedades y comportamientos) en un molde generico y sobre el cual crearemos nuevos objetos.

La clases las vamos a graficar primero en diagramas de clases de UML

# Modularidad

La modularidad en Java se abarca en 2 niveles, nos enfocaremos en el nivel más basico en este curso. La modularidad proviene del area del diseño industrial, digamos un sillon al cual se pueden unir mas sillones para obtener mas asientos. La orientación a objetos se basa en la modularidad y busca lo siguiente.

* Reutilizar.
* Evitar colapsos.
* Mantenible.
* Legibilidad.
* Resolución rápida de problemas.

Permite que en caso de que una parte del codigo sufra de un error, este estara contenido dentre de este. Esto tambien permite que creemos nuevos modulos de codigo que luego podran ser integrados con el resto del codigo y hace que todo el codigo sea mas legible.

Mediante las clases, podremos implementar la modularidad y la responsabilidad de ejecutar ciertas funciones seran agrupadas en clases.