package Modelo;

import java.util.Arrays;
import java.util.LinkedList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author rodrigo
 */
public class Usuario {
    private int id = -1;
    private int activo = 0;
    private String email = "";
    private String nombre = "";
    private String apellidos = "";
    private String descripcion = "";
    private int genero = 0;
    private String fechaNacimiento = "";
    private String pais = "";
    private String ciudad = "";
    private LinkedList<Integer>roles = new LinkedList<>();
    public Usuario() {
        this.roles.add(1);
    }
    public Usuario (String email,String nombre,String apellidos){
        this.email = email;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.roles.add(1);
    }
    public Usuario(int id, int activo, String email, String nombre, String apellidos, String descripcion, int genero, String fechaNacimiento, String pais, String ciudad) {
        this.id = id;
        this.activo = activo;
        this.email = email;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.descripcion = descripcion;
        this.genero = genero;
        this.fechaNacimiento = fechaNacimiento;
        this.pais = pais;
        this.ciudad = ciudad;
        this.roles.add(1);
    }

    public int getId() {
        return id;
    }

    public int getActivo() {
        return activo;
    }

    public void setActivo(int activo) {
        this.activo = activo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getGenero() {
        return genero;
    }

    public void setGenero(int genero) {
        this.genero = genero;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(String fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getPais() {
        return pais;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public LinkedList getRoles() {
        return roles;
    }

    public void setRoles(LinkedList<Integer> roles) {
        this.roles = roles;
    }
    public void setRol(final int i){
        if(!this.roles.contains(i)){
            this.roles.add(i);
        }
    }
    public boolean isRol(final int i){
        return this.roles.contains(i);
    }
    
}
