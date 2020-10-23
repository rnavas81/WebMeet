<%-- 
    Document   : formularioTarea
    Created on : 12 oct. 2020, 23:17:24
    Author     : rodrigo


Esta página contendra un formulario que debe servir tanto para agregar nuevas entradas de tareas
como para editar las existentes
--%>

<%@page import="Modelo.Usuario"%>
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
        <script src="<%=Constantes.J_FORMULARIOUSUARIO%>"></script>
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    </head>
    <%
        %>
    <body onload="validarFormulario()">
        <jsp:include page="../Componente/Cabecera.jsp"></jsp:include>
        <main class="formulario usuario">
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formularioUsuario" action="<%=Constantes.C_BASICO%>" method="POST" novalidate>
                        <div class="row">
                            <!-- CAMPO EMAIL -->
                            <span class="col-m-12 col-12 error_msg email"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-at"></i>&nbsp<label class="required">Email</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="email" name="email" required maxlength="500"/>
                            <!-- CAPTCHA -->
                            <div class="col-m6 col-6">
                                <div class="g-recaptcha" data-sitekey="6LeoQtoZAAAAAMiZi7FOGwWAYUUMeAD9XjMP94B8"></div>
                            </div>
                        </div>
                        <div class="row">
                        </div>
                        <div class="row botones">
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_RECUPERAR_USUARIO%>" value="Recuperar">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_SALIR%>" value="Cancelar">
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
