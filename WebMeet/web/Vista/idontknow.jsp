<%-- 
    Document   : idontknow
    Created on : 11 oct. 2020, 15:06:08
    Author     : rodrigo
--%>

<%@page import="Auxiliar.Constantes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Constantes.APP_NAME%></title>
        <link rel="shortcut icon" href="<%=Constantes.FAVICON%>" type="image/x-icon" />
        <link rel="stylesheet" href="<%=Constantes.CSS_COLORES%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
    </head>
    <body>
        <header>  
            <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt"/>
        </header>
        <main class="idontknow">
            <div class="row">
                <h1 class="col-m-12 col-12" style="text-align: center;">Lo siento pero no se lo que tengo que hacer</h1>                
                <div class="col-m-12 col-12">
                    <form action="<%=Constantes.C_BASICO%>" method="POST">
                        <input type="submit" name="accion" value="Salir">
                    </form>
                </div>
            </div>                    
        </main>
    </body>
</html>
