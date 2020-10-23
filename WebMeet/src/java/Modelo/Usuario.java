package Modelo;

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
    private LinkedList<Preferencia> preferencias = new LinkedList<>();
    private int total=0;
    public Usuario() {
    }
    public Usuario (String email,String nombre,String apellidos){
        this.email = email;
        this.nombre = nombre;
        this.apellidos = apellidos;
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
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public LinkedList<Integer> getRoles() {
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
    public void addPreferencia(Preferencia preferencia){
        boolean existe=false;
        for (int i = 0;!existe && i < preferencias.size(); i++) {
            Preferencia get = preferencias.get(i);
            if(get.getId()==preferencia.getId()){
                existe=true;
            }
        }
        if(!existe){
            this.preferencias.add(preferencia);
        }
    }
    public void updatePreferencia(Preferencia preferencia){
        boolean existe=false;
        for (int i = 0;!existe && i < preferencias.size(); i++) {
            Preferencia get = preferencias.get(i);
            if(get.getId()==preferencia.getId()){
                existe=true;
                get.setValor(preferencia.getValor());
            }
        }
        if(!existe){
            this.preferencias.add(preferencia);
        }
    }
    public Preferencia getPreferenciaById(int id){
        for (Preferencia preferencia : this.preferencias) {
            if(preferencia.getId()==id)return preferencia;
        }
        return null;
    }
    public int getPreferenciaValorById(int id){
        for (Preferencia preferencia : this.preferencias) {
            if(preferencia.getId()==id)return preferencia.getValor();
        }
        return 0;
    }
    public Preferencia getPreferenciaByIndex(int index){
        if(index<this.preferencias.size()){
            return this.preferencias.get(index);
        } else {
            return null;
        }
    }

    public LinkedList<Preferencia> getPreferencias() {
        return preferencias;
    }

    public void setPreferencias(LinkedList<Preferencia> preferencias) {
        this.preferencias = preferencias;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
    
    
}
