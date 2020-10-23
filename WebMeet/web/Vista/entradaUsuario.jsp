<%-- 
    Document   : idontknow
    Created on : 11 oct. 2020, 15:06:08
    Author     : rodrigo
--%>

<%@page import="Auxiliar.Funciones"%>
<%@page import="Auxiliar.Constantes"%>
<%@page import="Modelo.Mensaje"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Preferencia"%>
<%@page import="Modelo.Auxiliar"%>
<%@page import="java.util.LinkedList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Constantes.APP_NAME%></title>
        <link rel="shortcut icon" href="<%=Constantes.FAVICON%>" type="image/x-icon" />
        <link rel="stylesheet" href="<%=Constantes.CSS_COLORES%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_POPUP%>"/>
        <script src="<%=Constantes.J_POPUP%>"></script>
        <script src="<%=Constantes.J_ENTRADAUSUARIO%>"></script>
    </head>
    <%
        String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.invalidate();
            response.sendRedirect(Constantes.V_INDEX);
        }
        Usuario usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        LinkedList<Usuario> amigos = ConexionEstatica.obtenerAmigos(usuario);
        LinkedList<Usuario> otros = ConexionEstatica.obtenerNoAmigos(usuario);
        LinkedList<Usuario> pendientes = ConexionEstatica.obtenerAmigosPendientes(usuario);
        LinkedList<Usuario> noamigos = Funciones.calcularCompatibilidad(usuario,otros);
        LinkedList<Mensaje> mensajesRecibidos = ConexionEstatica.obtenerMensajesRecibidos(usuario);
        LinkedList<Mensaje> mensajesEnviados = ConexionEstatica.obtenerMensajesEnviados(usuario);
        LinkedList<Usuario> conectados=new LinkedList<>();
        if(application.getAttribute(Constantes.AP_USUARIOS)!=null){
            conectados = (LinkedList<Usuario>) application.getAttribute(Constantes.AP_USUARIOS);
        }
        LinkedList<Auxiliar> preferencias = new LinkedList<>();
        if(session.getAttribute(Constantes.S_PREFERENCIAS)!=null){
            preferencias = (LinkedList<Auxiliar>)session.getAttribute(Constantes.S_PREFERENCIAS);
        } else {
            preferencias = ConexionEstatica.getPreferencias();
            session.setAttribute(Constantes.S_PREFERENCIAS, preferencias);
        }
        
    %>
    <body onload="onloadEntradaUsuario(<%=msg_info.isBlank()?null:"'"+msg_info+"'"%>)">
        <jsp:include page="../Componente/Cabecera.jsp"></jsp:include>
        <main class="cuadro">
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
                    <div class="row toolbar">
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
                    <div id="amigosConectados">
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
                <div class="col-8 col-m-8 noamigos">
                    <div>
                        <div class="fila1">
                            <div class="campo">Usuario</div>
                            <% for (Auxiliar preferencia : preferencias) {%>
                            <div class="campo"><%=preferencia.getNombre()%></div>
                            <% }%>
                            <div class="campo"></div>
                        </div>
                    <% for (Usuario noamigo : noamigos) {%>
                        <div class="fila1">
                            <div class="campo"><%=noamigo.getNombre()+" "+noamigo.getApellidos()%></div>
                            <% for (Preferencia preferencia : noamigo.getPreferencias()) {%>
                            <div class="campo <%
                                if(preferencia.getValor()>-20 && preferencia.getValor()<20)out.print("bueno");
                                else if(preferencia.getValor()>-40 && preferencia.getValor()<40)out.print("vale");
                                else if(preferencia.getValor()>-60 && preferencia.getValor()<60)out.print("regular");
                                else out.print("malo");
                                %>"><%=preferencia.getValor()%></div>
                            <% }%>                           
                            <form action="<%=Constantes.C_BASICO%>" method="POST">
                                <input type="hidden" name="id" value="<%=noamigo.getId()%>">
                                <button type="submit" class="" name="<%=Constantes.A_SOLICITAR_AMISTAD%>">
                                    <i class="fas fa-heart"></i>
                                </button>
                                <button type="submit" class="" name="<%=Constantes.A_ENVIAR_MENSAJE%>">
                                    <i class="fas fa-envelope"></i>
                                </button>
                            </form>
                        </div>
                    <% }%>
                    </div>
                </div>
                <!-- SOLICITUDES PENDIENTES -->
                <div class="col-4 col-m-4 solicitudes">
                    <div>
                        <h2>Solicitudes</h2> 
                        <% for (Usuario user : pendientes) {%>
                            <div class="fila1">
                                <div class="campo"><%=user.getNombre()+" "+user.getApellidos()%></div>
                                <form action="<%=Constantes.C_BASICO%>" method="POST">
                                    <input type="hidden" name="id" value="<%=user.getId()%>">
                                    <button type="submit" class="" name="<%=Constantes.A_ACEPTAR_AMISTAD%>">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button type="submit" class="" name="<%=Constantes.A_DEJAR_AMIGO%>">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </form>
                            </div>
                        <% }%>                       
                    </div>
                </div>
            </div>                 
        </main>
    </body>
</html>
