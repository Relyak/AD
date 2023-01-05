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

/**
 *
 * @author iesjdc
 */
public class Practica1_2mysql {

    public static void main(String[] args) {
        System.out.println("practica 1 modificacion");
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
            //actualizo el primer campo a 18000
            final int SALARIOMODIFICADO=18000;
            rs.first();
            rs.updateFloat("salario", SALARIOMODIFICADO);
            rs.updateRow();
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
