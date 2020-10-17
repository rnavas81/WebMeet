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
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
        <script src="<%=Constantes.J_FORMULARIOUSUARIO%>"></script>
        <script src="<%=Constantes.J_OWNCAPTCHA%>"></script>
    </head>
    <%
        String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        String accion = (String)session.getAttribute(Constantes.S_ACCION_FORMULARIO);
        String boton_accion = "Agregar";
        String controlador = Constantes.C_BASICO;
        Usuario userData = null;
        if(session.getAttribute(Constantes.S_USUARIO_FORMULARIO)!=null){
            userData = (Usuario)session.getAttribute(Constantes.S_USUARIO_FORMULARIO);
        } else {
            userData = new Usuario();
        }
        if(accion.equals(Constantes.A_EDITAR_USUARIO)){
            boton_accion = "Modificar";
            controlador = Constantes.C_ADMIN;
        }
        session.removeAttribute(Constantes.S_USUARIO_FORMULARIO);
        session.removeAttribute(Constantes.S_ACCION_FORMULARIO);
        %>
    <body onload="validarFormulario()">
        <header>  
        </header>
        <main class="formulario usuario">
            <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt"/>
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formularioUsuario"  action="<%=controlador%>" method="POST" novalidate>
                        <div class="row">
                            <!-- MENSAJE DE ERROR -->
                            <span class="col-m-12 col-12"><%=msg_info%></span>
                        </div>
                        <div class="row">
                            <!-- CAMPO EMAIL -->
                            <span class="col-m-12 col-12 error_msg email"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-at"></i>&nbsp<label class="required">Email</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="email" name="email" required maxlength="500"/>
                            <!-- CAMPO NOMBRE -->
                            <span class="col-m-12 col-12 error_msg nombre"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-user"></i>&nbsp<label>Nombre</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="nombre" maxlength="500"/>
                            <!-- CAMPO APELLIDOS -->
                            <span class="col-m-12 col-12 error_msg apellidos"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-address-card">&nbsp</i><label>Apellidos</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="apellidos" maxlength="500"/>
                            <!-- CONTRASEÑA  -->
                            <span class="col-m-12 col-12 error_msg password"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-unlock-alt"></i>&nbsp<label class="required">Contraseña</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="password" name="password" required
                                minlength="4" maxlength="32" pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,32}$">
                            <!-- CONFIRMACIÓN CONTRASEÑA  -->
                            <span class="col-m-12 col-12 error_msg password2"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-unlock-alt"></i>&nbsp<label class="required">Confirmación de contraseña</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="password" name="password2" required
                                minlength="4" maxlength="32">
                            <!-- CAPTCHA -->
                            <div class="col-m12 col-12">
                                <span id="error_captcha" aria-live="assertive"></span>
                                <canvas id="captcha"></canvas>  
                                <input campo type="text" id="captchaInput"/>
                                <button type="button" class="rounded" onclick="refrescarCaptcha('captcha');"><i class="fas fa-redo-alt"></i></button>
                            </div>
                        </div>
                        <div class="row botones">
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=accion%>" value="<%=boton_accion%>">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" value="Cancelar">
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
