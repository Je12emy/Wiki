# ¿Qué es la Herencia? Don't Repeat Yourslef (DRY)

Cuando detectemos que estamos copiando y pegando código repetidas veces en necesario para y detectar de que forma podemos abstraer nuestro codigo para hacerlo mas reutilizable.

* Promueve la reducción de duplicación en programación.
* La piezas de información nunca deben de repetirse.

En nuestras clases `Doctor` y `Pacient` existen metodos repetidos, en donde podemos abstraer y reutilizar código.

La Herencia es el termino de utilizar clases a partir de otras ya existentes, aca se establece una relación padre / hijo o superclase y subclase.

![Herencia: Superclase y SUbclases](../Resources/Superclase_y_subclase.png)

Una superclase es aquella con un mayor nivel de [abstacción](Entender%20la%20OOP.md#Abstracci%C3%B3n%20%C2%BFQu%C3%A9%20es%20una%20Clase) para una clase hija, basicamente creamos un molde para otro molde. 

# Super y This

Para abstraer una nueva clase a partir de las clases `Doctor` y `Paciente` tenemos que identificar que propiedades y metodos se estan repetiendo, desde estos crearemos una clase `User` desde donde se podra especializar a crear un Doctor o Paciente

```java
public class User {
    private int id;
    private String name;
    private String email;
    private String address;
    private String phoneNumber;

    public User(int id, String name, String email, String address, String phoneNumber) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.address = address;
        this.phoneNumber = phoneNumber;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
```
Esta ahora sera nuestra super clase y las clases `Doctor` y `Pacient` seran sus sub clases, esto se logra con la palabra clave `extends` seguido con el nombre de la clase padre.

```java
public class User {
	// Super class
}

public class Patient extends User {
	// Subclass
}
```

De esta manera podemos aplicar la herencia, al momento de remover las propiedades por heredar y aplicar la herencia tendremos un error con `super()`, tenemos que discutor a `super` y a `this`

![Herencia: super y this](../Resources/Herencia_super_y_this.png)

Si queremos acceder a un metodo o propiedad de la clase padre de `User`, digamos el nombre ocupamos accederlo mediante la propiedad `super` digamos `super.getName()` y para aquello que es especifico de nuestra clase usaremos `this`, entonces `this.getSpeciality()`. Aun asi para futuro sepamos que podemos sobre escribir miembros heredados.

A esta clase `User` le asignaremos todas las propiedades y métodos repetidos.

```java
public class User {
    private int id;
    private String name;
    private String email;
    private String address;
    private String phoneNumber;

    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        if (phoneNumber.length() < 8){
            System.out.println("El número de telefono requiere 8 caracteres.");
        } else if (phoneNumber.length() == 8){
            this.phoneNumber = phoneNumber;
        }
    }
}
```

Y son las subclases quienes llamaran al método constructor de `super` para constuir a su clase padre.

```java
public class Doctor extends User {

    private String speciality;
    private ArrayList<AvailableAppointment> availableAppointments = new ArrayList<>();

    Doctor(String name, String email ){
        super(name, email);
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

}
```

# Polimorfismo: Sobreescritura de Métodos

Como dato curioso todos los objetos en Java heredan de la clase `Object` y podriamos utilizar metodos heredados por esta clase, el IDE identifica que estamos heredando y que forma parte de nuestra clase

Cuando una clase hereda de otra y en esta clase hija se redefine un método con una implementación distinta a la de la clase padre.

**Los métodos marcados como final o static no se pueden sobreescribir.**

La  sobreescritura de constructores se da cuando se utilizan los miembros heredados de la superclase con argumentos diferentes.

Esta es lograda mediante el decorador `@Overrride` antes del metodo, en este caso vamos a sobreescribir el metodo `toString()` the clase `Object` en `User`.

```java
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", Name='" + name + '\'' +
                ", Email='" + email + '\'' +
                ", Address='" + address + '\'' +
                ", PhoneNumber='" + phoneNumber + '\'' +
                '}';
    }
```

Esto esta bien, pero queremos mostrar más datos para aquellas clases en las cuales podemos mostrar más propiedades adicionales como seria en el `Patient`

```java
    @Override
    public String toString() {
        return super.toString() +
                ", birthDay='" + getBirthDay() + '\'' +
                ", weight=" + getWeight() +
                ", height=" + getHeight() +
                ", blood='" + getBlood() + '\'' +
                '}';
    }
```

Con esto se logra el siguiente resultado

```java
Patient myPatient = new Patient("Alejandra", "alegandra@mail.com");
System.out.println(myPatient);
```
```
User{id=0, Name='Alejandra', Email='alegandra@mail.com', Address='null', PhoneNumber='null'}, birthDay='null', weight=0.0 kg, height=0.0 mts, blood='null'}
```

# Polimorfismo: Sobreescribiendo el método toString

Veamos otros cambios que podemos agregar en la sobreescritura del método `toString()`

```java
public class Doctor extends User {  
    @Override  
 public String toString() {  
        return super.toString() +  
                "Speciality='" \+ this.speciality \+ "\\nAvailable: " \+ this.availableAppointments.toString();  
 }
}
```

Luego en la clase anidada estatica podemos volver a sobreescribir.

```java
    public static class AvailableAppointment {
        @Override
        public String toString() {
            return "\nAvailable Appointment: \nDate: " + this.date + "\nTime:" + this.time;
        }
```

Aca al imprimir la lista de citas, al ser un `ArrayList` de tipo `AvailibleAppointment`, este itera sobre cada objeto y nos permitira imprimir cada propiedad sin la necesidad de un ciclo.

# Interfaces

Hasta el momento podriamos representar nuestro código con el siguiente código.

![Diagrama de Clases](../Resources/MyMedicalAppointments_Class_Diagrams.png)

Por otro lado contamos con 2 capas, una capa de interface y otra de modelos, hemos aplicado el concepto de modularidad a tal nivel que podriamos crear un nuevo modelo de `Nurse` incluso sin el problema de generar choques en el código al heredar de la superclase `User`.

Si una nueva entidad entra en juego que ejecute las mismas acciones que otra entidad podemos utilizar a una interfaz.

Las interfaces son un tipo de referencia similar a una clase, que podría contener solo constantes y definiciones de métodos (que son redundantes), digamos agendar citas para un `Doctor` y un `Nurse`; estas difieren de le herencia por que unicamente definen en forma general un comportamiento puesto que un metodo heredado entre clases puede ser completamnete distinto en implementación a tal punto que no vale la pena hacer uso de la herencia.

Estas interfaces establecen la forma de una clase (nombres de métpdps. listas de argumentos y tipos de retorno, pero **no bloques de código**).

Las interfaces suelen tener el prefijo "I" en su nombre y una clase puede implementar múltiples interfaces.

```java
public interface ISchedulable {
	Schedule(Date date, String Time)
}

public class AppointmentDoctor implements ISchedulable {
}
```

# Creando una Interfaz para definir si una fecha es agendable

La capacidad de poder asignarle comportamientos a una clase mediante interfaces es llamado **composición de interfacez en clases**, donde se abstrae todos los comportamientos de una clase en una interfaz para posteriormente reutilizar en otras clases que deseamos que sigan ese comportamiento.

Una ventaja sobre la herencia rádica en el hecho de que no estrictamente lineal entre superclase y subclase sino que se puede hacer a cualquier nivel para una clase y se puede aprovechar este comportamiento en cualquier clase.

Para esto vamos a introducir a una nueva clase `Nurse` que va a heredar de `User` y dos clases nuevas `AppoinmentNurse` y `AppointmentDoctor` que van a implementar a la interfaz `ISchedulable`.

```java
public class AppointmentDoctor {
	// Este tipo de clase compuesta por Getters y Setters es conocida como POJO o Plain Old Java Object
    private int id;
    private Patient patient;
    private Doctor doctor;
    private Date date;
    private String time;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
```

Crearemos la interfaz por implementar en `AppointmentDoctor` y `AppointmentNurse`, una interfaz requiere unicamente del modificador de acceso del metodo asi como cualquier parametro necesario.

```java
public interface ISchedulable {
    void schedula(Date date, String time);
}
```

E implementamos esta interfaz en las clases necesarias, esto requiere implementar la función en cuestión junto a un `@Overrride`.

```java

public class AppointmentDoctor implements ISchedulable{
    
	// more code ...
	
	@Override
    public void schedulable(Date date, String time) {

    }
}
```

Por otro lado, vamos a mover todos los modelos de `Doctor`, `Nurse`, `Patient`, etc a un nuevo paquete de `model`, esto va a requerir que nuestros constructores sean de tipo `public` debido a su [encapsulamiento](Definir%20Clases%20y%20sus%20Componentes.md#Encapsulamiento%20Modificadores%20de%20Acceso)

# Collections
Otras interfaces que son muy importantes en Java son los llamados Collections

Los Collections nos van a servir para trabajar con colecciones de datos, específicamente y solamente con objetos, para esto recuerda que tenemos disponibles nuestras clases Wrapper que nos ayudan a convertir datos primitivos a objetos.

Los collections se diferencian de los arrays en que su tamaño no es fijo y por el contrario es dinámico.

A continuación te muestro un diagrama de su composición:
![](https://static.platzi.com/media/user_upload/IMG1-b5d51fc9-f21a-47c9-960c-409d2cf43f7d.jpg)

Como podemos observar el elemento más alto es la interfaz Collection, para lo cual, partiendo de su naturalidad de interface, entendemos que tiene una serie de métodos “básicos” dónde su comportamiento será definido a medida que se vaya implementando en más elementos. De ella se desprenden principalmente las interfaces Set y List.

La interface Set tendrá las siguientes características:

* Almacena objetos únicos, no repetidos.
* La mayoría de las veces los objetos se almacenarán en desorden.
* No tenemos índice.

La interface List tiene éstas características:

* Puede almacenar objetos repetidos.
* Los objetos se almacenan en orden secuencial.
* Tenemos acceso al índice.

## Si seguimos analizando las familias tenemos que de Set se desprenden:

### HashSet
Interfaz SortedSet y de ella la clase TreeSet.

### HashSet 
Los elementos se guardan en desorden y gracias al mecanismo llamado hashing (obtiene un identificador del objeto) permite almacenar objetos únicos.

### TreeSet 
Almacena objetos únicos, y gracias a su estructura de árbol el *acceso es sumamente rápido.

## Ahora si analizamos la familia List, de ella se desprenden:

* _Clase ArrayList_ puede tener duplicados, no está sincronizada por lo tanto es más rápida
* _Clase Vector_ es sincronizada, los datos están más seguros pero es más lento.
* _Clase LinkedList,_ puede contener elementos duplicados, no está sincronizada (es más rápida) al ser una estructura de datos doblemente ligada podemos añadir datos por encima de la pila o por debajo.

## Sigamos con Map

Lo primero que debes saber es que tiene tres implementaciones:

- HashTable
- LinkedHashMap
- HashMap
- SortedMap -> TreeMap

 ![](https://static.platzi.com/media/user_upload/img3-105ac91c-3d09-4ed5-a5cc-3b0a21f3c12b.jpg)

La interfaz Map no hereda de la interfaz Collection porque representa una estructura de datos de Mapeo y no de colección simple de objetos. Esta estructura es más compleja, pues cada elemento deberá venir en pareja con otro dato que funcionará como la llave del elemento.

## Map

- Donde K es el key o clave
- Donde V es el value o valor

Podemos declarar un map de la siguiente forma:

```java
Map<Integer, String> map = new HashMap<Integer, String>();
Map<Integer, String> treeMap = new TreeMap<Integer, String>();
Map<Integer, String> linkedHashMap = new LinkedHashMap<Integer, String>();
```

Como observas solo se puede construir el objeto con tres elementos que implementan de ella: `HashMap`, `TreeMap` y `LinkedHashMap` dejando fuera `HashTable` y `SortedMap`. `SortedMap` estará fuera pues es una interfaz y `HashTable` ha quedado deprecada pues tiene métodos redundantes en otras clases. Mira la funcionalidad de cada uno.

Como te conté hace un momento Map tiene implementaciones:

- HashMap: Los elementos no se ordenan. No aceptan claves duplicadas ni valores nulos.
- LinkedHashMap: Ordena los elementos conforme se van insertando; provocando que las búsquedas sean más lentas que las demás clases.
- TreeMap: El Mapa lo ordena de forma “natural”. Por ejemplo, si la clave son valores enteros (como luego veremos), los ordena de menos a mayor.

Para iterar alguno de estos será necesario utilizar la interface Iterator y para recorrerlo lo haremos un bucle while así como se muestra:

## Para HashMap

```java
// Imprimimos el Map con un Iterador
Iterator it = map.keySet().iterator();
while(it.hasNext()){
  Integer key = it.next();
  System.out.println("Clave: " + key + " -> Valor: " + map.get(key));
}
```

## Para LinkedHashMap

```java
// Imprimimos el Map con un Iterador
Iterator it = linkedHashMap.keySet().iterator();
while(it.hasNext()){
  Integer key = it.next();
  System.out.println("Clave: " + key + " -> Valor: " + linkedHashMap.get(key));
}
```

## Para TreeMap

```java
// Imprimimos el Map con un Iterador
Iterator it = treeMap.keySet().iterator();
while(it.hasNext()){
  Integer key = it.next();
  System.out.println("Clave: " + key + " -> Valor: " + treeMap.get(key));
}
```

Ahora lee esta lectura y en la sección de tutoriales cuéntanos en tus palabras cómo funciona Deque.