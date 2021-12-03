[#](#) Continuidad de la Operación

Incluye garantizar que una organización conozca sus proseos, datos, información, impacto y probabilidad sobre cortes sobre la operación, entran muchos tipos de riesgos como riesgos de liquidez, imagen y tecnológicos.

No solamente incluye que exista un plan de contingencia, que esté completo y actualizado, donde el plan aparte de estar funcional, se tiene que asegurar contar con una visión amplia de toda la empresa y entender que es crítico y que no para generar continuidad dentro de los procesos de negocio.

No se basa en solo generar el plan, políticas, procedimientos, etc., sino que también tiene de forma inmersa dentro de sus elementos todo lo que son las pruebas de estrés y continuidad para evaluar que todo se encuentra operacional e idóneo ante los cortes.

Elementos a considerar:

* Copias actualizadas.
* Criticidad de las aplicaciones: Procesos críticos, aplicaciones e información, incluso la obsolescencia tecnológica.
* Entornos distribuidos.
* Definición de los procesos.

Como identificar a criticidad

* Se identifica el proceso
* Se identifica el software que sustenta a ese proceso o
* Se identifica sistema/equipo asociada
* Recurso humano que sustenta.

## Términos a Considerar

* **Plan de Continuidad de Negocio (BCP):** Plan logístico para la práctica de como la organización debe de recuperarse, sus funciones críticas o totalmente interrumpidas. Un BCP tiene que contribuir a continuar con las operaciones, no necesariamente es el 100% donde se trabaja de forma parcial y no se tiene que garantizar volver a la normalidad en su totalidad y es posible trabajar de forma parcial sobre la continuidad digamos que no todos pueden trabajar durante una caída.
* **Análisis de Impacto del Negocio (BIA):** Se analizan todas las operaciones para estudiar todos los procesos que existen para centrarse en el "core" del negocio (en el banco los cajeros automáticos, apps de movilización del dinero son procesos de negocio que se tienen que validar vs. la realidad de tecnología) y que puede pasar si uno de estos llega a caer.
* **Centro de Operaciones Alterna (COA):** Corresponde a un "espejo" del DC principal, donde los servidores sigan una metodología en espejo de forma sincrónica. Que la caída no se llegue a sentir o a lo máximo 2 - 3 segundos.
* **Plan de Recuperación ante Desastres (DRP):** Plan de recuperación que incluye/cubre toda la data, información, software y hardware que permite volver a iniciar todas las operaciones en el caso de que haya un incidente de seguridad, interrupción o desastre natural. Muchas veces es necesario leer el entorno y sus amenazas.
* **Análisis de Riesgos (RA):** Se definen los eventos que pueden provocar una interrupción él en negocio, va de la mano con el BIA.
* **Tiempo Objetivo de Recuperación(RTO):** Plazo marcado para la reanudación de las operaciones. Tiempo limité para levantar todo
* **Punto Objetivo de Recuperación (RPO):** Perdida de datos permitida en función de tiempo, cuanto en tiempo establecido o permitido de caída del servicio y perdida de datos según el último backup.

  *Nota:* Estos dos últimos son en el ámbito de negocio.

## Elementos a Considerar.

* Aplicativo.
* RTO.
* TPO.
* Acuerdos de Servicio (SLA): Se define acuerdos de servicios con otras empresas.
  * Tiempo de Atención: Tiempo para llegar a atender un incidente.
  * Tiempo de Diagnóstico: Tiempo para llegar a definir un diagnóstico del problema
  * Tiempo de Solución: Tiempo para reparar o solucionar el problema, un caso problemático es la falta de un recurso para solucionar un problema.

  Si no se cumplen estos, se generan multas (escalonadas) según el tiempo que se ha incumplido cada acuerdo.
* Tipo de Recuperación Actual:
  * Continuidad Geográfica.
  * Recuperación Local.
  * No existe.

## Objetivo del Plan de Recuperación ante Desastres

Diseñado para minimizar el efecto de un desastre, asegurando la restauración de procedimientos esenciales dentro de los RTO establecidos por el BIA.

Según el BIA se clasifican las aplicaciones por su tiempo requerido de recuperación.

Procedimientos de Recuperación ante desastre.

* Automática.
* Semi automática.
* Manual

## Porcentaje de Disponibilidad de Servicios de TI

Tabla de referencia para definir el tiempo que se espera llegar en caída, las grandes empresas suelen estar entre los 4 y 5. Se vuelve importante en el escenario de la contratación como tal de proveedores de servicios.

![Tabla de Disponibilidad](https://i.pinimg.com/originals/8b/64/ea/8b64ea1bac7134918fb48102540d71df.jpg)
