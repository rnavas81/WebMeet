/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



validarFormulario = (mensaje=null) => {    
    if(mensaje!==null){
        crearPopUp({text:mensaje});
    }
    const form = document.getElementById('formulario');
    let elementos = {};
    const encontrados = document.querySelectorAll("[campo]");
    for (var i = 0; i < encontrados.length; i++) {
        const name = encontrados[i].name;
        elementos[name] = {
            input: encontrados[i],
            error: document.getElementsByClassName(`error_msg ${name}`)[0]
        };
        elementos[name].input.addEventListener('input:blur', function (event) {
            // Cada vez que el usuario escribe algo, verificamos si
            // los campos del formulario son válidos.

            if (elementos[name].input.validity.valid) {
                // En caso de que haya un mensaje de error visible, si el campo
                // es válido, eliminamos el mensaje de error.
                elementos[name].error.innerHTML = ''; // Restablece el contenido del mensaje
            } else {
                // Si todavía hay un error, muestra el error exacto
                showError(name);
            }
        });            
        
        /*
        if(document.getElementsByTagName("campo").length>0) {
        }
        */
    }
    form.addEventListener('submit', function (event) {
        if(event.submitter.value === 'Salir'){
            return true;
        }
        for(name in elementos){
            if (!elementos[name].input.validity.valid) {
                // Si no es así, mostramos un mensaje de error apropiado
                elementos[name].error.textContent="El valor debe estar entre 0 y 100";
                event.preventDefault();
            } else {
                elementos[name].error.innerHTML = ''; // Restablece el contenido del mensaje
            }            
        }
    });
    

    
    function showError(name) {
        for(var tipo in elementos[name].input.validity){
            if(elementos[name].input.validity[tipo]){
                if(typeof mensajes[name][tipo] !== undefined){
                    elementos[name].error.textContent = mensajes[name][tipo];
                } else {
                    elementos[name].error.textContent = `Error sin controlar ${name} ${tipo}`;
                }                
            }
        }
    }


};


