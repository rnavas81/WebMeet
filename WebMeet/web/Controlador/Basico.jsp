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
     * @var redireccion Almacena la dirección 
     * a la que se redirecciona el controlador al final del script
     */
    String redireccion = null;
    // Recupera la acción 
    String accion = request.getParameter("accion");
    
    Usuario usuario;
    if (accion == null) {
        if (request.getParameter("cancelarEditarPerfil") != null) {
            accion = "entrada";
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
            session.invalidate();
            redireccion = Constantes.V_INDEX;
        }
    }
    
    /**
     * @var cargarDatos Determina si se deben recuperar/cargar datos
     * 0=> Usuario
     */
    boolean[] cargarDatos = {false};
    
    if(accion.equals("Acceder")){
        
    } else if(accion.equals("entrada")){
        cargarDatos[0]=true;
    }



    //**************************
    //ACCIONES
    if (accion.equals("Acceder")) {
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        usuario = ConexionEstatica.accederUsuario(email, password);
        if (usuario != null) {//Puede acceder
            session.setAttribute("usuario", usuario);
        } else {
            //session.setAttribute(Constantes.S_MSG_INDEX, "DNI o contraseña no valido"); 
            usuario = new Usuario();
        }
        accion = "entrada";
    } else {
        session.invalidate();
        redireccion= Constantes.V_INDEX;
    }
    /*
    if(accion.equals("entrada")){
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
    }
    */
    if(redireccion!=null && !redireccion.isEmpty()){
        response.sendRedirect(redireccion);
    } else {
        response.sendRedirect(Constantes.V_IDONTKNOW);
    }
%>
