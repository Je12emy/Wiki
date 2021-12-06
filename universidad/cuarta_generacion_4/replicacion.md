# Replicación

> Replicación es el proceso de copiar y mantener objetos de esquema en multiples bases de datos, que componen a un sistema distribuido

Aca es posible replicar solo partes de un esquema para ahorrar recursos tanto de almacenamiento y de red. La replicación puede mejorar el rendimiento y a proteger los datos.

## Tipos de Replicas

Vamos a encontrar 2 tipos de replicas:

* Replicación Básica.
* Replicación Avanzada.

### Replicación Básica

Se proporciona acceso de solo lectura sobre un sitio primario, a este sitio le llamaremos "Master Site", en este sitio tomamos una "foto" de la tabla que no permitira que el cliente modifique su contenido.

* Soporta solo operaciones de **lectura** sobre los datos replicados originarios del sitio maestro.
* Es una opción ideal para datos historicos y de data-ware house.
* Se utilizan "snapshots"
    * Las vistas materializadas son una mejora sobre los snapshots regulares.

#### Tablas Snapshot

Esta es una copia local de una tabla local sobre la cual unicamente se pueden realizar operaciones de lectura. Aca el proceso de fondo `JobQueueProcces` se encarga de mantener a este snapshot actualizado.

Aca el query de snapshot se encarga de indicar cuales datos seran duplicados sobre un snapshot creado. Cuando se hace la construcción de la sentencia del snapshot, no se deberian incluir clausuas como el `GROUP BY` o `CONECT BY`, uniones, ni funciones de agregación como `COUNT` ni `SUM`.

Podemos crear un snapshot de la siguiente manera.

```sql
CREATE SNAPSHOT sales.customers AS SELECT * FROM sales.customers@hq.acme.com
```

Aca el `SELECT` indica la ubicación remota a `database link` a otro servidor.

```sql
CREATE SNAPSHOT sales.orders 
AS (SELECT * FROM sales.orders@hr.acme.com o)
WHERE EXISTS
(SELECT c_id FROM
sales.orders@hr.acme.com c WHERE o.c_id = c.c_id AND zip = 19555)
```

Para refrescar los snapshots, nosotros mismos tenemos que indicar como, cuando y donde, para esto tenemos que analizar nuestro caso de uso para definir el tipo ideal de refrescamiento.

##### Refrescamiento Completo

Aca cade vez que se ejecuta un query, se traen los datos actualizados del origen del snapshot y reemplazara los datos del snapshot actual. Este suele ser algo pesado y es ideal para tablas pequeñas.

##### Refrescamiento Rápido

Ideal para tablas muy transaccionales, requiere de un `snapshot log` para identificar los cambios que ocurren en el sitio maestro y que seran aplicados sobre el snapshot. Este es más eficiente que el refrescamiento completo ya que solo va a propagar los cambios que ha tenido el sitio maestro.

#### Vistas Meterializadas

En este tipo de vista se extienden las capacidades sobre los snapshots, se pueden incluir operaciones de agrupamiento sobre su sentencia. Este tipo de vista es un segmento que automaticamente se actualiza basado en su consulta, sea contra una fuente local o remota.

Requerimientos.

* Se debe contar con el privilegio `CRETE MATERIALIZED VIEW` y `CRETE ANY METERIALIZED VIEW.`

Para crear esta vista materializada se encuentra  la siguiente sintaxis básica

```sql
CREATE MATERIALIZED VIEW <view_name>
BUILD [IMMEDIATE | DEFERRED]
REFRESH [FAST | COMPLETE | FORCE]
ON [COMMIT | DEMAND]
AS SELECT ...;
```

Por ejemplo se obtiene el siguiente ejemplo.

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

Aca encontramos varias opciones.

* Build Type:
    * Immediate: Se popula los datos de manera inmediata.
    * Deffered: Se llenara la vista con datos en el momento que ocurra el primer refrescamiento.
* Refrescamiento:
    * Forzado: Se combina al refrescamiento rapido y completo, primero se realiza un refrescamiento rápido que si en primera instancia no se logra realizar con exito, se usara un refrescamiento completo.
* Modificador de Refrescamiento:
    * Demand: Se actaliza la vista manualmente o mediante una operacion ya planificada.
    * Commit: Se ejecutara el refrescamiento despues de un commit en el sitio maestro.

### Replicación Avanzada

Se extiendienden las capacidades sobre la replica de los datos, aca se permite actualizar la información de los tabla y esto se vera reflejado sobre las tablas replicadas. Aca participan varios procesos que se encargan de asegurar la consistencia de las transacciones en todas las bases de datos que participan en la replicación de los datos.

#### Replicación Multimaster

Es un tipo de replicación en donde se pueden tener varios sitios principales, los cuales se comunican para replicar los datos. Entonces todos los sitios operan como maestros que se mantienen sincronizados.

#### Configuraciones Hibridas

Es posible configurar un sitio maestro que utiliza de sitios secundarios con replicación básica.

Diferencias contra replicas básicas

* Comparado con snapsots, los sitios maestros cuentan con una copia completa de los datos, mientras que el snapshot puede contar con partes de la tabla por replicar.

#### Conflicos

#### Conflicos de Llames Primarias

Registros que cuentan con la misma llave primaria.

##### Conflicos de Actualización

Entre sitios maestros se pueden dar conflictos entre columnas actualizadas, las cuales deben de resolver.

##### Conflictos de Borrado

Ocurren cuando un registro se ve borrado en un sitio, el cual no se ve borrado en otro sitio.

## Utilizando la Replicación

Como buenas practicas encontramos los siguientes pasos para utilizar la replicación de forma efectiva.

1. Diseñar el ambiente de replicación básica, concentrese en modelar y diseñar la arquitectura de la replicación.
2. En cada sitio de replicación, crear los esquemas y `database links` para soportar/almacenar las replicas.
3. En el sitio maestro crear el `snapshot log` para que el sitio de replicar pueda replicar los datos.
4. Crear los snapshots en el sitio replica.
5. En cada sitio de replica, construir el grupo de refrescammiento.
6. Proporcionar los privilegios necesarios para los usuarios para acceder a las replicas.


- [ ] Replicar de HR empleados y departamentos cada 2 minutos
