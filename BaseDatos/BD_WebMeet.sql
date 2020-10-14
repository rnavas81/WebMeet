/**
 * Este fichero contiene el script para la creación de la base de datos necesaria
 * para la aplicación WebMeet.
 * @author Rodrigo Navas
 * @created 2020/10/13
 */

CREATE DATABASE IF NOT EXISTS WebMeet
    CHARACTER SET utf8
    COLLATE utf8_spanish_ci;


DROP TABLE IF EXISTS WebMeet.Mensajes_Adjuntos;
DROP TABLE IF EXISTS WebMeet.Mensajes;
DROP TABLE IF EXISTS WebMeet.Usuarios_Preferencias;
DROP TABLE IF EXISTS WebMeet.Usuarios_Roles;
DROP TABLE IF EXISTS WebMeet.Usuarios_Amistades;
DROP TABLE IF EXISTS WebMeet.Usuarios;
DROP TABLE IF EXISTS WebMeet.Auxiliar;

-- Crea la tabla auxiliar
-- 1=> ROLES; 2=> PREFERENCIAS; ·=>GENEROS
CREATE TABLE WebMeet.Auxiliar (
    id          INT NOT NULL AUTO_INCREMENT,
    tipo        TINYINT NOT NULL,
    nombre      VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    descripcion VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,

    PRIMARY KEY (id)
);
-- Datos iniciales del sistema
INSERT INTO WebMeet.Auxiliar (`tipo`,`nombre`,`descripcion`) VALUES
(1,'Usuario','Rol para usuario básico del sistema'),
(1,'Administrador','Rol para usuario administrador del sistema'),
(2,'Relación seria','indicarán si su finalidad es una relación seria o esporádica'),
(2,'Deportivos','valor numérico que indica, de 0 a 100, su gusto por los deportes'),
(2,'Artísticos','valor que indica su inquietud artística'),
(2,'Políticos','interés por la política, valorando de 0 a 100'),
(2,'Tiene/Quiere hijos o no','Indicando si tiene y/o si quiere hijos'),
(2,'Interés en','hombres, mujeres o ambos.'),
(3,'Hombre','Genero masculino'),
(3,'Mujer','Genero femenino');

CREATE TABLE WebMeet.Usuarios (
    id          INT NOT NULL AUTO_INCREMENT,
    activo      TINYINT NOT NULL DEFAULT 0,
    email       VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    password    VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    nombre      VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    apellidos   VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    descripcion VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    genero      TINYINT NOT NULL DEFAULT 0,
    fechaNacimiento DATE,
    pais        VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    ciudad      VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,

    PRIMARY KEY (id),
    UNIQUE KEY (email)
);

CREATE TABLE WebMeet.Usuarios_Roles (
    usuario     INT NOT NULL,
    rol         INT NOT NULL,

    PRIMARY KEY (usuario,rol),
    FOREIGN KEY (usuario) REFERENCES WebMeet.Usuarios(id),
    FOREIGN KEY (rol) REFERENCES WebMeet.Auxiliar(id)
);

CREATE TABLE WebMeet.Usuarios_Preferencias (
    id          INT NOT NULL AUTO_INCREMENT,
    usuario     INT NOT NULL,
    preferencia INT NOT NULL,
    valor       VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,

    PRIMARY KEY (id),
    FOREIGN KEY (usuario) REFERENCES WebMeet.Usuarios(id),
    FOREIGN KEY (preferencia) REFERENCES WebMeet.Auxiliar(id)
);

CREATE TABLE WebMeet.Usuarios_Amistades (
    id          INT NOT NULL AUTO_INCREMENT,
    usuario1    INT NOT NULL,
    usuario2    INT NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (usuario1) REFERENCES WebMeet.Usuarios(id),
    FOREIGN KEY (usuario2) REFERENCES WebMeet.Usuarios(id)
);

CREATE TABLE WebMeet.Mensajes (
    id          INT NOT NULL AUTO_INCREMENT,
    remitente   INT NOT NULL,
    destinatario INT NOT NULL,
    titulo      VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    mensaje     VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,
    fecha       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido       TINYINT DEFAULT 0,

    PRIMARY KEY (id),
    FOREIGN KEY (remitente) REFERENCES WebMeet.Usuarios(id),
    FOREIGN KEY (destinatario) REFERENCES WebMeet.Usuarios(id)
);

CREATE TABLE WebMeet.Mensajes_Adjuntos (
    id          INT NOT NULL AUTO_INCREMENT,
    mensaje     INT NOT NULL,
    fichero     VARCHAR (500) CHARACTER SET utf8 COLLATE utf8_spanish_ci,


    PRIMARY KEY (id),
    FOREIGN KEY (mensaje) REFERENCES WebMeet.Mensajes(id)
)