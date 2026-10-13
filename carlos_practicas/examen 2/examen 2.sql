create table proyecto(
    id_nombre_proyecto int auto_increment primary key,
    id_jurado int,
    id_estudiante int,
    fecha date,
    observaciones varchar(500),
    categoria varchar(50)
);

create table estudiante(
    id_estudiante int auto_increment primary key,
    nombre varchar(100) not null,
    correo int,
    uq_estudiante_correo int,
    telefono decimal(10.7)
);


create table jurado(
    id_jurado int auto_increment primary key,
    puntuacion int,
    calificacion decimal(10.1)
);

create table evaluacion(
    id_evaluacion int auto_increment primary key,
    id_proyecto int,
    id_jurado int,
    observaciones int,
    criterio int,
    puntaje decimal(10.5),
    chk_evaluacion_puntaje int
);

create table tema(
    id_tema int auto_increment primary key,
    categoria int,
    nombre varchar(50)
);

create table presentacion(
    id_presentacion int auto_increment primary key,
    id_proyecto int,
    id_tema int,
    fecha date
);
