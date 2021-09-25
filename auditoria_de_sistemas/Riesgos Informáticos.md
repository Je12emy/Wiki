# Riesgos Informáticos 🔐

Dentro del área de TI se encuentran las siguientes categorías de riesgos por los cuales debe velar el auditor.

* Integridad de la información: Parte de los pilares de la seguridad de la información.
* Acceso.
  * Segregación de funciones.
* Disponibilidad: Disponibilidad de la infraestructura, como serian los datos, sistemas y comunicaciones.
* Infraestructura: Infraestructura tecnológica de toda organización.
* Externalización de Servicios: Externalizar procesos o servicios.

## Riesgos de Integridad de la Información

Agrupa a todos los riesgos asociados con la **autorización, integridad y exactitud** de las transacciones, las cuales se originan de los siguientes componentes:

* **Interfaz Usuaria:** Hace referencia a las restricciones de las personas y que acciones pueden realizar, junto a la segregación de funciones. Esto es conocido como la *necesidad del saber* donde una persona solo debe acceder a la infraestructura que necesita únicamente.
* **Procesamiento:** Controles sobre el procesamiento de información y su salida, que aseguran su cumplimiento y realización a tiempo.
* **Interfase:** Se basa controles preventivos y detectivos sobre la transmisión adecuada y completa de los datos o información que han sido procesados en la interfaz usuaria.
* **Administración del Cambio:** Riesgos asociados a la ineficiente administración del cambio, así como el entrenamiento del usuario en el nuevo proceso, sobre todo que estos cambios sean comunicados oportunamente y que sean implementados.
* **Error de Procesamiento:** Se refiere a la revisión de excepciones en el procesamiento de datos, que estas puedan ser capturadas y reprocesadas nuevamente.

  Digamos un error de procesamiento en la actualización del stock después de una compra, en donde el reproceso se encarga de arreglar el cambio en el stock.
* **Datos:** Hace referencia a errores en la programación, errores de procesamiento (verificación de puertas externas, donde se apliquen prácticas de desarrollo seguro en las plataformas, donde [OWASP](https://en.wikipedia.org/wiki/OWASP) define un conjunto de normas al respecto.) y errores de administración de sistemas.

## Riesgos de Acceso

Pueden ocurrir a cualquier nivel digamos:

* Red: Generado por riesgo de acceso inapropiado a la red de pc's y servidores.
* Ambiente de Procesamiento: Generado por el acceso indebido al ambiente de procesamiento, a los programas y datos que están almacenados dentro de este.
* Sistemas de Aplicación: Inadecuada segregación de funciones, que podría ocurrir si el acceso a los sistemas estuviese concedido a personas con necesidades de negocio sin definiciones claras.
* Acceso Funcional: Dentro del código fuente.
* Acceso con respecto a campo o dato (Base de Datos).

Estos 5 niveles de acceso deben ser verificados por el auditor.

### Segregación de Funciones

Control sobre las funciones que caen sobre una sola persona, así evitar la comisión de *fraudes, sabotajes o errores internos*.

> Se busca que una persona no pueda hacerlo todo.

## Riesgo de Disponibilidad

Todo relacionado ante una **eventual caída de un servicio**, sistema, equipo o todo aquello relacionado con la interrupción del flujo normal del negocio.

Se busca que ante un proceso disruptivo es posible continuar con los procesos o la operación básica que generan ganancia y cumplimiento de objetivos.

**Es importante** que se haga una clasificación de los sistemas que maneja una empresa, puesto que no es idóneo invertir esfuerzos durante una crisis sobre procesos que no aportan nada al negocio.

* \*\*Para la UH \*\*si se cae el sistema de crédito y cobro, y el correo eléctrico, obviamente seria de mayor prioridad sin la necesidad de un estudio el sistema de crédito y cobro, puesto que existen otros medios de comunicación aparte del correo electrónico.
* **En un Call Cente**r un sistema de correo, chat y teléfono son sistemas críticos según su contexto.

### Cyber Resilencia

Reemplaza el término de *cyber seguridad*, que es la combinación entre continuidad de la operación y cyber seguridad. Atiende eventos disruptivos en la operación donde se garantiza que la empresa está preparada para atender esos eventos y continuar con su operación. Tiene aproximadamente 2 años de ser utilizada en el mercado, siendo el Banco Nacional una entidad que cuenta con una metodología de cyber resilencia para hacer frente a dichos eventos disruptivos ante los cuales puede ver expuesto.

La [NISP](https://en.wikipedia.org/wiki/National_Industrial_Security_Program) establece un conjunto de elementos para verificar que tan cyber resilente se es en un producto, servicio o sistema.

## Riesgo de Infraestructura

Se refiere a infraestructura con respecto a *hardware, software, personas y procesos* para darle soporte a todos estos sistemas automatizados, apoya todas las necesidades actuales y futuras para ser competitiva, generar utilidades y crecer como empresa. Esta infraestructura debe ser eficiente y eficaz.

Se encuentra relacionada con los siguientes:

* **Planificación Organizacional:** Las necesidades por de medio de la empresa y como estas alteran al proceso de *toma de decisiones y planificación*, estos dos últimos deben de ser racionales, objetivos y orientados al negocio.
* **Definición y despliegue de sistemas de aplicación:** El proceso de desarrollo, integración e implementación no estén correctamente focalizadas de tal manera que no es posible medir la satisfacción del usuario final, intermedio o de negocio. Incluso viene un tema de capacitación del personal, donde la adquisición de una solución en software donde la infraestructura es SAAS, pero no se incluye el tema de capacitación en su uso y nadie sabe como hacer uso de esta.
* **Seguridad Lógica y Administrativa de Seguridad:** Donde se garantiza que no hay perdida de datos o mal uso de los datos por parte del acceso del personal interno de la compañía.
* **Operaciones con computador y red:** Que no existan problemas de desempeño, procesamiento u capacitación sobre su uso.
* **Administración de Bases de Datos:** Que las bases de datos carezcan de la integridad necesaria para apoyar a las decisiones de negocio.
* **Recuperación del centro de proceso de datos:** Que los sistemas, procesos y datos/información no puedan ser restablecidos después de una interrupción del servicio de manera oportuna para las necesidades del negocio.

También hace referencia a la transferencia de conocimiento, seguridad lógica, administración de la seguridad (que no se dé la perdida de información ni el mal uso de este), administración de bases de datos.

## Riesgos de Externalización de Servicios

Generar e implementar una metodología de análisis de riesgos que permita evaluar los procesos y recursos, su vulnerabilidad y las amenazas para el proceso que la organización externaliza (digamos proveedores), se evalúa la dependencia con este.

Integrar el tema de que el **proveedor** puede reducir su exposición al riesgo y que estos también aplican su propia metodología de análisis de riesgos.

![[Mapa de Ideas de Riesgo de Informatica.png]]

## Otros Aspectos a Considerar

La gestión de riesgos debe considerar los siguientes aspectos

* Identificación del Sistema o Proceso.
* Identificación de las Amenazas.
* Identificación de las Vulnerabilidades.
* Controles (cuáles, tipo, medición de efectividad y seguimiento).
* Determinar la Probabilidad de ocurrencia.
* Análisis de Impacto.
* Determinación del Riesgo.
* Recomendación de Controles.
* Documentar los Resultados, **esto es lo más difícil.**

### Encriptación de Datos

Tecnología que asegura la transmisión segura de información, utiliza una llave pública para codificar los datos, y una llave privada para des-encriptar datos.

### Aspectos a Considerar en la Seguridad de Información.

* **Desde el Punto de Vista de Servidores**
  * Pruebas de penetración, estrés y extracción de datos.
  * Antivirus instalado y actualizado en los servidores que darán servicio.
  * Obsolescencia tecnológica.
  * Parches de seguridad evaluados e instalados según corresponda en los servidores que darán el servicio.
* **Transferencia de la Información.**
  * Encriptación de la comunicación entre la organización y la empresa prestadora de servicios.
* **Continuidad Operacional.**
  * Servidores de Respaldo
    * Sitio de respaldo.
    * Tecnologías de respaldo, digamos en espejo sincrónico.
    * Pruebas de contingencia.
    * Máquina especializada de respaldo.
    * Continuidad geográfica.