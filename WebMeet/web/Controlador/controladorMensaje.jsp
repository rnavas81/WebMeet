<%-- 
    Document   : controladorPerfil
    Created on : 7 oct. 2020, 13:58:54
    Author     : rodrigo
--%>
<%@page import="java.util.Enumeration"%>
<%@page import="Auxiliar.Constantes"%>
<%@page import="Modelo.Mensaje"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%

    if(request.getParameter(Constantes.A_MENSAJE_CANCELAR)!=null){
        response.sendRedirect(Constantes.V_ENTRADA_USER);
    }
    
    Usuario persona = (Usuario) session.getAttribute(Constantes.S_USUARIO);
    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);

    Mensaje mensaje = new Mensaje();
    mensaje.setRemitente(persona.getId());
    
    
    // req es la HttpServletRequest que recibimos del formulario.
    // Los items obtenidos serán cada uno de los campos del formulario,
    // tanto campos normales como ficheros subidos.
    
    List items = upload.parseRequest(request);
    // Se recorren todos los items, que son de tipo FileItem
    for (Object item : items) {
        FileItem uploaded = (FileItem) item;

        // Hay que comprobar si es un campo de formulario. Si no lo es, se guarda el fichero
        // subido donde nos interese
        if (!uploaded.isFormField()) {
            File directory = new File(Constantes.SUBIDOS_DIR);
            if (!directory.exists()) {
                directory.mkdir();
            }
            String fileName = uploaded.getName();
            if(!fileName.isBlank()){
                String extension = "";
                int index = fileName.lastIndexOf(".");
                if(index > 0){
                    extension = fileName.substring(index+1);
                    extension = extension.toLowerCase();
                }
                String newName = Long.toString(new Date().getTime()) + "." + extension;
                // No es campo de formulario, guardamos el fichero en algún sitio
                File fichero = new File(Constantes.SUBIDOS_DIR, newName);
                uploaded.write(fichero);
                mensaje.setAdjunto(newName);
            }            
        } else {
            String key = uploaded.getFieldName();
            String valor = uploaded.getString();
            if (key.equals("destinatario")){
                mensaje.setDestinatario(Integer.parseInt(valor));
            } else if (key.equals("titulo")){
                mensaje.setTitulo(valor);
            } else if (key.equals("mensaje")) {
                mensaje.setMensaje(valor);
            }
        }
    }
    ConexionEstatica.agregarMensaje(mensaje);
    Thread.sleep(2000);
    response.sendRedirect(Constantes.V_ENTRADA_USER);
%>
