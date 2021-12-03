# Tablas Cluster

Un cluster es un grupo de tablas que comparten el mismo **grupo de bloques de datos**, puesto que comparten columnas que son usadas usualmente juntas (las tablas). Es un método optimo de almacenamiento por que no se tienen bloques distintos almacenando la misma información. Es ejemplo sencillo serian dos tablas `employees` y `departments` que comparten el campo `department_id`.

`Clustering` es un método para eliminar relaciones intermedias y ahorrar almacenamiento, al mismo tiempo incrementando el rendimiento de una consulta donde no se deben leer `n` bloques, sino un solo bloque compartido. Un `Cluster Key` es la llave que nos permite hacer la unión entre las tablas y que usualmente es aquella usada para hacer una unión normal.

El hecho de que las tablas se encuentren clusterizadas, no afecta la lectura independiente de cada una. Es simplemente un método de tunear y reducir la contención al momento de realizar lecturas.

## Ventajas

Se logra lo siguiente por implementar esta técnica:

-   Reduce el tiempo de acceso, o sea se mejora el rendimiento
-   Se consume menos almacenamiento.
-   Se reduce la lectura a disco.
-   Reduce la contención

## Casos de Uso

Existen consideraciones cuando se debería o no implementar esta técnica.

### ¿Cuando Usar Tablas Cluster?

Hay que analizar si las tablas son usadas juntas, sino se estará desperdiciando esta funcionalidad. Un caso común es cuando se cuenta con una tabla de encabezado y una tabla de detalle ej. factura y detalle, en donde usar este método puede ser muy útil.

### ¿Cuando No Utilizar Tablas Cluster?

-   No se debería de utilizar cuando los `Cluster Key` son campos a los cuales les aplicamos actualizaciones frecuentemente.
-   Igualmente si los datos usados por el `Cluster Key` se encuentra compuesta por mas de dos bloques, que entonces es un valor muy grande.
-   Si frecuentemente se hace un `Full Table Scan` en donde se leen muchos datos

## El Cluster Key

Esta es la columna que se utiliza en común entre las tablas, cada valor en el `Cluster Key` se guarda **una sola vez** sin importar cuantos registros o tablas diferentes contengan el valor.

## Creando un Cluster

Primero se debe de contar con el privilegio `CREATE CLUSTER` o `CREATE ANY CLUSTER` como requerimiento.

```sql
CREATE CLUSTER orders (order_id NUMBER(x)) SIZE 512k; -- Creación del cluster, pero sin tablas asociadas.

CREATE TABLE order_header
(
    order_id NUMBER,
    customer_number NUMBER
)
CLUSTER orders (order_id); -- Se crea un tabla encabezado y se asocia el cluster

CREATE TABLE order_detail
(
    order_id NUMBER,
    detail_line VARCHAR2(100)
)
CLUSER orders(order_id); -- Se crea la tabla detalle y se asocia al cluster
```

Siguiente se debe de crear el indice al cluster, básicamente el `Cluster Key`

```sql
CREATE INDEX IDX_ORDER_ID ON CLUSTER order;
```

El `SELECT` entonces es bastante sencillo, ya que es el mismo, no se realiza hacia el `cluster` sino hacia las tablas que se encuentran asociadas hacia este.

También es posible crear tablas cluster desde tablas ya existentes.

```sql
CREATE CLUSTER personel (department_id NUMBER);

CREATE TABLE dept_10
CLUSTER personel (department_id)
AS (SELECT * FROM employees WHERE department_id = 10);

CREATE TABLE dept_20
CLUSTER personel (department_id)
AS (SELECT * FROM employees WHERE department_id = 20);

CREATE INDEX idx_department_id ON CLUSTER personel;
```

## Consideraciones Adicionales

-   No es necesario crear un `FOREIGN KEY CONSTRAINT` entre tablas cluster.
-   Si se borra un `CLUSTER INDEX` no sera posible acceder información en el cluster.
-   Los tipos de datos más apropiados para implementar tablas cluster son aquellos con una relación encabezado - detalle y datos leídos usualmente con un valor común.

## Vistas Útiles

- [DBA_CLUSTERS](https://docs.oracle.com/cd/B19306_01/server.102/b14237/statviews_1029.htm#i1575202)
- [DBA_CLU_COLUMNS](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/refrn/DBA_CLU_COLUMNS.html#GUID-844ADF06-067C-47E4-AD9E-54A88FDC6FF2)
- [DBA_CLUSTER_HASH_EXPRESSIONS](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/refrn/ALL_CLUSTER_HASH_EXPRESSIONS.html#GUID-CED13490-D1C9-42FD-99D2-B695BAFED0F6)
- [DBA_ALL_TABLES](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/refrn/ALL_TABLES.html#GUID-6823CD28-0681-468E-950B-966C6F71325D)

## Practica

1. Asociar tablas a un cluster `emp_dept_cluster`
2. Almacenamiento inicial de 200k y next de 300k.
3. Tamaño del cluster de 600.
4. Cluster index llamado `emp_dept_index`.
5. Hacer consulta a `dba_cluster` para revisar información.
6. Hacer consulta `dba_clu_columns` para revisar las columnas del cluster.
    - Nombre del cluster
    - Nombre de la columna
    - Nombre de la columna en la tabla.

```sql
-- Crear el cluster
CREATE CLUSTER emp_dept_cluster
(
    deptno NUMBER (2)
)
SIZE 600 STORAGE (
    INITIAL 200k
    NEXT 300K
);

-- Crear el indice del cluster
CREATE INDEX emp_dept_index ON CLUSTER emp_dept_cluster;

-- Crear tablas y asociarlas al cluster
CREATE TABLE scott_emp CLUSTER emp_dept_cluster (deptno) AS (SELECT * FROM scott.emp);
CREATE TABLE scott_dept CLUSTER emp_dept_cluster (deptno) AS (SELECT * FROM scott.dept);

-- Consultar vistas
-- DBA CLUSTERS
SELECT owner, cluster_name FROM dba_clusters WHERE cluster_name = 'EMP_DEPT_CLUSTER';

OWNER                          CLUSTER_NAME
------------------------------ ------------------------------
SYS                            EMP_DEPT_CLUSTER
-- DBA_CLU_COLUMNS
SELECT cluster_name, clu_column_name, table_name, tab_column_name FROM dba_clu_columns WHERE cluster_name = 'EMP_DEPT_CLUSTER';

CLUSTER_NAME         CLU_COLUMN_NAME TABLE_NAME           TAB_COLUMN_NAME
-------------------- --------------- -------------------- ---------------
EMP_DEPT_CLUSTER     DEPTNO          SCOTT_EMP            DEPTNO
EMP_DEPT_CLUSTER     DEPTNO          SCOTT_DEPT           DEPTNO
```
