<%-- 
    Document   : Cabecera
    Created on : 23 oct. 2020, 18:10:41
    Author     : rodrigo
--%>
<%@page import="Modelo.Usuario"%>
<%@page import="Auxiliar.Constantes"%>
<link rel="stylesheet" href="<%=Constantes.CSS_COLORES%>"/>
<link rel="stylesheet" href="<%=Constantes.CSS_CABECERA%>"/>
<link rel="stylesheet" href="<%=Constantes.CSS_TOOLTIP%>"/>
<link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
<%
    Usuario usuario = null;
    if(session.getAttribute(Constantes.S_USUARIO)!=null){
        usuario = (Usuario)session.getAttribute(Constantes.S_USUARIO);
    }
    %>
<header>
    <form action="<%=Constantes.C_BASICO%>" method="POST">
        <div>
            <img class="logo" src="<%=Constantes.I_LOGO%>" alt="alt" onclick="window.location.href='<%=Constantes.V_INDEX%>'"/>
        </div>
        <div>
            <% if(usuario!=null){%>
            <button type="submit" class="rounded tooltip" name="<%=Constantes.A_EDITAR_MI_USUARIO%>" >
                <i class="fas fa-user"></i>
                <span class="tooltiptext"><%=usuario.getNombre()+" "+usuario.getApellidos()%></span>
            </button>
            <button type="submit" class="rounded tooltip" name="<%=Constantes.A_SALIR%>" >
                <i class="fas fa-sign-out-alt"></i>
                <span class="tooltiptext">Salir</span>
            </button>
            <% }%>
        </div>
    </form>
</header>
