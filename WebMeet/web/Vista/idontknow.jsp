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
        <link rel="stylesheet" href="<%=Constantes.CSS_GLOBAL%>"/>
    </head>
    <body>
        <h1>No se lo que tengo que hacer</h1>
        <form action="<%=Constantes.C_BASICO%>">
            <input type="submit" name="accion" value="Salir">
        </form>
    </body>
</html>
