<%-- 
    Document   : Controlador
    Created on : 15 oct. 2020, 13:44:56
    Author     : rodrigo
--%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Auxiliar.Constantes"%>
<%
    
    /**
     * @var redireccion Almacena la direcci�n 
     * a la que se redirecciona el controlador al final del script
     */
    String redireccion = null;
    // Recupera la acci�n 
    String accion = request.getParameter("accion");
    
    Usuario usuario;
    if (accion == null) {
        if (request.getParameter(Constantes.A_CREAR_USUARIO) != null) {
            accion = Constantes.A_CREAR_USUARIO;
        } else if (request.getParameter("modificarEditarPerfil") != null) {
            accion = "modificarPerfil";
        } else if(request.getParameter("rechazar_tarea")!=null){
            accion = "rechazar_tarea";
        } else if(request.getParameter("editar_tarea")!=null){
            accion = "editar_tarea";
        } else if(request.getParameter("actualizar_tarea")!=null){
            accion = "actualizar_tarea";
        } else {
            accion = "";
            redireccion = Constantes.V_INDEX;
        }
    }
    
    /**
     * @var cargarDatos Determina si se deben recuperar/cargar datos
     * 0=> Usuario
     */
    boolean[] cargarDatos = {false};
    
    if(accion.equals("Acceder")){
    } else if(accion.equals("Registrar")){
    } else if(accion.equals("entrada")){
        cargarDatos[0]=true;
    }


    System.out.println(accion);
    //**************************
    //ACCIONES
    if (accion.equals("Acceder")) {
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        usuario = ConexionEstatica.accederUsuario(email, password);
        if (usuario != null) {//Puede acceder
            session.setAttribute("usuario", usuario);
        } else {
            //session.setAttribute(Constantes.S_MSG_INDEX, "DNI o contrase�a no valido"); 
            usuario = new Usuario();
        }
        accion = "entrada";
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


    } else if(accion.equals("salir")){
    } else {
        session.invalidate();
        redireccion= Constantes.V_INDEX;
    }
    if(accion.equals("entrada")){
    /*
        switch (usuario.getRol()) {
            case 1://Usuario normal
                redireccion = Constantes.V_ENTRADA_TECNI;
                break;
            case 2://Usuario administrador
                redireccion = Constantes.V_ENTRADA_ADMIN;
                break;
            default:
                //session.invalidate();
                redireccion = Constantes.V_INDEX;
                break;
        }        
    */
    }
    if(redireccion!=null && !redireccion.isEmpty()){
        response.sendRedirect(redireccion);
    } else {
        response.sendRedirect(Constantes.V_IDONTKNOW);
    }
%>
