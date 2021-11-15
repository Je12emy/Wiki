# Practica

- [x] Exportar el esquema HR completo con registros, constraints y commprimido, cualquier nombre de archivo.
- [x] Exportar de las tablas: scott.Employees y scott.Departmanets, incluyendo sus datos
- [x] Exportar las tablas: hr.Employees y hr.Departments, pero unicamnete la estructura.
- [x] Crear un usuario semana9 sobre el el cual importar las tablas scott.employees y scott.departments sin datos.

Para exportar al esquema HR se usa el siguiente comando, agregar parámetros omitidos

```
exp.exe userid=sysdba/root owner=HR rows=y constraints=y compress=y file=hr_exp.dmp
```

Para exportar a las tablas `Employees` y `Departments` de `Scott` incluyendo sus registros se usa el siguiente comando.

```
exp.exe userid=sys/root tables=scott.emp,scott.dept rows=yes file=employees_deparmtents_exp.dmp 
```

Para hacer ese mismo export sin los registros:

```
exp.exe userid=sys/root tables=hr.employees,hr.departments rows=no file=hr_employees_deparmtents_no_data_exp.dmp 
```

Para entonces importar las tablas se utiliza:

```
imp.exe userid=sys/root tables=EMPLOYEES,DEPARTMENTS file=hr_employees_deparmtents_no_data_exp.dmp touser=semana9 fromuser=HR 
```

Verificación:

```sql
SELECT table_name FROM dba_tables WHERE owner = 'SEMANA9';

TABLE_NAME
------------------------------
EMPLOYEES
DEPARTMENTS
```
