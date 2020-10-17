/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



const mensajes = {
    dni:{
        valueMissing :'El campo DNI es obligatorio.',
        patternMismatch:'DNI no valido. Utiliza algo como 00.000.000-#'
    },
    nombre:{
        valueMissing:'El campo nombre es obligatorio.',
        patternMismatch:'Dos palabras como mínimo y cuatro como máximo'
    },
    fechaNacimiento:{
        typeMismatch:'Fecha no valida. Utiliza algo como 01/01/2000',
        patternMismatch:'Fecha no valida. Utiliza algo como 01/01/2000'
    },
    telefono:{
        patternMismatch:'Telefono no valido. Utiliza algo como 000-000-000'
    },
    email:{
        valueMissing:'El campo email es obligatorio.',
        typeMismatch:'Email no valido. Utiliza algo como nombre@nomail.com',
        tooShort:'Muy corta, por lo menos 8 caracteres'
    },
    web:{
        patternMismatch:'Web no valida. Utiliza algo como http://wwww.nombre.asi'
    },
    password:{
        valueMissing:'El campo contraseña es obligatorio.',
        patternMismatch :'La contraseña debe contener al menos un numero, y una letra mayuscula',
        tooShort:'Muy corta, por lo menos 8 caracteres',
        tooLong:'Muy larga, no más de 10 caracteres'
    }
};
validarFormulario = (idFormulario,ponerCaptcha=false) => {
    const form = document.getElementById(idFormulario);
    let elementos = {};    
    var encontrados = document.querySelectorAll("[campo]");
    if(ponerCaptcha)captcha();
    for (var i = 0; i < encontrados.length; i++) {
        const clase = encontrados[i].name;
        elementos[clase] = {
            input:encontrados[i],
            error:document.getElementsByClassName(`error_msg ${clase}`)[0]
        };
        encontrados[i].addEventListener('input', function (event) {
            // Cada vez que el usuario escribe algo, verificamos si
            // los campos del formulario son válidos.

            if (encontrados[i].validity.valid) {
                // En caso de que haya un mensaje de error visible, si el campo
                // es válido, eliminamos el mensaje de error.
                document.getElementsByClassName(`error_msg ${clase}`)[0].innerHTML = ''; // Restablece el contenido del mensaje
                document.getElementsByClassName(`error_msg ${clase}`)[0].className = 'error'; // Restablece el estado visual del mensaje
            } else {
                // Si todavía hay un error, muestra el error exacto
                showError(clase);
            }
        });
    }
    form.addEventListener('submit', function (event) {
        console.log(event);
        if(event.submitter.name=='accion' && event.submitter.value == 'Registrar' || event.submitter.value){
            
        }
        var valido = true;
        for (var elemento in elementos) {
            if (!elementos[elemento].input.validity.valid) {
                // Si no es así, mostramos un mensaje de error apropiado
                showError(elemento);
                valido = false;
            }
        }
        if(ponerCaptcha){
            if(!validCaptcha('txtInput')){
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
    

    
    function showError(clase) {
        for(var tipo in elementos[clase].input.validity){
            if(elementos[clase].input.validity[tipo]){
                if(typeof mensajes[clase][tipo] !== undefined){
                    elementos[clase].error.textContent = mensajes[clase][tipo];
                } else {
                    elementos[clase].error.textContent = `Error sin controlar ${clase} ${tipo}`;
                }                
            }
        }
    }

    function validCaptcha(txtInput) {
        function removeSpaces(string) {
            return string.split(' ').join('');
        }
        let valido = false;
        try {
            var valores = undefined;

            var value = parseInt(removeSpaces(document.getElementById(txtInput).value));
            var array_cookies = document.cookie.split("; ");
            var temp;
            for (var i = 0; i < array_cookies.length && valores===undefined; i++) {
                temp = array_cookies[i].split("=");
                if(temp[0] === "captcha"){
                    valores = JSON.parse(temp[1]);
                }
            }
            switch(valores.signo){
                case "+":
                    valido = valores.num1 + valores.num2 === value;
                    break;
                case "-":
                    valido = valores.num1 - valores.num2 === value;
                    break;
                case "x":
                    valido = valores.num1 * valores.num2 === value;
                    break;
                default:
                    valido=false;
                    break;
            }
            
        } catch (e) {
            valido = false;
        }
        if (!valido) captcha();
        return valido;
    }
};
function captcha() {
    const n1 = Math.floor(Math.random() *10);
    const n2 = Math.floor(Math.random() *10);
    var code = {};
    switch(Math.floor(Math.random() *3)){
        case 0:
            code.signo = '+';
            break;
        case 1:
            code.signo = '-';
            break;
        case 2:
            code.signo = 'x';
            break;
        default :
            code.signo = '+';
            break;
    }
    code.num1 = n1>n2?n1:n2;
    code.num2 = n1>n2?n2:n1;
    
    const fecha = new Date(new Date().getTime() + 120000);
    document.cookie = `captcha=${JSON.stringify(code)}; expires=${fecha}; path=/;`;
    creaIMG(`${code.num1} ${code.signo} ${code.num2}`);
}

function creaIMG(texto) {
    var ctxCanvas = document.getElementById('captcha').getContext('2d');
    var fontSize = "30px";
    var fontFamily = "Arial";
    var width = 75;
    var height = 50;
    //tamaño
    ctxCanvas.canvas.width = width;
    ctxCanvas.canvas.height = height;
    //color de fondo
    ctxCanvas.fillStyle = "whitesmoke";
    ctxCanvas.fillRect(0, 0, width, height);
    //puntos de distorsión
    ctxCanvas.setLineDash([7, 10]);
    ctxCanvas.lineDashOffset = 5;
    ctxCanvas.beginPath();
    var line;
    for (var i = 0; i < (width); i++) {
        line = i * 5;
        ctxCanvas.moveTo(line, 0);
        ctxCanvas.lineTo(0, line);
    }
    ctxCanvas.stroke();
    //formato texto
    ctxCanvas.direction = 'ltr';
    ctxCanvas.font = fontSize + " " + fontFamily;
    //texto posicion
    var x = (width / 15);
    var y = (height / 3) * 2;
    //color del borde del texto
    ctxCanvas.strokeStyle = "yellow";
    ctxCanvas.strokeText(texto, x, y);
    //color del texto
    ctxCanvas.fillStyle = "red";
    ctxCanvas.fillText(texto, x, y);
}