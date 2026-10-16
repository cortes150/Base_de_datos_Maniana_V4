
-- ============================================================
-- BASE DE DATOS: UNIFEST_ES
-- Sistema de gestión de eventos universitarios
-- MySQL 8.0+
-- ============================================================

DROP DATABASE IF EXISTS unifest_es;

CREATE DATABASE unifest_es
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE unifest_es;


-- ============================================================
-- 1. TABLA: ROLES
-- Define los roles disponibles en el sistema.
-- ============================================================

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE = InnoDB;


-- ============================================================
-- 2. TABLA: USUARIOS
-- Cada usuario tiene un rol.
-- ============================================================

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    nombre_completo VARCHAR(120) NOT NULL,
    id_rol INT NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso DATETIME NULL,

    CONSTRAINT chk_usuarios_activo
        CHECK (activo IN (0, 1)),

    CONSTRAINT fk_usuarios_roles
        FOREIGN KEY (id_rol)
        REFERENCES roles(id_rol)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- 3. TABLA: EVENTOS
-- Cada evento registra quién lo creó.
-- ============================================================

CREATE TABLE eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha_evento DATE NOT NULL,
    hora_evento TIME NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    aforo_total INT NOT NULL,
    creado_por INT NOT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_eventos_aforo
        CHECK (aforo_total > 0),

    CONSTRAINT fk_eventos_creador
        FOREIGN KEY (creado_por)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- 4. TABLA: TIPOS_ENTRADA
-- Un evento puede tener varios tipos de entrada.
-- Ejemplo: General y VIP.
-- ============================================================

CREATE TABLE tipos_entrada (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    nombre_tipo VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    cantidad_total INT NOT NULL,

    CONSTRAINT uq_tipo_evento
        UNIQUE (id_tipo, id_evento),

    CONSTRAINT uq_nombre_tipo_evento
        UNIQUE (id_evento, nombre_tipo),

    CONSTRAINT chk_tipo_precio
        CHECK (precio >= 0),

    CONSTRAINT chk_tipo_cantidad
        CHECK (cantidad_total > 0),

    CONSTRAINT fk_tipos_eventos
        FOREIGN KEY (id_evento)
        REFERENCES eventos(id_evento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- 5. TABLA: ENTRADAS
-- Una entrada corresponde a un evento y a un tipo de ese evento.
-- El comprador puede ser NULL para una entrada sin asignar.
-- ============================================================

CREATE TABLE entradas (
    id_entrada INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    id_tipo INT NOT NULL,
    id_comprador INT NULL,
    codigo_qr VARCHAR(100) NULL UNIQUE,
    entrega ENUM('digital', 'fisica') NOT NULL,
    estado ENUM('vendida', 'reservada', 'cancelada')
        NOT NULL DEFAULT 'reservada',
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_entrada_evento
        UNIQUE (id_entrada, id_evento),

    CONSTRAINT fk_entradas_tipo_evento
        FOREIGN KEY (id_tipo, id_evento)
        REFERENCES tipos_entrada(id_tipo, id_evento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_entradas_comprador
        FOREIGN KEY (id_comprador)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- 6. TABLA: PAGOS
-- Una entrada puede tener varios pagos parciales.
-- ============================================================

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_entrada INT NOT NULL,
    id_pagador INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'online') NOT NULL,

    CONSTRAINT chk_pagos_monto
        CHECK (monto > 0),

    CONSTRAINT fk_pagos_entrada
        FOREIGN KEY (id_entrada)
        REFERENCES entradas(id_entrada)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pagos_pagador
        FOREIGN KEY (id_pagador)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- 7. TABLA: ASISTENCIA
-- Registra la asistencia de un usuario a un evento
-- mediante una entrada correspondiente a ese evento.
-- ============================================================

CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    id_usuario INT NOT NULL,
    id_entrada INT NOT NULL,
    asistio TINYINT(1) NOT NULL DEFAULT 0,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_asistencia_entrada
        UNIQUE (id_entrada),

    CONSTRAINT chk_asistencia_estado
        CHECK (asistio IN (0, 1)),

    CONSTRAINT fk_asistencia_evento
        FOREIGN KEY (id_evento)
        REFERENCES eventos(id_evento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_asistencia_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_asistencia_entrada_evento
        FOREIGN KEY (id_entrada, id_evento)
        REFERENCES entradas(id_entrada, id_evento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;


-- ============================================================
-- FIN DE LA ESTRUCTURA
-- Los INSERT se ejecutan después de crear todas las tablas.
-- ============================================================



USE unifest_es;

-- ============================================
-- 1. ROLES (15 registros)
-- ============================================

INSERT INTO roles (id_rol, nombre_rol, descripcion) VALUES
(1, 'Administrador', 'Administracion general del sistema'),
(2, 'Organizador general', 'Coordina los eventos universitarios'),
(3, 'Estudiante', 'Usuario estudiante'),
(4, 'Docente', 'Usuario docente'),
(5, 'Responsable de evento', 'Gestiona un evento especifico'),
(6, 'Taquilla', 'Gestiona ventas presenciales'),
(7, 'Control de acceso', 'Verifica entradas y asistencia'),
(8, 'Finanzas', 'Supervisa pagos y recaudaciones'),
(9, 'Comunicaciones', 'Gestiona la difusion de eventos'),
(10, 'Logistica', 'Coordina recursos y espacios'),
(11, 'Moderador', 'Modera actividades y participantes'),
(12, 'Expositor', 'Participa como expositor'),
(13, 'Invitado', 'Invitado externo'),
(14, 'Coordinador academico', 'Coordina actividades academicas'),
(15, 'Auditor', 'Consulta registros para auditoria');


-- ============================================
-- 2. USUARIOS (20 registros)
-- ============================================

INSERT INTO usuarios
(id_usuario, usuario, contrasena, correo, nombre_completo, id_rol, activo, creado_en, ultimo_acceso)
VALUES
(1, 'admin01', 'demo123', 'admin@unifest.bo', 'Carlos Mendoza', 1, 1, '2026-01-05 09:00:00', '2026-10-15 10:00:00'),
(2, 'organizador01', 'demo123', 'organizador@unifest.bo', 'Maria Fernandez', 2, 1, '2026-01-06 10:00:00', '2026-10-14 15:30:00'),
(3, 'estudiante01', 'demo123', 'ana.rojas@unifest.bo', 'Ana Rojas', 3, 1, '2026-02-01 08:00:00', '2026-10-15 12:00:00'),
(4, 'estudiante02', 'demo123', 'luis.mamani@unifest.bo', 'Luis Mamani', 3, 1, '2026-02-02 09:00:00', '2026-10-13 11:00:00'),
(5, 'docente01', 'demo123', 'pedro.siles@unifest.bo', 'Pedro Siles', 4, 1, '2026-02-03 10:00:00', '2026-10-12 14:00:00'),
(6, 'responsable01', 'demo123', 'sofia.vega@unifest.bo', 'Sofia Vega', 5, 1, '2026-02-04 11:00:00', '2026-10-15 09:00:00'),
(7, 'taquilla01', 'demo123', 'taquilla@unifest.bo', 'Jorge Salazar', 6, 1, '2026-02-05 12:00:00', '2026-10-14 16:00:00'),
(8, 'acceso01', 'demo123', 'acceso@unifest.bo', 'Daniel Quispe', 7, 1, '2026-02-06 13:00:00', '2026-10-15 08:00:00'),
(9, 'finanzas01', 'demo123', 'finanzas@unifest.bo', 'Gabriela Flores', 8, 1, '2026-02-07 14:00:00', '2026-10-13 17:00:00'),
(10, 'comunicacion01', 'demo123', 'comunicacion@unifest.bo', 'Valeria Cruz', 9, 1, '2026-02-08 15:00:00', '2026-10-12 10:00:00'),
(11, 'logistica01', 'demo123', 'logistica@unifest.bo', 'Miguel Torres', 10, 1, '2026-02-09 16:00:00', '2026-10-11 09:00:00'),
(12, 'moderador01', 'demo123', 'moderador@unifest.bo', 'Andrea Vargas', 11, 1, '2026-02-10 09:00:00', '2026-10-10 10:00:00'),
(13, 'expositor01', 'demo123', 'expositor@unifest.bo', 'Roberto Lima', 12, 1, '2026-02-11 10:00:00', '2026-10-09 11:00:00'),
(14, 'invitado01', 'demo123', 'invitado@unifest.bo', 'Patricia Rocha', 13, 1, '2026-02-12 11:00:00', '2026-10-08 12:00:00'),
(15, 'coordinador01', 'demo123', 'coordinador@unifest.bo', 'Fernando Arias', 14, 1, '2026-02-13 12:00:00', '2026-10-07 13:00:00'),
(16, 'auditor01', 'demo123', 'auditor@unifest.bo', 'Monica Paredes', 15, 1, '2026-02-14 13:00:00', '2026-10-06 14:00:00'),
(17, 'estudiante03', 'demo123', 'diego.condori@unifest.bo', 'Diego Condori', 3, 1, '2026-03-01 08:00:00', '2026-10-15 14:00:00'),
(18, 'estudiante04', 'demo123', 'camila.paz@unifest.bo', 'Camila Paz', 3, 1, '2026-03-02 09:00:00', NULL),
(19, 'docente02', 'demo123', 'elena.gutierrez@unifest.bo', 'Elena Gutierrez', 4, 1, '2026-03-03 10:00:00', '2026-10-14 09:00:00'),
(20, 'estudiante05', 'demo123', 'marco.arias@unifest.bo', 'Marco Arias', 3, 0, '2026-03-04 11:00:00', NULL);


-- ============================================
-- 3. EVENTOS (15 registros)
-- ============================================

INSERT INTO eventos
(id_evento, titulo, descripcion, fecha_evento, hora_evento, lugar, aforo_total, creado_por, creado_en)
VALUES
(1, 'Feria Tecnologica UNANDES', 'Exposicion de proyectos tecnologicos', '2026-11-05', '09:00:00', 'Auditorio principal', 200, 2, '2026-09-01 09:00:00'),
(2, 'Congreso de Sistemas', 'Congreso de ingenieria de sistemas', '2026-11-10', '08:30:00', 'Bloque A', 150, 2, '2026-09-02 09:00:00'),
(3, 'Festival de Musica', 'Presentaciones musicales universitarias', '2026-11-15', '18:00:00', 'Patio central', 300, 6, '2026-09-03 09:00:00'),
(4, 'Taller de Inteligencia Artificial', 'Taller practico de IA', '2026-11-18', '14:00:00', 'Laboratorio 1', 40, 6, '2026-09-04 09:00:00'),
(5, 'Seminario de Ciberseguridad', 'Buenas practicas de seguridad informatica', '2026-11-20', '10:00:00', 'Auditorio B', 100, 2, '2026-09-05 09:00:00'),
(6, 'Feria de Emprendimiento', 'Exposicion de ideas de negocio', '2026-11-22', '09:00:00', 'Cancha universitaria', 250, 6, '2026-09-06 09:00:00'),
(7, 'Jornada de Investigacion', 'Presentacion de trabajos academicos', '2026-11-25', '08:00:00', 'Sala de conferencias', 120, 15, '2026-09-07 09:00:00'),
(8, 'Torneo de Programacion', 'Competencia de desarrollo de software', '2026-11-27', '09:00:00', 'Laboratorio 2', 60, 2, '2026-09-08 09:00:00'),
(9, 'Concierto Universitario', 'Concierto de bandas invitadas', '2026-12-01', '19:00:00', 'Teatro universitario', 280, 6, '2026-09-09 09:00:00'),
(10, 'Taller de Bases de Datos', 'Practica de modelado y SQL', '2026-12-03', '15:00:00', 'Laboratorio 3', 45, 15, '2026-09-10 09:00:00'),
(11, 'Encuentro de Docentes', 'Intercambio de experiencias academicas', '2026-12-05', '09:00:00', 'Sala docente', 80, 2, '2026-09-11 09:00:00'),
(12, 'Feria de Robótica', 'Demostracion de prototipos roboticos', '2026-12-08', '10:00:00', 'Patio central', 180, 6, '2026-09-12 09:00:00'),
(13, 'Charla de Desarrollo Web', 'Tecnologias modernas para la web', '2026-12-10', '16:00:00', 'Auditorio A', 90, 15, '2026-09-13 09:00:00'),
(14, 'Expo Ciencia', 'Exposicion de proyectos cientificos', '2026-12-12', '09:00:00', 'Bloque B', 160, 2, '2026-09-14 09:00:00'),
(15, 'Clausura Academica', 'Cierre de actividades universitarias', '2026-12-15', '17:00:00', 'Auditorio principal', 220, 6, '2026-09-15 09:00:00');


-- ============================================
-- 4. TIPOS DE ENTRADA (30 registros)
-- Dos tipos por evento
-- ============================================

INSERT INTO tipos_entrada
(id_tipo, id_evento, nombre_tipo, precio, cantidad_total)
VALUES
(1, 1, 'General', 50.00, 150),
(2, 1, 'VIP', 100.00, 50),
(3, 2, 'General', 40.00, 120),
(4, 2, 'VIP', 80.00, 30),
(5, 3, 'General', 60.00, 250),
(6, 3, 'VIP', 120.00, 50),
(7, 4, 'General', 25.00, 30),
(8, 4, 'VIP', 40.00, 10),
(9, 5, 'General', 30.00, 80),
(10, 5, 'VIP', 60.00, 20),
(11, 6, 'General', 20.00, 200),
(12, 6, 'VIP', 40.00, 50),
(13, 7, 'General', 15.00, 100),
(14, 7, 'VIP', 30.00, 20),
(15, 8, 'General', 35.00, 50),
(16, 8, 'VIP', 60.00, 10),
(17, 9, 'General', 70.00, 230),
(18, 9, 'VIP', 140.00, 50),
(19, 10, 'General', 25.00, 35),
(20, 10, 'VIP', 45.00, 10),
(21, 11, 'General', 10.00, 60),
(22, 11, 'VIP', 20.00, 20),
(23, 12, 'General', 30.00, 150),
(24, 12, 'VIP', 60.00, 30),
(25, 13, 'General', 20.00, 70),
(26, 13, 'VIP', 40.00, 20),
(27, 14, 'General', 25.00, 130),
(28, 14, 'VIP', 50.00, 30),
(29, 15, 'General', 40.00, 180),
(30, 15, 'VIP', 80.00, 40);


-- ============================================
-- 5. ENTRADAS (30 registros)
-- Cada entrada usa un tipo del mismo evento
-- ============================================

INSERT INTO entradas
(id_entrada, id_evento, id_tipo, id_comprador, codigo_qr, entrega, estado, creado_en)
VALUES
(1, 1, 1, 3, 'UNI-QR-0001', 'digital', 'vendida', '2026-09-20 09:00:00'),
(2, 1, 2, 4, 'UNI-QR-0002', 'digital', 'vendida', '2026-09-20 09:15:00'),
(3, 2, 3, 5, 'UNI-QR-0003', 'fisica', 'vendida', '2026-09-21 10:00:00'),
(4, 2, 4, 17, 'UNI-QR-0004', 'digital', 'reservada', '2026-09-21 10:15:00'),
(5, 3, 5, 18, 'UNI-QR-0005', 'digital', 'vendida', '2026-09-22 11:00:00'),
(6, 3, 6, 19, 'UNI-QR-0006', 'fisica', 'vendida', '2026-09-22 11:15:00'),
(7, 4, 7, 3, 'UNI-QR-0007', 'digital', 'vendida', '2026-09-23 12:00:00'),
(8, 4, 8, 4, 'UNI-QR-0008', 'digital', 'reservada', '2026-09-23 12:15:00'),
(9, 5, 9, 5, 'UNI-QR-0009', 'fisica', 'vendida', '2026-09-24 13:00:00'),
(10, 5, 10, 17, 'UNI-QR-0010', 'digital', 'vendida', '2026-09-24 13:15:00'),
(11, 6, 11, 18, 'UNI-QR-0011', 'digital', 'vendida', '2026-09-25 14:00:00'),
(12, 6, 12, 19, 'UNI-QR-0012', 'fisica', 'vendida', '2026-09-25 14:15:00'),
(13, 7, 13, 3, 'UNI-QR-0013', 'digital', 'cancelada', '2026-09-26 15:00:00'),
(14, 7, 14, 4, 'UNI-QR-0014', 'digital', 'vendida', '2026-09-26 15:15:00'),
(15, 8, 15, 5, 'UNI-QR-0015', 'fisica', 'vendida', '2026-09-27 16:00:00'),
(16, 8, 16, 17, 'UNI-QR-0016', 'digital', 'reservada', '2026-09-27 16:15:00'),
(17, 9, 17, 18, 'UNI-QR-0017', 'digital', 'vendida', '2026-09-28 09:00:00'),
(18, 9, 18, 19, 'UNI-QR-0018', 'fisica', 'vendida', '2026-09-28 09:15:00'),
(19, 10, 19, 3, 'UNI-QR-0019', 'digital', 'vendida', '2026-09-29 10:00:00'),
(20, 10, 20, 4, 'UNI-QR-0020', 'digital', 'vendida', '2026-09-29 10:15:00'),
(21, 11, 21, 5, 'UNI-QR-0021', 'fisica', 'vendida', '2026-09-30 11:00:00'),
(22, 11, 22, 17, 'UNI-QR-0022', 'digital', 'cancelada', '2026-09-30 11:15:00'),
(23, 12, 23, 18, 'UNI-QR-0023', 'digital', 'vendida', '2026-10-01 12:00:00'),
(24, 12, 24, 19, 'UNI-QR-0024', 'fisica', 'vendida', '2026-10-01 12:15:00'),
(25, 13, 25, 3, 'UNI-QR-0025', 'digital', 'reservada', '2026-10-02 13:00:00'),
(26, 13, 26, 4, 'UNI-QR-0026', 'digital', 'vendida', '2026-10-02 13:15:00'),
(27, 14, 27, 5, 'UNI-QR-0027', 'fisica', 'vendida', '2026-10-03 14:00:00'),
(28, 14, 28, 17, 'UNI-QR-0028', 'digital', 'vendida', '2026-10-03 14:15:00'),
(29, 15, 29, 18, 'UNI-QR-0029', 'digital', 'vendida', '2026-10-04 15:00:00'),
(30, 15, 30, NULL, NULL, 'fisica', 'reservada', '2026-10-04 15:15:00');


-- ============================================
-- 6. PAGOS (30 registros)
-- Entradas 1-10 tienen dos pagos cada una.
-- Entradas 11-20 tienen un pago cada una.
-- Entradas 21-30 no tienen pagos registrados.
-- ============================================

INSERT INTO pagos
(id_pago, id_entrada, id_pagador, monto, fecha_pago, metodo_pago)
VALUES
(1, 1, 3, 20.00, '2026-09-20 09:05:00', 'efectivo'),
(2, 1, 3, 30.00, '2026-09-21 09:05:00', 'online'),
(3, 2, 4, 40.00, '2026-09-20 09:20:00', 'tarjeta'),
(4, 2, 4, 60.00, '2026-09-21 09:20:00', 'online'),
(5, 3, 5, 20.00, '2026-09-21 10:05:00', 'efectivo'),
(6, 3, 5, 20.00, '2026-09-22 10:05:00', 'tarjeta'),
(7, 4, 17, 30.00, '2026-09-21 10:20:00', 'online'),
(8, 4, 17, 30.00, '2026-09-22 10:20:00', 'efectivo'),
(9, 5, 18, 30.00, '2026-09-22 11:05:00', 'tarjeta'),
(10, 5, 18, 30.00, '2026-09-23 11:05:00', 'online'),
(11, 6, 19, 60.00, '2026-09-22 11:20:00', 'efectivo'),
(12, 6, 19, 60.00, '2026-09-23 11:20:00', 'tarjeta'),
(13, 7, 3, 25.00, '2026-09-23 12:05:00', 'online'),
(14, 7, 3, 15.00, '2026-09-24 12:05:00', 'efectivo'),
(15, 8, 4, 20.00, '2026-09-23 12:20:00', 'tarjeta'),
(16, 8, 4, 20.00, '2026-09-24 12:20:00', 'online'),
(17, 9, 5, 30.00, '2026-09-24 13:05:00', 'efectivo'),
(18, 9, 5, 30.00, '2026-09-25 13:05:00', 'tarjeta'),
(19, 10, 17, 30.00, '2026-09-24 13:20:00', 'online'),
(20, 10, 17, 30.00, '2026-09-25 13:20:00', 'efectivo'),
(21, 11, 18, 20.00, '2026-09-25 14:05:00', 'tarjeta'),
(22, 12, 19, 40.00, '2026-09-25 14:20:00', 'efectivo'),
(23, 13, 3, 15.00, '2026-09-26 15:05:00', 'online'),
(24, 14, 4, 30.00, '2026-09-26 15:20:00', 'tarjeta'),
(25, 15, 5, 35.00, '2026-09-27 16:05:00', 'efectivo'),
(26, 16, 17, 30.00, '2026-09-27 16:20:00', 'online'),
(27, 17, 18, 70.00, '2026-09-28 09:05:00', 'tarjeta'),
(28, 18, 19, 140.00, '2026-09-28 09:20:00', 'efectivo'),
(29, 19, 3, 25.00, '2026-09-29 10:05:00', 'online'),
(30, 20, 4, 45.00, '2026-09-29 10:20:00', 'tarjeta');


-- ============================================
-- 7. ASISTENCIA (20 registros)
-- ============================================

INSERT INTO asistencia
(id_asistencia, id_evento, id_usuario, id_entrada, asistio, fecha_registro)
VALUES
(1, 1, 3, 1, 0, '2026-10-01 09:00:00'),
(2, 1, 4, 2, 0, '2026-10-01 09:10:00'),
(3, 2, 5, 3, 0, '2026-10-02 10:00:00'),
(4, 2, 17, 4, 0, '2026-10-02 10:10:00'),
(5, 3, 18, 5, 0, '2026-10-03 11:00:00'),
(6, 3, 19, 6, 0, '2026-10-03 11:10:00'),
(7, 4, 3, 7, 0, '2026-10-04 12:00:00'),
(8, 4, 4, 8, 0, '2026-10-04 12:10:00'),
(9, 5, 5, 9, 0, '2026-10-05 13:00:00'),
(10, 5, 17, 10, 0, '2026-10-05 13:10:00'),
(11, 6, 18, 11, 0, '2026-10-06 14:00:00'),
(12, 6, 19, 12, 0, '2026-10-06 14:10:00'),
(13, 7, 3, 13, 0, '2026-10-07 15:00:00'),
(14, 7, 4, 14, 0, '2026-10-07 15:10:00'),
(15, 8, 5, 15, 0, '2026-10-08 16:00:00'),
(16, 8, 17, 16, 0, '2026-10-08 16:10:00'),
(17, 9, 18, 17, 0, '2026-10-09 09:00:00'),
(18, 9, 19, 18, 0, '2026-10-09 09:10:00'),
(19, 10, 3, 19, 0, '2026-10-10 10:00:00'),
(20, 10, 4, 20, 0, '2026-10-10 10:10:00');


/* Bloque A. Ejercicios de JOIN
Ejercicios 1–14 · Relaciones entre dos o más tablas
Nivel básico: INNER JOIN
1. Usuarios y roles
Mostrar el nombre completo, nombre de usuario y nombre del rol de cada usuario.

2. Eventos y organizadores
Mostrar el título del evento, la fecha, el lugar y el nombre completo del usuario que creó el evento.

3. Eventos y tipos de entrada
Mostrar el título del evento, el nombre del tipo de entrada y su precio.

4. Entradas y compradores
Mostrar el código QR, el estado de la entrada y el nombre completo del comprador. Considerar únicamente entradas que tengan comprador asignado.

5. Pagos y pagadores
Mostrar el identificador del pago, el monto, el método de pago y el nombre del usuario que realizó el pago.

6. Entradas, eventos y tipos
Mostrar el identificador de la entrada, el título del evento, el tipo de entrada, el precio y el estado de la entrada.

Nivel intermedio: JOIN con condiciones
7. Entradas VIP vendidas
Mostrar el título del evento, el comprador y el precio de las entradas VIP cuyo estado sea vendida.

8. Eventos creados por un usuario específico
Mostrar los títulos y fechas de los eventos creados por el usuario cuyo nombre de usuario sea organizador01.

9. Pagos realizados con tarjeta
Mostrar el título del evento, el código QR, el monto pagado y la fecha de cada pago realizado mediante tarjeta.

10. Asistencia por usuario
Mostrar el nombre completo del usuario, el título del evento y el valor del campo asistio.

11. Eventos con entradas económicas
Mostrar los eventos que tengan tipos de entrada con un precio inferior a 30 Bs. No repetir filas por tipos que no cumplan la condición.

12. Entradas reservadas con información del comprador
Mostrar las entradas reservadas junto con el título del evento, el tipo de entrada y el nombre del comprador, incluyendo las entradas que no tengan comprador asignado.

Nivel avanzado: LEFT JOIN y múltiples relaciones
13. Todos los eventos y sus entradas
Mostrar todos los eventos, incluso los que no tengan entradas registradas. Incluir el identificador de cada entrada cuando exista.

14. Usuarios que no han comprado entradas
Mostrar el nombre completo de los usuarios que no aparecen como compradores en la tabla entradas. Resolverlo mediante LEFT JOIN.

Bloque B. Ejercicios de GROUP BY
Ejercicios 15–26 · Agrupación y funciones de agregación
En este bloque se espera que utilices funciones como COUNT(), SUM(), AVG(), MAX() y MIN().
15. Cantidad de usuarios por rol
Mostrar cada rol y la cantidad de usuarios asignados a él.

16. Cantidad de eventos por lugar
Mostrar cada lugar y el número de eventos programados en él.

17. Tipos de entrada por evento
Mostrar el título de cada evento y la cantidad de tipos de entrada que tiene registrados.

18. Precio promedio por evento
Mostrar el título del evento y el precio promedio de sus tipos de entrada.

19. Recaudación por método de pago
Mostrar cada método de pago y la suma de dinero recaudado mediante ese método.

20. Cantidad de entradas por estado
Mostrar cada estado de entrada y cuántas entradas existen en ese estado.

21. Cantidad de pagos por usuario
Mostrar el nombre de cada pagador y el número de pagos que realizó.

22. Total pagado por entrada
Mostrar cada entrada y la suma de todos los pagos registrados para ella.

23. Cantidad de asistentes por evento
Mostrar el título de cada evento y la cantidad de registros que tiene en la tabla asistencia.

24. Asistentes confirmados por evento
Mostrar cada evento y el total de registros donde asistio = 1.

25. Precio máximo por evento
Mostrar el título de cada evento y el precio más alto de sus tipos de entrada.

26. Recaudación por evento y método de pago
Mostrar el título del evento, el método de pago y la suma recaudada para cada combinación.

Bloque C. Ejercicios de HAVING
Ejercicios 27–36 · Filtrar grupos después de agrupar
Recuerda la diferencia fundamental:
- WHERE filtra filas antes de agrupar.
- HAVING filtra los grupos después de aplicar GROUP BY.
27. Roles con más de un usuario
Mostrar los roles que tengan asignados más de un usuario.

28. Eventos con más de un tipo de entrada
Mostrar los eventos que tengan registrados más de un tipo de entrada.

29. Métodos de pago con recaudación superior a 200 Bs
Mostrar los métodos de pago cuya recaudación acumulada sea superior a 200 Bs.

30. Usuarios que realizaron más de un pago
Mostrar los pagadores que tengan registrados más de un pago.

31. Eventos con precio promedio superior a 40 Bs
Mostrar los eventos cuyo precio promedio de sus tipos de entrada sea superior a 40 Bs.

32. Estados con al menos cinco entradas
Mostrar los estados que tengan cinco o más entradas registradas.

33. Eventos con recaudación superior a 100 Bs
Mostrar los eventos cuya suma de pagos registrados supere los 100 Bs. Incluir únicamente eventos con pagos.

34. Usuarios con pagos acumulados superiores a 100 Bs
Mostrar los usuarios cuya suma de pagos realizados sea superior a 100 Bs.

35. Eventos con al menos dos asistentes confirmados
Mostrar los eventos que tengan dos o más registros de asistencia con asistio = 1.

36. Eventos con más entradas vendidas que reservadas
Mostrar los eventos donde la cantidad de entradas con estado vendida sea superior a la cantidad con estado reservada.


Reto adicional: combinar JOIN + GROUP BY + HAVING
Estos tres ejercicios son apropiados para un parcial práctico.
Reto 1. Organizadores con varios eventos
Mostrar el nombre completo de cada creador y la cantidad de eventos que creó. Mostrar solamente los usuarios que hayan creado dos o más eventos.

Reto 2. Eventos con alta recaudación
Mostrar el título del evento, la cantidad de pagos y el total recaudado. Incluir únicamente los eventos que tengan al menos tres pagos registrados y una recaudación superior a 100 Bs.

Reto 3. Tipos de entrada con alta demanda
Mostrar el título del evento, el nombre del tipo de entrada y la cantidad de entradas asociadas a ese tipo. Incluir únicamente los tipos que tengan tres o más entradas registradas.
*/

