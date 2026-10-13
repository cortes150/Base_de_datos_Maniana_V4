CREATE DATABASE Proyectos_universitarios_db;
USE proyectos_universitarios_db;

CREATE TABLE materia(
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) not NULL
);

CREATE TABLE proyecto(
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    tema VARCHAR(100) not NULL,
    categoria VARCHAR(150) not NULL,
    fecha VARCHAR(50) NOT NULL,
    id_materia INT,
    CONSTRAINT proyecto_materia FOREIGN KEY(id_materia) REFERENCES materia(id_materia)
);

CREATE TABLE estudiante(
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    edad INT
);

CREATE TABLE participacion(
    id_particiacion INT AUTO_INCREMENT PRIMARY KEY,
    id_proyecto INT,
    CONSTRAINT participacion_proyecto FOREIGN KEY(id_proyecto) REFERENCES proyecto(id_proyecto),
    id_estudiante INT,
    CONSTRAINT participacion_estudiante FOREIGN KEY(id_estudiante) REFERENCES estudiante(id_estudiante)
);

CREATE TABLE jurado(
    id_jurado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE evaluacion(
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    nota INT,
    criterios VARCHAR(100) NOT NULL,
    observaciones VARCHAR(100) NOT NULL,
    id_proyecto INT,
    CONSTRAINT evaluacion_proyecto FOREIGN KEY(id_proyecto) REFERENCES proyecto(id_proyecto),
    id_jurado INT,
    CONSTRAINT evaluacion_jurado FOREIGN KEY(id_jurado) REFERENCES jurado(id_jurado)
);

-- S 4 
-- E 8
alter table proyecto add column observaciones varchar(500);
-- E 9
alter table proyecto add column titulo varchar(50);
alter table proyecto modify column titulo varchar(250);
-- E 10
alter table proyecto rename column tema to nombre_tema;
-- E 11
alter table proyecto add column categoria_de_tipo varchar(50);
-- E 12
alter table jurado add column especialidad varchar(50);
alter table jurado drop column especialidad;
-- S 5
-- E 13
ALTER TABLE materia add COLUMN id_materia_ INT;
ALTER TABLE materia add CONSTRAINT PRIMARY KEY(id_materia_);
-- E 14

-- E 15

-- E 16

-- E 17

-- S 6
-- E 18

-- E 19

-- E 20

-- E 21

-- E 22

-- S 7
-- E 23
ALTER TABLE estudiante MODIFY COLUMN nombre VARCHAR(100) NOT NULL;
-- E 24
ALTER TABLE participacion DROP CONSTRAINT participacion_estudiante;
-- E 25
