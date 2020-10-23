/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

/**
 *
 * @author rodrigo
 */
public class Preferencia {
    private int id;
    private int idPreferencia;
    private String nombre;
    private int valor = 0;

    public Preferencia() {
    }

    public Preferencia(int id,int idPreferencia, String nombre, int valor) {
        this.id = id;
        this.idPreferencia = idPreferencia;
        this.nombre = nombre;
        this.valor = valor;
    }
    
    /// GETTER & SETTER

    public int getId() {
        return id;
    }

    public int getIdPreferencia() {
        return idPreferencia;
    }
    
    public String getNombre() {
        return nombre;
    }

    public int getValor() {
        return valor;
    }

    public void setValor(int valor) {
        this.valor = valor;
    }
    
}
