create database eventos;
use eventos;
create table evento(
id_evento int auto_increment primary key,
lugar varchar(100) not null,
fecha date not null,
hora time not null,
aforo int not null check (aforo > 0)
);
create table usuario (
id_usuario int auto_increment primary key,
informacion_contacto varchar(150) not null,
tipo_usuario varchar(30) not null
);
create table asistir (
id_asistir int primary key,
id_usuario int not null,
id_evento int not null,

constraint fk_asistir_usuario 
foreign key(id_usuario) references usuario(id_usuario),

constraint fk_asistir_evento
foreign key(id_evento) references evento (id_evento)
);
create table tipo_entrada(
id_tipo_entrada int auto_increment primary key,
nombre varchar(50),
precio decimal(10,2) not null check (precio >= 0),
id_evento int not null,
constraint pk_evento_tipoen
foreign key (id_evento) references evento (id_evento)
);

alter table tipo_entrada add column id_entrada int;
alter table tipo_entrada add constraint fk_entrada_tipoen foreign key (id_entrada) references entrada (id_entrada) ;
create table venta(
id_venta int auto_increment primary key ,
id_usuario  int not null,
fecha_venta date,
monto_venta decimal(10,2),
constraint fk_venta_usuario
foreign key (id_usuario) references usuario (id_usuario) 
);
create table pagos(
id_pago int auto_increment primary key,
id_venta int,
metodo_pago varchar(30) ,
constraint fk_pagos_venta
foreign key (id_venta) references venta (id_venta)
);
create table entrada(
id_entrada int auto_increment  primary key,
nombre_entreda varchar(50),
id_usuario int, 
id_venta int ,

constraint fk_entrada_usuario
foreign key (id_usuario) references usuario (id_usuario),

constraint fk_entrada_venta
foreign key (id_venta) references venta(id_venta)
);

