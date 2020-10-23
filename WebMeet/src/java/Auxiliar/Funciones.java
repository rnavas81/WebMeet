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
import java.util.HashMap;
import java.util.Iterator;
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
    /**
     * Ordena la lista de no amigos en función de la 
     * diferencia total entre los valores de cada preferencia
     * @param usuario
     * @param otros
     * @return lista ordenada
     */
    public static LinkedList<Usuario> calcularCompatibilidad(Usuario usuario,LinkedList<Usuario> otros){
        LinkedList<Usuario> lista = new LinkedList<>();
        HashMap<Integer,HashMap<Integer,Integer>> temp = new HashMap<>();
        for (Usuario otro : otros) {
            HashMap<Integer,Integer> valores = new HashMap<>();
            int total = 0;
            for (Preferencia preferencia : otro.getPreferencias()) {
                int valorUsuario=usuario.getPreferenciaValorById(preferencia.getIdPreferencia());
                int valorOtro = preferencia.getValor();
                preferencia.setValor(valorUsuario - valorOtro);
                valores.put(preferencia.getIdPreferencia(), valorUsuario-preferencia.getValor());
                total += valores.get(preferencia.getIdPreferencia());
                preferencia.setValor(valorUsuario - valorOtro);
                otro.updatePreferencia(preferencia);
            }
            valores.put(0,total);
            temp.put(otro.getId(), valores);
            if(lista.isEmpty()){
                lista.add(otro);
            } else {
                boolean puesto=false;
                for (int i = 0;!puesto && i < lista.size(); i++) {
                    Usuario get = lista.get(i);
                    if(temp.get(get.getId()).get(0)<valores.get(0)){
                        lista.add(i,otro);
                        puesto=true;
                    }
                } 
                if(!puesto){
                    lista.add(otro);
                }
            }
        }
        
        return lista;
    }
 
}
