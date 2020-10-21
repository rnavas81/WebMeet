/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

import java.util.Date;

/**
 *
 * @author rodrigo
 */
public class Mensaje {
    private int id;
    private int remitente = 0;
    private String nombreRemitente = "";
    private int destinatario = 0;
    private String nombreDestinatario = "";
    private String titulo ="";
    private String mensaje="";
    private Date fecha;
    private int leido = 0;
    private String adjunto="";
    //CONSTRUCTORES

    public Mensaje() {
    }

    public Mensaje(int id, int remitente, String nombreRemitente, int destinatario, String nombreDestinatario, String titulo, String mensaje, Date fecha, int leido) {
        this.id = id;
        this.remitente = remitente;
        this.nombreRemitente = nombreRemitente;
        this.destinatario = destinatario;
        this.nombreDestinatario = nombreDestinatario;
        this.titulo = titulo;
        this.mensaje = mensaje;
        this.fecha = fecha;
        this.leido = leido;
    }

    
    //GETTER && SETTER

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRemitente() {
        return remitente;
    }

    public void setRemitente(int remitente) {
        this.remitente = remitente;
    }

    public int getDestinatario() {
        return destinatario;
    }

    public String getNombreRemitente() {
        return nombreRemitente;
    }

    public void setNombreRemitente(String nombreRemitente) {
        this.nombreRemitente = nombreRemitente;
    }

    public String getNombreDestinatario() {
        return nombreDestinatario;
    }

    public void setNombreDestinatario(String nombreDestinatario) {
        this.nombreDestinatario = nombreDestinatario;
    }
    
    public void setDestinatario(int destinatario) {
        this.destinatario = destinatario;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public void setLeido() {
        this.leido = 1;
    }
    public void setNoLeido() {
        this.leido = 0;
    }
    
    public boolean isLeido(){
        return this.leido==1;
    }

    public String getAdjunto() {
        return adjunto;
    }

    public void setAdjunto(String adjunto) {
        this.adjunto = adjunto;
    }
    
}
