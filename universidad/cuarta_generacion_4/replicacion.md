<!-- LTeX: language=es -->

# Replicación

> La replicación es el proceso de copiar y mantener objetos de esquema en múltiples bases de datos, que componen a un sistema distribuido

Acá es posible replicar solo partes de un esquema para ahorrar recursos tanto de almacenamiento y de red, la replicación mejora el rendimiento y proteger la disponibilidad de los datos.

## Tipos de Réplicas

Vamos a encontrar 2 tipos de réplicas:

* Replicación Básica.
* Replicación Avanzada.

### Replicación Básica

En este tipo proporciona acceso de solo lectura sobre un sitio primario, a este sitio le llamaremos `Master Site`, en este sitio tomamos una "foto" de la por replicar tabla, pero esta copia es únicamente de lectura.

* Soporta solo operaciones de **lectura** sobre los datos replicados originarios del sitio maestro.
* Es una opción ideal para datos históricos y de `data-ware house`.
* Se utilizan `snapshots`
    * Las vistas materializadas son una mejora sobre los `snapshots` regulares.

![Replica Básica de Oracle](https://i.imgur.com/vIahnav.png)

Acá en operaciones de lectura el cliente utilizara la réplica, pero una operación de escritura utilizara a la tabla maestra. Este tipo de réplica suele ser utilizado en tablas ``snapshot``, de las cuales encontramos dos tipos.

¿Cuál diferencia a un `snapshot` de una vista **corriente**?

> La vista como tal no tiene datos, tiene un `query` para obtener sus datos... es un cascarón, por otro lado, el `snapshot` tiene datos que mediante su sentencia extrae los datos y los guardara.
    
#### Tablas `Snapshot`

Esta es una copia local de una tabla local de solo lectura sobre la cual únicamente se pueden realizar operaciones de lectura. Acá el proceso de fondo `JobQueueProcces` se encarga de mantener a este ``snapshot`` actualizado.

![Tabla Snapshot](https://i.imgur.com/2SGIWqS.png)

Acá la sentencia del `snapshot` se encarga de indicar cuáles datos serán duplicados sobre un ``snapshot`` creado. Cuando se hace la construcción de la sentencia del ``snapshot``, no se pueden incluir cláusulas como el `GROUP BY` o `CONECT BY`, uniones, ni funciones de agregación como `COUNT` ni `SUM`.

Podemos crear un ``snapshot`` de la siguiente manera.

```sql
CREATE SNAPSHOT sales.customers AS SELECT * FROM sales.customers@hq.acme.com
```

Acá el `SELECT` indica la ubicación remota a `database link` a otro servidor.

```sql
CREATE SNAPSHOT sales.orders 
AS ( SELECT * FROM sales.orders@hr.acme.com o )
WHERE EXISTS
( 
    SELECT c_id FROM
    sales.orders@hr.acme.com c 
    WHERE o.c_id = c.c_id 
    AND zip = 19555
)
```

Acá `sales.orders@hr.acme.com` es lo que se le conoce como un `dblink`, este nos permite consultar información entre base de datos remoto, estos requieren que modifiquemos el `tnsnames` para que la base de datos sepa hacia cuál IP debe de apuntar al momento de extraer dicha información.

![Oracle DB Link](https://i.imgur.com/pfPAddv.png)

Para refrescar los `snapshots`, nosotros mismos tenemos que indicar como, cuando y donde, para esto tenemos que analizar nuestro caso de uso para definir el tipo ideal de refrescamiento, entonces encontraremos varios tipos de refrescamiento:

##### Refrescamiento Completo

Acá cada vez que se ejecuta un `query`, se traen los datos actualizados del origen del `snapshot` y reemplazara los datos del `snapshot` actual. Este suele ser algo pesado y es ideal para tablas pequeñas.

##### Refrescamiento Rápido

Ideal para tablas muy transaccionales, requiere de un `snapshot log` para identificar los cambios que ocurren en el sitio maestro y que serán aplicados sobre el `snapshot`. Este es más eficiente que el refrescamiento completo, ya que solo se van a propagar los cambios que ha tenido el sitio maestro.

![Refrescamiento Rápido](https://i.imgur.com/JR0ZyDs.png)

### Vistas Materializadas

En este tipo de vista extiende las capacidades sobre los `snapshots`, ya que se pueden incluir operaciones de agrupamiento sobre su sentencia. 

* Este tipo de vista es un segmento que automáticamente se actualiza basado en su consulta sea contra una fuente local o remota.
* Maneja sus propios `logs` para poder establecer los refrescamientos
* En su sentencia se pueden incluir otras tablas, otras vistas u otras vistas materializadas.
* Es un segmento de tabla cuyo contenido se refresca periódicamente basado en una consulta. 
* Se debe contar con el privilegio `CRETE MATERIALIZED VIEW` y `CRETE ANY METERIALIZED VIEW.`
* Incluye en nuevo tipo de refrescamiento adicional a los que ya conocemos.

Para crear esta vista materializada se encuentra  la siguiente sintaxis básica:

```sql
CREATE MATERIALIZED VIEW <view_name>
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE]
ON [COMMIT | DEMAND]
[[ENABLE | DISABLE] QUERY REWRITE]
[ON PREBUILT TALE]
AS SELECT ...;
```

Por ejemplo:

```sql
CREATE MATERIALIZED VIEW emp_aggr_mv
BUILD IMMEDIATE
REFRESH FORCE
ON DEMAND
ENABLE QUERY REWRITE
AS
(
    SELECT deptno, SUM(sal) as sal_by_dept
    FROM emp
    GROUP BY deptno;
)

EXEC DBMS_STATS.gather_table_stats (USER, 'EMP_AGGR_MV');
```

*Nota:* Aca se puede ver que se esta utilizando una clausula de agrupamiento.

Aca encontramos varios parametros opcionales en la consulta:

* `Build Type`:
    * `Immediate`: Se popula los datos de manera inmediata.
    * `Deffered`: Se llenara la vista con datos en el momento que ocurra el primer refrescamiento.
* `Refresh Type`:
    * `Forced`: Se combina al refrescamiento rapido y completo, primero se realiza un refrescamiento rápido, que si en primera instancia no se logra realizar con exito, se usara un refrescamiento completo.
    * Modificador de Refrescamiento:
        * `On Demand`: Se actaliza la vista manualmente o mediante una operacion ya planificada.
        * `On Commit`: Se ejecutara el refrescamiento despues de un `commit` en el sitio principal.

### Replicación Avanzada

En este tipo de replicación se extiendienden las capacidades sobre la replica de los datos, puesto que se permite actualizar la información de los tabla y esto se vera reflejado sobre las tablas replicadas. Aca participan varios procesos que se encargan de asegurar la consistencia de las transacciones en todas las bases de datos que participan en la replicación de los datos.

* Si se actualiza la replica, se actualiza a la tabla principal.
* Si se actualiza la tabla principal, se actulizan las replicas

![Replicación de Datos Avanzada](https://i.imgur.com/kjK3jGu.png)

Aca la tabla replica cuenta con comunicación bi-direccionar con el sitio principal, esto significa que sus modificaciones se veran reflejadas en las replicas. Esto es muy util en casos donde se desea evitar la sobre carga sobre un sitio, donde se puede preparar un sitio replica en una nube para no realizar muchas consultas sobre el sitio principal.

#### Replicación Multimaster

Es un tipo de replicación en donde se pueden tener varios sitios principales, los cuales se comunican para replicar los datos. Entonces todos los sitios operan como maestros que se mantienen sincronizados.

![Multimaster Replication](https://i.imgur.com/iOzKo2N.png)

#### Configuraciones Hibridas

Es posible configurar un sitio maestro que utiliza de sitios secundarios con replicación básica.

Comparado con snapsots, los sitios maestros cuentan con una copia completa de los datos, mientras que el `snapshot` puede contar con partes de la tabla por replicar.

![Configuración Híbrida](https://i.imgur.com/PNTIlIf.png)

### Conflicos en Ambientes Avanzados

En ambientes avanzados es posible toparse conflictos en los datos entre los sitios maestros.

* Conflicos de Llames Primarias: Registros que cuentan con la misma llave primaria.
* Conflicos de Actualización: Entre sitios maestros se pueden dar conflictos entre columnas actualizadas, las cuales deben de resolver.
* Conflictos de Borrado: Ocurren cuando un registro se ve borrado en un sitio, el cual no se ve borrado en otro sitio.

## Consejos y buenas practicas al momento de usar la replicación

Como buenas practicas encontramos los siguientes pasos para utilizar la replicación de forma efectiva.

1. Diseñar el ambiente de replicación básica, concentrese en modelar y diseñar la arquitectura de la replicación.
2. En cada sitio de replicación, crear los esquemas y `database links` para soportar/almacenar las replicas.
3. En el sitio maestro crear el `snapshot log` para que el sitio de replicar pueda replicar los datos.
4. Crear los `snapshot` en el sitio replica.
5. En cada sitio de replica, construir el grupo de refrescammiento.
6. Proporcionar los privilegios necesarios para los usuarios para acceder a las replicas.

Para poner esto en practica, revice la [practica de replicación de datos](practica_replicacion)
