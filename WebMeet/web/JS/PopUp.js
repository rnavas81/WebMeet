/**
 * Funciones para controlar mis pop-ups
 */
/**
 * Crea un elemento popup
 * @param {type} valores, debe contener text=>texto a mostrar
 * puede contener time=>tiempo de muestra en milisegundos
 * @returns {undefined}
 */
crearPopUp = valores => {
    try {
        const text = typeof valores.text!=='undefined'?valores.text:"";
        const time = typeof valores.time!=='undefined'?valores.time:2000;
        const type = typeof valores.type!=='undefined'?valores.type:"";
        const id = "popup_"+new Date().getTime();
        var div = document.createElement('div');
        div.id=id;
        div.className=`popup ${type}`;
        var span = document.createElement('span');
        span.innerHTML=text;
        div.appendChild(span);
        document.body.appendChild(div);
        setTimeout(()=> {
            div.style.top="20vh";        
            setTimeout(()=> {
                div.style.top="-20vh";
                setTimeout(()=> {
                    document.body.removeChild(div);
                },2000);
            },time+2000);
        },100);
            
    } catch (e) {
        console.log(e);
    }
};


