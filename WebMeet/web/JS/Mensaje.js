/**
 * @author Rodrigo Navas
 * @create 2020/10/21
 * 
 */
const mensajes = {
    destinatario:{
        valueMissing:'Este campo es obligatorio.',
        typeMismatch:'No valido. Utiliza algo como nombre@nomail.com',
        tooShort:'Como mínimo 8 caracteres'
    },
    titulo:{
        tooLong:'Como máximo 500 caracteres'
    },
    mensaje:{
        tooLong:'Como máximo 500 caracteres'
    },
    adjunto:{
    }
};
mensajeOnload = (mensaje=null) => {    
    if(mensaje!==null){
        crearPopUp({text:mensaje});
    }
    
    var uploadField = document.querySelector("input[type=file]");
    console.log(uploadField);
    /*
    uploadField.onchange = function() {
        if(this.files[0].size > 2097152){
           alert("File is too big!");
           this.value = "";
        };
    };
     * 
     */
    
    const form = document.getElementById('formularioMensaje');
    let elementos = {};
    for(name in mensajes){
        if(document.getElementsByName(name).length>0) {
            elementos[name] = {
                input: document.getElementsByName(name)[0],
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
        }
    }
    form.addEventListener('submit', function (event) {
        if(event.submitter.value === 'Cancelar' || event.submitter.value === 'Volver'){
            return;
        }
        for (var name in elementos) {
            if (!elementos[name].input.validity.valid) {
                // Si no es así, mostramos un mensaje de error apropiado
                showError(name);
                event.preventDefault();
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
}


