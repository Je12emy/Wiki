# Pistas de Auditoría

Conjunto de documentos, archivos y otros elementos de información que se examinan durante una auditoria.

Se busca poder identificar en un proceso o flujo transaccional todo lo que son **errores, modificaciones, alteraciones que pueda recibir un sistema o BD.**

Estas permiten generar una trazabilidad, para determinar en un contexto de tiempo (fecha y hora) **determinar el origen del error o modificación en tiempo** y que disparo la excepción, modificación o el error junto a que sucedió posterior a esto.

En un motor de BD estas pueden ser habilitadas como tal, en el momento que un dato se vuelve identificador de una transacción se vuelve también una pista de auditoría.

> Se enfoca encontrar exepciónes o erroes, no escencialmente una llave primaria corresponde a una pista de auditoria.

Un ejemplo es un usuario malicioso que mediante un "log" de sus horas de accesos le logro identificar que este estaba utilizando una credencial legítima. Por otro lado se logró evidenciar a que recursos tuvo acceso.

## Propósitos

* **Implosión:** Rastrear a una transacción desde su origen, para obtener su origen, transformación y salida.
* **Explosión:** Reconstruir lo que paso con la transacción u operación en cuanto a la transacción, veámoslo como una auditoria en reversa.

### Implosión

Para lograrlo, se necesita junto a la transacción por capturar los siguientes aspectos:

* **Identificador de origen:** La fuente de la transacción para rastrearla.
* **Identificador del destino:** Permite que el dato alterado por la transacción sea identificado de forma única.

### Explosión

Se necesita tanto el origen y destino, si no un dato adicional que es el **factor del tiempo o cronológico o sea fecha y hora.** Estos permiten que se reconstruya la secuencia cronológica de las operaciones.

## Requisitos

1. Que cualquier transacción puede ser rastreada desde su origen, por medio del proceso que es sometida, hasta su salida (archivos, consultas o informes)
2. Que cada salida se puede seguir hacia atrás, conocido como la auditoria en reversa.
3. Que cualquier transacción *generada automáticamente*, se pueda rastrear hasta el evento que la generó.

*Una pista de auditoria no es siempre de manera correctiva, sino de manera preventiva simultáneamente*

![[Flujo de las Pistas de Auditoria.png]]

## Características

* Complejidad: Varía según el tipo de empresa, actividad principal, proceso a supervisar y de la transacción.
* Posee una secuencia cronológica, acá es necesario revisar que se están registrando las acciones y se están almacenando los datos de forma exitosa.
* Promueve la supervisión interna de la empresa.
* Brinda información necesaria al auditor para emitir su criterio.

## Aplicación

Las aplicaciones deben de contar con el software que suministre los elementos para el diseño de las pistas de auditoria.

Se encuentran 4 aspectos básicos.

* **Generación:** Generarse a partir de cualquier punto en el sistema.
* **Modificación:** Se realiza la transacción y queda un registro del cambio realizado, existen momentos donde las modificaciones serán legítimas.
* **Borrado:** Registra el momento en el que se dio el borrado de un dato.
* **Recuperación:** Obtener acceso a una pista que se haya eliminado mediante una reconstrucción de un registro, basado en un respaldo de la base de datos.

## Evidencias y Objetivos de Protección y Seguridad

A la derecha las pistas nos dejan evidencias sobre cada transacción, donde se busca como objetivo un elemento a la izquierda.

![[Pistas de Auditoria y sus Objetivos.png]]
