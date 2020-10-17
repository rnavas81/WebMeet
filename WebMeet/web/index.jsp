<%-- 
    Document   : index
    Created on : 15 oct. 2020, 10:37:13
    Author     : rodrigo

Punto de entrada para la aplicación
--%>

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
        <script src="<%=Constantes.J_INDEX%>"></script>
        <script src="<%=Constantes.J_OWNCAPTCHA%>"></script>

    </head>
    <%
        String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        int randNum = (int)(Math.random() * 100);
        boolean hayCaptcha = randNum>60;
        %>
    <body onload="validarFormulario(<%=hayCaptcha?"true":"false"%>)">
        <header>  
        </header>
        <main class="login">
            <div class="row">
                <div class="col-m-12 col-12">
                    <img src="<%=Constantes.I_LOGO%>" alt="alt"/>
                    <form id="formIndex" action="<%=Constantes.C_BASICO%>" method="POST" novalidate>
                        <div class="row">
                            <span class="col-m-12 col-12"><%=msg_info%></span>
                            <label class="col-m-3 col-3"><i class="fas fa-user"></i> Email</label>
                            <span class="col-m-9 col-9 error_msg email"></span>
                            <input class="col-m-12 col-12" type="email" name="email" campo="email" required/>
                            <label class="col-m-3 col-3"><i class="fas fa-key"></i> Contraseña</label>
                            <span class="col-m-9 col-9 error_msg password"></span>
                            <input class="col-m-12 col-12" type="password" name="password" campo="password" required/>
                        <%
                            if(hayCaptcha){%>
                            <div class="col-m12 col-12 owncaptcha">
                                <span id="error_captcha" aria-live="assertive"></span>
                                <canvas id="captcha"></canvas>  
                                <input campo type="text" id="captchaInput"/>
                                <button type="button" class="rounded" onclick="refrescarCaptcha('captcha');"><i class="fas fa-redo-alt"></i></button>
                            </div>
                        <% }%>
                        </div>
                        <div class="row botones">
                            <div class="col-m-4 col-l-4">
                                <input type="submit" name="accion" value="Acceder"    />
                            </div>
                            <div class="col-m-4 col-l-4">
                                <input type="submit" name="accion" value="Registrar"  />
                            </div>
                            <div class="col-m-4 col-l-4">
                                <input type="submit" name="accion" value="Recuperar"  />                
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
