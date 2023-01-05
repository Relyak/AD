/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package segundaeva;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Practica1_3mysql {
        public static void main(String[] args) {
        System.out.println("practica 1 anadir");
        // TODO code application logic here
        try {
// Cargamos la clase que implementa el Driver
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
            String url = "jdbc:mysql://localhost:3306/mysql?serverTimezone=UTC";
            Connection conn = DriverManager.getConnection(url, "root", "");
// Obtenemos un Statement de la conexión
            Statement st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            // Ejecutamos una consulta SELECT para obtener la tabla vendedores
            String sql = "SELECT * FROM vendedores";
            ResultSet rs = st.executeQuery(sql);
            //inserto datos
            rs.moveToInsertRow();
            rs.updateInt("id", 2);
            rs.updateString("nombre","NUEVO NOMBRE ANADIR");
            //123=2023, 0=mes, 5=dia
            Date fechaCreacion= new Date(123,0,5); 
            rs.updateDate("fecha_ingreso",fechaCreacion);
            final float NUEVOSALARIO=99999;
            rs.updateFloat("salario",NUEVOSALARIO);
            rs.insertRow();
            //otra vez ejecuto el select * from vendedores
            rs = st.executeQuery(sql);
            // Recorremos todo el ResultSet y mostramos sus datos
            while (rs.next()) {
                int id = rs.getInt("id");
                String nombre = rs.getString("nombre");
                Date fecha = rs.getDate("fecha_ingreso");
                float salario = rs.getFloat("salario");
                System.out.println(id + " " + nombre + " " + fecha + " " + salario);
            }
// Cerramos el statement y la conexión
            st.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
