/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



const mensajes = {
    email:{
        valueMissing:'Este campo es obligatorio.',
        typeMismatch:'No valido. Utiliza algo como nombre@nomail.com',
        tooShort:'Como mínimo 8 caracteres'
    },
    nombre:{
        tooLong:'Como máximo 500 caracteres'
    },
    apellidos:{
        tooLong:'Como máximo 500 caracteres'
    },
    password:{
        valueMissing:'Este campo es obligatorio.',
        patternMismatch :'Debe contener mayúsculas, minúsculas y números',
        tooShort:'Como mínimo 4 caracteres',
        tooLong:'Como máximo 32 caracteres'
    },
    password2:{
        valueMissing:'El campo contraseña es obligatorio.',
        patternMismatch :'La contraseña debe contener al menos un numero, y una letra mayuscula',
        tooShort:'Como mínimo 4 caracteres',
        tooLong:'Como máximo 32 caracteres',
        match:'La contraseña y la confimación no coinciden'
    }
};

validarFormulario = () => {
    const form = document.getElementById('formularioUsuario');
    let elementos = {};
    refrescarCaptcha('captcha');
    for(name in mensajes){
        elementos[name] = {
            input: document.getElementsByName(name)[0],
            error: document.getElementsByClassName(`error_msg ${name}`)[0]
        };
        console.log(elementos[name]);
        elementos[name].input.addEventListener('input', function (event) {
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
    form.addEventListener('submit', function (event) {
        if(event.submitter.value === 'Cancelar'){
            return true;
        }
        var valido = true;
        for (var name in elementos) {
            if (!elementos[name].input.validity.valid) {
                // Si no es así, mostramos un mensaje de error apropiado
                showError(name);
                valido = false;
            } else {
                elementos[name].error.innerHTML = ''; // Restablece el contenido del mensaje
            }
            if(name === 'password2' && elementos[name].input.value !== elementos.password.input.value 
                    && elementos[name].input.value !== elementos.password.input.value){
                elementos[name].error.textContent = mensajes[name].match;
                valido = false;
            }
        }
        if(!validarCaptchaCalculo('captchaInput','captcha')){
            valido = false;
            document.getElementById("error_captcha").textContent="Comprobación no valida";
        } else {
            document.getElementById("error_captcha").textContent="";            
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


