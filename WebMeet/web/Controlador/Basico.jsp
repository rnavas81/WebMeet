<%-- 
    Document   : Controlador
    Created on : 15 oct. 2020, 13:44:56
    Author     : rodrigo
--%>
<%@page import="java.util.Enumeration"%>
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
            accion = request.getParameter(Constantes.A_CREAR_USUARIO);
            if(accion.equals(Constantes.A_AGREGAR)){
                accion = Constantes.A_CREAR_USUARIO;
            }
        } else if (request.getParameter(Constantes.A_RECUPERAR_USUARIO) != null) {
            accion = Constantes.A_RECUPERAR_USUARIO;
        } else if(request.getParameter(Constantes.A_AGREGAR_PREFERENCIAS)!=null){
            accion = Constantes.A_AGREGAR_PREFERENCIAS;
        } else if(request.getParameter(Constantes.A_ENVIAR_MENSAJE)!=null){
            accion = Constantes.A_ENVIAR_MENSAJE;
        } else if(request.getParameter(Constantes.A_DEJAR_AMIGO)!=null){
            accion = Constantes.A_DEJAR_AMIGO;          
        }else if (request.getParameter(Constantes.A_EDITAR_MI_USUARIO) != null) {
            accion = Constantes.A_EDITAR_MI_USUARIO;
        }else if (request.getParameter(Constantes.A_MENSAJE_ENVIAR) != null) {
            accion = Constantes.A_MENSAJE_ENVIAR;
        }else if (request.getParameter(Constantes.A_MENSAJE_CANCELAR) != null) {
            accion = Constantes.A_MENSAJE_CANCELAR;
        }else if (request.getParameter(Constantes.A_MENSAJE_LEER) != null) {
            accion = Constantes.A_MENSAJE_LEER;
        }else if (request.getParameter(Constantes.A_MENSAJE_BORRAR) != null) {
            accion = Constantes.A_MENSAJE_BORRAR;
        }else if (request.getParameter(Constantes.A_SOLICITAR_AMISTAD) != null) {
            accion = Constantes.A_SOLICITAR_AMISTAD;
        }else if (request.getParameter(Constantes.A_ACEPTAR_AMISTAD) != null) {
            accion = Constantes.A_ACEPTAR_AMISTAD;
        }else if (request.getParameter(Constantes.A_PREFERENCIAS_FORMULARIO) != null) {
            accion = Constantes.A_PREFERENCIAS_FORMULARIO;
        }else if (request.getParameter(Constantes.A_EDITAR_USUARIO) != null) {
            accion = request.getParameter(Constantes.A_EDITAR_USUARIO);
        }else if (request.getParameter(Constantes.A_SALIR) != null) {
            accion = request.getParameter(Constantes.A_SALIR);
        } else if(session.getAttribute(Constantes.S_ACCION)!=null){
            accion =(String) session.getAttribute(Constantes.S_ACCION);
            session.removeAttribute(Constantes.S_ACCION);
        } else {
            accion = "";
            redireccion = Constantes.V_INDEX;
        }
    }
    
    System.out.println("ACCION == "+accion);
    if(accion.equals("Acceder")){
    } else if(accion.equals(Constantes.A_DEJAR_AMIGO) 
            || accion.equals(Constantes.A_SOLICITAR_AMISTAD) || accion.equals(Constantes.A_ACEPTAR_AMISTAD)
            || accion.equals(Constantes.A_EDITAR_MI_USUARIO) || accion.equals("conectados")
            || accion.equals("entrada") || accion.equals(Constantes.A_ENTRAR_USUARIO)){
        cargarDatos[0]=true;
    } else if(accion.equals(Constantes.A_AGREGAR_PREFERENCIAS)){
        cargarDatos[0]=true;
        cargarDatos[1]=true;
    } else if(accion.equals(Constantes.A_SALIR)){
        LinkedList<Usuario> usuariosConectados = (LinkedList<Usuario>)application.getAttribute(Constantes.AP_USUARIOS);
        boolean encontrado = false;
        for (int i = 0; !encontrado && i < usuariosConectados.size(); i++) {
            Usuario u=usuariosConectados.get(i);
            if(u.getId()==usuario.getId()){
                encontrado=true;
                usuariosConectados.remove(i);
            }   
        }
        application.setAttribute(Constantes.AP_USUARIOS, usuariosConectados);
        session.invalidate();
        response.sendRedirect(Constantes.V_INDEX);
    }

    if(cargarDatos[0]){        
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
            response.sendRedirect(Constantes.C_BASICO);
        }
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

    //**************************
    //ACCIONES
    if (accion.equals("Acceder")) {
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        usuario = ConexionEstatica.accederUsuario(email, password);
        if (usuario != null) {//Puede acceder
            session.setAttribute(Constantes.S_USUARIO, usuario);
            LinkedList<Usuario> usuariosConectados = new LinkedList<>();
            if(application.getAttribute(Constantes.AP_USUARIOS)!=null){
                usuariosConectados = (LinkedList<Usuario>)application.getAttribute(Constantes.AP_USUARIOS);
            }
            boolean encontrado = false;
            for (int i = 0; !encontrado && i < usuariosConectados.size(); i++) {
                    Usuario get = usuariosConectados.get(i);
                    encontrado=get.getId()==usuario.getId();
                }
            if(!encontrado)usuariosConectados.add(usuario);
            application.setAttribute(Constantes.AP_USUARIOS, usuariosConectados);
            accion = "entrada";
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Usuario o contraseña no valido"); 
            redireccion = Constantes.V_INDEX;
        }
    } else if (accion.equals("entrada")){
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
            response.sendRedirect(Constantes.C_BASICO);
        }
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
    } else if(accion.equals(Constantes.A_EDITAR_MI_USUARIO)){
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO,usuario);
        session.setAttribute(Constantes.S_ACCION_FORMULARIO,Constantes.A_EDITAR_USUARIO_BASICO);
        redireccion=Constantes.V_FORMULARIO_USUARIO;                
    } else if(accion.equals(Constantes.A_ENVIAR_MENSAJE)){
        if(request.getParameter("id")!=null){
            session.setAttribute(Constantes.S_MENSAJE_DESTINO, request.getParameter("id"));
        }
        session.setAttribute(Constantes.S_ACCION_MENSAJE, Constantes.A_ESCRIBIR_MENSAJE);
        redireccion = Constantes.V_MENSAJE;
    } else if(accion.equals(Constantes.A_MENSAJE_LEER)){
        if(request.getParameter("id")!=null){
            String idMensaje = (String)request.getParameter("id");
            session.setAttribute(Constantes.S_ACCION_MENSAJE, Constantes.A_LEER_MENSAJE);
            session.setAttribute(Constantes.S_MENSAJE_ID, idMensaje);
            redireccion = Constantes.V_MENSAJE;
        } else {
            redireccion = Constantes.V_ENTRADA_USER;            
        }
    } else if(accion.equals(Constantes.A_MENSAJE_BORRAR)){
        if(request.getParameter("id")!=null){
            int idMensaje = Integer.parseInt(request.getParameter("id"));
            ConexionEstatica.borrarMensaje(idMensaje);
            redireccion = Constantes.V_MENSAJE;
        } else {
            redireccion = Constantes.V_ENTRADA_USER;            
        }
    } else if(accion.equals(Constantes.A_ACEPTAR_AMISTAD)){
        if(request.getParameter("id")!=null){
            int idusuario = Integer.parseInt(request.getParameter("id"));
            ConexionEstatica.aceptarAmistad(usuario.getId(),idusuario);
        }
        redireccion = Constantes.V_ENTRADA_USER;
    } else if(accion.equals(Constantes.A_SOLICITAR_AMISTAD)){
        if(request.getParameter("id")!=null){
            int idusuario = Integer.parseInt(request.getParameter("id"));
            ConexionEstatica.solicitarAmistad(usuario.getId(),idusuario);
        }
        redireccion = Constantes.V_ENTRADA_USER;
        
    } else if(accion.equals("conectados")){
        LinkedList<Usuario> usuariosConectados = (LinkedList<Usuario>)application.getAttribute(Constantes.AP_USUARIOS);
        LinkedList<Usuario> amigos = ConexionEstatica.obtenerAmigos(usuario);
        LinkedList<Usuario> devolver = new LinkedList<>();
        for (Usuario amigo : amigos) {
                if(usuariosConectados.contains(amigo)){
                    devolver.add(amigo);
                }
            }
        String[] usuarios = new String[amigos.size()];
        int j=0;
        for (int i = 0; i < amigos.size(); i++) {
                Usuario get = amigos.get(i);
                if(get.getId()!=usuario.getId()){
                    boolean conectado = false;
                    for (Usuario usuariosConectado : usuariosConectados) {
                            if(usuariosConectado.getId()==get.getId())conectado=true;
                        }
                    usuarios[j]="{"
                            + "\"id\":"+get.getId()+","
                            + "\"nombre\":\""+get.getNombre()+" "+get.getApellidos()+"\""
                            + "\"conectado\":"+conectado
                            + "}";
                    j++;
                }
                
            }
        out.print("["+(usuarios.length>0?String.join(",", usuarios):"")+"]");
        
    } else if(accion.equals(Constantes.A_DEJAR_AMIGO)){
        int id = Integer.parseInt(request.getParameter("id"));
        ConexionEstatica.eliminarAmistad(usuario.getId(),id);
        redireccion = Constantes.V_ENTRADA_USER;        
    } else if(accion.equals(Constantes.A_CANCELAR)){
        redireccion = Constantes.V_ENTRADA_USER;
        
    } else if(accion.equals(Constantes.A_PREFERENCIAS_FORMULARIO)){
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario u = ConexionEstatica.obtenerUsuarioById(id);
        session.setAttribute(Constantes.S_USUARIO_FORMULARIO, u);
        redireccion =Constantes.V_FORMULARIO_PREFERENCIAS;
    } else if(accion.equals(Constantes.A_MODIFICAR)){
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
                redireccion = Constantes.V_FORMULARIO_USUARIO;
            } catch (Exception e) {
            }
        } else {
            session.setAttribute(Constantes.S_MSG_INFO, "Los password no son iguales");
            redireccion = Constantes.V_FORMULARIO_USUARIO;            
        }      
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
    
    //REDIRECCION
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
        if(!accion.equals("conectados"))
        response.sendRedirect(Constantes.V_IDONTKNOW);
    }
%>
