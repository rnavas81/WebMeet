/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Auxiliar;

import Modelo.Preferencia;
import Modelo.Usuario;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.LinkedList;

/**
 *
 * @author rodrigo
 */
public class Funciones {
    public static int randomInt(int max,int min){
        int num = (int)(Math.random() * max)+min;
        return num;
    }
    public static String alphanumericoAleatorio(int n) 
    { 
  
        // chose a Character random from this String 
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                    + "0123456789"
                                    + "abcdefghijklmnopqrstuvxyz"; 
  
        // create StringBuffer size of AlphaNumericString 
        StringBuilder sb = new StringBuilder(n); 
  
        for (int i = 0; i < n; i++) { 
  
            // generate a random number between 
            // 0 to AlphaNumericString variable length 
            int index 
                = (int)(AlphaNumericString.length() 
                        * Math.random()); 
  
            // add Character one by one in end of sb 
            sb.append(AlphaNumericString 
                          .charAt(index)); 
        } 
  
        return sb.toString(); 
    } 
    
    public static String encriptarTexto(String textToHash){
        String generatedHash = null;
        try {
            // Create MessageDigest instance for MD5
            MessageDigest md = MessageDigest.getInstance("MD5");
            //Add password bytes to digest
            md.update(textToHash.getBytes());
            //Get the hash's bytes 
            byte[] bytes = md.digest();
            //This bytes[] has bytes in decimal format;
            //Convert it to hexadecimal format
            StringBuilder sb = new StringBuilder();
            for(int i=0; i< bytes.length ;i++)
            {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            //Get complete hashed password in hex format
            generatedHash = sb.toString();
        } 
        catch (NoSuchAlgorithmException e) 
        {
            generatedHash = null;
        }
        return generatedHash;
    }
    public static LinkedList<Usuario> calcularCompatibilidad(Usuario usuario,LinkedList<Usuario> otros){
        LinkedList<Usuario> lista=new LinkedList<>();
        for (Usuario otro : otros) {
            int total = 0;
            for (Preferencia preferencia : otro.getPreferencias()) {
                Preferencia pu = usuario.getPreferenciaById(preferencia.getId());
                preferencia.setValor(pu.getValor() - preferencia.getValor());
                total += preferencia.getValor();
            }
            otro.setTotal(total);
            if(lista.isEmpty()){
                lista.add(otro);
            } else {
                boolean puesto=false;
                for (int i = 0; !puesto && i < lista.size(); i++) {
                    Usuario get = lista.get(i);
                    if(get.getTotal()>otro.getTotal()){
                        lista.add(i, otro);
                        puesto=true;
                    }
                }
            }
        }
        return lista;
    }
 
}
