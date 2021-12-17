# Practica de Datapump

- [x] Crear un respaldo el cual va a ubicarse un una ruta llamada 'c:/app/respaldos'
- [x] Otorgar los permisos necesario sobre este directorio.
- [x] Exportar a los esquemas hr y oe.
- [x] Del esquema oe aplicar un query a la tabla orders donde las ventas o el total de la orden sea mayor a 3000, incluir objetos solo tipo tablas. 
- [x] Llamar a este respaldo `backup_{año}{mes}{dia}_{hora}`, estos parametros obtenerlos del sistema operativoen en el momento que se ejecuta.
      
## Solución

Configurar el directorio de respaldos
      
```sql
CREATE OR REPLACE DIRECTORY backups as 'd:/app/respaldos'
```
      
Configurar permisos
      
```sql
GRANT READ, WRITE ON DIRECTORY backups TO scott_clone;
```

Preparación de variable de ambiente con bash.

```sh
export exp_date=`date "+%Y%m%d%_H%M%S"`
```

Parfile por utilizar: `exp.par`

```
SCHEMAS=hr,oe 
INCLUDE=table 
QUERY=oe.orders:"WHERE order_total > 3000" 
LOGFILE=hr_oe.log
DIRECTORY=backups
```

Comando `exp`

```console
expdp.exe DUMPFILE=backup_${exp_date}.dmp PARFILE=exp.par
```
