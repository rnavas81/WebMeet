package Modelo;

import Auxiliar.Constantes;
import Auxiliar.Consultas;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedList;
import javax.swing.JOptionPane;

public class ConexionEstatica {

    //********************* Atributos *************************
    private static java.sql.Connection Conex;
    //Atributo a través del cual hacemos la conexión física.
    private static java.sql.Statement Sentencia_SQL;
    //Atributo que nos permite ejecutar una sentencia SQL
    private static java.sql.ResultSet Conj_Registros;

    public static void abrirBD() {
        try {
            //Cargar el driver/controlador
            //String controlador = "com.mysql.jdbc.Driver";
            //String controlador = "com.mysql.cj.jdbc.Driver";
            //String controlador = "oracle.jdbc.driver.OracleDriver";
            //String controlador = "sun.jdbc.odbc.JdbcOdbcDriver"; 
            String controlador = "org.mariadb.jdbc.Driver"; // MariaDB la version libre de MySQL (requiere incluir la librería jar correspondiente).
            //Class.forName("org.mariadb.jdbc.Driver");              
            //Class.forName(controlador).newInstance();
            Class.forName(controlador);
            //Class.forName("com.mysql.jdbc.Driver"); 

            //String URL_BD = "jdbc:mysql://localhost:3306/" + Constantes.BBDD;
            //String URL_BD = "jdbc:mariadb://"+"localhost:3306"+"/"+Constantes.BBDD;
            //String URL_BD = "jdbc:oracle:oci:@REPASO";
            //String URL_BD = "jdbc:oracle:oci:@REPASO";
            //String URL_BD = "jdbc:odbc:REPASO";
            //String connectionString = "jdbc:mysql://localhost:3306/" + Constantes.BBDD + "?user=" + Constantes.usuario + "&password=" + Constantes.password + "&useUnicode=true&characterEncoding=UTF-8";
            //Realizamos la conexión a una BD con un usuario y una clave.
            //Conex = java.sql.DriverManager.getConnection(connectionString);
            //Conex = java.sql.DriverManager.getConnection(URL_BD, Constantes.usuario, Constantes.password);
            Conex = DriverManager.getConnection(
                    "jdbc:mariadb://localhost:3306/" + Constantes.DB_NAME, Constantes.DB_USER, Constantes.DB_PASS);
            Sentencia_SQL = Conex.createStatement();
            System.out.println("Conexion realizada con éxito");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Exception: " + e.getMessage());
        }
    }

    public static void cerrarBD() {
        try {
            // resultado.close();
            Conex.close();
            System.out.println("Desconectado de la Base de Datos"); // Opcional para seguridad
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "Error de Desconexion", JOptionPane.ERROR_MESSAGE);
        }
    }
    private static Usuario recogerDatosUsuario() {
        Usuario p;
        try {
            //String dni, String username, int tipo, String nombre, String apellidos, String email, String avatar, String password
            p = new Usuario(
                Conj_Registros.getInt("id"),
                Conj_Registros.getInt("activo"),
                Conj_Registros.getString("email"),
                Conj_Registros.getString("password"),
                Conj_Registros.getString("nombre")!=null?Conj_Registros.getString("nombre"):"",
                Conj_Registros.getString("apellidos")!=null?Conj_Registros.getString("apellidos"):"",
                Conj_Registros.getString("descripcion")!=null?Conj_Registros.getString("descripcion"):"",
                Conj_Registros.getInt("genero"),
                Conj_Registros.getString("fechaNacimiento")!=null?Conj_Registros.getString("fechaNacimiento"):"",
                Conj_Registros.getString("pais")!=null?Conj_Registros.getString("pais"):"",
                Conj_Registros.getString("ciudad")!=null?Conj_Registros.getString("ciudad"):""
            );            
        } catch (SQLException e) {
            System.err.println("recogerDatosUsuario[Error] "+e.getMessage());
            p=null;
        }
        return p;
    }
    /*
    private static Tarea recogerDatosTarea() {
        Tarea item;
        try {
            //int id, String descripcion, int horasPrev, int horasEmpl, int nivelDiff, int finalizado
            item = new Tarea(
                Conj_Registros.getInt("id"),
                Conj_Registros.getString("descripcion"),
                Conj_Registros.getString("usuario"),
                Conj_Registros.getInt("horasPrev"),
                Conj_Registros.getInt("horasEmpl"),
                Conj_Registros.getInt("nivelDiff"),
                Conj_Registros.getInt("finalizado")
            );            
        } catch (SQLException e) {
            System.err.println("recogerDatosTarea[Error] "+e.getMessage());
            item=null;
        }
        return item;
    }
    */
    public static Usuario existeUsuario(String dni) {
        Usuario existe = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getUsuario(dni));
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                existe = recogerDatosUsuario();
            }
        } catch (SQLException ex) {
            System.err.println("existeUsuario[Error] "+ex.getMessage());
            existe = null;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return existe;//Si devolvemos null el usuario no existe.
    }

    /**
     * Comprueba si un usuario puede acceder al sistema
     *
     * @param email
     * @param password
     * @return Usuario o null
     */
    public static Usuario accederUsuario(String email, String password) {
        Usuario existe = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.testUsuario(email, password));
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                existe = recogerDatosUsuario();
            }
        } catch (SQLException ex) {
            System.err.println("accederUsuario[Error] "+ex.getMessage());
            existe = null;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return existe;//Si devolvemos null el usuario no existe.

    }

    /**
     * Usando una LinkedList.
     *
     * @return
     */
    public static LinkedList<Usuario> obtenerUsuarios() {
        LinkedList<Usuario> personasBD = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getUsuarios());
            Usuario element;
            while (Conj_Registros.next()) {
                element = recogerDatosUsuario();
                personasBD.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            personasBD = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personasBD;
    }

    /**
     * Usando una tabla Hash.
     *
     * @return
     */
    public static HashMap<Integer, Usuario> obtenerUsuarios2() {
        HashMap<Integer, Usuario> personas = new HashMap<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getUsuarios());
            Usuario p;
            while (Conj_Registros.next()) {
                p = recogerDatosUsuario();
                personas.put(p.getId(), p);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios2[Error] "+ex.getMessage());
            personas = new HashMap<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personas;
    }

    public static boolean eliminarUsuario(String dni) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.deleteUsuario(dni));
        } catch (SQLException ex) {
            System.err.println("eliminarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;
    }

    /**
     * Comprueba si existe una entrada con el mismo dni. Si no existe agrega una
     * entrada con la persona
     *
     * @param persona
     * @return
     */
    public static boolean agregarUsuario(Usuario persona) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            if (existeUsuario(persona.getEmail()) == null) {
                ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.insertUsuario(persona));
                hecho = true;
            }
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }
    /**
     * Comprueba si existe una entrada con el mismo dni. Si no existe agrega una
     * entrada con la persona
     *
     * @param persona
     * @return
     */
    public static boolean actualizarUsuario(Usuario persona) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            if (existeUsuario(persona.getEmail()) != null) {
                ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.updateUsuario(persona));                
                hecho = true;
            }
        } catch (SQLException ex) {
            System.err.println("actualizarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }
    ///AUXILIAR
    public static LinkedList<Auxiliar> getAuxiliar(int tipo) {
        LinkedList<Auxiliar> cosasBD = new LinkedList<>();
        Auxiliar item;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getAuxiliar(tipo));
            while (Conj_Registros.next()) {
                item = new Auxiliar(
                        Conj_Registros.getInt("id"),
                        tipo,
                        Conj_Registros.getString("nombre"),
                        Conj_Registros.getString("descripcion")
                );
                cosasBD.push(item);
            }
        } catch (SQLException ex) {
            System.err.println("getAuxiliar[Error] "+ex.getMessage());
            cosasBD = null;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return cosasBD;
    }
    
    //ROLES
    public static LinkedList<Auxiliar> getRolesUsuario() {
        LinkedList<Auxiliar> cosasBD = getAuxiliar(1);
        return cosasBD;
    }

    //PREFERENCIAS
    public static LinkedList<Auxiliar> getPreferencias() {
        LinkedList<Auxiliar> cosasBD = getAuxiliar(2);
        return cosasBD;
    }
    
    //PREFERENCIAS
    public static LinkedList<Auxiliar> getGeneros() {
        LinkedList<Auxiliar> cosasBD = getAuxiliar(3);
        return cosasBD;
    }
    
    //TAREAS
    /*
    public static LinkedList<Tarea> obtenerTareas(){
        LinkedList<Tarea> tareas = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getTareas());
            Tarea element;
            while (Conj_Registros.next()) {
                element = recogerDatosTarea();
                tareas.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerTareas[Error] "+ex.getMessage());
            tareas = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return tareas;
    }
    public static LinkedList<Tarea> obtenerTareas(Usuario u){
        LinkedList<Tarea> tareas = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getTareas(u));
            Tarea element;
            while (Conj_Registros.next()) {
                element = recogerDatosTarea();
                tareas.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerTareas[Error] "+ex.getMessage());
            tareas = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return tareas;
    }
    public static Tarea obtenerTarea(int id){
        Tarea element = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getTarea(id));
            if(Conj_Registros.next()) {
                element = recogerDatosTarea();
            }
        } catch (SQLException ex) {
            System.err.println("obtenerTareas[Error] "+ex.getMessage());
            element = null;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return element;
        
    }

    public static boolean agregarTarea(Tarea tarea) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.insertTarea(tarea));
            hecho = true;
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }

    public static boolean actualizarTarea(Tarea tarea) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
        ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.updateTarea(tarea));
        hecho = true;
        } catch (SQLException ex) {
            System.err.println("actualizarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }
    */

}
