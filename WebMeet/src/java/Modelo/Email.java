package Modelo;

import Auxiliar.Constantes;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class Email {
    
    public void enviarCorreo(String para, String mensaje, String asunto){
            try{
                            
                Properties prop = System.getProperties();
                
                prop.put("mail.smtp.starttls.enable","true");
                prop.put("mail.smtp.host", Constantes.EMAIL_HOST);
                prop.put("mail.smtp.user",Constantes.EMAIL_ADDRESS);
                prop.put("mail.smtp.password", Constantes.EMAIL_PASSWORD);
                prop.put("mail.smtp.port",Constantes.EMAIL_PORT);
                //prop.put("mail.smtp.port",465);
                prop.put("mail.smtp.auth",Constantes.EMAIL_AUTH);
                
                Session sesion = Session.getDefaultInstance(prop,null);
                
                MimeMessage message = new MimeMessage(sesion);
                
                message.setFrom(new InternetAddress(Constantes.EMAIL_ADDRESS));

                
                message.setRecipient(Message.RecipientType.TO, new InternetAddress(para));
                
                message.setSubject(asunto);
                message.setText(mensaje);
                
                try (Transport transport = sesion.getTransport("smtp")) {
                    transport.connect(Constantes.EMAIL_HOST,Constantes.EMAIL_ADDRESS,Constantes.EMAIL_PASSWORD);
                    
                    transport.sendMessage(message, message.getAllRecipients());
                }
                System.out.println("Envío del correo a " + para + " con exito.");
                
            }catch(MessagingException e){
                System.out.println("Envio correo[Error] "+e.getMessage());
            }
        
    }
    
}
