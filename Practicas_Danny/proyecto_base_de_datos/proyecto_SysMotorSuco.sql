create database SysMotorSuco;
use SysMotorSuco;
create table cliente (
id_cliente int auto_increment primary key,
nombre varchar(80),
telefono int ,
correo varchar(80),
direccion varchar(80)
);
create table vehiculo (
id_vehiculo int auto_increment primary key,
placa varchar(10),
id_cliente int ,
marca varchar(40),
modelo varchar(50),
anio int ,
color varchar(50),

constraint fk_vehiculo_cliente
foreign key (id_cliente) references cliente (id_cliente)
);

create table tipo_de_servicio (
id_tipo_servicio int auto_increment primary key ,
nombre_servicio varchar(150),
descripcion varchar (150)
);

create table rol (
id_rol int auto_increment primary key,
nombre_rol varchar (150),
descripcion varchar(150)
);

create table usuario(
id_usuario int auto_increment primary key ,
id_rol int,
nombre varchar (80),
correo varchar (80),
password varchar(80),

constraint fk_usuario_rol
foreign key (id_rol) references rol (id_rol)
);

create table orden_de_trabajo(
id_orden int auto_increment primary key,
id_vehiculo  int ,
id_tipo_servicio int,
id_usuario_abre int,
id_usuario_atiende int,
id_usuario_cobra int,
id_usuario_elabora int,
fecha_apertura varchar(10),
estado varchar(30),
observaciones varchar(150),

constraint fk_orden_vehiculo
foreign key (id_vehiculo) references vehiculo (id_vehiculo), 
constraint fk_orden_tservicio
foreign key (id_tipo_servicio) references tipo_de_servicio (id_tipo_servicio),
constraint fk_orden_usuarioA
foreign key (id_usuario_abre) references usuario (id_usuario),
constraint fk_orden_usuarioAt
foreign key (id_usuario_atiende) references usuario (id_usuario),
constraint fk_orden_usuarioCo
foreign key (id_usuario_cobra) references usuario (id_usuario),
constraint fk_orden_usuarioEl
foreign key (id_usuario_elabora) references usuario (id_usuario)

);



create table proveedor(
id_proveedor int auto_increment primary key,
nombre_proveedor varchar(80),
telefono int,
correo  varchar(100)
);
create table repuesto (
id_repuesto int auto_increment primary key,
id_proveedor int,
id_orden int,
nombre_repuesto varchar(80),
precio_unitario float(50),
stock int ,
constraint fk_repuesto_orden
foreign key (id_orden) references orden_de_trabajo (id_orden),
constraint fk_repuesto_proveedor 
foreign key(id_proveedor ) references proveedor(id_proveedor)

);
create table comprobante (
id_comprobante int auto_increment primary key,
id_orden int ,
fecha_pago varchar(10),
monto_total decimal(10,2),
metodo_pago varchar(80),

constraint fk_comprobante_orden
foreign key (id_orden) references orden_de_trabajo (id_orden)
);
create table expediente_anh (
id_expediente int auto_increment primary key,
id_orden int,
fecha_elaboracion varchar(10),
codigo_regulacion varchar(20),

constraint fk_expediente_orden
foreign key (id_orden) references orden_de_trabajo(id_orden)
);
create table checklist (
id_checklist int  auto_increment primary key,
id_orden int,
id_usuario_firma int,
fecha_revision varchar(10),
estado varchar(30),

constraint fk_checklist_orden
foreign key (id_orden) references orden_de_trabajo (id_orden) ,
constraint fk_checklist_usuarioF
foreign key (id_usuario_firma) references usuario(id_usuario)
);
create table punto_de_inspeccion(
id_punto_inspeccion int auto_increment primary key ,
id_checklist int,
descripcion_punto varchar(150),
categoria varchar(80),

constraint fk_punto_checklist
foreign key (id_checklist) references checklist (id_checklist)
);
INSERT INTO rol (id_rol, nombre_rol, descripcion) VALUES 
(1, 'Administrador', 'Control total del sistema'),
(2, 'Mecánico', 'Atiende órdenes de trabajo');

INSERT INTO usuario (id_rol, nombre, correo, password) VALUES 
(1, 'Carlos Perez', 'admin@suco.com', '12345');

insert into usuario(id_rol,nombre,correo,password) values
(2,'Jose Raul' ,'master@gmail.com','654321');

SELECT u.nombre, u.correo, u.password, r.nombre_rol 
FROM usuario u 
JOIN rol r ON u.id_rol = r.id_rol;


