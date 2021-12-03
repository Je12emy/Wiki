# Manejo de Recursos

Hablaremos de manejo de recursos a nivel de procesamiento para así dar una mejor distribución de los mismos, un DBA debe de garantizar a grupos de usuario un monto mínimo de recursos de procesamiento. Acá entonces se agrupan a usuarios en grupos específicos con recursos asignados, esto se hace mediante porcentajes, cantidad de intentos, cantidad de sesiones, limitar el grado de paralelismo (evitar que un usuario haga mucho al mismo tiempo)

Entonces el DBA hace uso de los siguientes componentes para implementar control sobre los recursos.

-   `Resource Consumer Groups`: Aquellas personas que perteneces a un grupo, con características particulares y similares.
-   `Resource Plans`
-   `Resource Allocation Methods`
-   `Resource Plan Directives`: Indica como llevar a cabo la alocalización.

## Resource Consumer Groups

Proporciona un método de particionamiento de recursos entre diferentes usuarios o grupos del mismo, también especifica como se dará la distribución de los recursos.

> Un grupo de consumidores es un grupo de sesiones que se agrupan según un conjunto de características similares en el uso de recursos.

El paquete `DBA_RSRC_CONSUMER_GROUPS` proporciona información sobre lo siguiente:

-   Como se llama el grupo de consumidor, aunque no asignamos a un usuario, este siempre es asignado a un grupo predeterminado.
-   Método de asignación de recursos, ej. `Round Robin`
-   Comentarios.
-   Estado.

## Planes de Recursos

Los grupos de consumidores cuentan con planes, que son un conjunto de directivas que especifican como es que los recursos serán asignados a cada grupo de consumidores, pueden ser visto como _contenedores de directivas_ y se pueden usar para:

-   Realizar o asignar grupos o planes juntos.
-   Particionar recursos alrededor de los grupos o planes.
-   Especificar un metodo de alocalización de recursos para un grupo.

Buscan darle o garantizarle a una sesión un porcentaje mínimo de recursos o incluso máximo de recursos para que haga sus labores, como ya se dijo, se trabajan con porcentajes sobre los recursos. Por otro lado es posible limitar la cantidad de sesiones que puede abrir un usuario, para evitar que este se aproveche de esto o incluso remover usuarios que se encuentren inactivos. Es posible que un plan cuente con sub planes, los cuales hacen uso del porcentaje asignado a estos ej. un sub plan distribuye el porcentaje de %60 entre dos grupos.

![Plan de Recursos DAYTIME](https://th.bing.com/th/id/OIP.bZvIZYYZdUtAK7d7lYOJ9AHaEW?pid=ImgDet&rs=1)

Acá ocurre lo siguiente:

-   Se crea a un plan llamado `DAYTIME`.
-   El plan `DAYTIME` cuenta con 3 directivas que especifican los porcentajes de recursos utilizados.
    -   La primera directiva distribuye 75% de recursos del CPU.
    -   La segunda directiva distribuye un 15% de recursos del CPU.
    -   La tercera directiva distribuye un 10% de recursos del CPU.
-   Cada directiva se encuentra asignada a un grupo de usuarios.
    -   La primera directiva esta asignada al grupo `OLTP`.
    -   La segunda directiva esta asignada al grupo `REPORTING`.
    -   La tercera directiva esta asignada al grupo `OTHER_GROUPS`.

El siguiente plan sigue el mismo concepto, pero los sub planes distribuyen los recursos distribuidos por directrices, entonces el sub plan `SALES_TEAM` distribuye un 60% en 50% para dos grupos.

![Plan de Recursos GREAT_BREAD](https://th.bing.com/th/id/R.f4e5854a19a6720c51d01c1da6a26b75?rik=AVgwm4cAEJN3HQ&pid=ImgRaw&r=0)

## Prioridad de Recursos de CPU

Los recursos de CPU son priorizados según el nivel de cada plan, donde entre más bajo sea el nivel, se usaran recursos libres o no utilizados de los niveles más altos. Por ejemplo el grupo de consumidores a nivel 2, usaran recursos que no fueron utilizados por aquellos de un grupo a nivel 1, para un grupo nivel 3, se usarían los recursos restantes de grupos nivel 1 y 2.

## En Practica

Para crear un simple plan usamos la siguiente sentencia.

```sql
DBMS_RESOURCE_MANAGER.CREATE_SIMPLE_PLAN(
    SIMPLE_PLAN => 'simple_plan1',
    CONSUMER_GROUP2 => 'my_group1', GROUP1_PERCENT => 80,
    CONSUMER_GROUP2 => 'my_group2', GROUP2_PERCENT => 20
);
```

Se obtiene entonces la siguiente matriz.

| Consumer Group | Level 1 | Level 2 | Level 3 |
| -------------- | ------- | ------- | ------- |
| SYS_GROUP      | 100%    |         |         |
| mygroup1       |         | 80%     |         |
| mygroup2       |         | 20%     |         |
| other_groups   |         |         | 100%    |

Observaciones:

-   Siempre esta presente el grupo `SYS_GROUP`, que contara con un 100% de recursos a nivel 1.
-   Acá se están creando dos grupos, que por predeterminado quedan en nivel 2.

Para crear un grupo de consumidores usamos el siguiente comando.

```sql
DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP (
    CONSUMER_GROUP => 'OLTP',
    COMMENT => 'OLTP Applications'
);
```

Para asignar un usuario a un grupo se usa el comando `CREATE USER`, entonces igualmente seria posible usar el comando `ALTER USER` para moverlo de grupo. Para crear un plan con más parametros de configuración se usa el siguiente comando.

```sql
DBA_RESOURCE_MANAGER.CREATE_PLAN(
    PLAN => 'DAYTIME',
    COMMENT => 'More sources for OLTP applications'
);
```

Con el siguiente comando se crea una directiva, para ya definir los porcentajes de recursos asignados.

```sql
DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTUVE(
    PLAN => 'DAYTIME',
    GROUP_OR_SUBPLAN => 'OLT',
    COMMENT => 'Plan for OLTP Group',
    MGMT_P1 => 75
);


DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTUVE(
    PLAN => 'DAYTIME',
    GROUP_OR_SUBPLAN => 'REPORTING',
    COMMENT => 'Plan for REPORTING Group',
    MGMT_P1 => 15,
    PARALLEL_DEGREE_LIMIT_P1 => 8, -- Se cuantos procesos simultáneos se pueden ejecutar
    ACTIVE_SESS_POOL_P1 => 4 -- Se indica cuantas sesiones se pueden abrir
);

DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTUVE(
    PLAN => 'DAYTIME',
    GROUP_OR_SUBPLAN => 'OTHER_GROUPS',
    COMMENT => 'Plan for OTHER_GROUPS Group',
    MGMT_P1 => 10
);
```

_Nota_: Un plan no debería tener el mismo nombre que un grupo.

Por otro lado, es posible mapear a un usuario temporalmente a un grupo, aca se re direcciona al usuario `SCOTT` al grupo `DEV_GROUP`. En este ejemplo se mapea según el usuario de Oracle, pero es posible mapear según parámetros como el nombre de usuario de SO, nombre del programa (ej Toad, PLSQL), nombre de la maquina, etc.

```sql
DBMS_RESOURCE_MANAGER.SET_CONSUMER_GROUP_MAPPING (
    DBMS_RESOURCE_MANAGER.ORACLE_USER, 'SCOTT', 'DEV_GROUP'
);
```

Acá se mueve a una sesión especifica a un grupo, esto se logra mediante el sid y serial.

```sql
DBMS_RESOUCE_MANAGER.SWITCH_CONSUMER_GROUP_FOR_SESS ('17', '12345', 'HIGH_PRIORITY');
```

Acá se mueven todas las sesiones de un usuario hacia un grupo especifico.

```sql
DBMS_RESOUCE_MANGER.SWITCH_CONSUMER_GROUP_FOR_USER ('HR', 'LOW_GROUP');
```

Con la función `REVOKE_SWITCH_CONSUMER_GROUP` es posible revertir este ultimo comando.

## Grupos

Encontraremos unos cuantos grupos ya existentes.

-   `OTHER_GROUPS` que aplica para todas las sesiones que no aplican para un plan.
-   `DEFAULT_CONSUMER_GROUP` que aplica para todas las sesiones que no forman parte explícitamente de un plan.
-   `SYS_GROUP`
-   `LOW_GROUP`
-   `DBA_RSRC_PLANS`

Para listar los grupos contamos con la vista `v$rsrc_consumer_group`.

```sql
SELECT name, consumed_cpu_time FROM v$rsrc_consumer_group ORDER BY name;
```
También encontramos la vista `dba_rsrc_plan_directives` para obtener información sobre como están agrupadas las directivas y sus niveles.

```sql
SELECT plan, group_or_subplan, cpu_p1, cpu_p2, cpu_p3, cpu_p4
FROM dba_rsrc_plan_directives
WHERE plan = DECODE( UPPER('&1'),'ALL', plan, UPPER('&1'))
ORDER BY 
plan, cpu_p1 DESC,
cpu_p2 DESC, 
cpu_p3 DESC;
```

## Perfiles

Los recursos son un conjunto de características de acceso que agrupamos y asignamos a los usuarios, encontramos dos tipos de controles sobre recursos y sobre contraseñas. 

Controles sobre recursos pueden ser sobre sesiones por usuario, CPU por usuario, tiempo de inactividad, tiempo de conexión máximo, etc. Los parámetros de contraseña pueden especificar la cantidad máxima de fallos, tiempo de vida de la contraseña, cuantas veces puede reutilizar una contraseña, por cuanto tiempo se bloquea el ingreso por fallas, incluso se puede alterar las contraseñas aceptables para el perfil.

El parámetro `RESOURCE_LIMIT` tiene que ser verdadero para que todos estos controles de recursos entren en funcionamiento.

```sql
CREATE PROFIEL app_user2
LIMIT FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LIFE_TIME 60
PASSWORD_REUSE_TIME 60
PASSWORD_REUSE_MAX 5
PASWWORD_VERIFY_FUNCTION verify_function
PASSWORD_LOCK_TIME 1/24
PASSWORD_GRACE_TIME 10;
```
