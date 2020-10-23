/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



const mensajes = {
    email:{
        valueMissing:'El campo email es obligatorio.',
        typeMismatch:'Email no valido. Utiliza algo como nombre@nomail.com',
        tooShort:'Muy corta, por lo menos 8 caracteres'
    },
    password:{
        valueMissing:'El campo contraseña es obligatorio.',
        patternMismatch :'La contraseña debe contener al menos un numero, y una letra mayuscula',
        tooShort:'Muy corta, por lo menos 8 caracteres',
        tooLong:'Muy larga, no más de 10 caracteres'
    }
};

validarFormulario = (ponerCaptcha=false,mensaje=null) => {    
    if(mensaje!==null){
        crearPopUp({text:mensaje});
    }
    const form = document.getElementById('formIndex');
    let elementos = {};    
    if(ponerCaptcha){
        refrescarCaptcha('captcha');
    }
    for(name in mensajes){
        elementos[name] = {
            input: document.getElementsByName(name)[0],
            error: document.getElementsByClassName(`error_msg ${name}`)[0]
        };
        elementos[name].input.addEventListener('input', function (event) {
            // Cada vez que el usuario escribe algo, verificamos si
            // los campos del formulario son válidos.

            if (elementos[name].input.validity.valid) {
                // En caso de que haya un mensaje de error visible, si el campo
                // es válido, eliminamos el mensaje de error.
                document.getElementsByClassName(`error_msg ${name}`)[0].innerHTML = ''; // Restablece el contenido del mensaje
                document.getElementsByClassName(`error_msg ${name}`)[0].className = 'error'; // Restablece el estado visual del mensaje
            } else {
                // Si todavía hay un error, muestra el error exacto
                showError(name);
            }
        });
    }
    form.addEventListener('submit', function (event) {
        if(event.submitter.value === 'Registrar' || event.submitter.value === 'Recuperar'){
            return true;
        }
        var valido = true;
        for (var name in elementos) {
            if (!elementos[name].input.validity.valid) {
                // Si no es así, mostramos un mensaje de error apropiado
                showError(name);
                valido = false;
            }
        }
        if(ponerCaptcha){
            if(!validarCaptchaCalculo('captchaInput','captcha')){
                valido = false;
                document.getElementById("error_captcha").textContent="Comprobación no valida";
            } else {
                document.getElementById("error_captcha").textContent="";
            }            
        }
        if(!valido){
            event.preventDefault();
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


