create database UniProjects_db;
use UniProjects_db;

create table Estudiante (
id_Estudiante int auto_increment primary key,
Nombre varchar(50) not null,
carrera varchar(50) not null,
correo varchar(50) not null
);


create table jurado(
id_Jurado int auto_increment primary key,
Nombre varchar(50) not null,
correo varchar(50) not null,
especialidad varchar(50)
);

alter table jurado drop column especialidad ;


create table asignatura(
id_asignatura int auto_increment primary key,
Nombre_materia varchar(50) not null
);


create table proyecto (
id_proyecto int auto_increment primary key,
id_asignatura int ,
Fecha_de_entrega date,
titulo_del_proyecto varchar(100) not null,
tema varchar(50),
constraint fk_proyecto_asignatura
foreign key (id_asignatura) references asignatura (id_asignatura)
);

alter table proyecto add column observaciones varchar(500);
alter table proyecto add column catergoria varchar(250);
alter table proyecto add constraint pk_proyecto_asignatura foreign key (id_asignatura) references asignatura (id_asignatura);





create table participacion(
id_participacion int auto_increment primary key,
id_proyecto int,
id_Estudiante int,
constraint fk_participacion_proyecto
foreign key (id_proyecto) references proyecto (id_proyecto),
constraint fk_participacion_Estudiante
foreign key (id_Estudiante) references Estudiante (id_Estudiante)
);
 alter table participacion add constraint pk_participacion_proyecto foreign key (id_proyecto) references proyecto (id_proyecto);
 alter table participacion add constraint pk_participacion_Estudiante foreign key (id_Estudiante) references Estudiante (id_Estudiante);


 
 create table evaluacion(
 id_evaluacion int auto_increment primary key,
 id_proyecto int,
 id_Jurado int,
 puntaje int,
 criterio varchar (500),
 observaciones varchar(500),
 constraint fk_evaluacion_Jurado
foreign key (id_Jurado) references Jurado (id_Jurado),
constraint fk_evaluacion_proyecto
foreign key (id_proyecto) references proyecto (id_proyecto)
 );
 
 
 

