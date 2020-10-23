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
        <script src="<%=Constantes.J_FORMULARIOUSUARIO%>"></script>
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    </head>
    <%
        Usuario usuario = (Usuario) session.getAttribute(Constantes.S_USUARIO);
        String accion = (String)session.getAttribute(Constantes.S_ACCION_FORMULARIO);
        String boton_accion = Constantes.A_AGREGAR;
        String controlador = Constantes.C_BASICO;
        Usuario userData = null;
        boolean expandido=false;
        boolean[] cargar = {false,false};
        LinkedList<Auxiliar> roles = new LinkedList<>();
        LinkedList<Auxiliar> generos = new LinkedList<>();
        /////////////////////////////////////////////////////////////
        String msg_info = "";
        if(session.getAttribute(Constantes.S_MSG_INFO)!=null){
            msg_info = (String)session.getAttribute(Constantes.S_MSG_INFO);
            session.removeAttribute(Constantes.S_MSG_INFO);
        }
        if(session.getAttribute(Constantes.S_USUARIO_FORMULARIO)!=null){
            userData = (Usuario)session.getAttribute(Constantes.S_USUARIO_FORMULARIO);
        } else {
            userData = new Usuario();
        }
        if(accion.equals(Constantes.A_EDITAR_USUARIO)){
            expandido=true;
            boton_accion = Constantes.A_MODIFICAR;
            controlador = Constantes.C_ADMIN;
            cargar[0]=true;
            cargar[1]=true;
        } else if(accion.equals(Constantes.A_EDITAR_USUARIO_BASICO)){
            expandido=true;
            boton_accion = Constantes.A_MODIFICAR;
            controlador = Constantes.C_BASICO;
            cargar[0]=true;
            cargar[1]=true;
            accion = Constantes.A_EDITAR_USUARIO;
        } else if(accion.equals(Constantes.A_AGREGAR_USUARIO)){
            expandido=true;
            controlador = Constantes.C_ADMIN;
            cargar[0]=true;
            cargar[1]=true;
            
        }
        // Carga los roles
        if(cargar[0]){
            if(session.getAttribute(Constantes.S_ROLES)!=null){
                roles = (LinkedList<Auxiliar>) session.getAttribute(Constantes.S_ROLES);
            } else {
                roles = ConexionEstatica.getRolesUsuario();
                session.setAttribute(Constantes.S_ROLES, roles);
            }
        }
        //Carga los generos
        if(cargar[1]){
            if(session.getAttribute(Constantes.S_GENEROS)!=null){
                generos = (LinkedList<Auxiliar>) session.getAttribute(Constantes.S_GENEROS);
            } else {
                generos = ConexionEstatica.getGeneros();
                session.setAttribute(Constantes.S_GENEROS, generos);
            }
        }
        %>
    <body onload="validarFormulario(<%=msg_info.isBlank()?null:"'"+msg_info+"'"%>)">
        <jsp:include page="../Componente/Cabecera.jsp"></jsp:include>
        <main class="formulario usuario">
            <div class="row">
                <div class="col-m-12 col-12">
                    <form id="formularioUsuario"  action="<%=controlador%>" method="POST" novalidate>
                        <div class="row">
                            <% if(expandido){%>
                            <!-- ROLES -->
                            <span class="col-m-12 col-12 error_msg activo"></span>
                            <div class="col-m-12 col-12">
                                <i class="fas fa-check-circle"></i>&nbsp<label>Activo</label>
                                <input class="" type="checkbox" name="activo" <%=userData.getActivo()==1?"checked":""%>/>
                            </div>
                            <% } %>
                            <!-- CAMPO EMAIL -->
                            <span class="col-m-12 col-12 error_msg email"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-at"></i>&nbsp<label class="required">Email</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="email" name="email" required maxlength="500" 
                                   value="<%=userData.getEmail()%>"/>
                            <!-- CAMPO NOMBRE -->
                            <span class="col-m-12 col-12 error_msg nombre"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-user"></i>&nbsp<label>Nombre</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="nombre" maxlength="500"
                                   value="<%=userData.getNombre()%>"/>
                            <!-- CAMPO APELLIDOS -->
                            <span class="col-m-12 col-12 error_msg apellidos"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-address-card">&nbsp</i><label>Apellidos</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="apellidos" maxlength="500"
                                   value="<%=userData.getApellidos()%>"/>
                            <% if(expandido){%>
                            <!-- CAMPO DESCRIPCION -->
                            <span class="col-m-12 col-12 error_msg descripcion"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-edit"></i>&nbsp<label class="">Descripcion</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="descripcion" maxlength="500" 
                                   value="<%=userData.getDescripcion()%>"/>                                    
                            <% } %>
                            <!-- CONTRASEÑA  -->
                            <span class="col-m-12 col-12 error_msg password"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-unlock-alt"></i>&nbsp<label 
                                    class="<%=accion.equals(Constantes.A_EDITAR_USUARIO)?"":"required"%>">Contraseña</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="password" name="password" <%=accion.equals(Constantes.A_EDITAR_USUARIO)?"":"required"%>
                                minlength="4" maxlength="32" pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,32}$">
                            <!-- CONFIRMACIÓN CONTRASEÑA  -->
                            <span class="col-m-12 col-12 error_msg password2"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-unlock-alt"></i>&nbsp<label class="<%=accion.equals(Constantes.A_EDITAR_USUARIO)?"":"required"%>">Confirmación de contraseña</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="password" name="password2" <%=accion.equals(Constantes.A_EDITAR_USUARIO)?"":"required"%>
                                minlength="4" maxlength="32">
                            <% if(expandido){%>
                            <!-- CAMPO GENERO -->
                            <span class="col-m-12 col-12 error_msg genero"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-venus-mars"></i>&nbsp<label>Genero</label>                                
                            </div>
                            <select class="col-m-8 col-8" campo name="genero">
                                <option value="0"></option>
                                <%for(Auxiliar genero:generos){%>
                                <option value="<%=genero.getId()%>" <%=userData.getGenero()==genero.getId()?"selected":""%>><%=genero.getNombre()%></option>
                                <% } %>
                            </select>
                            <!-- CAMPO FECHA -->
                            <span class="col-m-12 col-12 error_msg fechaNacimiento"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-birthday-cake"></i>&nbsp<label>Fecha de nacimiento</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="date" name="fechaNacimiento" 
                                   value="<%=userData.getFechaNacimiento()%>"/>
                            <!-- CAMPO PAIS -->
                            <span class="col-m-12 col-12 error_msg pais"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-globe-europe"></i>&nbsp<label>País</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="pais" maxlength="500"
                                   value="<%=userData.getPais()%>"/>
                            <!-- CAMPO CIUDAD -->
                            <span class="col-m-12 col-12 error_msg ciudad"></span>
                            <div class="col-m-4 col-4">
                                <i class="fas fa-city"></i>&nbsp<label>Ciudad</label>                                
                            </div>
                            <input class="col-m-8 col-8" campo type="text" name="ciudad" maxlength="500"
                                   value="<%=userData.getCiudad()%>"/>
                            <% if(usuario.isRol(Constantes.ROL_ADMIN)){%>
                            <!-- ROLES -->
                            <span class="col-m-12 col-12 error_msg roles"></span>
                            <div class="col-m-12 col-12">
                                <i class="fas fa-tasks"></i>&nbsp<label>Roles</label>
                            </div>
                            
                            <% for(Auxiliar rol:roles){%>
                            <div class="col-m-<%=12/roles.size()%> col-<%=12/roles.size()%>">
                                <label><%=rol.getNombre()%></label><input class="" type="checkbox" name="roles" value="<%=rol.getId()%>" <%=userData.isRol(rol.getId())?"checked":""%>/>
                            </div>
                            <% }
                            }%>
                            <input type="hidden" name="id" value="<%=userData.getId()%>">
                            <% } %>
                            <!-- CAPTCHA -->
                            <div class="col-m-2 col-2">
                                <div class="g-recaptcha" id="rcaptcha" data-sitekey="6LeoQtoZAAAAAMiZi7FOGwWAYUUMeAD9XjMP94B8" data-callback="verifyCallback"></div>
                            </div>

                        </div>
                        <div class="row botones">
                            <% if(accion==Constantes.A_EDITAR_USUARIO){%>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=Constantes.A_PREFERENCIAS_FORMULARIO%>" value="Preferencias">
                            </div>
                            <% }%>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=accion%>" value="<%=boton_accion%>">
                            </div>
                            <div class="col-m-2 col-2">
                                <input type="submit" name="<%=accion%>" value="<%=Constantes.A_CANCELAR%>">
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
