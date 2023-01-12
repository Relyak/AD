/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mipractica3;
/**
 *
 * @author rocas
 */

public class MiVersion {

    private static Empleaditos BD;

    public MiVersion() throws ClassNotFoundException,
            java.sql.SQLException, InstantiationException,
            IllegalAccessException {
        // Realizar la conexi n con la base de datos BD
        BD = new Empleaditos();
    }

    //Inserta un empleadito
    public void insertarFilaEnEmpleaditos()
            throws java.sql.SQLException {
        System.out.print("Nombre: ");
        String nombre = Leer.dato();
        System.out.print("Apellido: ");
        String apellido = Leer.dato();
        System.out.print("Salario: ");
        int salario = Leer.datoInt();
        System.out.print("Funcion: ");
        String funcion = Leer.dato();      

        BD.insertarFilaEnEmpleaditos(nombre,apellido,salario,funcion);
    }
    //borra un empleado con ID 
    public void borrarFilaEnEmpleaditos()
            throws java.sql.SQLException {
        int ID;

        System.out.print("\nIdentificador: ");
        ID = Leer.datoInt();
        BD.borrarFilaEnEmpleaditos(ID);
    }

    
    public static int menu(String[] opciones, int numOpciones) {
        int i = 0, opcion = 0;

        System.out.println("\n____________________________________\n");
        for (i = 1; i <= numOpciones; ++i) {
            System.out.print("    " + i + ". " + opciones[i - 1] + "\n");
        }
        System.out.println("____________________________________\n");
        do {
            System.out.print("\nOpcion (1 - " + numOpciones + "): ");
            opcion = Leer.datoInt();
        } while (opcion < 1 || opcion > numOpciones);
        return opcion;
    }

    public static void main(String args[]) {
        int i = 0, opcion = 0;
        MiVersion objAp = null;

        try {
            objAp = new MiVersion();

            // Opciones del menu
            String[] opciones = {
                "Mostrar empleados",
                "Contratar empleado ",
                "Despedir empleado",
                "Mostrar un empleado",
                "Modificar sueldo a un empleado",
                "Modificar cargo de un empleado",
                "Salir"};

            do {
                switch (opcion = objAp.menu(opciones, opciones.length)) {
                    case 1:
                         BD.datosEmpleaditos();
                        
                        break;
                    case 2:
                        objAp.insertarFilaEnEmpleaditos();
                        break;
                    case 3:
                        objAp.borrarFilaEnEmpleaditos();
                        break;
                    case 4:
                        BD.mostrarEmpleadito();
                        break;
                    case 5:
                        BD.modificarSueldoEmpleadito();
                        break;
                    case 6:
                        BD.modificarCargoEmpleadito();
                        break;
                    case 7:
                        break;
                       
                    
                }
            } while (opcion != 6);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        } catch (InstantiationException e) {
            System.out.print(e.getMessage());
        } catch (IllegalAccessException e) {
            System.out.print(e.getMessage());
        } catch (java.sql.SQLException e) {
            System.out.print(e.getMessage());
        } finally // pase lo que pase cerramos la conexi n
        {
            try {
                BD.cerrarConexion();
            } catch (java.sql.SQLException ignorada) {
            }
        }
    }
}
