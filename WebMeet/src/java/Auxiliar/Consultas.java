/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Auxiliar;

//import Modelo.Tarea;
import Modelo.ConexionEstatica;
import Modelo.Usuario;

/**
 *
 * @author rodrigo
 */
public class Consultas {

    ///////////////////////////////
    //         USUARIOS          //
    ///////////////////////////////
    private static final String[] CAMPOS_AUXILIAR = {"id", "nombre", "descripcion"};
    private static final String[] CAMPOS_USUARIO = {"id", "activo", "email", "nombre", "apellidos", "descripcion", "genero", "fechaNacimiento", "pais", "ciudad"};
    private static final String[] CAMPOS_PREFERENCIAS = {"id","usuario","preferencia","valor"};
    private static final String[] CAMPOS_MENSAJE= {"id","remitente","destinatario","titulo","mensaje","fecha","leido"};
    //private static final String[] CAMPOS_TAREAS_HISTORICO = {"idTarea","usuario","fechaInicio","fechaFin","horasEmpl"};

    private static String getCampos(String[] campos, String pref) {
        String response = "";
        if (!pref.isBlank()) {
            boolean primero = true;
            for (String campo : campos) {
                if (!primero) {
                    response += ",";
                }
                response += pref + "." + campo;
                primero = false;
            }
        } else {
            response = String.join(",", campos);
        }
        return response;
    }

    /**
     * Recupera los datos de todos los usuarios
     *
     * @return
     */
    public static String getUsuarios() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p")
        + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=p.id) AS roles "
        + "FROM " + Constantes.T_USUARIOS + " p " 
        + "ORDER BY p.apellidos,p.nombre";
    }

    /**
     * Recupera los datos de todos los usuarios
     *
     * @return
     */
    public static String getUsuariosByRol() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p")
        + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=p.id) AS roles "
        + "FROM " + Constantes.T_USUARIOS + " p " 
        + "WHERE p.id IN (SELECT usuario FROM "+Constantes.T_USUARIOS_ROLES+" WHERE rol=?) "
        + "ORDER BY p.apellidos,p.nombre";
    }
    public static String getUsuariosById() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p")
        + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=p.id) AS roles "
        + "FROM " + Constantes.T_USUARIOS + " p " 
        + "WHERE p.id = ? "
        + "ORDER BY p.apellidos,p.nombre";
    }

    /**
     * Recupera los datos de un usuario
     *
     * @return
     */
    public static String getUsuarioByEmail() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p")
        + ",(SELECT GROUP_CONCAT(r.rol) FROM " + Constantes.T_USUARIOS_ROLES + " r WHERE r.usuario=p.id) AS roles "
        + "FROM `" + Constantes.T_USUARIOS + "` p "
        + "WHERE email = ? "
        + "ORDER BY p.apellidos,p.nombre";
    }

    /**
     * Comprueba un usuario por dni && password
     *
     * @return
     */
    public static String testUsuario() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p")
        + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=p.id) AS roles "
        + "FROM " + Constantes.T_USUARIOS + " p "
        + "WHERE p.email = ? AND p.password=? AND activo=1";
    }

    /**
     * Crea una nueva entrada de usuario
     *
     * @param usuario
     * @return
     */
    public static String insertUsuario() {
        String campos = "`activo`,`email`,`password`,`nombre`,`apellidos`,`descripcion`,`genero`,`fechaNacimiento`,`pais`,`ciudad`";
        String valores = "?,?,?,?,?,?,?,?,?,?";

        String consulta = "INSERT INTO " + Constantes.T_USUARIOS + " (" + campos + ") VALUES (" + valores + ");";

        return consulta;
    }

    /**
     * Inserta un nuevo rol para el usuario (int usuario,int rol)
     *
     * @return
     */
    public static String insertUsuarioRol() {
        return "INSERT INTO " + Constantes.T_USUARIOS_ROLES + "(usuario,rol) VALUES (?,?);";
    }

    public static String deleteUsuarioRolesById() {
        return "DELETE FROM " + Constantes.T_USUARIOS_ROLES + " WHERE usuario = ?;";
    }

    /**
     * Actualiza los datos de un usuario
     *
     * @param usuario
     * @return
     */
    public static String updateUsuario(boolean password) {
        String consulta = "UPDATE " + Constantes.T_USUARIOS + " SET ";
        boolean primero = true;
        for(String campo:CAMPOS_USUARIO){
            if(campo!="id"){
                if(!primero)consulta+=",";
                else primero=false;
                consulta+="`"+campo+"`=?";                
            }
        }
        if (password) {
            consulta += ",`password` = ?";
        }
        consulta += " WHERE id = ?";
        return consulta;
    }

    public static String updateUsuarioById(String campo) {
        return "UPDATE " + Constantes.T_USUARIOS + " SET " + campo + " = ? WHERE id = ?";
    }

    /**
     * Actualiza un solo campo del usuario
     *
     * @param dni
     * @param Campo
     * @param Valor
     * @return
     */
    public static String updateUsuarioField(String dni, String Campo, String Valor) {
        return "UPDATE " + Constantes.T_USUARIOS + " SET `" + Campo + "` = '" + Valor + "' WHERE dni = '" + dni + "'";
    }

    /**
     * Elimina el usuario de la base de datos
     *
     * @param dni
     * @return
     */
    public static String deleteUsuario(String dni) {
        return "DELETE FROM " + Constantes.T_USUARIOS + " WHERE dni='" + dni + "'";
    }

    ///////////////////////////////
    //         AUXILIAR          //
    ///////////////////////////////
    public static String getAuxiliar() {
        return "SELECT " + String.join(",", CAMPOS_AUXILIAR) + " FROM " + Constantes.T_AUXILIAR + " WHERE tipo= ? ORDER BY nombre;";
    }

    public static String getPreferenciasById() {
        return "SELECT "+getCampos(CAMPOS_PREFERENCIAS,"p")+",a.nombre "
                + "FROM "+Constantes.T_USUARIOS_PREFERENCIAS+" p "
                + "RIGHT JOIN "+Constantes.T_AUXILIAR+" a ON a.id=p.preferencia "
                + "WHERE usuario = ?;";
    }

    public static String insertPreferencia() {
        return "INSERT INTO "+Constantes.T_USUARIOS_PREFERENCIAS+" (usuario,preferencia,valor) VALUES (?,?,?)"
                + "ON DUPLICATE KEY UPDATE valor=?";
    }

    public static String getAmigosById() {
        return "SELECT " +getCampos(CAMPOS_USUARIO, "u")
                + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=u.id) AS roles "
                + "FROM "+Constantes.T_USUARIOS_AMISTADES+" a " 
                + "LEFT JOIN "+Constantes.T_USUARIOS+ " u ON u.id=IF(a.usuario1= ? ,a.usuario2,a.usuario1) "
                + "WHERE (a.usuario1= ? || a.usuario2= ?) AND a.aceptada=1";
    }
    public static String getAmigosPendientesById() {
        return "SELECT " +getCampos(CAMPOS_USUARIO, "u")
                + ",(SELECT GROUP_CONCAT(r.rol) FROM "+Constantes.T_USUARIOS_ROLES+" r WHERE r.usuario=u.id) AS roles "
                + "FROM "+Constantes.T_USUARIOS_AMISTADES+" a " 
                + "LEFT JOIN "+Constantes.T_USUARIOS+ " u ON u.id=IF(a.usuario1= ? ,a.usuario2,a.usuario1) "
                + "WHERE (a.usuario1= ? || a.usuario2= ?) AND a.aceptada=0";
    }
    public static String getNoAmigosById() {
        return "SELECT " +getCampos(CAMPOS_USUARIO, "u")+" "
                + "FROM "+Constantes.T_USUARIOS+" u "
                + "RIGHT JOIN "+Constantes.T_USUARIOS_ROLES+" r ON r.usuario=u.id AND r.rol="+Constantes.ROL_USER+" "
                + "WHERE u.id!= ? AND u.id NOT IN("
                    + "SELECT usuario1 AS usuario FROM "+Constantes.T_USUARIOS_AMISTADES+" WHERE usuario2=? " 
                    + "UNION "
                    + "SELECT usuario2 AS usuario FROM "+Constantes.T_USUARIOS_AMISTADES+" WHERE usuario1=?);";
    }

    public static String getUsuarioMensajesRecibidos() {
        return "SELECT "+getCampos(CAMPOS_MENSAJE,"m")+", CONCAT(u.nombre,' ',u.apellidos) AS remitenteNombre "
                + "FROM "+Constantes.T_MENSAJES+" m "
                + "LEFT JOIN "+Constantes.T_USUARIOS+" u ON u.id=m.remitente "
                + "WHERE m.destinatario=? ORDER BY fecha DESC;";
    }
    public static String getUsuarioMensajesEnviados() {
        return "SELECT "+getCampos(CAMPOS_MENSAJE,"m")+", CONCAT(u.nombre,' ',u.apellidos) AS destinatarioNombre "
                + "FROM "+Constantes.T_MENSAJES+" m "
                + "LEFT JOIN "+Constantes.T_USUARIOS+" u ON u.id=m.destinatario "
                + "WHERE m.remitente=? ORDER BY fecha DESC;";
    }
    public static String getMensajeById(){
        return "SELECT "+getCampos(CAMPOS_MENSAJE, "m")+ " "
                + "FROM "+Constantes.T_MENSAJES+" m "
                + "WHERE m.id = ?";
    }

    public static String insertMensaje() {
        return "INSERT INTO " + Constantes.T_MENSAJES 
                + "(remitente,destinatario,titulo,mensaje) VALUES (?,?,?,?);";
    }

    public static String leerMensaje() {
        return "UPDATE "+Constantes.T_MENSAJES+" SET leido=1 WHERE id=?";
    }

    public static String borrarMensaje() {
        return "DELETE FROM "+Constantes.T_MENSAJES+" WHERE id=?";
    }
    public static String aceptarAmistad(){
        return "UPDATE "+Constantes.T_USUARIOS_AMISTADES+" SET aceptada=1 WHERE (usuario1=? AND usuario2=?) OR (usuario1=? AND usuario2=?);";
    }

    public static String deleteAmistad() {
        return "DELETE FROM "+Constantes.T_USUARIOS_AMISTADES+" WHERE (usuario1=? AND usuario2=?) OR (usuario1=? AND usuario2=?);";
    }

    public static String insertAmistad() {
        return "INSERT INTO "+Constantes.T_USUARIOS_AMISTADES+" (usuario1,usuario2) VALUE (?,?);";
    }
}
