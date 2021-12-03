# Segments

Recordemos que los segmentos corresponden a agrupaciones de extensiones y todos los datos de la base de datos están almacenados en segmentos. Cuando trabajamos con segmentos, encontraremos 4 tipos de segmentos:

* **Datos:** Que guardan tablas.
* **Indices:** Almacenan los índices.
* **Rollback:** Almacena la información necesaria para deshacer transacciones
* **Temporales:** Realizar operaciones que no caben en memoria, como por ejemplo ordenamiento y agrupación.

Cuando se hace la asignación del manejo del tablespace podemos definir la forma en como empezar a almacenar la información, esto puede generar extensiones grandes o extensiones pequeñas:

**Ventajas de Extensiones Grandes**

* Evita extensiones dinámicas, o sea no tener tamaños variables.
* Pequeñas ventajas de rendimiento, si se define un tamaño correcto en la extensión al momento de grabar datos se estará grabando en una única extensión y no se estarán encadenando múltiples extensiones.

**Desventajas de Extensiones Grandes**

* Encontrar espacio libre en las extensiones o sea fragmentación.
* Desperdicio de espacio inicialmente.

## Fragmentación

Cuando un tablespace se encuentra fragmentado, puede contar con mucho espacio libre, pero este puede encontrarse en porciones tan pequeñas que Oracle no puede usarlas (Puesto que el tamaño de la extensión no es suficiente para insertar datos).

Cuando un objeto necesita una extensión o la siguiente extensión, Oracle asigna una extensión contigua (que este al lado para unirla) y realiza un encadenamiento del espacio para tomarlo como uno solo. Si Oracle no encuentra espacio para unir, tirara un error.

![Fragmentación y Encadenamiento](./resources/Fragmentación_Encadenamiento.png)

Al final posiblemente se tendrán varios espacios pequeños de espacio libre que no se pueden unir y por lo cual no se pueden usar.

![Fragmentacion y Espacio Perdido](./resources/Fragmentación_Espacio_Perdido.png)

### Tipos de Fragmentación

* Cuando el tablespace tiene dos porciones de espacio libre, pero están entre un objeto permanente y por esto no hay forma de unir estos dos debido al objeto en el medio.
* Cuando el tablespace tiene dos porciones de espacio libre, que están adyacentes el uno al otro, pero están separados, acá Oracle intentara solucionar esto intentando unir los espacio adyacentes.

![Tipos de Fragmentación](./resources/Fragmentación_Tipos.png)

### Resolver Fragmentación en el Tablespace

Existirán casos cuando el System Monitor de Oracle no podrá resolver los problemas de fragmentación por lo cual tenemos los siguientes métodos para evitar la fragmentación o disminuir la carga sobre el rendimiento:

* Usar tablespaces con manejo local y con tamaños uniformes, cuando se conoce que tan grande será el segmento o como llegara a crecer.
* Usar tamaños de extensiones que sean múltiplos de los tamaños de los bloques de la base de datos.
* Mover las tablas hacia un tablespaces con configuraciones de almacenamiento más apropiadas.
* Evitar usar encadenamiento y utilizar Automatic Segment Space Management o ASSM (Esta es el tercer forma que vimos para crear tablespaces con manejo local).

Para des fragmentar a un tablespace tenemos las siguientes opciones:

* Usar la cláusula `coalesce`, que busca áreas libres para unirlas: `ALTER TABLESPACE <name> coalesce`.
* Si el espacio de tablas se encuentra muy fragmento, entonces se debe de encontrar la fragmentación con respecto a tablas. Si se encuentra la tabla fragmentada se debería exportarla, borrarla e importarla , puesto que, al exportar se comprimen todas las extensiones juntan el espacio libre o probar con las otras formas que veremos dentro de poco.
* Si después de eliminar las tablas fragmentadas puede ser que se haya resuelto el problema, es ideal ejecutar de nuevo la clausula `coalesce`.
* Si después de realizar esto el tablespace sigue fragmentado, entonces la configuración del tablespace puede estar causando la fragmentación, para esto es conveniente eliminar el tablespace completo y volver a crearlo con dimensiones adecuadas.

A continuación se presentan dos queries para verificar la fragmentación en una tabla, este primer query busca la fragmentación en las tablas con un porcentaje superior al especificado, ignorando las tablas del diccionario donde encajen el nombre del segmento y el de la tabla.

```sql
SELECT  /*+ rule */ a.owner,
        a.segment_name,
        a.segment_type,
        round(a.bytes/1024/1024,0) MBS,
        round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) WASTED
FROM dba_segments a, dba_tables b
WHERE a.owner=b.owner 
AND a.owner not like 'SYS%' 
AND a.segment_name = b.table_name 
AND a.segment_type='TABLE' 
GROUP BY  a.owner,
          a.segment_name,
          a.segment_type,
          round(a.bytes/1024/1024,0),
          round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0)
HAVING round(bytes/1024/1024,0) >&PORCENTAJE
ORDER BY round(bytes/1024/1024,0) desc; 

OWNER           SEGMENT_NAME    SEGMENT_TYPE           MBS     WASTED
--------------- --------------- --------------- ---------- ----------
SH              CUSTOMERS       TABLE                   12          2
```

*Nota:* La base de datos puede trabajar con varios optimizadores, uno de ellos es aquel basado en reglas y otro es basado en costo, entonces si la base de datos trabaja usando con costo y queremos forzarla a usar el optimizador por regla podemos darle un "hint". De esta manera se obtendrían resultados distintos, ya que con el optimizador por regla tiene las estadísticas actualizadas.

Este es casi el mismo query trabajando con el optimizador predeterminado por costo y se asume que las estadísticas de la base de datos se encuentran actualizadas, únicamente se está utilizando la vista de tablas.

```sql
SELECT  owner,
        table_name,
        round((blocks*8),2)||'kb' AS FRAGMENTED_SIZE,
        round((num_rows*avg_row_len/1024),2)||'kb' AS ACTUAL_SIZE,
        round((blocks*8),2)-round((num_rows*avg_row_len/1024),2)||'kb' AS RECLAIMABLE_SPACE,
        ((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 AS RECLAIMABLE_SPACE_PCT
FROM dba_tables
WHERE table_name ='&table_Name' 
AND OWNER LIKE '&schema_name';  

OWNER           TABLE_NAME                     FRAGMENTED_SIZE ACTUAL_SIZE     RECLAIMABLE_SPA RECLAIMABLE_SPACE_PCT
--------------- ------------------------------ --------------- --------------- --------------- ---------------------
TEST            CARRERAS                       40kb            .03kb           39.97kb                        89.925
```

Este query tambien muestra información sobre el espacio fragmentado.

```sql
SELECT  TABLE_NAME,
        ROUND((num_rows*avg_row_len)/1024/1024,2) || ' MB'                    AS CONSUMED_SPACE,
        ROUND((blocks*8)/1024,2) || ' MB'                                     AS TOTAL_SIZE,
        ROUND((blocks*8)/1024 - (num_rows*avg_row_len)/1024/1024,2) || ' MB' AS RECLAIMABLE_SPACE
FROM dba_tables
WHERE table_name LIKE '%table_name'
```

## Automatic Segment Space Management o ASSM

Al proporcionar este manejo de almacenamiento al manejo local de tablespaces no se usa el bitmap, sino que en un bloque especial separado llamado **Bitmaped Block** o BMSB, esto libera la lectura del encabezado del segmento con la lista del estado del segmento, así no se tiene que leer constantemente. Este bloque es más rápido porque usa un tipo de árbol para realizar la búsqueda e indexación bloques libres.

Este RMSB contiene marcas especiales para definir el espacio usado y el espacio libre:

* Low High Water Mark o LHWM: Bajo esta marca índica es espacio formateado y úsable.
* High High Water Mark o HHWM: Indica el espacio utilizable en una tabla, por ejemplo él `delete` borra los datos, pero no libera el espacio (lo marca como utilizable) y no baja la marca, por otro lado `truncate` libera el espacio y baja la marca.

Se puede visualizar lar marca alta de la siguiente manera. 

![Marcas en la Fragmentación](./resources/Fragmentación_Marcas.png)

Para buscar las marcas se puede usar el siguiente query.

```sql
SELECT  a.tablespace_name,
        SUBSTR(a.file_name, 28) AS FILE_NAME,
        CEIL( (nvl(hwm,1)*8192)/1024/1024 ) "Mo"
FROM dba_data_files a, 
(
	SELECT  file_id,
	        MAX(block_id+blocks-1) hwm
	FROM dba_extents
	GROUP BY  file_id 
) b
WHERE a.file_id = b.file_id(+)
ORDER BY tablespace_name, file_name;  

TABLESPACE_NAME FILE_NAME                              Mo
--------------- ------------------------------ ----------
EXAMPLE         \ORADATA\ORCL\EXAMPLE01.DBF            82
SYSAUX          \ORADATA\ORCL\SYSAUX01.DBF            559
SYSTEM          \ORADATA\ORCL\SYSTEM01.DBF            695
TBS_DATOS       \ORADATA\ORCL\TBS_DATOS01.DBF           2
TBS_INDEX       \ORADATA\ORCL\TBS_INDEX01.DBF           2
UNDOTBS1        \ORADATA\ORCL\UNDOTBS01.DBF            37
USERS           \ORADATA\ORCL\USERS01.DBF               5
```

### Resolver Fragmentación

Para mover la marca alta, o sea igualar las dos marcas y eliminar la fragmentación se tienen los siguientes metodos:

Hacer un `ALTER TABLE MOVE` para moverla hacia otro tablespace o el mismo tablespace y reconstruir los índices, se movería la tabla a otra posición física, esto depende del espacio disponible en el tablespace hacia donde mover la tabla.

```sql
-- Permitir el movimiento de la tabla.
ALTER TABLE <TABLA> MOVE; 

  -- Habilitar el movimiento (fisico) de los registros de la tabla, hacia otros bloques
ALTER TABLE <TABLA> ENABLE ROW MOVEMENT;

-- Mover la tabla a otro tablespace
ALTER TABLE <TABLA> MOVE TABLESPACE <TABLESPACE_NUEVO>; 

-- Mover la tabla al mismo tablespace
ALTER TABLE <TABLA> MOVE TABLESPACE <TABLEPSACE_VIEJO>; 

-- Buscar el indice por recostruir
SELECT  status,
        index_name
FROM dba_indexes
WHERE table_name = '&table_name'; 

-- Reconstruir el indice
ALTER INDEX <INDEX_NAME> REBUILD ONLY; 

-- Actualizar las estadisticas de la base de datos
EXECUTE dbms_stats.gather_table_stats('&owner_name','&table_name');  
```

Exportar e importar la tabla, esto es difícil de implementar en un ambiente de producción.

Usar el comando `SHRINK`, esto es únicamente posible desde Oracle 10 g y solo aplica para tablespaces donde se usan **Automatic Segment Space Management** o ASSM.

```sql
-- Habilitar el movimiento de registros
ALTER TABLE <TABLA> ENABLE ROW MOVEMENT;

-- Reorganizar los bloques
ALTER TABLE <TABLA> SHRINK SPACE COMPACT;

-- Reorganiza los bloques, pero no hace rebuild de los indices.
ALTER TABLE <TABLA> SHRINK SPACE CASCADE;

-- Ajustar la marca alta
ALTER TABLE <TABLA> SKRINK SPACE;
```

Se puede también solo ajustar la marca sin reducir el espacio.

```sql
-- Habilitar el movimiento de registros
ALTER TABLE <TABLA> ENABLE ROW MOVEMENT;

-- Ajustar la marca alta
ALTER TABLE <TABLA> SKRINK SPACE;
```

*Nota:* Deshabilitar el movimiento de filas cuando terminemos de eliminar la fragmentación.

#### Consideraciones

* Los índices son actualizados después de usar `ALTER TABLE MOVE`
* Ajustar la marca es una operación en línea, no requiere poner un tablespace fuera de línea.
* No requiere espacio adicional para realizar el proceso de ajuste.

#### Vistas Útiles

Estas vistas nos permitirán obtener información sobre los espacios, espacio usado, espacio libre, espacio adyacente, espacio unido.

* DBA_FREE_SPACE
* DBA_FREE_SPACE_COALESCED
* ALL_TAB_COMMENTS
* ALL_COL_COMMENTS
* DBA_TABLES
* DBA_SEGMENTS
* DBA_EXTENTS
* DBA_TABLESPACES

### Tablespaces Temporales

La base de datos trabaja con un único tablespace temporal es posible crear nuevos tablespaces temporales.

```sql
SELECT file_name, tablespace_name FROM dba_temp_files;

FILE_NAME                      TABLESPACE_NAME
------------------------------ ---------------
\ORADATA\ORCL\TEMP01.DBF       TEMP

CREATE TEMPORARY TABLESPACE temp_new TEMPFILE 'C:\ORADATA\ORCL\TEMP01.DBF' SIZE 500M AUTOEXTENT ON NEXT 10M MAXSIZE UNLIMITED;

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp_new;

DROP TABLESPACE old_temp_tablespace INCLUDING CONTENTS AND DATAFILES.
```
