
-- ============================================
-- BASE DE DATOS
-- ============================================
CREATE DATABASE IF NOT EXISTS MiTelefericoDB;
USE MiTelefericoDB;

-- ============================================
--  USUARIOS / PASAJEROS
-- ============================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    ciudad VARCHAR(50),
    tipo_usuario ENUM('pasajero','administrador','operador') DEFAULT 'pasajero',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
--  TARJETAS
-- ============================================
CREATE TABLE tarjetas (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0,
    fecha_emision DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- RECARGAS DE TARJETA
-- ============================================
CREATE TABLE recargas (
    id_recarga INT AUTO_INCREMENT PRIMARY KEY,
    id_tarjeta INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_recarga DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo','tarjeta','transferencia','qr') DEFAULT 'efectivo',
    FOREIGN KEY (id_tarjeta) REFERENCES tarjetas(id_tarjeta)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- ============================================
-- LINEAS DE TELEFERICO
-- ============================================
CREATE TABLE lineas (
    id_linea INT AUTO_INCREMENT PRIMARY KEY,
    nombre_linea VARCHAR(50) NOT NULL,
    color VARCHAR(30),
    estado ENUM('activo','en_mantenimiento') DEFAULT 'activo'
);
-- ============================================
-- ESTACIONES
-- ============================================
CREATE TABLE estaciones (
    id_estacion INT AUTO_INCREMENT PRIMARY KEY,
    id_linea INT NOT NULL,
    nombre_estacion VARCHAR(50) NOT NULL,
    orden INT NOT NULL, -- posición de la estación en la línea
    FOREIGN KEY (id_linea) REFERENCES lineas(id_linea)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- ============================================
-- VIAJES (cabinas recorriendo estaciones)
-- ============================================
CREATE TABLE viajes (
    id_viaje INT AUTO_INCREMENT PRIMARY KEY,
    id_linea INT NOT NULL,
    id_estacion_origen INT NOT NULL,
    id_estacion_destino INT NOT NULL,
    fecha_viaje DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente','en_curso','finalizado') DEFAULT 'pendiente',
    FOREIGN KEY (id_linea) REFERENCES lineas(id_linea)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_estacion_origen) REFERENCES estaciones(id_estacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_estacion_destino) REFERENCES estaciones(id_estacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- ============================================
-- BOLETOS (un solo uso)
-- ============================================
CREATE TABLE boletos (
    id_boleto INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_linea INT NOT NULL,
    id_viaje INT NOT NULL,
    id_pago INT NULL, -- si se paga con tarjeta o transferencia
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    precio DECIMAL(10,2) NOT NULL DEFAULT 3.00,
    estado ENUM('activo','usado','cancelado') DEFAULT 'activo',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_linea) REFERENCES lineas(id_linea)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_viaje) REFERENCES viajes(id_viaje)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- ============================================
-- PAGOS (boletos o recargas)
-- ============================================
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_boleto INT NULL,     -- si es pago de boleto
    id_recarga INT NULL,    -- si es pago de recarga
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('efectivo','tarjeta','transferencia','qr') DEFAULT 'efectivo',
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente','completado','cancelado') DEFAULT 'pendiente',
    FOREIGN KEY (id_boleto) REFERENCES boletos(id_boleto)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (id_recarga) REFERENCES recargas(id_recarga)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================
-- USUARIOS (50)
-- ============================================
INSERT INTO usuarios (nombre, email, telefono, ciudad, tipo_usuario) VALUES
('Juan Perez','juan.perez@gmail.com','71234567','La Paz','pasajero'),
('Maria Lopez','maria.lopez@gmail.com','71234568','El Alto','pasajero'),
('Carlos Sanchez','carlos.sanchez@gmail.com','71234569','La Paz','pasajero'),
('Ana Gutierrez','ana.gutierrez@gmail.com','71234570','La Paz','pasajero'),
('Luis Fernandez','luis.fernandez@gmail.com','71234571','El Alto','pasajero'),
('Sofia Morales','sofia.morales@gmail.com','71234572','La Paz','pasajero'),
('Jorge Rojas','jorge.rojas@gmail.com','71234573','El Alto','pasajero'),
('Paola Castillo','paola.castillo@gmail.com','71234574','La Paz','pasajero'),
('Miguel Vargas','miguel.vargas@gmail.com','71234575','La Paz','pasajero'),
('Carla Medina','carla.medina@gmail.com','71234576','La Paz','pasajero'),
('Admin1','admin1@teleferico.bo','70100001','La Paz','administrador'),
('Admin2','admin2@teleferico.bo','70100002','El Alto','administrador'),
('Operador1','operador1@teleferico.bo','70110001','La Paz','operador'),
('Operador2','operador2@teleferico.bo','70110002','El Alto','operador'),
('Admin3','admin3@teleferico.bo','70100003','La Paz','administrador'),
('Pedro Aguirre','pedro.aguirre@gmail.com','71234577','La Paz','pasajero'),
('Lucia Ramos','lucia.ramos@gmail.com','71234578','La Paz','pasajero'),
('Diego Herrera','diego.herrera@gmail.com','71234579','El Alto','pasajero'),
('Valeria Cruz','valeria.cruz@gmail.com','71234580','La Paz','pasajero'),
('Ricardo Flores','ricardo.flores@gmail.com','71234581','La Paz','pasajero'),
('Natalia Suarez','natalia.suarez@gmail.com','71234582','El Alto','pasajero'),
('Fernando Diaz','fernando.diaz@gmail.com','71234583','La Paz','pasajero'),
('Jessica Ortega','jessica.ortega@gmail.com','71234584','La Paz','pasajero'),
('Alvaro Molina','alvaro.molina@gmail.com','71234585','El Alto','pasajero'),
('Gabriela Torres','gabriela.torres@gmail.com','71234586','La Paz','pasajero'),
('Santiago Jimenez','santiago.jimenez@gmail.com','71234587','La Paz','pasajero'),
('Camila Vega','camila.vega@gmail.com','71234588','El Alto','pasajero'),
('Mateo Castillo','mateo.castillo@gmail.com','71234589','La Paz','pasajero'),
('Isabella Ramos','isabella.ramos@gmail.com','71234590','La Paz','pasajero'),
('Admin4','admin4@teleferico.bo','70100004','El Alto','administrador'),
('Operador3','operador3@teleferico.bo','70110003','La Paz','operador'),
('Pedro Martinez','pedro.martinez@gmail.com','71234591','El Alto','pasajero'),
('Paula Gutierrez','paula.gutierrez@gmail.com','71234592','La Paz','pasajero'),
('Andres Silva','andres.silva@gmail.com','71234593','La Paz','pasajero'),
('Fernanda Lopez','fernanda.lopez@gmail.com','71234594','El Alto','pasajero'),
('Javier Castillo','javier.castillo@gmail.com','71234595','La Paz','pasajero'),
('Camila Fernandez','camila.fernandez@gmail.com','71234596','La Paz','pasajero'),
('Martin Rojas','martin.rojas@gmail.com','71234597','El Alto','pasajero'),
('Daniela Vargas','daniela.vargas@gmail.com','71234598','La Paz','pasajero'),
('Ricardo Alvarez','ricardo.alvarez@gmail.com','71234599','La Paz','pasajero'),
('Monica Torres','monica.torres@gmail.com','71234600','El Alto','pasajero'),
('Andres Romero','andres.romero@gmail.com','71234601','La Paz','pasajero'),
('Paula Jimenez','paula.jimenez@gmail.com','71234602','La Paz','pasajero'),
('Luis Molina','luis.molina@gmail.com','71234603','El Alto','pasajero'),
('Laura Gutierrez','laura.gutierrez@gmail.com','71234604','La Paz','pasajero'),
('Miguel Rojas','miguel.rojas@gmail.com','71234605','La Paz','pasajero'),
('Sofia Fernandez','sofia.fernandez@gmail.com','71234606','El Alto','pasajero'),
('Diego Alvarez','diego.alvarez@gmail.com','77665453','La Paz','pasajero'),
('Camila Jimenez','camila.jimenez@gmail.com','72543234','La Paz','pasajero');

-- ============================================
-- LINEAS (5)
-- ============================================
INSERT INTO lineas (nombre_linea, color) VALUES
('Roja','Rojo'),
('Amarilla','Amarillo'),
('Verde','Verde'),
('Azul','Azul'),
('Morada','Morado');

-- ============================================
-- ESTACIONES
-- ============================================
INSERT INTO estaciones (id_linea, nombre_estacion, orden) VALUES
(1,'Estacion Central',1),(1,'Estacion Norte',2),(1,'Estacion Sur',3),(1,'Estacion Final',4),
(2,'Estacion Centro',1),(2,'Estacion Este',2),(2,'Estacion Oeste',3),(2,'Estacion Terminal',4),
(3,'Estacion Uno',1),(3,'Estacion Dos',2),(3,'Estacion Tres',3),(3,'Estacion Cuatro',4),
(4,'Estacion A',1),(4,'Estacion B',2),(4,'Estacion C',3),(4,'Estacion D',4),
(5,'Estacion I',1),(5,'Estacion II',2),(5,'Estacion III',3),(5,'Estacion IV',4);

-- ============================================
-- TARJETAS
-- ============================================
INSERT INTO tarjetas (id_usuario, saldo) VALUES
(1,50),(2,30),(3,20),(4,15),(5,10),(6,25),(7,40),(8,35),(9,50),(10,20),(11,50),
(12,45),(13,40),(14,30),(15,60),(16,45),(17,30),(18,25),(19,40),(20,35),(21,50),
(22,45),(23,60),(24,55),(25,30),(26,20),(27,15),(28,50),(29,35),(30,25),(31,40),
(32,30),(33,45),(34,50),(35,60),(36,40),(37,35),(38,25),(39,30),(40,45),(41,50),
(42,55),(43,60),(44,35),(45,25),(46,20),(47,15),(48,40),(49,35);

-- ============================================
-- RECARGAS
-- ============================================
INSERT INTO recargas (id_tarjeta, monto, metodo_pago) VALUES
(1,20,'efectivo'),(2,15,'tarjeta'),(3,10,'transferencia'),(4,20,'qr'),
(5,15,'efectivo'),(6,30,'tarjeta'),(7,25,'transferencia'),(8,10,'qr'),
(9,20,'efectivo'),(10,15,'tarjeta'),(11,20,'transferencia'),(12,25,'qr'),
(13,10,'efectivo'),(14,15,'tarjeta'),(15,30,'transferencia'),(16,20,'qr'),
(17,25,'efectivo'),(18,30,'tarjeta'),(19,15,'transferencia'),(20,20,'qr'),
(21,25,'efectivo'),(22,20,'tarjeta'),(23,15,'transferencia'),(24,30,'qr'),
(25,20,'efectivo'),(26,25,'tarjeta'),(27,15,'transferencia'),(28,20,'qr'),
(29,25,'efectivo'),(30,20,'tarjeta'),(31,15,'transferencia'),(32,20,'qr'),
(33,25,'efectivo'),(34,30,'tarjeta'),(35,15,'transferencia'),(36,20,'qr'),
(37,25,'efectivo'),(38,30,'tarjeta'),(39,15,'transferencia'),(40,20,'qr'),
(41,25,'efectivo'),(42,30,'tarjeta'),(43,20,'transferencia'),(44,25,'qr'),
(45,15,'efectivo'),(46,20,'tarjeta'),(47,15,'transferencia'),(48,20,'qr'),
(49,25,'efectivo');

-- ============================================
-- VIAJES
-- ============================================
INSERT INTO viajes (id_linea, id_estacion_origen, id_estacion_destino, estado) VALUES
(1,1,2,'finalizado'),(1,2,3,'finalizado'),(1,3,4,'en_curso'),(2,5,6,'pendiente'),(2,6,7,'pendiente'),
(2,7,8,'pendiente'),(3,9,10,'finalizado'),(3,10,11,'finalizado'),(3,11,12,'en_curso'),(4,13,14,'pendiente'),
(4,14,15,'pendiente'),(4,15,16,'pendiente'),(5,17,18,'finalizado'),(5,18,19,'finalizado'),(5,19,20,'en_curso'),
(1,1,2,'finalizado'),(2,5,6,'pendiente'),(3,9,10,'finalizado'),(4,13,14,'pendiente'),(5,17,18,'finalizado'),
(1,2,3,'en_curso'),(2,6,7,'pendiente'),(3,10,11,'finalizado'),(4,14,15,'pendiente'),(5,18,19,'finalizado'),
(1,3,4,'en_curso'),(2,7,8,'pendiente'),(3,11,12,'finalizado'),(4,15,16,'pendiente'),(5,19,20,'finalizado');
-- mostrar el nombre de un usuario con los viajes que realizo, las estaciones que visito y el numero de boleto. 
-- ============================================
-- BOLETOS
-- ============================================
INSERT INTO boletos (id_usuario, id_linea, id_viaje, id_pago, precio, estado) VALUES
(1,1,1,1,3.00,'activo'),(2,1,2,2,3.00,'activo'),(3,1,3,3,3.00,'activo'),(4,2,4,4,3.00,'activo'),
(5,2,5,5,3.00,'activo'),(6,2,6,6,3.00,'activo'),(7,3,7,7,3.00,'activo'),(8,3,8,8,3.00,'activo'),
(9,3,9,9,3.00,'activo'),(10,4,10,10,3.00,'activo'),(11,4,11,11,3.00,'activo'),(12,4,12,12,3.00,'activo'),
(13,5,13,13,3.00,'activo'),(14,5,14,14,3.00,'activo'),(15,5,15,15,3.00,'activo'),(16,1,16,16,3.00,'activo'),
(17,1,17,17,3.00,'activo'),(18,2,18,18,3.00,'activo'),(19,2,19,19,3.00,'activo'),(20,3,20,20,3.00,'activo'),
(21,3,1,21,3.00,'activo'),(22,3,2,22,3.00,'activo'),(23,4,3,23,3.00,'activo'),(24,4,4,24,3.00,'activo'),
(25,5,5,25,3.00,'activo'),(26,5,6,26,3.00,'activo'),(27,1,7,27,3.00,'activo'),(28,1,8,28,3.00,'activo'),
(29,2,9,29,3.00,'activo'),(30,2,10,30,3.00,'activo'),(31,3,11,31,3.00,'activo'),(32,3,12,32,3.00,'activo'),
(33,4,13,33,3.00,'activo'),(34,4,14,34,3.00,'activo'),(35,5,15,35,3.00,'activo'),(36,5,16,36,3.00,'activo'),
(37,1,17,37,3.00,'activo'),(38,1,18,38,3.00,'activo'),(39,2,19,39,3.00,'activo'),(40,2,20,40,3.00,'activo'),
(41,3,1,41,3.00,'activo'),(42,3,2,42,3.00,'activo'),(43,4,3,43,3.00,'activo'),(44,4,4,44,3.00,'activo'),
(45,5,5,45,3.00,'activo'),(46,5,6,46,3.00,'activo'),(47,1,7,47,3.00,'activo'),(48,1,8,48,3.00,'activo'),
(49,2,9,49,3.00,'activo');

