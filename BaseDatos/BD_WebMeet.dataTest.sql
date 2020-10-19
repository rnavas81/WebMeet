/**
 * Datos de pureba para la aplicación WebMeet
 * @author Rodrigo Navas
 * @created 2020/10/14
 */
/*
El password para admin1@email.com y a@email.com es 123a
*/
INSERT INTO WebMeet.Usuarios 
    (`activo`,`email`,`password`,`nombre`,`apellidos`)
    VALUES
    (1,'admin1@email.com','1552c03e78d38d5005d4ce7b8018addf','admin1','surname1'),
    (1,'admin2@email.com','','admin2','surname2'),
    (1,'a@email.com','1552c03e78d38d5005d4ce7b8018addf','user1','surname1'),
    (1,'b@email.com','','user2','surname2'),
    (1,'c@email.com','','user3','surname3'),
    (1,'d@email.com','','user4','surname4');
INSERT INTO WebMeet.Usuarios_Roles 
    (`usuario`,`rol`)
    VALUES
    (1,2),
    (2,2),
    (3,1),
    (4,1),
    (5,1),
    (6,1);
INSERT INTO WebMeet.Usuarios_Preferencias 
    (`usuario`,`preferencia`,`valor`)
    VALUES
    (3,3,"0"),
    (3,4,"50"),
    (3,5,"50"),
    (3,6,"50"),
    (3,7,1),
    (3,8,2),
    (4,3,"0"),
    (4,4,"60"),
    (4,5,"40"),
    (4,6,"40"),
    (4,7,1),
    (4,8,2),
    (5,3,"0"),
    (5,4,"60"),
    (5,5,"40"),
    (5,6,"40"),
    (5,7,1),
    (5,8,2),
    (6,3,"0"),
    (6,4,"60"),
    (6,5,"40"),
    (6,6,"40"),
    (6,7,1),
    (6,8,2);
INSERT INTO WebMeet.Usuarios_Amistades 
    (`usuario1`,`usuario2`,`aceptada`)
    VALUES
    (3,4,0),
    (3,5,1),
    (4,5,1),
    (6,5,0),
    (6,4,1);
INSERT INTO WebMeet.Mensajes 
    (`remitente`,`destinatario`,`titulo`,`mensaje`,`fecha`,`leido`)
    VALUES
    (3,4,'Hola','Hola user2','2020-10-10 09:00:00',1),
    (3,5,'Hola','Hola user3','2020-10-10 09:10:00',0),
    (4,5,'Hola','Hola user3','2020-10-11 09:10:00',1),
    (6,5,'Hola','Hola user3','2020-10-12 09:10:00',0),
    (6,4,'Hola','Hola user2','2020-10-13 09:10:00',0);