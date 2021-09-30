# Clases Abstractas

Hasta el momento hemos sobreescrito métodos mediante la sobreescritura tanto en la [herencia](Reutilizar%20C%C3%B3digo.md#%C2%BFQu%C3%A9%20es%20la%20Herencia%20Don't%20Repeat%20Yourslef%20DRY) y al momento de aplicar [interfaces](Reutilizar%20C%C3%B3digo.md#Interfaces).

Con las interfaces a veces no es necesario implementar todos los métodos y en caso de la herencia es posible no heredar la implementación de un método.

En la herencia no necesitamos crear instancias de una clase padre, ya que es muy genérica

![La Clase Abstracta](../Resources/Clase_Abstracta.png)

* Una clase abstracta es aquella que no implementa todos los métodos
* No creamos instancias para ellas
* Pueden verse como una combinación entre una interfaz y la herencia.

```java
public abstract class Figura {

}

class Triangulo extends Figura {

}
```

Si aplicamos esto en nuestra clase de `User` se veria de la siguiente manera.

```java
public abstract class User {
}
```

Aunque el resto de las clases hacen uso de la clase `User` para su herencia, como tal **ya no es posible instanciar a esta clase.** Solo se podria hacer lo siguiente

```java
User user = new Doctor("Jeremy Zelaya", "jeremyzelaya@hotmail.es")
```

# Clases Anónimas

Según lo que vimos en la sección pasada, vimos previamente que no es posible instanciar una clase anónima sin utilizar a una de sus subclases. Con una clase anónima es posible saltar esta restricción, pero aún asi el ciclo de vida de esta clase sera mucho mas corto.

Esto significa que este comportamiento funcionara una unica vez durante la ejecución

```java
User user1 = new User("Anahi","ana@mail.com") {
	@Override
	public void showDataUser() {
		System.out.println("Información del Usuario");
	}
};

user1.showDataUser();
```

Esto mismo puede ser utilizado en una interfaz.

```java
ISchedulable iSchedulable = new ISchedulable() {
	@Override
	public void schedulable(Date date, String time) {
		System.out.println("Appointment Data");
	}
};

iSchedulable.schedulable(new Date(), "4 pm");

ISchedulable iSchedulable1 = new AppointmentDoctor();  
iSchedulable1.schedulable(new Date() , "6 p,");
```

Un uso practico es en el dessarollo en Android, cuando se desea sobreescribir un método de `onClick`.

Esta practica ha sido mejorada en Java mediante la programación funcional y lambdas.

# Diferencia Entre las Interfaces y las Clases Abstractas

Una clase abstracta se usara para generar subclases, se encuentra restringida por no poder generar instancias ni objetos a partir de ella y esto signidica que se hereda de forma lineal. Unicamente nos servira para redefinir nuevas clases sin la necesidad de crear nuevos objetos.

Una interfaz se encuentra compuesta por metodos abstractos y no abstractos, estos métodos pueden ser aplicados en multiples familias de clases.

Las intefaces seran utilizadas para implementar métodos en multiples familias de clases

## Creación

Al crear una clase abstracta nos enfocaremos en la creación de objetos y en las clases nos enfocaremos en la creación de acciones que pueden tener muchos objetos.

## Nombrado

En el nombrado usaremos principalmente verbos como `Drawable`, `Runnable`, `Callable` y `Visualizable` y en una clase abstracta sustantivos como `Movie`.

## Buenas Practicas

* El diseño de nuestras aplicaciones deberia estar orientado a interfaces y no a la implementación.
* Concentremonos en crear buenas abstraciones.
* Identificar comportamiento común.
* Enforcarse en la declaración de objetos.

Esto permitira que nuestros programas sean escalables y eficientes.

# Interfaces en Java 8 y 9

Las interfaces como las conocemos ha cambiado desde Java 9, una intefaz debe de contar con métodos abstractos o sea que son muy generales, podemos aplicar polimorfismo en las clases que implementan estas intefaces.

En Java 8 una interfaz requieren métodos abstracos, es posible tener un modificador `default` en Java 8 y en Java 9 es posible tener `private`, esto significa que aquellas clases con estos modificadores tienen una implementación o sea un comportamiento

Se sigue la misma lógica de los modificadores de acceso.

![Encapsulamiento_modificadores_de_acceso](../Resources/Encapsulamiento_modificadores_de_acceso.png)

Aplicado podemos verlo asi

```java
public interface MyInterface {
	default void defaultMethod() {
		privateMethod("Hello from the default method");
	}
	private void privateMethod(final String string){
		System.out.println(string);
	}
	void normalMethod();
}
```

Aca el método `defaultMethod` puede ser invocado desde una clase hija y esta llama a un método privado que no seria accesible para la clase hija; obviamente el `normalMethod()` es obligatorio para implementar.

# Herencia en Intefaces

Las interfaces pueden heredar de otras interfaces utilizando la palabra clave extends, el concepto de herencia se aplicará como naturalmente se practica en clases, es decir, la interfaz heredará y adquirirá los métodos de la interfaz padre.

Una cosa interesante que sucede en caso de herencia con interfaces es que, aquí sí es permitido la herencia múltiple como ves a continuación:

```java
public interface IReadable {
	public void read();
}


public interface Visualizable extends IReadable, Serializable {
	public void setViewed();
	public Boolean isViewed();
	public String timeViewed();
}
```

Además siguiendo las implementaciones de métodos default y private de las versiones Java 8 y 9 respectivamente podemos sobreescribir métodos y añadirles comportamiento, si es el caso.

```java
public interface Visualizable extends IReadable, Serializable {
	public void setViewed();
	public Boolean isViewed();
	public String timeViewed();
	
	@Override
		default void read() {
		// TODO Auto-generated method stub
	}
}

```