package Auxiliar;

/**
 * Contiene las variables globales de la aplicación
 *
 * @author rodrigo
 */
public class Constantes {

    public static final String APP_NAME = "WebMeet";

    //BASE DE DATOS
    public static final String DB_NAME = "WebMeet";
    public static final String DB_USER = "rodrigo";
    public static final String DB_PASS = "Chubaca2020";

    //TABLAS
    public static final String T_USUARIOS = "Usuarios";
    public static final String T_AUXILIAR = "Auxiliar";
    public static final String T_TAREAS = "Tareas";
    public static final String T_TAREAS_HISTORICO = "Tareas_Historico";

    //MAIL
    public static final String EMAIL_ADDRESS = "auxiliardaw2@gmail.com";
    public static final String EMAIL_PASSWORD = "Chubaca20";
    public static final String EMAIL_HOST = "smtp.gmail.com";
    public static final int EMAIL_PORT = 587;
    public static final String EMAIL_AUTH = "true";

    //VARIABLES DE SESION
    public static final String S_INDEX_MSG = "index_msg";
    //DIRECCIONES
    private static final String APP_PATH = "/WebMeet";
    private static final String CSS_PATH = APP_PATH + "/CSS";
    private static final String CONTROLADOR_PATH = APP_PATH + "/Controlador";
    private static final String JS_PATH = APP_PATH + "/JS";
    private static final String RECURSOS_PATH = APP_PATH + "/Recursos";
    private static final String VISTAS_PATH = APP_PATH + "/Vista";

    //CSS
    public static final String CSS_GLOBAL = CSS_PATH + "/global.css";
    public static final String CSS_FONTAWESOME = CSS_PATH + "/fontawesome/all.min.css";

    //VISTAS
    public static final String V_INDEX = APP_PATH + "/index.jsp";
    public static final String V_IDONTKNOW = VISTAS_PATH+"/idontknow.jsp";
    public static final String V_ENTRADA = VISTAS_PATH + "/Entrada.jsp";

    //CONTROLADORES
    public static final String C_BASICO = CONTROLADOR_PATH + "/Basico.jsp";

    //IMAGENES
    public static final String I_LOGO = RECURSOS_PATH + "/logo.png";
    public static final String FAVICON = RECURSOS_PATH + "/favicon.ico";

    //JS
    public static final String J_FORM = JS_PATH + "/Formularios.js";

}
