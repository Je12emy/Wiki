# Base DB from which we copy our pfile
base_db_sid="orcl"
# SID for our new db
sid="tst3"
# Absolute path to ora home
ora_home="D:\\app\\user"
# SYS user password for oradim
sys_pwd="root"
# Variables for DB creation
control_file="system01.dbf"
sys_aux="sysaux01.dbf"
temp_tablespace="temp01.dbf"

# Create needed file structure
echo "Generating basic file structure..."
(cd $ora_home &&
mkdir admin/$sid &&
mkdir admin/$sid/adump &&
mkdir admin/$sid/dpdump &&
mkdir admin/$sid/pfile &&
mkdir flash_recovery_area/$sid &&
mkdir cfgtoollogs/dbca/$sid && 
mkdir oradata/$sid)

# Clone the PFILE and rename it
echo "Cloning PFILE from $base_db_sid"
(cd $ora_home &&
cp admin/$base_db_sid/pfile/init.* admin/$sid/pfile/ &&
mv admin/$sid/pfile/* admin/$sid/pfile/init.ora)

# Search and replace the old sid with the new sid
echo "Replacing old sid: $base_db_sid with new sid: $sid"
(cd $ora_home/admin/$sid/pfile/ && sed -i "s/$base_db_sid/$sid/g" init.ora)

echo "All files created, please create the Oracle sid with oradim.exe AS ADMIN by using: oradim.exe -NEW -SID $sid -STARTMODE manual -SYSPWD $sys_pwd -PFILE $ora_home\\admin\\$sid\\pfile\\init.ora"
echo "WARNING: Password for user SYS is '$sys_pwd'..."
echo "After running this command please make sure the instance is running in Windows' process monitor..."
echo "Jump into a terminal and set your oracle sid environment variable: SET ORACLE_SID=$sid"
echo "Login to this oracle instance, if the message 'Connected to an idle instance.' shows up, you're good... else please check the generated pfile, maybe the file extension is wrong..."
echo "Run: startup nomount pfile=$ora_home\\admin\\$sid\\pfile\\init.ora , NOTE: Please fix file path to use backslashes '\\' if needed for your terminal..."
echo "Run the sample create database script, please alter any variable as needed or check the script for the default values..."

creteDbScript="
CREATE DATABASE $sid 
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE '$ora_home\oradata\\$sid\\$control_file' SIZE 700M REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '$ora_home\oradata\\$sid\\$sys_aux' SIZE 600M REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '$ora_home\oradata\\$sid\\$temp_tablespace' SIZE 20M REUSE AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE \"UNDOTBS1\" DATAFILE 'D:\app\jerem\oradata\\$sid\\undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT 5120K MAXSIZE UNLIMITED
CHARACTER SET WE8MSWIN1252
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('$ora_home\oradata\\$sid\redo01.log') SIZE 51200K,
GROUP 2 ('$ora_home\oradata\\$sid\redo02.log') SIZE 51200K,
GROUP 3 ('$ora_home\oradata\\$sid\redo03.log') SIZE 51200K
USER SYS IDENTIFIED BY $sys_pwd USER SYSTEM IDENTIFIED BY $sys_pwd;
"
echo "$creteDbScript"
echo "We are almost there...lol running these next steps may take a while..."
echo "Run the following scripts in your sqlplus terminal: catalog.sql, catproc.sql and catexp.sql. They are all located at /product/<version>/rdbms/admin you may do this a sys or withouth login in to this instance with: sqlplus \nolog"
echo "Hint: Just use the following commands:"
echo "@?/rdbms/admin/catalog.sql"
echo "@?/rdbms/admin/catproc.sql"
echo "@?/rdbms/admin/catexp.sql"
echo "Run the scripts: catalog.sql, catblock.sql, catproc.sql, catoctk.sql and owminst.plb located at /rdbms/admin"
echo "@?/rdbms/admin/catalog.sql"
echo "@?/rdbms/admin/catblock.sql"
echo "@?/rdbms/admin/catproc.sql"
echo "@?/rdbms/admin/catoctk.sql"
echo "@?/rdbms/admin/owminst.plb"
echo "As SYSTEM run the following scripts:"
echo "@?/sqlplus/admin/pupbld.sql"
echo "@?/sqlplus/admin/help/hlpbld.sql"
echo "@?/sqlplus/admin/help/helpus.sql"
echo ""
echo "Afterwards please check $ora_home/oradata/$sid for your new files."
echo "Try reading data from the v\$session dictionary view and create a dummy table maybe: CREATE TABLE foo (id NUMBER); and insert/read some data."
echo "You may use this DB afterwards by specifying the pfile: startup pfile=$ora_home\admin\\$sid\pfile\init.ora"
echo "You may also generate a new spfile from this pfile with: CREATE SPFILE FROM PFILE='$ora_home\admin\\$sid\pfile\init.ora';"
