/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


window.onload = () => {
    comprobarConectados = () => {
        var amigos = document.getElementsByClassName(`usuarioConectado`);
        for (var i = 0; i < amigos.length; i++) {
            amigos[i].className=amigos[i].className.replace(" activo","");
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "/WebMeet/Controlador/Basico.jsp?accion=conectados","true");
        xhr.onreadystatechange = aEvt => {
            if(xhr.readyState == 4){
                var response;
                try {
                    response = JSON.parse(xhr.response.toString().trim());                    
                } catch (e) {
                    response = [];
                }
                for (var i = 0; i < amigos.length; i++) {
                    amigos[i].className=amigos[i].className.replace(" activo","");
                }
                for(var index in response){
                    const item = response[index];
                    if(document.getElementsByClassName(`usuarioConectado ${item.id}`).length>0 && item.conectado){
                        document.getElementsByClassName(`usuarioConectado ${item.id}`)[0].className=document.getElementsByClassName(`usuarioConectado ${item.id}`)[0].className+" activo";
                    }

                }
            }
        };
        xhr.send(null);        
    };
    comprobarConectados();
    setInterval(comprobarConectados(),60000);
};
/**
 * Muestra un tipo de mensajes
 * @param {type} tipo
 */
verMensajes = tipo => {
    let hRecibidos=0,hEnviados=0;
    switch (tipo) {
        case 'recibidos':
            hRecibidos = 38;
            break;
        case 'enviados':
            hEnviados = 38;
            break;
            
        default:
            
            break;
    }
    document.getElementById('recibidos').style.height=`${hRecibidos}vh`;
    document.getElementById('enviados').style.height=`${hEnviados}vh`;
};
leerMensaje = id => {
    window.location.href=`/WebMeet/Controlador/Basico.jsp?accion=mensajeLeer&id=${id}`;
}
