<%-- 
    Document   : formularioTarea
    Created on : 12 oct. 2020, 23:17:24
    Author     : rodrigo


Esta página contendra un formulario que debe servir tanto para agregar nuevas entradas de tareas
como para editar las existentes
--%>

<%@page import="Modelo.Mensaje"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Auxiliar"%>
<%@page import="Auxiliar.Constantes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Constantes .APP_NAME%></title>
        <link rel="shortcut icon" href="<%=Constantes.FAVICON%>" type="image/x-icon" />
        <link rel="stylesheet" href="<%=Constantes.CSS_COLORES%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_POPUP%>"/>
        <script src="<%=Constantes.J_POPUP%>"></script>
        <script src="<%=Constantes.J_MENSAJE%>"></script>
    </head>
    <%
        String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        if(session.getAttribute(Constantes.S_USUARIO)==null){
            session.setAttribute(Constantes.S_ACCION, Constantes.A_SALIR);
            response.sendRedirect(Constantes.C_BASICO);
        }
        Usuario usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        LinkedList<Usuario> usuarios = ConexionEstatica.obtenerUsuarios(Constantes.ROL_USER);
        String accion = (String)session.getAttribute(Constantes.S_ACCION_MENSAJE);
        boolean editable=false,esEnviado=true;
        Mensaje mensaje = new Mensaje();
        int idSelect = 0;
        if(accion.equals(Constantes.A_LEER_MENSAJE)){
            if(session.getAttribute(Constantes.S_MENSAJE_ID)!=null){
                int id = Integer.parseInt(session.getAttribute(Constantes.S_MENSAJE_ID).toString());
                mensaje = ConexionEstatica.obtenerMensaje(id);
                esEnviado = mensaje.getRemitente()==usuario.getId();
                idSelect = esEnviado?mensaje.getDestinatario():mensaje.getRemitente();
                if(!esEnviado && !mensaje.isLeido())ConexionEstatica.leerMensaje(id);
            }
        } else if(accion.equals(Constantes.A_ESCRIBIR_MENSAJE)){
            if(session.getAttribute(Constantes.S_MENSAJE_DESTINO)!=null){
                idSelect = Integer.parseInt(session.getAttribute(Constantes.S_MENSAJE_DESTINO).toString());
                session.removeAttribute(Constantes.S_MENSAJE_DESTINO);
            }
            editable = true;
        }
        %>
    <body onload="mensajeOnload(<%=msg_info.isBlank()?null:"'"+msg_info+"'"%>)">
        <header>  
            <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt"/>
        </header>
        <main class="formulario mensaje">
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formularioMensaje" action="<%=Constantes.C_MENSAJES%>" method="POST" novalidate enctype="multipart/form-data">
                        <div class="row">
                            <% if(editable){%>
                            <p class="col-12 col-m-12">Enviar a</p>
                            <% } else {
                                if(esEnviado){%>
                                <p class="col-12 col-m-12">Enviado a</p>
                                <% } else {%>
                                <p class="col-12 col-m-12">Enviar por</p>
                                <%}
                            }%>
                            <span class="col-m-12 col-12 error_msg destinatario"></span>
                            <select class="col-12 col-m-12" name="destinatario" <%=editable?"":"disabled"%>>
                                <option value="0"></option>
                                <% for (Usuario usuario1 : usuarios) {%>
                                <option value="<%=usuario1.getId()%>" <%=idSelect==usuario1.getId()?"selected":""%>><%=usuario1.getNombre()+" "+usuario1.getApellidos()%></option>
                                <% }%>
                            </select>
                            <p class="col-12 col-m-12">Asunto</p>
                            <span class="col-m-12 col-12 error_msg titulo"></span>
                            <input class="col-12 col-m-12" type="text" name="titulo" maxlength="500" value="<%=mensaje.getTitulo()%>" <%=editable?"":"disabled"%>>
                            <p class="col-12 col-m-12">Mensaje</p>
                            <span class="col-m-12 col-12 error_msg mensaje"></span>
                            <textarea class="col-12 col-m-12" name="mensaje" rows="5" cols="10" maxlength="500" <%=editable?"":"disabled"%>><%=mensaje.getMensaje()%></textarea>
                             <% if(editable){%>
                            <p class="col-12 col-m-12">Adjuntar archivo</p>
                            <span class="col-m-12 col-12 error_msg adjunto"></span>
                            <input class="col-12 col-m-12" type="file" name="adjunto" >
                            <% } else if(!mensaje.getAdjunto().isBlank()) {%>
                            <a class="col-12 col-m-12" onclick='window.open("<%=Constantes.SUBIDOS_PATH+"/"+mensaje.getAdjunto()%>", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=400,height=400");'>Descargar archivo</a>
                            <% }%>
                        </div>
                        <div class="row botones">
                            <% if(editable){%>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_MENSAJE_ENVIAR%>" value="Enviar">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_MENSAJE_CANCELAR%>" value="Cancelar">
                            </div>
                            <% } else {%>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_MENSAJE_CANCELAR%>" value="Volver">
                            </div>
                            <% }%>
                        </div>
                    </form>
                </div>
            </div>
        </main>
        <footer>
        </footer>
    </body>
</html>
