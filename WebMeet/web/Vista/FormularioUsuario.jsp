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
        <script src="<%=Constantes.J_FORM%>"></script>
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
    <body onload="validarFormulario('formulario')">
        <header>  
        </header>
        <main class="formulario usuario">
            <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt"/>
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formulario"  action="<%=controlador%>" method="POST" novalidate>
                        <div class="row">
                            <!-- MENSAJE DE ERROR -->
                            <span class="col-m-12 col-12"><%=msg_info%></span>
                        </div>
                        <div class="row">
                            <!-- CAMPO EMAIL -->
                            <span class="col-m-12 col-12 error_msg email"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-at"></i><label class="required">Email</label>                                
                            </div>
                            <label class="col-m-4 col-4 required"><i class="fas fa-at"></i> Email</label>
                            <input class="col-m-8 col-8" campo="email" type="email" name="email" required maxlength="500"/>
                            <!-- CAMPO NOMBRE -->
                            <span class="col-m-12 col-12 error_msg nombre"></span>
                            <label class="col-m-4 col-4"><i class="fas fa-user"></i> Nombre</label>
                            <input class="col-m-8 col-8" campo="nombre" type="text" name="nombre" maxlength="500"/>
                            <!-- CAMPO APELLIDOS -->
                            <span class="col-m-12 col-12 error_msg apellidos"></span>
                            <label class="col-m-4 col-4"><i class="fas fa-address-card"></i> Apellidos</label>
                            <input class="col-m-8 col-8" campo="apellidos" type="text" name="apellidos" maxlength="500"/>
                            <!-- CONTRASEÑA  -->
                            <span class="col-m-12 col-12 error_msg pasword"></span>
                            <label class="col-m-4 col-4 required"><i class="fas fa-unlock-alt"></i> Contraseña</label>
                            <input class="col-m-8 col-8" campo="pasword" type="pasword" name="pasword" required maxlength="32"minlength="8"/>
                            <!-- CONFIRMACIÓn CONTRASELA  -->
                            <span class="col-m-12 col-12 error_msg confirmacion"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-unlock-alt"></i><label class="required">Confirmación de contraseña</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo="confirmacion" type="pasword" name="confirmacion" required maxlength="32"minlength="8"/>
                        </div>
                        <div class="row botones">
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=accion%>" value="<%=boton_accion%>">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=accion%>" value="Cancelar">
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
