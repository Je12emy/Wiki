# Etapas de la Auditoria

## Planificación de la Auditoría

> El primer paso para realizar una auditoria es la planeación, en esta fase se decidica que sector sera auditado, se decide la estrategia a utilizar.

Se define que área por abordar y que estrategia por utilizar, se tiene que considerar las técnicas para poder recolectar la mayor cantidad de información necesaria y disponible.

### Identificación del Perfil de Riesgos

> Proceso que describe un problema y contexto, con el fin de identificar los elementos de peligro o riesgo importante para varias desiciones de gestión de riesgos.

Previamente visto, el [perfil de riesgo](Teoría_de_Riesgos.md) permite determinar cuanto riesgo se tiene en una empresa, cuanto se aceptara y cuanto se aguantara.

Requiere de un proceso de identificación de aspectos de riesgos para establecer prioridad y se determina la política ante como evaluar los riesgos y cuál normal por utilizar en los procesos de evaluación.

Estos son únicos según el contexto de cada negocio, por otro lado se debería de definir un **perfil de riesgo digital** por aparte. Se definen valores como:

* Obsolencia.
* Actualización.
* Normas de seguridad de la información.

Que funcionan para determinar el perfil de riesgo según este entonó.

El perfil no lo define auditoria, tecnología, secretarias, sino **alta administración**, pero estos pueden colaborar y la alta administración lo define según su criterio.

### Evaluaciones de Riesgos (ISO 27001).

* Identificación de los activos.
* Identificación de los requisitos legales y de negocio que son relevantes, que están relacionados con los activos identificados.
* Valoración de los activos identificados, tomando en cuenta los requisitos y su impacto en perdida de confidencialidad, integridad y disponibilidad (Los 3 pilares de la seguridad).
* Identificación de las amenazas y vulnerabilidades a ocurrir.
* Cálculo del riesgo.
* Evaluación del riesgo frente a una escala de riesgos preestablecidos. (Mapas de calor de 3 a 5)

### Identificación de los Controles

Es necesario ver como se atiende al riesgo, se tiene que definir cuál es la acción que se está tomando ante el riesgo y estos tienen que estar alineados conforme al perfil del riesgo. Sobre todo se tiene que ver la efectividad del control.

### Evaluación de la Matriz de Riesgos y Controles

*Se usan herramientas como:*

* **Matriz de Riesgo:** Identificar en donde orientar recursos.
* **Controles:** Analizan el funcionamiento, la efectividad y el cumplimiento de las medidas de protección para determinar y ajustar sus deficiencias.

## Ejecución de la Auditoría

Ejecución de los procedimientos previamente planeados para obtener suficiente evidencia que respalde la elaboración del informe. Se utilizan las pruebas de cumplimiento y las pruebas sustantivas.

Acciones por Ejecutar:

* Conocimiento del área o proceso de negocio.
* Identificación y valoración de riesgos.
* Revisión preliminar del área o proceso (puede ser remoto).
* Evaluación del área o proceso.
* Pruebas de cumplimiento.
* Pruebas Sustantivas.
* Reporte y Seguimiento.

Acá entra el juego el  [Ciclo de Vida de la Auditoria de Sistemas](Ciclo_de_Vida_de_la_Auditoria_de_Sistemas.md) que habla sobre la ejecución.

Dentro de la ejecución de la auditoria se encuentran las siguientes etapas:

### Planeación

Se define a **que áreas se llegara a validar en un estudio** y por aplicar un análisis detallado; por lo general la auditoria se basa en procesos críticos como el respaldo, continuidad y cyber resiliencia.

Acá se definen:

* Objetivos.
* Alcance.
* Recursos.
* Metodología.
* Duración: Tiempo para hacer el informe.
* Plan de Trabajo.
* Análisis de inconformidades.

### Revisión y Evaluación

Consisten en la realización de\*\* pruebas de cumplimiento, pruebas\*\*, valoración de aplicaciones, procesos históricos, documentación, pistas de auditoria, archivos, flujos de proceso.

Se evalúan:

* Sistemas.
* Etapas (Ciclo de vida)
* Lecciones Aprendidas
* Aplicaciones.
* Control de cambios.
* Integración.
* Inversión.

### Puntos de Control

Busca valorar las funciones y accionar del área o proceso de estudio, permitiendo varificar la conformidad o disconformidad. Tiene las siguientes clasificaciones:

* Preventivo.
* Detectivo.
* Correctivo.

*Nota:*  Recordemos que ** Punto de control == Acción Mitigadora**.
*Nota:*  Integrar == Correctivo.

### Pruebas en la Ejecución de la Auditoria

* **Pruebas de Cumplimiento:** Se asegura el cumplimiento del\*\* marco normativo, legal o de negocio\*\* que debe de ser acotado o adaptado.

  Por ejemplo un banco sigue la SUGEF14-17
* **Pruebas Sustantivas:** Es con respecto a transacciones, digamos la integridad de las transacciones individuales.

  Por ejemplo una aplicación de intereses, donde el cálculo de este se realiza de forma correcta.

### Comunicación de Resultados

Confeccionamiento de un informe, que es enviado por primera vez en carácter de borrador para ser presentado y analizado con los responsables del área para evaluar su contenido. Cuando este es entregado, sigue el seguimiento de las recomendaciones.

> La idea de ser presentado en borrador es que se pueda discutir con el dueño del proceso, para evaluar si esta de acuerdo o si hay un hecho que deberia ser alterado.

Características:

* Objetivo.
* Preciso.
* Oportuno.
* Conciso.
* Completo.

Cuando se presenta el informe, se da un seguimiento del cumplimiento de las recomendaciones.

### Reporte de la Auditoria

Un reporte puede ser uno de los siguientes 9:

* Modelación.
* Monitoreo Continuo.
* Relación de Hechos.
* Denuncia Penal.
* Asesorías.
* **Fiscalización.**
* Advertencia.
* Asignaciones Especiales.
* Relación de Hechos.

*Nota:* Así como no es posible indicar el como hacer en un proceso mitigador, en los informes de auditoria dentro de las recomendaciones no se puede indicar como hacer.

*Nota;* no existe un formato estándar en un informe de auditoria, existen algunas empresas que establecen papeles de trabajo estandarizados.

### Seguimiento

Darle el seguimiento adecuado a las no conformidades, para determinar si las recomendaciones se han visto cumplidas, asegurado el cumplimiento de los resultados deseados en el tiempo establecido.

* Seguimiento a recomendaciones.
* Actualizaciones periódicas de parte del área de auditoria:
  * Atención de plazos.
  * Acciones mitigadoras implementadas y pendientes.
  * Eventuales cambios a los planes de tratamiento (previa justificación).
  * Gestión del status de las recomendaciones.
* Análisis de las respuestas e implementación de acciones mitigadoras.
* Informar a la alta administración sobre la situación de las respuestas a las recomendaciones realizadas.

Si no se da el cumplimiento se da un informe advertencia y si no se da el incumplimiento se eleva a la *alta administración*

Se encuentran los siguientes **tipos de seguimiento**.

* Externo
  * **Se realiza ante el proceso de la empresa**, se evalúan los controles mitigadores y acciones derivadas (plan de remedición) de las oportunidades de mejora halladas.
  * Evaluación de controles y acciones a implementar.
  * Seguimiento periódico en atención a los plazos y avances.
  * Control de pendientes y avances de los ejecutivos, ver el cumplimiento de las recomendaciones según el progreso del tiempo.
  * **Informe de atención de acciones correctivas.**
* Interno
  * Calidad en la programación de la auditoria, que esta fue la adecuada y contó con todos los procesos necesarios.
  * Obtención de evidencia y análisis de los resultados.
  * Análisis de los hallazgos y recomendaciones.
  * Propuesta de las unidades operativas sobre observaciones y recomendaciones, asiste a entender las recomendaciones.
  * Control de plazos y avances, que se estén dando a lo interno.
  * Retroalimentación de las unidades organizacionales, consultas, criterios realizados para la unidad de auditoría.

# Roles y Alcances de la Auditoria en Sistemas

* Revisión de procesos automatizados y licenciados.
* Actualización y aprovechamiento de los equipos de computación.
* Toma de decisiones por parte de los sistemas de información.
* Trámites internos.
* Adecuado manejo ambiental: Zonas sísmicas o expuestas a inundaciones.
* Software actualizado y equipos modernos.
* Existencia de backup de sobre la información clave.
* Apropiado mantenimiento de los equipos.
* Utilización de los equipos en labores propias del objetivo de la organización.
* Existencia de claves de acceso sobre archivos reservados de la organización.
* Existencia de manuales de procesos y fuentes de información.