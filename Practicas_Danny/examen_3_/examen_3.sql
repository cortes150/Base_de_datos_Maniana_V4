use unifest_es;
desc entradas;
desc eventos;
desc pagos;
desc tipos_entrada;
select * from usuarios;
select * from eventos;
select * from pagos;
select * from entradas;
select * from tipos_entrada;
select * from asistencia;
-- ejercicio1
select * from eventos e inner join entradas en on e.id_evento = en.id_evento;
select u.nombre_completo,count(en.entrega) as entradas_digitales,count(en.entrega) as entradas_fisica
from usuarios u 
inner join entradas en on u.id_usuario = en.id_comprador
where en.estado='vendida'
group by u.id_usuario,u.nombre_completo;
-- ejercicio3
select u.nombre_completo,e.titulo,p.monto,p.metodo_pago,p.fecha_pago from entradas en 
inner join usuarios u on u.id_usuario = en.id_comprador
inner join eventos e on e.id_evento = en.id_evento
inner join pagos p on en.id_entrada = p.id_entrada where monto >50 order by p.id_pago;
-- ejercicio 8
select u.nombre_completo,count(distinct p.metodo_pago) as cantidad_metodo_pago from usuarios u 
inner join pagos p on u.id_usuario = p.id_pagador 
group by u.nombre_completo  having count(p.metodo_pago > 2);
-- ejercicio 4
select e.titulo, count(distinct en.id_comprador) as cantidad_compradores from eventos e 
inner join entradas en on e.id_evento=en.id_evento 
where en.estado='vendida'  group by e.titulo;
-- ejercicio 7
SELECT e.titulo, en.id_entrada
FROM eventos e
LEFT JOIN entradas en ON en.id_evento = e.id_evento;
select e.titulo , ti.nombre_tipo,ti.precio,sum(ti.nombre_tipo) as recaudado from eventos e 
inner join tipos_entrada ti on e.id_evento = ti.id_evento
group by e.titulo,ti.id_tipo
order by e.titulo,ti.nombre_tipo desc;
select e.titulo , e.fecha_evento,count(en.id_entrada) as entradas_vendidas from eventos e 
inner join entradas en on e.id_evento = en.id_evento
where en.estado = 'vendida'
group by e.id_evento, e.titulo
order by e.fecha_evento desc;

-- ejercicio 9 
select en.id_entrada,e.titulo,u.nombre_completo, count(p.id_pago) as cantidad_pagos, sum(p.monto) as monto_total from entradas en 
inner join eventos e on en.id_evento = e.id_evento
inner join usuarios u on en.id_comprador = u.id_usuario
inner join pagos p on en.id_entrada = p.id_entrada
group by en.id_entrada,e.titulo,u.nombre_completo
having count(p.id_pago)>=2

