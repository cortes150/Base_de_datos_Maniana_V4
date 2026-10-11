create database veterinaria;
use veterinaria;
 create table dueno(
 id_dueno int auto_increment primary key,
 nombre varchar(60),
 apellido_p varchar(60),
 apellido_m varchar(60)
 );
 create table telefono(
 id_telefono int auto_increment primary key,
 nro_telefono varchar(20),
 id_dueno int,
 
 constraint fk_telefono_dueno
 foreign key(id_dueno) references dueno (id_dueno)
 );
 
 create table mascota(
 id_mascota int auto_increment primary key,
 nombre varchar(60),
 sexo char(1) check (sexo in ('M','H')),
 microchip varchar(30),
 foto_mascota varchar(255),
 id_dueno int not null,
 
 constraint fk_mascota_dueno
 foreign key (id_dueno) references dueno (id_dueno)
 );
 create table veterinario(
 id_veterinario int auto_increment primary key,
 nombre varchar(60),
 apellido varchar(60),
 n_colegiatura varchar(30),
 telefono varchar(20),
 correo varchar(100)
 );
 
 create table ficha(
 id_ficha int auto_increment primary key,
 prioridad varchar(20),
 fecha date,
 tipo varchar(40),
 observacion text,
 id_mascota int,
 id_veterinario int,
 
 constraint fk_ficha_mascota
 foreign key(id_mascota) references mascota (id_mascota),
 
 constraint fk_ficha_veterinario
 foreign key (id_veterinario) references  veterinario (id_veterinario)
 );
 
 create table cita(
 id_cita int auto_increment primary key,
 fecha date,
 hora time,
 motimo varchar(150),
 id_dueno int,
 id_veterinario int,
 constraint fk_cita_dueno
 foreign key (id_dueno) references dueno (id_dueno),
 
 constraint fk_cita_veterinario 
 foreign key (id_veterinario) references veterinario (id_veterinario)
 );
 
 create table receta (
 id_receta int auto_increment primary key,
 fecha date,
 indicaciones text,
 id_cita int,
 
 constraint fk_receta_cita
 foreign key (id_cita) references cita (id_cita)
 );
 create table factura (
 id_factura int auto_increment primary key,
 nro_factura varchar(20),
 monto decimal(10,2),
 id_dueno int,
 
 constraint fk_factura_dueno
 foreign key (id_dueno) references dueno (id_dueno)
 );
 
 create table pago(
 id_pago int auto_increment primary key,
 fecha_pago date,
 saldo decimal(10,2),
 id_factura int,
 
 constraint fk_pago_factura
 foreign key (id_factura) references factura (id_factura)
 );
 
 create table tratamiento(
id_tratamiento int auto_increment primary key,
tipo varchar(50),
id_mascota int,

constraint fk_tratamiento_mascota
foreign key (id_mascota) references mascota (id_mascota)
 );
 
 create table vacuna(
 id_vacuna int auto_increment primary key,
 nombre_vacuna varchar(80),
 lote varchar(30),
 caducidad date
 );
 
 create table tratamiento_vacuna(
 id_tratamiento_vacuna int auto_increment primary key,
 id_tratamiento int,
 id_vacuna int,
 
 constraint fk_trataVAcu_tratamiento
 foreign key (id_tratamiento) references tratamiento (id_tratamiento),
 
 constraint fk_trataVacu_vacuna
 foreign key (id_vacuna) references vacuna (id_vacuna)
 );