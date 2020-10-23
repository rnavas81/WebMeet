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
    },
    descripcion:{
        tooLong:'Como máximo 500 caracteres'
    },
    fechaNacimiento:{
        
    },
    pais:{
        tooLong:'Como máximo 500 caracteres'
    },
    ciudad:{
        tooLong:'Como máximo 500 caracteres'
    }
};
var validarCaptcha=false;

validarFormulario = (mensaje=null) => {    
    if(mensaje!==null){
        crearPopUp({text:mensaje});
    }
    const form = document.getElementById('formularioUsuario');
    let elementos = {};
    for(name in mensajes){
        if(document.getElementsByName(name).length>0) {
            elementos[name] = {
                input: document.getElementsByName(name)[0],
                error: document.getElementsByClassName(`error_msg ${name}`)[0]
            };
            elementos[name].input.addEventListener('blur', function (event) {
                console.log(name);
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
        if(event.submitter.value === 'Cancelar'){
            return true;
        }
        if(event.submitter.value === 'Preferencias'){
            if(confirm("Si continua perderá los cambios no guardados,\n¿Desea continuar?")){
                return true;
            } else {
                event.preventDefault();
            }
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
            if(name === 'password2' 
                    && elementos[name].input.value !== elementos.password.input.value ){
                elementos[name].error.textContent = mensajes[name].match;
                valido = false;
            }
        }
        if(!validarCaptcha){
            valido=false;
            crearPopUp({text:"Valida el captcha"});
        }
        if(!valido){
            window.scrollTo(0,0);
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
verifyCallback = value => {
    console.log("verifyCallback",value);
    validarCaptcha = value;
};
