/**
 * @author Rodrigo Navas
 * @created 2020/10/17
 * Fichero de funciones para mi propio captch
 */

function removeSpaces(string) {
    return string.split(' ').join('');
}
function generarCaptchaCalculo() {
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
    return code;
}
function generarCaptchaCaracteres(numeros = false) {
    var alpha = new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
    if(numeros === true){
        alpha = alpha.concat(['0','1','2','3','4','5','6','7','8','9']);
    }
    var code = "";
    for (let i = 0; i < 8; i++) {
        code+=alpha[Math.floor(Math.random() * alpha.length)]+" ";
    }
    const fecha = new Date(new Date().getTime() + 120000);
    document.cookie = `captcha=${code}; expires=${fecha}; path=/;`;
    return code;
}

function validarCaptchaCaracteres(txtInput,idCanvas) {
    var string1 = undefined;
    var string2 = removeSpaces(document.getElementById(txtInput).value);
    var array_cookies = document.cookie.split("; ");
    var temp;
    for (var i = 0; i < array_cookies.length && string1===undefined; i++) {
        temp = array_cookies[i].split("=");
        if(temp[0] === "captcha"){
            string1 = removeSpaces(temp[1]);
        }
    }
    if (string1 === string2) {
        return true;
    }
    else {
        refrescarCaptcha(idCanvas);
        return false;
    }
}
function validarCaptchaCalculo(txtInput,idCanvas) {
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
    if (!valido) refrescarCaptcha(idCanvas);
    return valido;
}

function dibujarCaptcha(idCanvas,texto,props={}) {
    var ctxCanvas = document.getElementById(idCanvas).getContext('2d');
    var fontSize = props.fontSize?props.fontSize:"30px";
    var fontFamily = props.fontFamily?props.fontFamily:"Arial";
    var width = props.width?props.width:75;
    var height = props.height?props.height:50;
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

function refrescarCaptcha(idCanvas,tipo='calculo'){
    var captcha = tipo==='calculo'?generarCaptchaCalculo():generarCaptchaCaracteres();
    dibujarCaptcha(idCanvas,
        tipo==='calculo'?`${captcha.num1} ${captcha.signo} ${captcha.num2}`:captcha
    );
}