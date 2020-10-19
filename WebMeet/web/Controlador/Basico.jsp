<%-- 
    Document   : Controlador
    Created on : 15 oct. 2020, 13:44:56
    Author     : rodrigo
--%>
<%@page import="java.util.LinkedList"%>
<%@page import="Auxiliar.Funciones"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Email"%>
<%@page import="Modelo.Auxiliar"%>
<%@page import="Auxiliar.Constantes"%>
<%
    
    /**
     * @var redireccion Almacena la dirección 
     * a la que se redirecciona el controlador al final del script
     */
    String redireccion = null;
    // Recupera la acción 
    String accion = request.getParameter("accion");
    /**
     * @var cargarDatos Determina si se deben recuperar/cargar datos
     * 0=> Usuario 1=>Preferencias
     */
    boolean[] cargarDatos = {false,false};
    Usuario usuario = new Usuario();
    LinkedList<Auxiliar> preferencias = new LinkedList<>();
    
    if (accion == null) {
        if (request.getParameter(Constantes.A_CREAR_USUARIO) != null) {
            accion = Constantes.A_CREAR_USUARIO;
        } else if (request.getParameter(Constantes.A_RECUPERAR_USUARIO) != null) {
            accion = Constantes.A_RECUPERAR_USUARIO;
        } else if(request.getParameter(Constantes.A_AGREGAR_PREFERENCIAS)!=null){
            accion = Constantes.A_AGREGAR_PREFERENCIAS;
        } else if(session.getAttribute(Constantes.S_ACCION)!=null){
            accion =(String) session.getAttribute(Constantes.S_ACCION);
        } else {
            accion = "";
            redireccion = Constantes.V_INDEX;
        }
    }
    
    
    if(accion.equals("Acceder")){
    } else if(accion.equals("Registrar")){
    } else if(accion.equals(Constantes.A_AGREGAR_PREFERENCIAS)){
        cargarDatos[0]=true;
        cargarDatos[1]=true;
    } else if(accion.equals(Constantes.A_ENTRAR_USUARIO)){
        cargarDatos[0]=true;
    } else if(accion.equals("entrada")){
        cargarDatos[0]=true;
    }

    if(cargarDatos[0]){
        usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
    }
    if(cargarDatos[1]){
        if(session.getAttribute(Constantes.S_PREFERENCIAS)!=null){
            preferencias = (LinkedList<Auxiliar>)session.getAttribute(Constantes.S_PREFERENCIAS);
        } else {
            preferencias = ConexionEstatica.getPreferencias();
            session.setAttribute(Constantes.S_PREFERENCIAS, preferencias);
        }
    }

    System.out.println(accion);
    //**************************
    //ACCIONES
    if (accion.equals("Acceder")) {
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        usuario = ConexionEstatica.accederUsuario(email, password);
        if (usuario != null) {//Puede acceder
            session.setAttribute(Constantes.S_USUARIO, usuario);
            accion = "entrada";
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Usuario o contraseña no valido"); 
            redireccion = Constantes.V_INDEX;
        }
    } else if (accion.equals("entrada")){
        usuario = (Usuario)session.getAttribute(Constantes.S_USUARIO);
    } else if (accion.equals("Registrar")){
        redireccion = Constantes.V_FORMULARIO_USUARIO;
        session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_CREAR_USUARIO);
    } else if(accion.equals(Constantes.A_CREAR_USUARIO)){
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String nombre = request.getParameter("nombre") != null ? request.getParameter("nombre") : "";
        String apellidos = request.getParameter("apellidos") != null ? request.getParameter("apellidos") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        String password2 = request.getParameter("password2") != null ? request.getParameter("password2") : "";
        Usuario nuevo = new Usuario(email,nombre,apellidos);
        nuevo.setRol(Constantes.ROL_USER);
        if(password.equals(password2)){
            if(ConexionEstatica.agregarUsuario(nuevo,password)){
                session.setAttribute(Constantes.S_MSG_INFO, "Usuario creado");
                redireccion = Constantes.V_INDEX;
            } else {
                session.setAttribute(Constantes.S_MSG_INFO, "Error al crear el usuario");
                session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_CREAR_USUARIO);
                session.setAttribute(Constantes.S_USUARIO_FORMULARIO,nuevo);
                redireccion = Constantes.V_FORMULARIO_USUARIO;
            }            
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Error en los datos del usuario");
            session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_CREAR_USUARIO);
            session.setAttribute(Constantes.S_USUARIO_FORMULARIO,nuevo);
            redireccion = Constantes.V_FORMULARIO_USUARIO;            
        }
    } else if (accion.equals("Recuperar")){
        redireccion = Constantes.V_RECUPERAR_USUARIO;        
    } else if (accion.equals(Constantes.A_RECUPERAR_USUARIO)){
        session.setAttribute(Constantes.S_MSG_INFO, "Contrseña modificada.\nConsulte su email para acceder con su nueva contraseña");
        redireccion = Constantes.V_INDEX;
        try {
            String to = request.getParameter("email") != null ? request.getParameter("email") : "";
            String newPass = Funciones.alphanumericoAleatorio(8);
            ConexionEstatica.cambiarCampoUsuario("password",Funciones.encriptarTexto(newPass),to);
            Email email = new Email();
            String mensaje= "Ha solicitado un cambio de contraseña.\nSu nueva contraseña es " + newPass;
            String asunto = "Contraseña olvidada";
            email.enviarCorreo(to, mensaje, asunto);                
        } catch (Exception e) {
        }
    } else if(accion.equals(Constantes.A_ENTRAR_USUARIO)){
        if(ConexionEstatica.tienePreferencias(usuario)){
            redireccion = Constantes.V_ENTRADA_USER;            
        } else {
            redireccion = Constantes.V_FORMULARIO_PREFERENCIAS;            
        }
    } else if(accion.equals(Constantes.A_AGREGAR_PREFERENCIAS)){
        for(Auxiliar preferencia:preferencias){
            int idPreferencia = preferencia.getId();
            int valor = Integer.parseInt(request.getParameter(String.valueOf(idPreferencia)));
            ConexionEstatica.agregarPreferenciaUsuario(usuario,idPreferencia,valor);
        }
        redireccion = Constantes.V_ENTRADA_USER;
    } else if(accion.equals(Constantes.A_SALIR)){
    } else {
        session.invalidate();
        redireccion= Constantes.V_INDEX;
    }
    if(accion.equals("entrada")){
        if(usuario.isRol(Constantes.ROL_ADMIN)){
            redireccion = Constantes.V_TABLA_CRUD;
            session.setAttribute(Constantes.S_DATOS_TABLA, Constantes.M_USUARIOS);
        } else if(usuario.isRol(Constantes.ROL_USER)){
            if(ConexionEstatica.tienePreferencias(usuario)){
                redireccion = Constantes.V_ENTRADA_USER;            
            } else {
                redireccion = Constantes.V_FORMULARIO_PREFERENCIAS;            
            }
        } else {
            redireccion = Constantes.V_INDEX;
        }
    }
    if(redireccion!=null && !redireccion.isEmpty()){
        response.sendRedirect(redireccion);
    } else {
        response.sendRedirect(Constantes.V_IDONTKNOW);
    }
%>
