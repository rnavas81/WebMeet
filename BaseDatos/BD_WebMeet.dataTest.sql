/**
 * Datos de pureba para la aplicación WebMeet
 * @author Rodrigo Navas
 * @created 2020/10/14
 */
/*
El password para todos es 123a
*/
INSERT INTO WebMeet.Usuarios 
    (`activo`,`email`,`password`,`nombre`,`apellidos`,`genero`)
    VALUES
    (1,'admin@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Administrador','',null),
    (1,'juan@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Juan','Fernandez',9),
    (1,'pedro@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Pedro','Sanchez',9),
    (1,'marta@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Marta','Gonzalez',10),
    (1,'elena@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Elena','Lopez',10),
    (1,'miguel@webmeet.com','1552c03e78d38d5005d4ce7b8018addf','Miguel','Hernandez',10);
INSERT INTO WebMeet.Usuarios_Roles 
    (`usuario`,`rol`)
    VALUES
    (1,1),
    (2,2),
    (3,2),
    (4,2),
    (5,1);
    
INSERT INTO WebMeet.Usuarios_Preferencias 
    (`usuario`,`preferencia`,`valor`)
    VALUES
    (2,3,5),
    (2,4,40),
    (2,5,60),
    (2,6,40),
    (2,7,1),
    (2,8,2),
    (3,3,0),
    (3,4,50),
    (3,5,50),
    (3,6,50),
    (3,7,1),
    (3,8,2),
    (4,3,0),
    (4,4,60),
    (4,5,40),
    (4,6,40),
    (4,7,1),
    (4,8,2),
    (5,3,0),
    (5,4,60),
    (5,5,40),
    (5,6,40),
    (5,7,1),
    (5,8,2),
    (6,3,0),
    (6,4,60),
    (6,5,40),
    (6,6,40),
    (6,7,1),
    (6,8,2);
INSERT INTO WebMeet.Usuarios_Amistades 
    (`usuario1`,`usuario2`,`aceptada`)
    VALUES
    (2,3,1),
    (2,4,0),
    (3,4,1),
    (3,5,0),
    (4,5,1),
    (4,6,0),
    (5,6,1);
    (5,2,0);
    (6,2,1);
    (6,3,0);
INSERT INTO WebMeet.Mensajes 
    (`remitente`,`destinatario`,`titulo`,`mensaje`,`fecha`,`leido`)
    VALUES
    (2,3,'Hola Pedro!!','Me gustaría conocerte','2020-10-10 09:00:00',1),
    (2,4,'Hola Marta!!','Me gustaría conocerte','2020-10-10 09:05:00',1),
    (3,4,'Hola Marta!!','Hola, como estas?','2020-10-10 09:00:00',1),
    (3,5,'Hola Elena!!','Vaya mensaje','2020-10-10 09:10:00',0),
    (4,5,'Hola Elena!!','Esto no se si funciona','2020-10-11 09:10:00',1),
    (4,6,'Hola Miguel!!','No debería escribir esto','2020-10-11 09:15:00',1),
    (5,6,'Hola Miguel!!','','2020-10-12 09:20:00',0),
    (5,2,'Hola Juan!!','','2020-10-12 09:25:00',0),
    (6,2,'Hola Juan!!','Nos volvemos a encontrar','2020-10-13 09:25:00',0),
    (6,3,'Hola Pedro!!','Nos volvemos a encontrar','2020-10-13 09:30:00',0);