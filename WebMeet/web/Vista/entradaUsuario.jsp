<%-- 
    Document   : idontknow
    Created on : 11 oct. 2020, 15:06:08
    Author     : rodrigo
--%>

<%@page import="Modelo.Mensaje"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Auxiliar.Constantes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Constantes.APP_NAME%></title>
        <link rel="shortcut icon" href="<%=Constantes.FAVICON%>" type="image/x-icon" />
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
        <script src="<%=Constantes.J_ENTRADAUSUARIO%>"></script>
    </head>
    <%
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.invalidate();
            response.sendRedirect(Constantes.V_INDEX);
        }
        Usuario usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        LinkedList<Usuario> amigos = ConexionEstatica.obtenerAmigos(usuario);
        LinkedList<Usuario> noamigos = ConexionEstatica.obtenerNoAmigos(usuario);
        LinkedList<Mensaje> mensajesRecibidos = ConexionEstatica.obtenerMensajesRecibidos(usuario);
        LinkedList<Mensaje> mensajesEnviados = ConexionEstatica.obtenerMensajesEnviados(usuario);
        LinkedList<Usuario> conectados=new LinkedList<>();
        if(application.getAttribute(Constantes.AP_USUARIOS)!=null){
            conectados = (LinkedList<Usuario>) application.getAttribute(Constantes.AP_USUARIOS);
        }
        
    %>
    <body>
        <header>
            <form class="row" action="<%=Constantes.C_BASICO%>" method="POST">
                <div class="col-3 col-m-3 left">
                    <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt" onclick="window.location.href='<%=Constantes.V_INDEX%>'"/>
                </div>
                <div c class="col-9 col-m-9 right">
                    <button type="submit" class="rounded" name="<%=Constantes.A_SALIR%>" ><i class="fas fa-sign-out-alt"></i></button>
                    <button type="submit" class="rounded" name="<%=Constantes.A_EDITAR_MI_USUARIO%>" ><i class="fas fa-user"></i></button>
                </div>
            </form>
        </header>
        <main class="">
            <form class="row toolbar" action="<%=Constantes.C_ADMIN%>" method="POST">
                <div class="col-6 col-m-6 left">
                    <% if(usuario.isRol(Constantes.ROL_ADMIN)){%>
                    <input type="submit" name="<%=Constantes.A_TABLA_USUARIOS%>" value="Usuarios">
                    <input type="submit" name="<%=Constantes.A_TABLA_ADMINISTRADORES%>" value="Administradores">
                    <% }%>
                </div>
                <div class="col-6 col-m-6 right">
                </div>
            </form>
            <div class="row">
                <!-- MENSAJES -->
                <div class="col-9 col-m-9 mensajes">
                    <div class="row toolbar" action="<%=Constantes.C_ADMIN%>" method="POST">
                        <div class="left">
                        </div>
                        <div class="right">
                            <button onclick="verMensajes('recibidos')" ><i class="fas fa-folder-open"></i></button>
                            <button onclick="verMensajes('enviados')" ><i class="fas fa-share-square"></i></button>
                            <form class="row" action="<%=Constantes.C_BASICO%>" method="POST">
                                <button type="submit" class="" name="<%=Constantes.A_ENVIAR_MENSAJE%>" ><i class="fas fa-paper-plane"></i></button>
                            </form>
                        </div>
                    </div>
                    <div id="recibidos">
                        <h3>Recibidos</h3>
                        <% for(Mensaje mensaje:mensajesRecibidos){%>
                        <div class="mensaje" ondblclick="leerMensaje(<%=mensaje.getId()%>)">
                            <% if(mensaje.isLeido()){%><i class="fas fa-envelope-open"></i><%} else {%><i class="far fa-envelope"></i><% }%>
                            <div class="campo">
                                <%=mensaje.getFecha()%>
                            </div>
                            <div class="campo"><%=mensaje.getTitulo()%></div>
                            <div class="campo"><%=mensaje.getNombreRemitente()%></div>
                            
                            <form action="<%=Constantes.C_BASICO%>" method="POST">
                                <input type="hidden" name="id" value="<%=mensaje.getId()%>">
                                <button type="submit" class="" name="<%=Constantes.A_MENSAJE_BORRAR%>">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                        <% }%>
                    </div>
                    <div id="enviados">
                        <h3>Enviados</h3>
                        <% for(Mensaje mensaje:mensajesEnviados){%>
                        <div class="mensaje" ondblclick="leerMensaje(<%=mensaje.getId()%>)">
                            <div class="campo"><%=mensaje.getFecha()%></div>
                            <div class="campo"><%=mensaje.getTitulo()%></div>
                            <div class="campo"><%=mensaje.getNombreDestinatario()%></div>                            
                            <form action="<%=Constantes.C_BASICO%>" method="POST">
                                <input type="hidden" name="id" value="<%=mensaje.getId()%>">
                                <button type="submit" class="" name="<%=Constantes.A_MENSAJE_BORRAR%>">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                        <% }%>
                    </div>
                </div>
                <!-- AMIGOS -->
                <div class="col-3 col-m-3 amigos">
                    <div>
                        <h2>Amigos</h2>
                        <% for(Usuario amigo:amigos){%>
                        <form class="row" action="<%=Constantes.C_BASICO%>" method="POST">
                            <input type="hidden" name="id" value="<%=amigo.getId()%>">
                            <i class="fas fa-circle usuarioConectado <%out.print(amigo.getId());%>"></i>
                            <div class=""><%=amigo.getNombre()+" "+amigo.getApellidos()%></div>
                            <button type="submit" class="rounded mini" name="<%=Constantes.A_ENVIAR_MENSAJE%>" ><i class="fas fa-paper-plane"></i></button>
                            <button type="submit" class="rounded mini" name="<%=Constantes.A_DEJAR_AMIGO%>" ><i class="fas fa-times-circle"></i></button>
                        </form>    
                        <% }%>                                
                    </div>
                </div>
                <!-- BUSCAR GENTE -->
                <div class="col-8 col-m-8">
                    <h2>Aún no son amigos</h2>
                    <%
                        
                        %>
                </div>
                <!-- SOLICITUDES PENDIENTES -->
                <div class="col-4 col-m-4">
                    <h2>Solicitudes</h2>
                </div>
            </div>                 
        </main>
    </body>
</html>
