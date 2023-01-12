/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mipractica3;

import java.sql.Connection;
import java.util.Scanner;

/**
 *
 * @author rocas
 */
public class Empleaditos {

    private java.sql.Connection conexion;
    private java.sql.Statement sentenciaSQL;
    private java.sql.ResultSet cdr; // conjunto de resultados
    private Connection n;
    private Scanner sc = new Scanner(System.in);

    public Empleaditos() throws ClassNotFoundException, java.sql.SQLException,
            InstantiationException, IllegalAccessException {
        // Cargar el controlador JDBC
        String controlador = "com.mysql.cj.jdbc.Driver";
        Class.forName(controlador).newInstance();
        conectar(); // conectar con la fuente de datos
    }

    public void conectar() throws java.sql.SQLException {
        String URL_bd = "jdbc:mysql://localhost:3306/mysql?serverTimezone=UTC";
        String usuario = "root";
        String pw = "";
        // Conectar con la BD
        conexion = java.sql.DriverManager.getConnection(
                URL_bd, usuario, pw);
        // Crear una sentencia SQL
        sentenciaSQL = conexion.createStatement(
                java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                java.sql.ResultSet.CONCUR_UPDATABLE);
        System.out.println("\nConexion realizada con exito.\n");
        // Mostrar las tablas de la base de datos
        System.out.println("DATOS DE LA TABLA EMPLEADITOS: \n");
        String[] tabla = tablas();
        for (int i = 0; i < tabla.length; ++i) {
            System.out.println(tabla[i]);
        }
    }

    public void datosEmpleaditos() throws java.sql.SQLException {
        cdr = sentenciaSQL.executeQuery("Select * FROM empleaditos");
        int id = 0, salario = 0;
        String nombre, apellido, funcion;
        while (cdr.next()) {

            id = cdr.getInt(1);
            nombre = cdr.getString(2);
            apellido = cdr.getString(3);
            salario = cdr.getInt(4);
            funcion = cdr.getString(5);
            System.out.println(id + " " + nombre + " " + apellido + " " + salario + " " + funcion);
        }
    }

    public void cerrarConexion() throws java.sql.SQLException {
        if (cdr != null) {
            cdr.close();
        }
        if (sentenciaSQL != null) {
            sentenciaSQL.close();
        }
        if (conexion != null) {
            conexion.close();
        }
    }

    public String[] tablas() throws java.sql.SQLException {
        cdr = sentenciaSQL.executeQuery("SELECT * FROM empleaditos;");
        cdr.last(); // mover el cursor a la ultima fila
        String[] tablas = new String[cdr.getRow()];
        cdr.beforeFirst(); // mover el cursor a su posici n inicial
        int id = 0, salario = 0;
        String nombre, apellido, funcion;
        while (cdr.next()) {
            nombre = cdr.getString(2);
            apellido = cdr.getString(3);
            salario = cdr.getInt(4);
            funcion = cdr.getString(5);
            tablas[id++] = (id + " " + nombre + " " + apellido + " " + salario + " " + funcion);
        }
        return tablas;
    }

    //mostrar toda la tabla
    public java.sql.ResultSet mostrarTodosEmpleaditos() throws java.sql.SQLException {
        cdr = sentenciaSQL.executeQuery(
                "SELECT * FROM " + "empleaditos");
        return cdr;
    }

    //anadir un empleado
    public void insertarFilaEnEmpleaditos(String nombre, String apellido, int salario, String funcion)
            throws java.sql.SQLException {
        sentenciaSQL.executeUpdate("INSERT INTO " + "empleaditos (nombre,apellido,salario,funcion)"
                + " VALUES ('" + nombre + "', '" + apellido + "'," + salario + ", '" + funcion + "')"
        );
        System.out.println("Empleado anadido");
    }

    //borrar un empleado
    public void borrarFilaEnEmpleaditos(int ID)
            throws java.sql.SQLException {
        sentenciaSQL.executeUpdate("DELETE FROM " + "empleaditos"
                + " WHERE id = " + ID);
        System.out.println("Empleado con ID: " + ID + " despedido");
    }

    //mostrar un empleado específico
    public void mostrarEmpleadito() throws java.sql.SQLException {
        System.out.print("Numero de empleado: ");
        int idemp = sc.nextInt();
        cdr = sentenciaSQL.executeQuery("Select * FROM " + "empleaditos"
                + " WHERE id = " + idemp);
        int id = 0, salario = 0;
        String nombre, apellido, funcion;
        while (cdr.next()) {
            nombre = cdr.getString("nombre");
            apellido = cdr.getString("apellido");
            salario = cdr.getInt("salario");
            funcion = cdr.getString("funcion");
            System.out.println((idemp + " " + nombre + " " + apellido + " " + salario + " " + funcion));
        }

    }

    //modificacion de sueldo de un empleado
    public void modificarSueldoEmpleadito() throws java.sql.SQLException {
        System.out.print("Numero de empleado a modificar: ");
        int idemp = sc.nextInt();
        cdr = sentenciaSQL.executeQuery("Select id,nombre,apellido,salario FROM " + "empleaditos"
                + " WHERE id = " + idemp);
        int salario = 0;
        String nombre, apellido;
        while (cdr.next()) {
            nombre = cdr.getString("nombre");
            apellido = cdr.getString("apellido");
            salario = cdr.getInt("salario");
            System.out.println("Empleado con ID: " + idemp + "\nNOMBRE: " + nombre + " " + apellido + "\nSUELDO ACTUAL: " + salario);
        }
        System.out.println("Nuevo sueldo: ");
        int NUEVOSUELDO = sc.nextInt();
        sentenciaSQL.executeUpdate("Update empleaditos set salario=" + NUEVOSUELDO
                + " WHERE id = " + idemp);
        System.out.println("Empleado con id: " + idemp + " ahora tiene un sueldo de " + NUEVOSUELDO);
    }

    public void modificarCargoEmpleadito() throws java.sql.SQLException {
        System.out.print("Numero de empleado a modificar: ");
        int idemp = sc.nextInt();
        cdr = sentenciaSQL.executeQuery("Select id,nombre,apellido,funcion FROM " + "empleaditos"
                + " WHERE id = " + idemp);
        
        String nombre, apellido,funcion;
        while (cdr.next()) {
            nombre = cdr.getString("nombre");
            apellido = cdr.getString("apellido");
            funcion = cdr.getString("funcion");
            System.out.println("Empleado con ID: " + idemp + "\nNOMBRE: " + nombre + " " + apellido + "\nFUNCION ACTUAL: " + funcion);
        }
        System.out.println("Nuevo cargo: ");
        String NUEVOCARGO = sc.next();
        sentenciaSQL.executeUpdate("Update empleaditos set funcion=" + "'"+NUEVOCARGO+"'"
                + " WHERE id = " + idemp);
        System.out.println("\nEmpleado con id: " + idemp + " ahora tiene el cargo "+NUEVOCARGO);
    }

}
