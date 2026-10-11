create database teleferico ;
use teleferico;
create table pasajero(
id_pasajero int auto_increment primary key,
ci varchar(20),
nombre varchar(60),
apellido varchar(60),
telefono varchar(20)
);
alter table pasajero rename column id_passajero to id_pasajero;


create table tarjeta(
id_tarjeta int auto_increment primary key,
numero varchar(30),
saldo decimal(10,2),
estado varchar(20),
fecha_emision date,
id_pasajero int ,

constraint fk_tarjeta_pasajero
foreign key (id_pasajero) references pasajero (id_pasajero)
);
create table recarga (
id_recarga int auto_increment primary key,
monto decimal(10,2),
fecha date,
id_tarjeta int,
constraint fk_recarga_tarjeta
foreign key(id_tarjeta) references tarjeta (id_tarjeta)
);
create table linea (
id_linea int auto_increment primary key,
nombre varchar(50),
color varchar(30)
);
create table estacion(
id_estacion int auto_increment primary key,
nombre varchar(80),
ubicacion varchar(159),
id_linea int,

constraint fk_estacion_linea
foreign key(id_linea) references linea (id_linea)
);

create table ingreso (
id_ingreso int auto_increment primary key,
fecha_hora datetime ,
id_tarjeta int,
id_estacion int,

constraint fk_ingreso_tarjeta
foreign key (id_tarjeta) references tarjeta(id_tarjeta),

constraint fk_ingreso_estacion
foreign key (id_estacion) references estacion (id_estacion)
);
create table cabina (
id_cabina int auto_increment primary key,
codigo varchar(50),
estado varchar(50),
capacidad int,
id_linea int,
constraint fk_cabina_linea
foreign key (id_linea) references linea (id_linea)
);

create table viaje(
id_viaje int auto_increment primary key,
fecha date,
hora time,
id_cabina int,
constraint fk_viaje_cabina
foreign key (id_cabina) references cabina (id_cabina)
);
create table mantenimiento(
id_mantenimiento int auto_increment primary key,
descripcion varchar(255),
fecha date,
tipo varchar(40),
id_cabina int,

constraint fk_mantenimiento_cabina
foreign key (id_cabina) references cabina (id_cabina)
);
