create database gimnasio;
use gimnasio;
create table socio(
id_socio int auto_increment primary key, 
cod_socio varchar(20) not null unique ,
nombre varchar(50) not null,
apellido_p varchar(50) not null,
apellido_m varchar(50),
fecha_nacimiento date not null,
calle varchar(100),
numero varchar(10),
ciudad varchar(60),
correo_electronico varchar(100) unique,
fecha_incripcion date
);
create table entrenador(
id_entrenador int auto_increment primary key,
cod_entrenador varchar(20),
nombre varchar(50),
apellido_p varchar(50),
apellido_m varchar(50),
especielidad varchar(50),
anios_experiencia int check(anios_experiencia >=0),
telefono_contacto varchar(50),
turno_trabajo varchar(50) 
);
create table clase(
id_clase int auto_increment primary key,
cod_clase varchar(20),
nombre_clase varchar(60),
tipo_actividad varchar(50),
duracion int,
horario varchar(20),
nivel_dificultad varchar(20),
id_entrenador int,
constraint pk_clase_entrenador
foreign key (id_entrenador) references entrenador (id_entrenador)
);
create table inscripcion(
id_inscripcion int auto_increment primary key,
id_socio int,
id_clase int,
fecha_incripcion date not null,
pagos_realizados decimal(10,2) default 0,
asistencia int default 0,
constraint pk_inscripcion_socio
foreign key (id_socio) references socio (id_socio),

constraint pk_inscripcion_clase
foreign key (id_clase) references clase (id_clase)
);
