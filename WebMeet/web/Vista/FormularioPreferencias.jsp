<%-- 
    Document   : formularioTarea
    Created on : 12 oct. 2020, 23:17:24
    Author     : rodrigo


Esta página contendra un formulario que debe servir tanto para agregar nuevas entradas de tareas
como para editar las existentes
--%>

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
        <script src="<%=Constantes.J_FORMULARIOPREFERENCIAS%>"></script>
    </head>
    <%  String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        Usuario userData= new Usuario();
        if(session.getAttribute(Constantes.S_USUARIO_FORMULARIO)!=null){
            userData = (Usuario)session.getAttribute(Constantes.S_USUARIO_FORMULARIO);
        }
        out.print(userData.getNombre());
        LinkedList<Auxiliar> preferencias;
        if(session.getAttribute(Constantes.S_PREFERENCIAS)!=null){
            preferencias = (LinkedList<Auxiliar>) session.getAttribute(Constantes.S_PREFERENCIAS);
        } else {
            preferencias = ConexionEstatica.getPreferencias();
            session.setAttribute(Constantes.S_PREFERENCIAS, preferencias);
        }
        %>
    <body onload="validarFormulario(<%=msg_info.isBlank()?null:"'"+msg_info+"'"%>)">
        <jsp:include page="../Componente/Cabecera.jsp"></jsp:include>
        <main class="formulario usuario">
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formulario" action="<%=Constantes.C_BASICO%>" method="POST" novalidate>
                        <div class="row">
                            <h1 class="col-12 col-m-12">Intereses</h1>
                        <%
                            for(Auxiliar preferencia:preferencias){%>
                            <span class="col-m-12 col-12 error_msg <%=preferencia.getId()%>"></span>
                            <div class="col-m-4 col-4">
                                </i>&nbsp<label class="required"><%=preferencia.getNombre()%></label>
                            </div>
                            <input class="col-m-8 col-8" campo type="number" name="<%=preferencia.getId()%>" min="0" max="100" 
                                   value="<%=userData.getPreferenciaById(preferencia.getId())!=null?userData.getPreferenciaById(preferencia.getId()).getValor():0%>"/>
                            <% }%>
                        </div>
                        <div class="row botones">
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_AGREGAR_PREFERENCIAS%>" value="Guardar">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_ENTRAR_USUARIO%>" value="<%=Constantes.A_CANCELAR%>">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
        <footer>
        </footer>
    </body>
</html>
