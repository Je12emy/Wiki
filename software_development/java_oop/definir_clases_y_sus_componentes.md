[Ahora](Ahora) que vimos las bases sobre [[Entender la OOP|que es un objeto]] y las bases de  [[Introducción a Java SE|Java SE]], podemos crear nuestra primera clase.

# Creando Nuestra Primera Clase

Partiendo desde la premisa que crearemos un sistema medico para agendar citas, crearemos nuestra primera clase llamada Doctor.

Crearemos un nuevo project con la clase `Main` para el punto de entrada y la clase `Doctor` con lo siguiente.

```java
public class Doctor {
    // Atributos
    int id;
    String name;
    String speciality;

    // Métodos
    public void showName(){
        System.out.println(this.name);
    }
}
```

## Declar e Instanciar un Objeto

Para crear un objeto tenemos la siguiente sintaxis:

```java
// <Tipo de Dato> <Nombre del Dato>
Doctor myDoctor;
```

Para instanciar un objeto usamos la siguiente sintaxis:

```java
// <Nombre del Dato> = new <Tipo del Objeto>()
myDoctor = new Doctor()
```

Es gracias a esto que ahora este objeto existe y toma un espacio en la memoria.

```java
Doctor myDoctor = new Doctor();
```

Veamos esto en nuestra clase `Main`, al instanciar a un nuevo Doctor.

```java
public class Main {
    public static void main(String[] args) {
        Doctor myDoctor = new Doctor();

        myDoctor.id = 1;
        myDoctor.name = "Jeremy";
        myDoctor.speciality = "Brain surgeon";

        myDoctor.showName(); // Jeremy
    }
}
```

# Método Constructor

En la clase pasada instanciamos a un nuevo objeto de tipo `Doctor`, al usar los parentesis podemos pasar parametros para crear nuestro nuevo doctor, esto es un metodo constructor.

```java
// <nombre> new <Método Constructor()>
myDoctor = new Doctor();
```

El metodo constructor tiene las siguientes caracteristicas:

* Nos permite crear nuevas instancia de una clase, o sea un objeto.
* Tiene siempre el mismo nombre de la clase desde donde se esta inicializando.
* Utiliza la palabra clave `new`.
* Puede utilizar cero o más argumentos, cuando no tenemos un método constructor Java crear uno para nosotros.
* Los métodos constructores nunca van a regresar un valor.

Para crear un nuevo objeto constructor, simplemente creamos un método con el mismo nombre de la clase y dentro de este se estara ejecutando un bloque de código cada vez que se cree el objeto.


```java
public class Doctor {
    Doctor(){
        System.out.println("Construyendo el objeto doctor");
    }
}
```

Si creamos otro método constructor, entonces tendremos dos maneras de crear a un nuevo objeto.

```java
public class Doctor {
    Doctor(){
        System.out.println("Construyendo el objeto doctor");
    }
    Doctor(String name){
		// No asigna a la propiedad name, entonces showName() retornara null
        System.out.println("Mi nombre es " + name);
    }

}
```

Entonces en nuestro metodo `main` lo instanciamos de la siguiente manera

```java
public class Main {
    public static void main(String[] args) {
        Doctor _myDoctor = new Doctor("Jeremy Zelaya");
        _myDoctor.showName(); // Mi nombre es null
    }
}
```

# Static: Variables y Métodos Estáticos

Recordemos que la clase es el molde en el cual abstraemos sus atributos y metodos que mediante el objeto podemos definir dichos atributos e invocar sus metodos.

Los métodos y variables estaticos son aquellos que se pueden utilizar en **toda** la clase y se encuentran definidos por la palabra reservada `static`. 

![Acceso a Miemrbos `static`](../Resources/Acceso_a_Miembros_Estaticos.png)

Mediante los metodos estaticos podemos llamar a una variable sin tener que utilizar a un objeto, estos pueden accedidos utilizando el nombre de la clase y se realiza sobre una clase sin la necesidad de un objeto.

Esto nos permitiria definir un miembro estatico en la `Clase C`, modificarlo en la `Clase A` y accederlo en la `Clase B` con los cambios realizados, significa que este miembro mantendra su "ciclo de vida" durante todo el programa.

Cuando hacemos uso de esta sintaxis, la clase es importada por el IDE de forma automatica e incluso al momento de importar podemos utilizar el modificador `static`

```java
// Importar todos los miembros estaticos de la clase Math
import static java.lang.Math.*

public class Principal{
	public static void main(String[] args){
		// Acceder directo a PI sin usar Math.PI
		System.out.println(PI)
	}
}
```

# Creando Elementos Estáticos

Vamos a alterar la clase `Doctor` y vamos a simular un id auto-incremental, esto lo logramos alterando la propiedad con la palabra reservada `static` que, con el método constructor sera posible incrementarla por cada nuevo `Doctor` que sea creado.

```java
public class Doctor {
    // Atributos
    static int id = 0; // auto-incremental
    String name;
    String speciality;
    Doctor(){
        this.id ++;
    }
}
```

De esta manera al crear nuevos objetos de tipo `Doctor`, la propiedad de `id` sera incrementada de manera automatica.

```java
public class Main {
    public static void main(String[] args) {
        Doctor myDoctor = new Doctor();
		// La propiedad id sera incrementada a 1
        myDoctor.name = "Jeremy";
        myDoctor.showName(); // Jeremy
        myDoctor.showID(); // 1

        // Se puede accesar sin tener que utilizar un objeto
        // System.out.println(Doctor.id); // 0

        // Doctor.id ++; // Todos los siguientes eran alterados
		
		// La propiedad id sera alterada a 2 para todos
        Doctor _myDoctor = new Doctor();
        _myDoctor.showID(); // 2

    }
}
```

Se nos va a proporcionar un código para mostrar un menú por consola, vamos a mover este codigo a una clase nueva.

Se deberia ver de la siguiente manera.

```java
import java.util.Scanner;

public class UIMenu {
    static void showMenu(){
		// code ...
    }

    static void showPatientMenu(){
      // code ...
    }
}
```
Ahora podemos utilizar el metodo `showMenu()` sin la necesidad de crear un objeto `UIMenu`.

```java
public class Main {
    public static void main(String[] args) {
        UIMenu.showMenu();
    }
}
```

Movamos a este código a un paquete nuevo; Click Derecho -> New -> Package y lo movemos a esta nueva carpeta, esto lo hacemos para aprovechar la sintaxis de `import`. 

Para que estos métodos sean accesibles dentro de este paquete al momento de importarlo (o sea para otros paquetes) tenemos que volverlos públicos.

```java
package ui;
import java.util.Scanner;

public class UIMenu {
    public static void showMenu(){
		// code ...
    }

    public static void showPatientMenu(){
      // code ...
    }
}
```

Y dentro de la clase `Main` vamos a aprovechar la sintaxis de `import` para importar estas funciones estáticas.

```java
import static ui.UIMenu.*;

public class Main {
    public static void main(String[] args) {
        showMenu();
    }
}
```

# Final: Variables Constantes

Una variable constante es aquella que no cambiara jamas, hace uso de la palabra reservada `final` y usalmente va de la mano con `static` puesto que usualmente este tipo de variables no deseamos que cambien.

Vamos a hacer esto para una lista con los meses del año, los cuales lógicamente nunca cambiarian.

```java
public class UIMenu {

    public static final String [] MONTHS = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};

    public static void showMenu(){
        int response = 0;
        do {
            System.out.println("1. Doctor");
            System.out.println("2. Patient");
            System.out.println("0. Salir");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response){
                case 2:
                    response = 0;
                    showPatientMenu();

                    break;
            }
        }while (response != 0);
    }

    public static void showPatientMenu(){
        int response = 0;
        do {
            switch (response){
                case 1:
                    System.out.println("::Book an appointment");
                    for (int i = 1; i < 4; i++) {
                        System.out.println(i + ". " + MONTHS[i]);
                    }
                    break;
            }
        }while (response != 0);
    }
}
```

# Variables vs. Objeto: Un Vistazo a la Memoria

Una grán diferencia entre una variables y un objeto se centra en su asignación en memoria.

![Asignación en Memoria de un Objeto vs una Variable](../Resources/Java_Objeto_vs_Variable_Asignaci%C3%B3n%20_en_Memoria.png)

Aca el dato de tipo primitivo es almacenado en la memoria de nuestra computadora o  `stack`, pero para un objeto se almacena la dirección en una memoria aparte en forma de arbol, `heap`. 

Esto significa que podemos asignar de manera directa variables de tipo primitivo.

```java
int i = 0;
int n = 1:
i = n; // 1
```

Pero no podriamos hacer lo mismo con objetos, puesto que unicamente se esta asignando la dirección de memoria y ambos se veran alterados en caso de realizar modificaciones.

```java
Doctor doctor1 = new Doctor();
Doctor doctor2 = new Doctor();

doctor2 = doctor1;
doctor.id = 200; // doctor.id = 200
```

# Sobrecarga de Métodos y Constructores

Existen casos en donde ocupamos dos o más métodos con el mismo nombre pero con distintos argumentos. Igualmente los métodos constructores pueden ser sobrecargados.

Para sobrecargar a un método constructor, simplemente definimos las variables necesarias para invocar al metodo, para asignar un valor a las propiedades se utiliza la palabra reservada `this` para acceder a los miembros de la clase.

```java
public class Doctor {
    // Atributos
    static int id = 0; // auto-incremental
    String name;
    String speciality;

    Doctor(){
    }
    Doctor(String name, String speciality){
        this.id ++
        ;
        this.name = name;
        this.speciality = speciality;
    }
}
```

Para crear el objeto pasamos los parametros necesarios para crearlo.

```java
public class Main {
    public static void main(String[] args) {
        Doctor myDoctor = new Doctor("Jeremy Zelaya", "Brain Surgeon");
    }
}
```

# Encapsulamiento: Modificadores de Acceso

Hace referencia a la restricción sobre el nivel de acceso de las propiedades de una clase, esto se hace para que no se de una modificación sobre estas en una capa de la aplicación en donde no corresponde, como seria evitar que en la capa de interfaz gráfica sea posible alterar el nombre del doctor.

Esto es logrado mediante los modificadores de acceso.

![Modificadores de Acceso en el Encapsulamiento](../Resources/Encapsulamiento_modificadores_de_acceso.png)

En nuestro caso, unicamente deseamos que el nombre de un doctor unicamente sea alterado desde la clase/modelo de negocio.

```java
public class Patient {
    private String name;
    private String email;
    private String address;
    private String phoneNumber;
    private String birthDay;
    private double weight;
    private double height;
    private String blood;

    Patient(String name, String email ){
        this.name = name;
        this.email = email;
    }
}
```

# Getters y Setters

Nos permiten Leer y Escribir específicamente los valores de las variables miembro, son utiles cuando nuestras variables son privadas y nos permiten realizar validaciones dentro de ellos.

![Getters y Setters](../Resources/Getter_y_Setter.png)

En nuestro caso queremos retornar el peso y la altura con una medida exacta y queremos realizar validación sobre el numero de teléfono, gracias a los metodos `getter` y `setter` es posible agregar esta lógica de negocio.

```java
public class Patient {

    public String getWeight(){
        return this.weight + " kg";
    }

    public String getHeight(){
        return this.height + " mts";
    }

    public void setPhoneNumber(String phoneNumber) {
        if (phoneNumber.length() < 8){
            System.out.println("El numero de teléfono debe de ser de 8 caracteres");
        }else if (phoneNumber.length() == 8) {
            this.phoneNumber = phoneNumber;
        }
    }

}
```

# Variables vs. Objeto

Las variables son entidades elementales (muy sencillas)
* Un número.
* Un caractér.
* Un valor verdadero o falso.

Los objetos como tal son entidades más complejas, compuestas por agrupaciones de variables (propiedades) y metodos.

Los arreglos igualmente son objetos, son una colección de datos igualmente y cuenta con mas operaciones para manipular dichos datos.

Aun asi las clases pueden ser `wrappers` para primitivos, entre estas encontramos Byte, Short, Integer, Long, Float, Double, Character y **String**, de igual manera nos van a proporcionar más metodos para manipular a estos primitivos.

# Clases Anidadas

Este es un tipo de clases que nos podriamos topar al momento de trabajar con un `Framework`.

```java
class ClaseExterior {
	class ClaseAnidada{
	}
}
```

En escencia se tiene a una clase que vive dentro de otra, esto es asi por que su logica esta directamente relacionada con la clase exterior.

Encontramos 2 tipos de clases anidadas.

* Las clases internas: 
	* Clases locales a un Método: Clases declaradas dentro de un metodo.
	* Clases Internas Anónimas: Sera visto en el curso de programación funcional, pero sigue el principio de JavaScript donde una variable contiene una clase..
* Las clases estáticas anidadas.

A continuación se presentan en forma de diagrama

![Tipos de Clases Anidadas](../Resources/Clases_anidadas_tipos.png)

Se pueden diferenciar facilmente con la palabra reservada `static`

```java
class ClaseExterior {
	// Clase Estática Anidada
	static class ClaseStaticaAnidada {
	}

	//  Clase Interna
	class ClaseAnidada {
	}
}
```

## Clases Estáticas

* No se necesitan crear instancias para llamarlas, es lo mismo que hemos visto con propiedades y metodos estaticos.
* Solo se pueden llamar a los métodos estáticos.

## Clases Anidadas

Pueden llamar a cualquier elemento o método, suelen ser llamadas "Clases Helper" y suelen ser agrupadas por lógica.

Para acceder a una clase anidada es necesario instanciar a su clase externa.

```java
public class Enclosing {
	private static int x = 1;
	
	public static class StaticNested {
		private void run(){
			// Implementación
		}
	}
}

public class Main{
	Enclosing.StaticNested nested = new Enclosing.StaticNested();
	nested.run();
}
```

Si quisieramos agregar dentro de nuestra clase `Doctor` una forma de manejar sus citas podriamos crear una clase anidada sobre la cual solo este tendra acceso.

```java
public class Doctor {
    public static class AvailableAppointment {
        private int id;
        private Date date;
        private String time;

        public AvailableAppointment(Date date, String time){
            this.date = date;
            this.time = time;
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
}
```

Y en la clase `Doctor` crear un arreglo de tipo `AvailableAppointment` que almacenara todas sus citas, asi como la logica para crear nuevas citas y retornarlas.

```java
public class Doctor {
    public void addAvailableAppointment(Date date, String time){
        // Se podria hacer new Doctor.AvailableAppointment(date, time)
        availableAppointments.add(new AvailableAppointment(date, time));
    }

    public ArrayList<AvailableAppointment> getAvailableAppointments(){
        return this.availableAppointments;
    }

    public static class AvailableAppointment {
        private int id;
        private Date date;
        private String time;

        public AvailableAppointment(Date date, String time){
            this.date = date;
            this.time = time;
        }
    }
}
```

En nuestro metodo `Main` creamos nuevas citas para este doctor y manejamos la logica para imprimir el listado.

```java
public class Main {
    public static void main(String[] args) {
        Doctor myDoctor = new Doctor("Jeremy Zelaya", "Brain Surgeon");
        myDoctor.addAvailableAppointment(new Date(), "4 pm");
        myDoctor.addAvailableAppointment(new Date(), "5 pm");

		// Por cada cita en la lista de citas, imprimir fecha y hora.
        for (Doctor.AvailableAppointment appointment:
                myDoctor.getAvailableAppointments()) {
            System.out.println(appointment.getDate() + " : " + appointment.getTime());
        }

    }
}
```

# Clases Internas y Locales a un Método

Este es el otro metodo que nos podemos topar en Java, se tienen que acceder creando un nuevo objeto para la clase externa e interna.

```java
public class Outer {
	public class Inner{
	}
}

public class Main {
	public static void main(String[] args) {
		Outer outer = new Outer();
		Outer.Inner inner = new Outer.Inner();
	}
}
```

La ventaja de usar clases estaticas anidadas sobre estas es que no estaremos creando tantos objetos y no estaremos llenando la memoria.

En las clases locales a un método, estaremos almacenando una clase dentro de un metodo y los estaremos llamando al momento de crear objeto para la clase externa.

```java
public class Enclosing {
	void run(){
		class Local {
			void run()
		}
	}
	
	Local local = new Local();
	local.run();
}

public class Main {
	public static void main (String[] args){
		Enclosing enclosing = new Enclosing();
		enclosing.run();
	}
}
```

Aca se esta desperdiciando recursos creando un metodo que almacena un objeto, por esto las estaticas anidadas suelen ser la mejor opcion.

# Enums
Los enumerations son tipos de datos muy especiales pues este, es el único en su tipo que sirve para declarar una colección de constantes, al ser así estaremos obligados a escribirlos con mayúsculas.

Usaremos enum cada vez que necesitemos representar un conjunto fijo de constantes. _Por ejemplo los días de la semana._

Así podemos declarar un enumeration usando la palabra reservada **enum.**

```java
public enum Day {
	SUNDAY, MONDAY, TUESDAY, WEDNESDAY,
	THURSDAY, FRIDAY, SATURDAY
}
```

Puedo crear referencias de enumerations de la siguiente forma:

```java
Day day;
switch (day) {
	case MONDAY:
		System.out.println(“Mondays are good.”);
		break;
	case FRIDAY:
		System.out.println(“Fridays are nice”);
		break;
	case SATURDAY: case: SUNDAY:
		System.out.println(“Weekends are the best”);
		break;
	default:
		System.out.println(“Midweek are so-so”);
		break;

}
```

Y puedo llamar un valor del enumeration así:

```java
Day.MONDAY;
Day.FRIDAY;
Day.SATURDAY
```

Los enumerations pueden tener atributos, métodos y constructores, como se muestra:

```java
public enum Day {
  MONDAY("Lunes");
  TUESDAY("Jueves");
  FRIDAY("Viernes");
  SATURDAY("Sábado");
  SUNDAY("Domingo");

  private String spanish;
  private Day(String s) {
    spanish = s;
  }

  private String getSpanish() {
    return spanish;
  }
}
```

Y para utilizarlo lo podemos hacer así:

```java
System.out.println(Day.MONDAY);
```

_Imprimirá:_ **MONDAY**

```java
System.out.println(Day.MONDAY.getSpanish());
```

_Imprimirá:_ **Lunes**
