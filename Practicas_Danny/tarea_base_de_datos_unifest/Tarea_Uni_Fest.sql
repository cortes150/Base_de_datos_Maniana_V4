USE unifest_es;


-- ===== BLOQUE A. JOIN =====

-- Ejercicio 1. Usuarios y roles
SELECT u.nombre_completo, u.usuario, r.nombre_rol
FROM usuarios u
INNER JOIN roles r ON r.id_rol = u.id_rol;

-- Ejercicio 2. Eventos y organizadores
SELECT e.titulo, e.fecha_evento, e.lugar, u.nombre_completo
FROM eventos e
INNER JOIN usuarios u ON u.id_usuario = e.creado_por;

-- Ejercicio 3. Eventos y tipos de entrada
SELECT e.titulo, t.nombre_tipo, t.precio
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento;

-- Ejercicio 4. Entradas y compradores
SELECT en.codigo_qr, en.estado, u.nombre_completo
FROM entradas en
INNER JOIN usuarios u ON u.id_usuario = en.id_comprador;

-- Ejercicio 5. Pagos y pagadores
SELECT p.id_pago, p.monto, p.metodo_pago, u.nombre_completo
FROM pagos p
INNER JOIN usuarios u ON u.id_usuario = p.id_pagador;

-- Ejercicio 6. Entradas, eventos y tipos
SELECT en.id_entrada, e.titulo, t.nombre_tipo, t.precio, en.estado
FROM entradas en
INNER JOIN eventos e ON e.id_evento = en.id_evento
INNER JOIN tipos_entrada t ON t.id_tipo = en.id_tipo;

-- Ejercicio 7. Entradas VIP vendidas
SELECT e.titulo, u.nombre_completo AS comprador, t.precio
FROM entradas en
INNER JOIN eventos e ON e.id_evento = en.id_evento
INNER JOIN tipos_entrada t ON t.id_tipo = en.id_tipo
INNER JOIN usuarios u ON u.id_usuario = en.id_comprador
WHERE t.nombre_tipo = 'VIP' AND en.estado = 'vendida';

-- Ejercicio 8. Eventos de organizador01
SELECT e.titulo, e.fecha_evento
FROM eventos e
INNER JOIN usuarios u ON u.id_usuario = e.creado_por
WHERE u.usuario = 'organizador01';

-- Ejercicio 9. Pagos con tarjeta
SELECT e.titulo, en.codigo_qr, p.monto, p.fecha_pago
FROM pagos p
INNER JOIN entradas en ON en.id_entrada = p.id_entrada
INNER JOIN eventos e ON e.id_evento = en.id_evento
WHERE p.metodo_pago = 'tarjeta';

-- Ejercicio 10. Asistencia por usuario
SELECT u.nombre_completo, e.titulo, a.asistio
FROM asistencia a
INNER JOIN usuarios u ON u.id_usuario = a.id_usuario
INNER JOIN eventos e ON e.id_evento = a.id_evento;

-- Ejercicio 11. Eventos con entradas económicas
SELECT DISTINCT e.titulo
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento
WHERE t.precio < 30;

-- Ejercicio 12. Entradas reservadas (con o sin comprador)
SELECT en.id_entrada, e.titulo, t.nombre_tipo, u.nombre_completo AS comprador
FROM entradas en
INNER JOIN eventos e ON e.id_evento = en.id_evento
INNER JOIN tipos_entrada t ON t.id_tipo = en.id_tipo
LEFT JOIN usuarios u ON u.id_usuario = en.id_comprador
WHERE en.estado = 'reservada';

-- Ejercicio 13. Todos los eventos y sus entradas
SELECT e.titulo, en.id_entrada
FROM eventos e
LEFT JOIN entradas en ON en.id_evento = e.id_evento;

-- Ejercicio 14. Usuarios que no han comprado
SELECT u.nombre_completo
FROM usuarios u
LEFT JOIN entradas en ON en.id_comprador = u.id_usuario
WHERE en.id_entrada IS NULL;


-- ===== BLOQUE B. GROUP BY =====

-- Ejercicio 15. Usuarios por rol
SELECT r.nombre_rol, COUNT(u.id_usuario) AS cantidad_usuarios
FROM roles r
LEFT JOIN usuarios u ON u.id_rol = r.id_rol
GROUP BY r.id_rol, r.nombre_rol;

-- Ejercicio 16. Eventos por lugar
SELECT lugar, COUNT(*) AS cantidad_eventos
FROM eventos
GROUP BY lugar;

-- Ejercicio 17. Tipos de entrada por evento
SELECT e.titulo, COUNT(t.id_tipo) AS cantidad_tipos
FROM eventos e
LEFT JOIN tipos_entrada t ON t.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo;

-- Ejercicio 18. Precio promedio por evento
SELECT e.titulo, AVG(t.precio) AS precio_promedio
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo;

-- Ejercicio 19. Recaudación por método de pago
SELECT metodo_pago, SUM(monto) AS total_recaudado
FROM pagos
GROUP BY metodo_pago;

-- Ejercicio 20. Entradas por estado
SELECT estado, COUNT(*) AS cantidad_entradas
FROM entradas
GROUP BY estado;

-- Ejercicio 21. Pagos por usuario
SELECT u.nombre_completo, COUNT(p.id_pago) AS cantidad_pagos
FROM pagos p
INNER JOIN usuarios u ON u.id_usuario = p.id_pagador
GROUP BY u.id_usuario, u.nombre_completo;

-- Ejercicio 22. Total pagado por entrada
SELECT id_entrada, SUM(monto) AS total_pagado
FROM pagos
GROUP BY id_entrada;

-- Ejercicio 23. Registros de asistencia por evento
SELECT e.titulo, COUNT(a.id_asistencia) AS registros_asistencia
FROM eventos e
LEFT JOIN asistencia a ON a.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo;

-- Ejercicio 24. Asistentes confirmados por evento
SELECT e.titulo, COUNT(a.id_asistencia) AS asistentes_confirmados
FROM eventos e
LEFT JOIN asistencia a ON a.id_evento = e.id_evento AND a.asistio = 1
GROUP BY e.id_evento, e.titulo;

-- Ejercicio 25. Precio máximo por evento
SELECT e.titulo, MAX(t.precio) AS precio_maximo
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo;

-- Ejercicio 26. Recaudación por evento y método de pago
SELECT e.titulo, p.metodo_pago, SUM(p.monto) AS total_recaudado
FROM pagos p
INNER JOIN entradas en ON en.id_entrada = p.id_entrada
INNER JOIN eventos e ON e.id_evento = en.id_evento
GROUP BY e.id_evento, e.titulo, p.metodo_pago;


-- ===== BLOQUE C. HAVING =====

-- Ejercicio 27. Roles con más de un usuario
SELECT r.nombre_rol, COUNT(u.id_usuario) AS cantidad_usuarios
FROM roles r
INNER JOIN usuarios u ON u.id_rol = r.id_rol
GROUP BY r.id_rol, r.nombre_rol
HAVING COUNT(u.id_usuario) > 1;

-- Ejercicio 28. Eventos con más de un tipo de entrada
SELECT e.titulo, COUNT(t.id_tipo) AS cantidad_tipos
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo
HAVING COUNT(t.id_tipo) > 1;

-- Ejercicio 29. Métodos de pago con más de 200 Bs
SELECT metodo_pago, SUM(monto) AS total_recaudado
FROM pagos
GROUP BY metodo_pago
HAVING SUM(monto) > 200;

-- Ejercicio 30. Usuarios con más de un pago
SELECT u.nombre_completo, COUNT(p.id_pago) AS cantidad_pagos
FROM pagos p
INNER JOIN usuarios u ON u.id_usuario = p.id_pagador
GROUP BY u.id_usuario, u.nombre_completo
HAVING COUNT(p.id_pago) > 1;

-- Ejercicio 31. Eventos con precio promedio mayor a 40 Bs
SELECT e.titulo, AVG(t.precio) AS precio_promedio
FROM eventos e
INNER JOIN tipos_entrada t ON t.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo
HAVING AVG(t.precio) > 40;

-- Ejercicio 32. Estados con al menos cinco entradas
SELECT estado, COUNT(*) AS cantidad_entradas
FROM entradas
GROUP BY estado
HAVING COUNT(*) >= 5;

-- Ejercicio 33. Eventos con recaudación mayor a 100 Bs
SELECT e.titulo, SUM(p.monto) AS total_recaudado
FROM pagos p
INNER JOIN entradas en ON en.id_entrada = p.id_entrada
INNER JOIN eventos e ON e.id_evento = en.id_evento
GROUP BY e.id_evento, e.titulo
HAVING SUM(p.monto) > 100;

-- Ejercicio 34. Usuarios con pagos acumulados mayores a 100 Bs
SELECT u.nombre_completo, SUM(p.monto) AS total_pagado
FROM pagos p
INNER JOIN usuarios u ON u.id_usuario = p.id_pagador
GROUP BY u.id_usuario, u.nombre_completo
HAVING SUM(p.monto) > 100;

-- Ejercicio 35. Eventos con al menos dos asistentes confirmados
SELECT e.titulo, COUNT(*) AS asistentes_confirmados
FROM eventos e
INNER JOIN asistencia a ON a.id_evento = e.id_evento
WHERE a.asistio = 1
GROUP BY e.id_evento, e.titulo
HAVING COUNT(*) >= 2;

-- Ejercicio 36. Eventos con más entradas vendidas que reservadas
SELECT e.titulo
FROM eventos e
INNER JOIN entradas en ON en.id_evento = e.id_evento
GROUP BY e.id_evento, e.titulo
HAVING SUM(en.estado = 'vendida') > SUM(en.estado = 'reservada');


-- ===== BLOQUE Reto adicional =====

-- Reto 1. Organizadores con varios eventos
SELECT u.nombre_completo, COUNT(e.id_evento) AS cantidad_eventos
FROM eventos e
INNER JOIN usuarios u ON u.id_usuario = e.creado_por
GROUP BY u.id_usuario, u.nombre_completo
HAVING COUNT(e.id_evento) >= 2;

-- Reto 2. Eventos con alta recaudación
SELECT e.titulo, COUNT(p.id_pago) AS cantidad_pagos, SUM(p.monto) AS total_recaudado
FROM pagos p
INNER JOIN entradas en ON en.id_entrada = p.id_entrada
INNER JOIN eventos e ON e.id_evento = en.id_evento
GROUP BY e.id_evento, e.titulo
HAVING COUNT(p.id_pago) >= 3 AND SUM(p.monto) > 100;

-- Reto 3. Tipos de entrada con alta demanda
SELECT e.titulo, t.nombre_tipo, COUNT(en.id_entrada) AS cantidad_entradas
FROM tipos_entrada t
INNER JOIN eventos e ON e.id_evento = t.id_evento
INNER JOIN entradas en ON en.id_tipo = t.id_tipo
GROUP BY t.id_tipo, e.titulo, t.nombre_tipo
HAVING COUNT(en.id_entrada) >= 3;
