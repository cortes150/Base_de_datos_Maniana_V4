create database teleferico ;
use teleferico;
create table pasajero(
id_pasajero int auto_increment primary key,
ci varchar(20),
nombre varchar(60),
apellido varchar(60),
telefono varchar(20)
);


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
delete from tarjeta where id_tarjeta = 4;
desc tarjeta;
show create table tarjeta;
select * from tarjeta;
insert into tarjeta(numero,saldo,estado,fecha_emision,id_pasajero) value ('6543','53.2','activo','03/06/22','2');
create table recarga (
id_recarga int auto_increment primary key,
monto decimal(10,2),
fecha date,
id_tarjeta int,
constraint fk_recarga_tarjeta
foreign key(id_tarjeta) references tarjeta (id_tarjeta)
);
desc recarga;
show create table recarga;
insert into recarga (monto,fecha,id_tarjeta) value ('10','10/02/23','3');
select * from recarga;
delete from recarga where id_recarga = 6;
delete from pasajero where id_pasajero = 2;

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
desc pasajero;
show create table pasajero;
insert into pasajero (ci,nombre,apellido,telefono)values
 ('1505711','raul','garcia','65352'),
 ('4562312','carlos','torrez','546321'),
 ('652333','ignacio','rubin','465465'),
 ('652563','zuleyka','herrera','645654'),
 ('4562312','Diego','escobar','546321');
 select * from pasajero ;
 insert into tarjeta(numero,saldo,estado,fecha_emision,id_pasajero) value 
 ('6556','53.2','activo','01/07/22','3'),
 ('4253','5','activo','02/08/22','4'),
 ('6532','20','activo','03/09/22','5'),
 ('9632','30','activo','04/10/22','6'),
 ('9874','3','activo','05/11/22','7');
 select * from tarjeta;
 insert into recarga (monto,fecha,id_tarjeta) value
 ('85','02/01/20','6'),
 ('30','03/02/21','7'),
 ('20','06/03/22','8'),
 ('15','02/04/23','9'),
 ('20','07/06/24','10');
select * from recarga;

update pasajero set nombre = 'carlos' where id_pasajero = 1;
update pasajero set nombre = 'jose' , apellido = 'perez' where id_pasajero = 2;
update pasajero set nombre = 'fernando' where id_pasajero = 1 ;
delete from pasajero where id_pasajero = 2;


