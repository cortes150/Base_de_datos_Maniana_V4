create database cocacola_db;
use cocacola_db;



create table categoria(
id_categoria int auto_increment primary key,
nombre_categoria varchar(50),
estado bool
);

create table producto(
id_producto int auto_increment primary key,
nombre varchar(60) not null,
precio decimal(10,2) not null,
caducidad int not null,
id_categoria int,
constraint fk_producto_categoria
foreign key (id_categoria) references categoria (id_categoria)
);

create table planta_produccion(
id_planta_produccion int auto_increment primary key,
nombre varchar(60) not null,
ubicacion varchar(60) not null
);

create table invetario(
id_invetario int auto_increment primary key,
stock varchar(60),
id_producto int,
constraint fk_producto_inventario
foreign key (id_producto) references producto (id_producto),
id_planta_produccion int,
constraint fk_planta_produccion_inventario
foreign key (id_planta_produccion) references planta_produccion (id_planta_produccion)
);

create table ciudad (
id_ciudad int auto_increment primary key,
nombre varchar(60) not null,
id_planta_produccion int,
constraint fk_planta_produccion_ciudad
foreign key (id_planta_produccion) references planta_produccion (id_planta_produccion)
);

