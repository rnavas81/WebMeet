<%-- 
    Document   : Controlador
    Created on : 15 oct. 2020, 13:44:56
    Author     : rodrigo
--%>
<%@page import="java.util.LinkedList"%>
<%@page import="Auxiliar.Funciones"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Auxiliar"%>
<%@page import="Auxiliar.Constantes"%>
<%

    // Recupera la acción 
    String accion = request.getParameter("accion");    
    if(session.getAttribute(Constantes.S_USUARIO)==null){
        session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
        response.sendRedirect(Constantes.C_BASICO);
    }    
    Usuario usuario = (Usuario)session.getAttribute(Constantes.S_USUARIO);
    if(!usuario.isRol(Constantes.ROL_ADMIN)){
        session.invalidate();
        response.sendRedirect(Constantes.V_INDEX);
    }    
    // cargarDatos Determina si se deben recuperar/cargar datos
    //0=>Usuario; 1=>Roles
    //
    boolean[] cargarDatos = {false,false};
    // Almacena la dirección a la que se redirecciona el controlador al final del script
    String redireccion = null;
    LinkedList<Auxiliar> roles = new LinkedList<>();    
    
    if (accion == null) {
        if (request.getParameter(Constantes.A_TABLA_USUARIOS) != null) {
            accion = Constantes.A_TABLA_USUARIOS;
        }else if (request.getParameter(Constantes.A_TABLA_ADMINISTRADORES) != null) {
            accion = Constantes.A_TABLA_ADMINISTRADORES;
        }else if (request.getParameter(Constantes.A_PANEL) != null) {
            accion = Constantes.A_PANEL;
        }else if (request.getParameter(Constantes.A_EDITAR_USUARIO) != null) {
            accion = request.getParameter(Constantes.A_EDITAR_USUARIO);  
        }else if (request.getParameter(Constantes.A_AGREGAR_USUARIO) != null) {
            accion = request.getParameter(Constantes.A_AGREGAR_USUARIO);            
        }else if (request.getParameter(Constantes.A_EDITAR_MI_USUARIO) != null) {
            accion = Constantes.A_EDITAR_MI_USUARIO;
        }else if (request.getParameter(Constantes.A_CRUD_ACTIVAR) != null) {
            accion = Constantes.A_CRUD_ACTIVAR;
        }else if (request.getParameter(Constantes.A_CRUD_EDITAR) != null) {
            accion = Constantes.A_CRUD_EDITAR;
        }else if (request.getParameter(Constantes.A_CRUD_ELIMINAR) != null) {
            accion = Constantes.A_CRUD_ELIMINAR;
        }else if (request.getParameter(Constantes.A_CRUD_AGREGAR) != null) {
            accion = Constantes.A_CRUD_AGREGAR;
        }else if (request.getParameter(Constantes.A_SALIR) != null) {
            accion = Constantes.A_SALIR;
        }else if (request.getParameter(Constantes.A_PREFERENCIAS_FORMULARIO) != null) {
            accion = Constantes.A_PREFERENCIAS_FORMULARIO;
        } else {
            accion = "";
            redireccion = Constantes.V_INDEX;
        }
    }
    System.out.println("Probando "+accion);
    
    if(accion.equals(Constantes.A_SALIR)){
        cargarDatos[0]=true;
    }
    
    if(cargarDatos[0]){//Usuario
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
            response.sendRedirect(Constantes.C_BASICO);
        }
        usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
    } else if(cargarDatos[1]){//Roles
        if(session.getAttribute(Constantes.S_ROLES)!=null){
            roles = (LinkedList<Auxiliar>)session.getAttribute(Constantes.S_ROLES);
        } else {
            roles = ConexionEstatica.getRolesUsuario();
        }
    }
    //**************************
    //ACCIONES
    if (accion.equals(Constantes.A_TABLA_USUARIOS)) {
        redireccion = Constantes.V_TABLA_CRUD;
        session.setAttribute(Constantes.S_DATOS_TABLA, Constantes.M_USUARIOS);
    } else if(accion.equals(Constantes.A_TABLA_ADMINISTRADORES)){
        redireccion = Constantes.V_TABLA_CRUD;
        session.setAttribute(Constantes.S_DATOS_TABLA, Constantes.M_ADMINISTRADORES);
    } else if(accion.equals(Constantes.A_EDITAR_MI_USUARIO)){
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO,usuario);
        session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_EDITAR_USUARIO);
        redireccion=Constantes.V_FORMULARIO_USUARIO;                        
    } else if(accion.equals(Constantes.A_CRUD_ACTIVAR)){
        try{
            int id = Integer.parseInt(request.getParameter("id"));
            ConexionEstatica.activarUsuario(id);
        } catch (Exception e){
            
        }
        redireccion=Constantes.V_TABLA_CRUD;
    } else if(accion.equals(Constantes.A_CRUD_EDITAR)){
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario u = ConexionEstatica.obtenerUsuarioById(id);
            if(u!=null){
                session.setAttribute(Constantes.S_USUARIO_FORMULARIO,u);
                session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_EDITAR_USUARIO);
                redireccion=Constantes.V_FORMULARIO_USUARIO;                
            }
        } catch (Exception e) {
            redireccion=Constantes.V_TABLA_CRUD;
        }        
    } else if(accion.equals(Constantes.A_CRUD_ELIMINAR)){
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ConexionEstatica.eliminarUsuario(id);
        } catch (Exception e) {
        }
        redireccion=Constantes.V_TABLA_CRUD;
    } else if(accion.equals(Constantes.A_CRUD_AGREGAR)){
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO, new Usuario());
        session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_AGREGAR_USUARIO);
        redireccion=Constantes.V_FORMULARIO_USUARIO;
    } else if(accion.equals(Constantes.A_PANEL)){
        session.setAttribute(Constantes.S_ACCION, Constantes.A_ENTRAR_USUARIO);
        redireccion=Constantes.C_BASICO;
    } else if(accion.equals(Constantes.A_CANCELAR)){
        redireccion = Constantes.V_TABLA_CRUD;
    } else if(accion.equals(Constantes.A_AGREGAR)){
        Usuario u = new Usuario();
        u.setId(Integer.parseInt(request.getParameter("id")));
        u.setActivo(request.getParameter("activo").equals("on")?1:0);
        u.setEmail(request.getParameter("email"));
        u.setNombre(request.getParameter("nombre"));
        u.setApellidos(request.getParameter("apellidos"));
        u.setDescripcion(request.getParameter("descripcion"));       
        u.setGenero(Integer.parseInt(request.getParameter("genero")));
        u.setFechaNacimiento(request.getParameter("fechaNacimiento"));
        u.setPais(request.getParameter("pais"));
        u.setCiudad(request.getParameter("ciudad"));
        String[]vRoles = request.getParameterValues("roles");
        for(String rol:vRoles){
            u.setRol(Integer.parseInt(rol));
        }
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO, u);
        if(password.equals(password2)){
            if(ConexionEstatica.existeUsuario(u.getEmail())==null){
                if(ConexionEstatica.agregarUsuario(u,password)){
                    session.setAttribute(Constantes.S_MSG_INFO, "Usuario creado");
                    if(u.getId()==usuario.getId()){
                        session.setAttribute(Constantes.S_USUARIO, u);
                        usuario = u;
                    }
                    redireccion = Constantes.V_TABLA_CRUD;
                } else {
                    session.setAttribute(Constantes.S_MSG_INFO, "Error al crear el usuario");
                    redireccion = Constantes.V_FORMULARIO_USUARIO;
                }                
            } else {
                session.setAttribute(Constantes.S_MSG_INFO, "Ese email ya está en uso");
                redireccion = Constantes.V_FORMULARIO_USUARIO;                
            }
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Los password no son iguales");
            redireccion = Constantes.V_FORMULARIO_USUARIO;
        }
        
    } else if(accion.equals(Constantes.A_MODIFICAR)){
        System.out.println("Entrando");
        int id;
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        if(password.equals(password2)){
            try {
                id =Integer.parseInt(request.getParameter("id"));
                Usuario u = ConexionEstatica.obtenerUsuarioById(id);
                if(u!=null){
                    u.setActivo(request.getParameter("activo").equals("on")?1:0);
                    u.setEmail(request.getParameter("email"));
                    u.setNombre(request.getParameter("nombre"));
                    u.setApellidos(request.getParameter("apellidos"));
                    u.setDescripcion(request.getParameter("descripcion"));       
                    u.setGenero(Integer.parseInt(request.getParameter("genero")));
                    u.setFechaNacimiento(request.getParameter("fechaNacimiento"));
                    u.setPais(request.getParameter("pais"));
                    u.setCiudad(request.getParameter("ciudad"));
                    u.setRoles(new LinkedList<>());
                    try {
                        String[]vRoles = request.getParameterValues("roles");
                        for(String rol:vRoles){
                            System.out.println("ROL: "+rol);
                            u.setRol(Integer.parseInt(rol));
                        }                
                    } catch (Exception e) {
                    }
                    session.setAttribute(Constantes.S_USUARIO_FORMULARIO, u);
                        if(ConexionEstatica.actualizarUsuario(u,password)){
                            session.setAttribute(Constantes.S_MSG_INFO, "Usuario modificado");
                            if(u.getId()==usuario.getId()){
                                session.setAttribute(Constantes.S_USUARIO, u);
                                usuario = u;
                            }
                            session.setAttribute(Constantes.S_MSG_INFO, "Datos guardados correctamente");
                        } else {
                            session.setAttribute(Constantes.S_MSG_INFO, "Error al modificar el usuario");
                        }            

                } else {
                    session.setAttribute(Constantes.S_MSG_INFO, "No se puede modificar el usuario");
                }
            } catch (Exception e) {
            }
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Los password no son iguales");
        }
        redireccion = Constantes.V_FORMULARIO_USUARIO;        
        System.out.println("Saliendo");
        
    } else if(accion.equals(Constantes.A_SALIR)){
        session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
        redireccion = Constantes.C_BASICO;
    } else if(accion.equals(Constantes.A_PREFERENCIAS_FORMULARIO)){
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario u = ConexionEstatica.obtenerUsuarioById(id);
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO, u);
        redireccion = Constantes.V_FORMULARIO_PREFERENCIAS;
    } else {
        if(usuario==null && session.getAttribute(Constantes.S_USUARIO)!=null){
            usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        }
        if(usuario!=null){
            LinkedList<Usuario> usuariosConectados = (LinkedList<Usuario>)application.getAttribute(Constantes.AP_USUARIOS);
            boolean encontrado = false;
            for (int i = 0; i < usuariosConectados.size() && !encontrado; i++) {
                Usuario u=usuariosConectados.get(i);
                if(u.getId()==usuario.getId()){
                    encontrado=true;
                    usuariosConectados.remove(i);
                }   
            }
            application.setAttribute(Constantes.AP_USUARIOS, usuariosConectados);         
        }
        session.invalidate();
        redireccion= Constantes.V_INDEX;
    }

    
    if(redireccion!=null && !redireccion.isEmpty()){
        response.sendRedirect(redireccion);
    } else {
        response.sendRedirect(Constantes.V_IDONTKNOW);
    }
%>
