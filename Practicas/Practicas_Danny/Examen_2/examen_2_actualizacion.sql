create database Uniprojects_db ;
use Uniprojects_db;
create table estudiante (
id_estudiante int auto_increment primary key,
nombre varchar(50),
apellido_P varchar(50),
correo varchar(70)
);
alter table estudiante add constraint uq_estudiante_correo unique(correo);
alter table estudiante modify nombre varchar(100) not null;

create table categoria(
id_categoria int auto_increment primary key,
tipo_categoria varchar(80)
);
create table materia(
id_materia int auto_increment primary key,
nombre_materia varchar(80),
turno varchar(20),
cod_materia varchar(10)
);
alter table materia add constraint pk_materia primary key(id_materia);


create table proyecto (
id_proyecto int auto_increment primary key,
titulo varchar(80),
tema varchar(80),
fecha_presentacion date,
id_materia int,
id_categoria int,

constraint fk_proyecto_materia
foreign key (id_materia) references materia (id_materia),

constraint fk_proyecto_categoria
foreign key (id_categoria) references categoria (id_categoria)
);

alter table proyecto add column observaciones varchar(500);
alter table proyecto modify titulo varchar(250);
alter table proyecto add column categoria varchar(50);
alter table proyecto rename column tema to nombre_tema;
alter table proyecto add constraint pk_proyecto primary key (id_proyecto);

create table jurado (
id_jurado int auto_increment primary key,
nombre varchar(50),
apellido_P varchar(50),
telefono int,
especialidad varchar(80)
);
alter table jurado drop especialidad;
alter table jurado add constraint pk_jurado primary key(id_jurado);

create table participacion(
id_participacion int auto_increment primary key,
id_proyecto int,
id_estudiante int
);
alter table participacion drop id_participacion;
alter table participacion add primary key(id_proyecto ,id_estudiante);
alter table participacion add constraint fk_participacion_proyecto foreign key(id_proyecto) references proyecto (id_proyecto);
alter table participacion add constraint fk_participacion_estudiante foreign key(id_estudiante) references estudiante(id_estudiante);
alter table participacion drop fk_participacion_estudiante;

create table evaluacion(
id_evaluacion int auto_increment primary key,
id_jurado int,
id_proyecto int,
puntaje decimal(10,2),
observacion varchar(150),
criterio varchar(80),

constraint fk_evalucacion_jurado 
foreign key (id_jurado) references jurado (id_jurado),

constraint fk_evaluacion_proyecto
foreign key (id_proyecto) references proyecto (id_proyecto)
);
alter table evaluacion add constraint fk_evaluacion_jurado foreign key (id_jurado) references jurado(id_jurado);
alter table evaluacion add constraint chk_evaluacion_puntaje check (puntaje >=0 && puntaje <= 100);