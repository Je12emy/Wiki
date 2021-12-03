# Simulando Autenticación de Usuarios

Hasta el momento la capa de modelo no se encuentra integrada junto a la capa de UI.

```java
public class UIMenu {

    public static final String [] MONTHS = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
    public static Doctor doctorLogged;
    public static Patient patientLogged;

    public static void showMenu(){
        System.out.println("Welcome to My Appointments");
        System.out.println("Selecciona la opción deseada");

        int response = 0;
        do {
            System.out.println("1. model.Doctor");
            System.out.println("2. model.Patient");
            System.out.println("0. Salir");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response){
                case 1:
                    System.out.println("Doctor");
                    response = 0;
                    authUser(1);
                    break;
                case 2:
                    System.out.println("Patient");
                    response = 0;
                    authUser(2);

                    // showPatientMenu();
                    break;
                case 0:
                    System.out.println("Thank you for you visit");
                    break;
                default:
                    System.out.println("Please select a correct answer");
            }
        }while (response != 0);
    }

    private static void authUser(int userType){
        // UserType = 1 Doctor

        ArrayList<Doctor> doctors = new ArrayList<>();
        doctors.add(new Doctor("Alejando Martínez", "Alejando@mail.com"));
        doctors.add(new Doctor("Karen Sosa", "Karen@mail.com"));
        doctors.add(new Doctor("Rocío Gómez", "rocio@mail.com"));

        // UserType = 2 Patient

        ArrayList<Patient> patients = new ArrayList<>();
        patients.add(new Patient("Anahi Salgado", "anahi@mail.com"));
        patients.add(new Patient("Roberto Rodríguez", "roberto@mail.com"));
        patients.add(new Patient("Carlos Sanchez", "carlos@mail.com"));

        // Falso hasta tener verificación
        boolean emailCorrect = false;

        do {
            System.out.println("Please insert your email: [e@e.com]");
            Scanner sc = new Scanner(System.in);
            String email = sc.nextLine();

            if (userType == 1) {
                for (Doctor d: doctors){
                    if (d.getEmail().equals(email)){
                        emailCorrect = true;
                        // Obtener datos
                        doctorLogged = d;
                        // Show Doctor menu

                    }
                }
            }

            if (userType == 2) {
                for (Patient p: patients){
                    if (p.getEmail().equals(email)){
                        emailCorrect = true;
                        // Obtener datos
                        patientLogged = p;
                        // Show Doctor menu

                    }
                }
            }

        } while(!emailCorrect);
    }
}
```

# Modularizando la UI de Doctores

En una clase nueva vamos a manejar la UI del menu de doctores.

```java
public class UIDoctorMenu {
    public static void showDoctorMenu(){
        int response = 0;

        do {
            System.out.println("\n\n");
            System.out.println("Doctor");
            System.out.println("Welcome" + UIMenu.doctorLogged.getName());
            System.out.println("1. Add available appointment.");
            System.out.println("2. My scheduled appointments.");
            System.out.println("3. Logout.");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response) {
                case 1:
                    showDoctorMenu();
                    break;
                case 2:
                    UIMenu.showMenu();
                    break;
                case 0:
                    break;
            }

        } while(response != 0);
    }

    private void showAddAvailableAppointmentsMenu(){
        int response = 0;
        do {
            System.out.println();
            System.out.println(":: Add Available Appointment");
            System.out.println(":: Select a Month");

            for (int i = 0; i < 3; i++) {
                int j = i + 1;

                System.out.println(j + "." + UIMenu.MONTHS[i]);
            }

            System.out.println("0. Return");
            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            if (response > 0 && response < 4){
                int monthSelected = response;

                System.out.println(monthSelected + " . " + UIMenu.MONTHS[monthSelected]);

                System.out.println("Insert the date available: [dd/mm/yyyy]");
                String date = sc.nextLine();

                System.out.println("Your date is " + date + "\n1. Correct \n2.Change date");


            }else if (response == 0) {
                showDoctorMenu();
            }

        } while(response != 0);
    }
}
```

# Definiendo las Citas Disponibles

Modificaremos el objeto de doctor para recibir un `String` al momento de agregar una cita nueva.

```java
    public static class AvailableAppointment {
        private int id;
        private Date date;
        private String time;
        SimpleDateFormat format = new SimpleDateFormat("dd/mm/yyyy");

        public AvailableAppointment(String date, String time){
            try {
                this.date = format.parse(date);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            this.time = time;
        }

        public Date getDate() {
            return date;
        }

        public String getDate(String DATE) {
            return format.format(this.date);
        }
    }
```

Y en el `UIDoctorMenu` vamos a recibir la fecha, agregaremos la cita al doctor y a este lo agregaremos a una lista.

```java
public class UIDoctorMenu {

    public static ArrayList<Doctor> doctorsAvailableAppointments = new ArrayList<>();

    public static void showDoctorMenu(){
        int response = 0;

        do {
            System.out.println("\n\n");
            System.out.println("Doctor");
            System.out.println("Welcome" + UIMenu.doctorLogged.getName());
            System.out.println("1. Add available appointment.");
            System.out.println("2. My scheduled appointments.");
            System.out.println("3. Logout.");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response) {
                case 1:
                    showDoctorMenu();
                    break;
                case 2:
                    UIMenu.showMenu();
                    break;
                case 0:
                    break;
            }

        } while(response != 0);
    }

    private void showAddAvailableAppointmentsMenu(){
        int response = 0;
        do {
            System.out.println();
            System.out.println(":: Add Available Appointment");
            System.out.println(":: Select a Month");

            for (int i = 0; i < 3; i++) {
                int j = i + 1;

                System.out.println(j + "." + UIMenu.MONTHS[i]);
            }

            System.out.println("0. Return");
            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            if (response > 0 && response < 4){
                int monthSelected = response;

                System.out.println(monthSelected + " . " + UIMenu.MONTHS[monthSelected]);

                System.out.println("Insert the date available: [dd/mm/yyyy]");
                String date = sc.nextLine();

                System.out.println("Your date is " + date + "\n1. Correct \n2.Change date");
                response = Integer.valueOf(sc.nextLine());
                if (response == 2) continue; // vuelve a iniciar el bloque actual de código

                int responseTime = 0;
                String time = "";
                do {
                    System.out.println("Insert the time available for date:" + date + ": [16:00]");
                    time = sc.nextLine();
                    System.out.println("Your time is: " + time + "\n1. Correct \n2.Change time.");

                    responseTime = Integer.valueOf(sc.nextLine());

                } while (responseTime == 2);

                UIMenu.doctorLogged.addAvailableAppointment(date, time);
                checkDoctorAvailableAppointments(UIMenu.doctorLogged);

            }else if (response == 0) {
                showDoctorMenu();
            }

        } while(response != 0);
    }

    private void checkDoctorAvailableAppointments(Doctor doctor){
        if (doctor.getAvailableAppointments().size() > 0 && !doctorsAvailableAppointments.contains(doctor)){
            doctorsAvailableAppointments.add(doctor);
        }
    }
}
```

# Modularizando la UI de Pacientes

Ahora crearemos una UI para que el paciente interacciones con el sistema.

```java
public class UIPatient {
    public static void showPatientMenu(){
        int response = 0;

        do {
            System.out.println("\n\n");
            System.out.println("Patient");
            System.out.println("Welcome " + UIMenu.patientLogged.getName());

            System.out.println("1. Book and appointment");
            System.out.println("2. My appointments");
            System.out.println("3. Logout");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response){
                case 1:
                    break;
                case 2:
                    break;
                case 0:
                    UIMenu.showMenu();
                    break;
            }

        } while (response != 0);
    }

    private static void showBookAppointmentMenu(){
        int response = 0;
        do {
            System.out.println(":: Book an appointment");
            System.out.println(":: Select a date");

            

        }while (response != 0);
    }
}
```

## Recorriendo Estructura de Árbol en Java

Vamos a preparar una UI para la interfaz de pacientes.

```java
public class UIPatient {
    public static void showPatientMenu(){
        int response = 0;

        do {
            System.out.println("\n\n");
            System.out.println("Patient");
            System.out.println("Welcome " + UIMenu.patientLogged.getName());

            System.out.println("1. Book and appointment");
            System.out.println("2. My appointments");
            System.out.println("3. Logout");

            Scanner sc = new Scanner(System.in);
            response = Integer.valueOf(sc.nextLine());

            switch (response){
                case 1:
                    break;
                case 2:
                    break;
                case 0:
                    UIMenu.showMenu();
                    break;
            }

        } while (response != 0);
    }

    private static void showBookAppointmentMenu(){
        int response = 0;
        do {
            System.out.println(":: Book an appointment");
            System.out.println(":: Select a date");
            
            // Numeración de lista de fechas, lista
            // Indice de la fecha que seleccione el usuario
            // [doctors]
            // - Doctor 1
            //  - Appointments
            //      - Fecha 1
            //      - Fecha 2
            // - Doctor 2
            //  - Appointments
            // - Doctor 3
            //  - Appointments
            
            Map<Integer, Map<Integer, Doctor>> doctors = new TreeMap<>();

            // Global map index
            int k = 0;
            // Loop through the doctors with available appointments
            for (int i = 0; i < UIDoctorMenu.doctorsAvailableAppointments.size(); i++) {

                /*
                i: 0 ->
                DOCTOR {
                    name: "FOO",
                    email: "BAR",
                    AvailableAppointments: {}
                }
                 */

                // Create a AvailableAppointment array list with the list of available doctors' AvailableAppointments at index i
                // This arraylist will contain a list of ALL available appointments
                ArrayList<Doctor.AvailableAppointment> availableAppointments
                        = UIDoctorMenu.doctorsAvailableAppointments.get(i).getAvailableAppointments();



                // Create a new map with a index number and a Doctor object
                Map<Integer, Doctor> doctorAppointment = new TreeMap<>();

                /*
                i-> 0,
                availableAppointments:[
                    {
                        date: "20/01/2020",
                        time: "14:00"
                    },
                    {
                        date: "21/01/2020",
                        time: "16:00"
                    },
                    {
                        date: "21/01/2020",
                        time: "17:00"
                    },
                ]
                */

                // Loop through all of the available appointments, this is done to show information
                for (int j = 0; j < availableAppointments.size(); j++) {
                    // Increase the global map index
                    k++;
                    // Exact the appointments for the i doctor
                    System.out.println(k + "." + availableAppointments.get(j).getDate());
                    // Insert into the map a new appointment

                     /*
                    i: 0 ->
                    DOCTOR {
                        name: "FOO",
                        email: "BAR",
                        AvailableAppointments: {}
                    }
                    */

                    doctorAppointment.put(Integer.valueOf(i), UIDoctorMenu.doctorsAvailableAppointments.get(i));
                    // Insert into the global map a new doctor map
                    /*
                    k: 0 ->
                    DOCTOR {
                        name: "FOO",
                        email: "BAR",
                        AvailableAppointments: {}
                    }
                    */
                    doctors.put(Integer.valueOf(k), doctorAppointment);
                }
            }

            Scanner sc = new Scanner(System.in);
            int responseDateSelected = Integer.valueOf(sc.nextLine());

        }while (response != 0);
    }
}
```

