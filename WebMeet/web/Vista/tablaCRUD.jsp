<%-- 
    Document   : idontknow
    Created on : 11 oct. 2020, 15:06:08
    Author     : rodrigo
--%>

<%@page import="java.util.Arrays"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Auxiliar"%>
<%@page import="java.util.LinkedList"%>
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
        <link rel="stylesheet" href="<%=Constantes.CSS_FONTAWESOME%>"/>
        <link rel="stylesheet" href="<%=Constantes.CSS_POPUP%>"/>
        <script src="<%=Constantes.J_POPUP%>"></script>
    </head>
    <%
        Usuario usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        if (!usuario.isRol(Constantes.ROL_ADMIN)) {
            session.invalidate();
            response.sendRedirect(Constantes.V_INDEX);
        }
        LinkedList<Auxiliar> roles = new LinkedList<>();
        if (session.getAttribute(Constantes.S_ROLES) != null) {
            roles = (LinkedList<Auxiliar>) session.getAttribute(Constantes.S_ROLES);
        } else {
            roles = ConexionEstatica.getRolesUsuario();
            session.setAttribute(Constantes.S_ROLES, roles);
        }
        LinkedList<Usuario> lista;
        String datos = Constantes.M_USUARIOS;
        if (session.getAttribute(Constantes.S_DATOS_TABLA) != null) {
            datos = (String) session.getAttribute(Constantes.S_DATOS_TABLA);
        }
        if (datos.equals(Constantes.M_USUARIOS)) {
            lista = ConexionEstatica.obtenerUsuarios(Constantes.ROL_USER);
        } else if (datos.equals(Constantes.M_ADMINISTRADORES)) {
            lista = ConexionEstatica.obtenerUsuarios(Constantes.ROL_ADMIN);
        } else {
            lista = new LinkedList<>();
        }
    %>
    <body>
        <jsp:include page="../Componente/Cabecera.jsp"></jsp:include>
        <main class="">
            <form class="row toolbar" action="<%=Constantes.C_ADMIN%>" method="POST">
                <div class="col-6 col-m-6 left">
                    <input type="submit" name="<%=Constantes.A_TABLA_USUARIOS%>" value="Usuarios">
                    <input type="submit" name="<%=Constantes.A_TABLA_ADMINISTRADORES%>" value="Administradores">
                    <% if(usuario.isRol(Constantes.ROL_USER)){%>
                    <input type="submit" name="<%=Constantes.A_PANEL%>" value="Mi panel">
                    <% }%>
                </div>
                <div class="col-6 col-m-6 right">
                    <button type="submit" name="<%=Constantes.A_CRUD_AGREGAR%>" ><i class="fas fa-plus"></i></button>
                </div>
            </form>
            <div class="row cabecera">
                <div class="col-2 col-m-2">Nombre</div>
                <div class="col-2 col-m-2">Apellidos</div>
                <div class="col-2 col-m-2">Email</div>
            </div>
            <%
                if (lista.size() > 0) {
                    for (Usuario u : lista) {
                        LinkedList<String> rolesUsuario = new LinkedList<>();
                        for (Auxiliar rol : roles) {
                            if (u.getRoles().contains(rol.getId())) {
                                rolesUsuario.add(rol.getNombre());
                            }
                        }
            %>
            <form class="row fila" action="<%=Constantes.C_ADMIN%>" method="POST">
                <input type="hidden" name="id" value="<%=u.getId()%>">
                <div class="col-2 col-m-2"><%=u.getNombre()%></div>
                <div class="col-2 col-m-2"><%=u.getApellidos()%></div>
                <div class="col-3 col-m-3"><%=u.getEmail()%></div>
                <div class="col-3 col-m-3"><%=Arrays.toString(rolesUsuario.toArray())%></div>
                <div class="col-2 col-m-2">
                    <button type="submit" class="rounded mini" name="<%=Constantes.A_CRUD_EDITAR%>" ><i class="fas fa-edit"></i></button>
                    <button type="submit" class="rounded mini" name="<%=Constantes.A_CRUD_ELIMINAR%>"><i class="fas fa-trash-alt"></i></button>
                    <button type="submit" class="rounded mini" name="<%=Constantes.A_CRUD_ACTIVAR%>" ><i class="<%=u.getActivo() == 0 ? "far" : "fas"%> fa-check-circle"></i></button>
                </div>
            </form>
            <%}
                    } else {%>
            <div class="row">
                <h1 class="col-12 col-m-12">No hay usuarios</h1>
            </div>
            <% }%>
        </main>
    </body>
</html>
