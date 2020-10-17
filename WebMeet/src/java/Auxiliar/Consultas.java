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
    private static final String[] CAMPOS_AUXILIAR = {"id", "nombre","descipcion"};
    private static final String[] CAMPOS_USUARIO = {"id","activo","email","password","nombre","apellidos","descripcion","genero","fechaNacimiento","pais","ciudad"};
    //private static final String[] CAMPOS_TAREAS = {"id", "descripcion","usuario","horasPrev","horasEmpl","nivelDiff","finalizado"};
    //private static final String[] CAMPOS_TAREAS_HISTORICO = {"idTarea","usuario","fechaInicio","fechaFin","horasEmpl"};

    private static String getCampos(String[] campos, String pref) {
        String response = "";
        if(!pref.isBlank()){
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
     * @return 
     */
    public static String getUsuarios() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p") + ", GROUP_CONCAT(r.rol) AS roles "
            + "FROM `" + Constantes.T_USUARIOS + "` p "
            + "RIGHT JOIN " + Constantes.T_USUARIOS_ROLES + " r ON r.usuario = p.id "
            + "ORDER BY p.apellidos,p.nombre";
    }
    /**
     * Recupera los datos de un usuario
     * @return 
     */
    public static String getUsuarioByEmail() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p") + ", GROUP_CONCAT(r.rol) AS roles "
            + "FROM `" + Constantes.T_USUARIOS + "` p "
            + "RIGHT JOIN " + Constantes.T_USUARIOS_ROLES + " r ON r.usuario = p.id "
            + "WHERE email = ?";
    }
    /**
     * Comprueba un usuario por dni && password
     * @return 
     */
    public static String testUsuario() {
        return "SELECT " + getCampos(CAMPOS_USUARIO, "p") + ", GROUP_CONCAT(r.rol) AS roles "
            + "FROM `" + Constantes.T_USUARIOS + "` p "
            + "RIGHT JOIN " + Constantes.T_USUARIOS_ROLES + " r ON r.usuario = p.id "
            + "WHERE p.email = ? AND p.password=? AND activo=1";
    }
    /**
     * Crea una nueva entrada de usuario
     * @param usuario
     * @return 
     */
    public static String insertUsuario() {
        String campos = "`activo`,`email`,`password`,`nombre`,`apellidos`,`descripcion`,`genero`,`fechaNacimiento`,`pais`,`ciudad`";
        String valores = "?,?,?,?,?,?,?,?,?,?";

        String consulta = "INSERT INTO " + Constantes.T_USUARIOS + " (" + campos + ") VALUES (" + valores + ");";

        return consulta;
    }
    public static String insertUsuarioRol() {
        return "INSERT INTO " + Constantes.T_USUARIOS_ROLES + "(usuario,rol) VALUES (?,?);";
    }
    public static String deleteUsuarioRolesById(){
        return "DELETE FROM " + Constantes.T_USUARIOS_ROLES + " WHERE id = ?;";
    }
    /**
     * Actualiza los datos de un usuario
     * @param usuario
     * @return 
     */
    public static String updateUsuario(Usuario usuario) {
        /*
        String consulta = "UPDATE " + Constantes.T_USUARIOS + " SET "
            + "`username` = '" + usuario.getUsername()+ "'"
            + ",`tipo` = '" + usuario.getTipo()+ "'"
            + ",`nombre` = '" + usuario.getNombre()+ "'"
            + ",`apellidos` = '" + usuario.getApellidos()+ "'"
            + ",`email` = '" + usuario.getEmail()+ "'"
            + ",`avatar` = '" + usuario.getAvatar()+ "'";
        if (!usuario.getPassword().isBlank()) {
            consulta += ",`password` = '" + usuario.getPassword() + "'";
        }
        consulta += " WHERE dni='" + usuario.getDni() + "'";
        return consulta;
        */
        return "";
    }
    public static String updateUsuarioById(String campo){
        return "UPDATE " + Constantes.T_USUARIOS + " SET " + campo + " = ? WHERE id = ?";
    }
    /**
     * Actualiza un solo campo del usuario
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
     * @param dni
     * @return 
     */
    public static String deleteUsuario(String dni) {
        return "DELETE FROM " + Constantes.T_USUARIOS + " WHERE dni='" + dni + "'";
    }
    
    
      ///////////////////////////////
     //         AUXILIAR          //
    ///////////////////////////////
    
    public static String getAuxiliar(int tipo){
        return "SELECT "+String.join(",",CAMPOS_AUXILIAR)+" FROM "+Constantes.T_AUXILIAR+" WHERE tipo="+tipo+";";
    }
    
      ///////////////////////////////
     //          TAREAS           //
    ///////////////////////////////
    /*
    public static String getTareas() {
        return "SELECT "+String.join(",",CAMPOS_TAREAS)+" FROM "+Constantes.T_TAREAS+";";
    }
    public static String getTareas(Usuario u) {
        return "SELECT "+String.join(",",CAMPOS_TAREAS)+" FROM "+Constantes.T_TAREAS+" WHERE email = '"+u.getEmail()+"';";
    }
    public static String getTarea(int id) {
        return "SELECT "+String.join(",",CAMPOS_TAREAS)+" FROM "+Constantes.T_TAREAS+" WHERE id='"+id+"';";
    }
    */
    /**
     * Crea una nueva entrada de tarea
     * @param tarea
     * @return 
     */
    /*
    public static String insertTarea(Tarea tarea) {
        String campos = "`id`, `descripcion`,`usuario`,`horasPrev`,`horasEmpl`,`nivelDiff`,`finalizado`";
        String valores = "'" + tarea.getId()+ "','" + tarea.getDescripcion()+ "','" + tarea.getUsuario()+ "','" + tarea.getHorasPrev()+ "','" + tarea.getHorasEmpl()+ "','" + tarea.getNivelDiff()+ "','" + tarea.getFinalizado()+ "'";

        String consulta = "INSERT INTO " + Constantes.T_TAREAS + " (" + campos + ") VALUES (" + valores + ");";

        return consulta;
    }
    */
    /**
     * Actualiza los datos de un tarea
     * @param tarea
     * @return 
     */
    /*
    public static String updateTarea(Tarea tarea) {
        String consulta = "UPDATE " + Constantes.T_TAREAS + " SET "
            + "`descripcion` = '" + tarea.getDescripcion()+ "'"
            + ",`usuario` = '" + tarea.getUsuario()+ "'"
            + ",`horasPrev` = '" + tarea.getHorasPrev()+ "'"
            + ",`horasEmpl` = '" + tarea.getHorasEmpl()+ "'"
            + ",`nivelDiff` = '" + tarea.getNivelDiff()+ "'"
            + ",`finalizado` = '" + tarea.getFinalizado()+ "'";
        consulta += " WHERE id='" + tarea.getId()+ "'";
        return consulta;
    }
    */
    /**
     * Elimina una tarea
     * @param id
     * @return 
     */
    /*
    public static String deleteTarea(int id) {
        return "DELETE FROM " + Constantes.T_TAREAS + " WHERE id='" + id + "'";
    }
    */
}
