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
public class Auxiliar {

    ///CAMPOS
    private int id = 0;
    private int tipo = 0;
    private String nombre = "";
    private String descripcion = "";
    ///CONSTRUCTOR

    public Auxiliar() {
    }

    public Auxiliar(int id, int tipo, String nombre, String descripcion) {
        this.id = id;
        this.tipo = tipo;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }
    
    ///GETTER

    public int getId() {
        return id;
    }

    public int getTipo() {
        return tipo;
    }

    public String getNombre() {
        return nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }
    

}
