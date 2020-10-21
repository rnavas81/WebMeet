package Modelo;

import Auxiliar.Constantes;
import Auxiliar.Consultas;
import Auxiliar.Funciones;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedList;
import javax.swing.JOptionPane;

public class ConexionEstatica {

    //********************* Atributos *************************
    private static java.sql.Connection Conex;
    //Atributo a través del cual hacemos la conexión física.
    private static java.sql.Statement Sentencia_SQL;
    private static java.sql.PreparedStatement Sentencia_preparada;
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
            p = new Usuario(
                Conj_Registros.getInt("id"),
                Conj_Registros.getInt("activo"),
                Conj_Registros.getString("email"),
                Conj_Registros.getString("nombre")!=null?Conj_Registros.getString("nombre"):"",
                Conj_Registros.getString("apellidos")!=null?Conj_Registros.getString("apellidos"):"",
                Conj_Registros.getString("descripcion")!=null?Conj_Registros.getString("descripcion"):"",
                Conj_Registros.getInt("genero"),
                Conj_Registros.getString("fechaNacimiento")!=null?Conj_Registros.getString("fechaNacimiento"):"",
                Conj_Registros.getString("pais")!=null?Conj_Registros.getString("pais"):"",
                Conj_Registros.getString("ciudad")!=null?Conj_Registros.getString("ciudad"):""
            );
            try {
                if(Conj_Registros.getString("roles")!=null){
                    String[] roles = Conj_Registros.getString("roles").split(",");
                    for(String rol:roles){
                        p.setRol(Integer.parseInt(rol));
                    }                
                }
            } catch (Exception e) {
                System.err.println("recogerDatosUsuarioRol[Error] "+e.getMessage());
            }
        } catch (Exception e) {
            System.err.println(e.getCause());
            System.err.println("recogerDatosUsuario[Error] "+e.getMessage());
            p=null;
        }
        return p;
    }
    
    private static Mensaje recogerDatosMensaje() {
        Mensaje item;
        try {
            String nombreRemitente=null,nombreDestinatario=null;
            try {
                nombreRemitente = Conj_Registros.getString("remitenteNombre");
            } catch (Exception e) {
                nombreRemitente = null;
            }
            try {
                nombreDestinatario = Conj_Registros.getString("destinatarioNombre");
            } catch (Exception e) {
                nombreDestinatario = null;
            }
            item = new Mensaje(
                    Conj_Registros.getInt("id"),
                    Conj_Registros.getInt("remitente"),
                    nombreRemitente, 
                    Conj_Registros.getInt("destinatario"), 
                    nombreDestinatario, 
                    Conj_Registros.getString("titulo"),
                    Conj_Registros.getString("mensaje"),
                    Conj_Registros.getTimestamp("fecha"),
                    Conj_Registros.getInt("leido")
            );
        } catch (Exception e) {
            System.err.println(e.getCause());
            System.err.println("recogerDatosMensaje[Error] "+e.getMessage());
            item=null;
        }
        return item;
        
    }
    public static Usuario existeUsuario(String email) {
        Usuario existe = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            //ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.getUsuario(dni));
            Sentencia_preparada = Conex.prepareStatement(Consultas.getUsuarioByEmail());
            Sentencia_preparada.setString(1, email);       
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
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
            //ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(Consultas.testUsuario(email, password));
            Sentencia_preparada = Conex.prepareStatement(Consultas.testUsuario());
            Sentencia_preparada.setString(1, email);
            Sentencia_preparada.setString(2, Funciones.encriptarTexto(password));
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                existe = recogerDatosUsuario();
            }
        } catch (Exception ex) {
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
     * @param rol
     * @return
     */
    public static LinkedList<Usuario> obtenerUsuarios(int rol) {
        LinkedList<Usuario> personasBD = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getUsuariosByRol());
            Sentencia_preparada.setInt(1, rol);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            Usuario element;
            while (Conj_Registros.next()) {
                element = recogerDatosUsuario();
                if(element!=null)personasBD.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            personasBD = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personasBD;
    }    
    public static Usuario obtenerUsuarioById(int id) {
        Usuario personasBD = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getUsuariosById());
            Sentencia_preparada.setInt(1, id);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            if (Conj_Registros.next()) {
                personasBD = recogerDatosUsuario();
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarioById[Error] "+ex.getMessage());
            personasBD = null;
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
                if(p!=null)personas.put(p.getId(), p);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios2[Error] "+ex.getMessage());
            personas = new HashMap<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personas;
    }

    /**
     * Comprueba si existe una entrada con el mismo dni.Si no existe agrega una
 entrada con la persona
     *
     * @param usuario
     * @param password
     * @return
     */
    public static boolean agregarUsuario(Usuario usuario,String password) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.insertUsuario());
            Sentencia_preparada.setInt(1, usuario.getActivo());
            Sentencia_preparada.setString(2, usuario.getEmail());
            Sentencia_preparada.setString(3, Funciones.encriptarTexto(password));
            Sentencia_preparada.setString(4, usuario.getNombre());
            Sentencia_preparada.setString(5, usuario.getApellidos());
            Sentencia_preparada.setString(6, usuario.getDescripcion());
            Sentencia_preparada.setInt(7, usuario.getGenero());
            Sentencia_preparada.setString(8, usuario.getFechaNacimiento().isBlank()?null:usuario.getFechaNacimiento());
            Sentencia_preparada.setString(9, usuario.getPais());
            Sentencia_preparada.setString(10, usuario.getCiudad());
            hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
            if(hecho){
                usuario = existeUsuario(usuario.getEmail());
                for(int rol:usuario.getRoles()){
                    try {
                        Sentencia_preparada = Conex.prepareStatement(Consultas.insertUsuarioRol());
                        Sentencia_preparada.setInt(1, usuario.getId());
                        Sentencia_preparada.setInt(2, rol);
                        ConexionEstatica.Sentencia_preparada.executeUpdate();
                    } catch (Exception e) {
                        System.err.println("agregarUsuarioRol[Error] "+e.getMessage());
                    }
                }
            }
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }
    public static boolean cambiarCampoUsuario(String campo,String valor,String email){
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Usuario usuario = existeUsuario(email);
            if (usuario != null) {
                Sentencia_preparada = Conex.prepareStatement(Consultas.updateUsuarioById(campo));
                Sentencia_preparada.setString(1, valor);
                Sentencia_preparada.setInt(2, usuario.getId());
                hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
                //ConexionEstatica.Sentencia_SQL.executeUpdate(Consultas.insertUsuario(persona,password));
            }
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
        
    }
    public static boolean cambiarCampoUsuario(String campo,String valor,int id){
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.updateUsuarioById(campo));
            Sentencia_preparada.setString(1, valor);
            Sentencia_preparada.setInt(2, id);
            hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
        
    }
    public static boolean activarUsuario(int id){
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(
                "UPDATE "+Constantes.T_USUARIOS+" SET activo=IF(activo=1,0,1) WHERE id=?;"
            );
            Sentencia_preparada.setInt(1, id);
            hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
        } catch (SQLException ex) {
            System.err.println("agregarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
        
    }

    public static boolean eliminarUsuario(int id) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(
                "DELETE FROM "+Constantes.T_USUARIOS+" WHERE id=?;"
            );
            Sentencia_preparada.setInt(1, id);
            hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
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
    public static boolean actualizarUsuario(Usuario usuario,String password) {
        boolean hecho = false;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            
            Sentencia_preparada = Conex.prepareStatement(Consultas.updateUsuario(!password.isBlank()));
            Sentencia_preparada.setInt(1, usuario.getActivo());
            Sentencia_preparada.setString(2, usuario.getEmail());
            Sentencia_preparada.setString(3, usuario.getNombre());
            Sentencia_preparada.setString(4, usuario.getApellidos());
            Sentencia_preparada.setString(5, usuario.getDescripcion());
            Sentencia_preparada.setInt(6, usuario.getGenero());
            Sentencia_preparada.setString(7, usuario.getFechaNacimiento().isBlank()?null:usuario.getFechaNacimiento());
            Sentencia_preparada.setString(8, usuario.getPais());
            Sentencia_preparada.setString(9, usuario.getCiudad());
            if(password.isBlank()){
                Sentencia_preparada.setInt(10, usuario.getId());
            } else {
                Sentencia_preparada.setString(10, Funciones.encriptarTexto(password));
                Sentencia_preparada.setInt(11, usuario.getId());            
            }
            hecho = ConexionEstatica.Sentencia_preparada.executeUpdate()>0;
            if(hecho){
                try {
                    Sentencia_preparada = Conex.prepareStatement(Consultas.deleteUsuarioRolesById());
                    Sentencia_preparada.setInt(1, usuario.getId());
                    ConexionEstatica.Sentencia_preparada.executeUpdate();
                    for (Integer role : usuario.getRoles()) {
                        Sentencia_preparada = Conex.prepareStatement(Consultas.insertUsuarioRol());
                        Sentencia_preparada.setInt(1, usuario.getId());
                        Sentencia_preparada.setInt(2, role);
                        ConexionEstatica.Sentencia_preparada.executeUpdate();
                    }                    
                } catch (Exception e) {
                    System.err.println("actualizarUsuarioRoles[Error] "+e.getMessage());
                }
            }
            
        } catch (SQLException ex) {
            System.err.println("actualizarUsuario[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }

        return hecho;
    }
    ///PREFERENCIAS
    public static boolean tienePreferencias(Usuario usuario){
        boolean tiene;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getPreferenciasById());
            Sentencia_preparada.setInt(1, usuario.getId());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            tiene = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("getAuxiliar[Error] "+ex.getMessage());
            tiene = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return tiene;
        
    }
    public static boolean agregarPreferenciaUsuario(Usuario usuario,int idPreferencia,int valor){
        boolean hecho;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.insertPreferencia());
            Sentencia_preparada.setInt(1, usuario.getId());
            Sentencia_preparada.setInt(2, idPreferencia);
            Sentencia_preparada.setInt(3, valor);
            Sentencia_preparada.setInt(4, valor);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            hecho = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("getAuxiliar[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;
        
    }
    ///AMIGOS
    public static LinkedList<Usuario> obtenerAmigos(Usuario usuario){
        LinkedList<Usuario> personasBD = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getAmigosById());
            Sentencia_preparada.setInt(1, usuario.getId());
            Sentencia_preparada.setInt(2, usuario.getId());
            Sentencia_preparada.setInt(3, usuario.getId());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            Usuario element;
            while (Conj_Registros.next()) {
                element = recogerDatosUsuario();
                if(element!=null)personasBD.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            personasBD = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personasBD;
    }    
    ///NO AMIGOS
    public static LinkedList<Usuario> obtenerNoAmigos(Usuario usuario){
        LinkedList<Usuario> personasBD = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getNoAmigosById());
            Sentencia_preparada.setInt(1, usuario.getId());
            Sentencia_preparada.setInt(2, usuario.getId());
            Sentencia_preparada.setInt(3, usuario.getId());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            Usuario element;
            while (Conj_Registros.next()) {
                element = recogerDatosUsuario();
                if(element!=null)personasBD.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            personasBD = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return personasBD;
    }
    public static boolean eliminarAmistad(int id1,int id2){
        boolean hecho;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.deleteAmistad());
            //remitente,destinatario,titulo,mensaje
            Sentencia_preparada.setInt(1, id1);
            Sentencia_preparada.setInt(2, id2);
            Sentencia_preparada.setInt(3, id2);
            Sentencia_preparada.setInt(4, id1);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            hecho = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("agregarMensaje[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;  
        
    }
    ///MENSAJES
    public static Mensaje obtenerMensaje(int id){
        Mensaje mensaje = null;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getMensajeById());
            Sentencia_preparada.setInt(1, id);
            System.out.println(Sentencia_preparada);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            if(Conj_Registros.next()) {
                mensaje = recogerDatosMensaje();
                System.out.println(mensaje.getTitulo());
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            mensaje = null;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return mensaje;
    }
    public static LinkedList<Mensaje> obtenerMensajesRecibidos(Usuario usuario){
        LinkedList<Mensaje> lista = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getUsuarioMensajesRecibidos());
            Sentencia_preparada.setInt(1, usuario.getId());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            Mensaje element;
            while (Conj_Registros.next()) {
                element = recogerDatosMensaje();
                if(element!=null)lista.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            lista = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return lista;
        
    }    
    public static LinkedList<Mensaje> obtenerMensajesEnviados(Usuario usuario){
        LinkedList<Mensaje> lista = new LinkedList<>();
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getUsuarioMensajesEnviados());
            Sentencia_preparada.setInt(1, usuario.getId());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            Mensaje element;
            while (Conj_Registros.next()) {
                element = recogerDatosMensaje();
                if(element!=null)lista.add(element);
            }
        } catch (SQLException ex) {
            System.err.println("obtenerUsuarios[Error] "+ex.getMessage());
            lista = new LinkedList<>();
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return lista;
        
    }
    public static boolean agregarMensaje(Mensaje mensaje){
        boolean hecho;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.insertMensaje());
            //remitente,destinatario,titulo,mensaje
            Sentencia_preparada.setInt(1, mensaje.getRemitente());
            Sentencia_preparada.setInt(2, mensaje.getDestinatario());
            Sentencia_preparada.setString(3, mensaje.getTitulo());
            Sentencia_preparada.setString(4, mensaje.getMensaje());
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            hecho = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("agregarMensaje[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;        
    }
    public static boolean leerMensaje(int id){
        boolean hecho;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.leerMensaje());
            Sentencia_preparada.setInt(1, id);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            hecho = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("agregarMensaje[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;
    }
    public static boolean borrarMensaje(int id){
        boolean hecho;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.borrarMensaje());
            //remitente,destinatario,titulo,mensaje
            Sentencia_preparada.setInt(1, id);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
            hecho = Conj_Registros.next();
        } catch (SQLException ex) {
            System.err.println("agregarMensaje[Error] "+ex.getMessage());
            hecho = false;
        } finally {
            if(!estabaAbierta)cerrarBD();
        }
        return hecho;
    }
    ///AUXILIAR
    private static LinkedList<Auxiliar> getAuxiliar(int tipo) {
        LinkedList<Auxiliar> cosasBD = new LinkedList<>();
        Auxiliar item;
        boolean estabaAbierta = true;
        try {
            if(Conex==null || Conex.isClosed()){
                estabaAbierta = false;
                abrirBD();
            }
            Sentencia_preparada = Conex.prepareStatement(Consultas.getAuxiliar());
            Sentencia_preparada.setInt(1, tipo);
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_preparada.executeQuery();
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
