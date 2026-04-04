USE esports_center;
GO

-- ─────────────────────────────────────────────
-- PLATAFORMAS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM plataforma WHERE nombre = 'PlayStation 5')
BEGIN
    INSERT INTO plataforma (nombre, marca) VALUES
    ('PlayStation 5',   'Sony'),
    ('Xbox Series X',   'Microsoft'),
    ('PC',              'Custom'),
    ('Nintendo Switch', 'Nintendo'),
    ('PlayStation 4',   'Sony');
END

-- ─────────────────────────────────────────────
-- JUEGOS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM juego WHERE nombre = 'League of Legends')
BEGIN
    INSERT INTO juego (nombre, calificacion_esrb, estudio, num_jugadores, tipo, existencias) VALUES
    ('League of Legends', 'T',   'Riot Games',   10, 'digital', 0),
    ('FIFA 25',           'E',   'EA Sports',    22, 'fisico',  5),
    ('Valorant',          'T',   'Riot Games',   10, 'digital', 0),
    ('Tekken 8',          'T',   'Bandai Namco',  2, 'fisico',  3),
    ('Super Smash Bros',  'E10+','Nintendo',      8, 'fisico',  2);
END

-- ─────────────────────────────────────────────
-- RELACIÓN JUEGO ↔ PLATAFORMA (usa subqueries, sin IDs fijos)
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM juego_plataforma)
BEGIN
    -- League of Legends → PC
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'League of Legends' AND p.nombre = 'PC';

    -- FIFA 25 → PS5
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'FIFA 25' AND p.nombre = 'PlayStation 5';

    -- FIFA 25 → Xbox Series X
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'FIFA 25' AND p.nombre = 'Xbox Series X';

    -- FIFA 25 → PC
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'FIFA 25' AND p.nombre = 'PC';

    -- FIFA 25 → PS4
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'FIFA 25' AND p.nombre = 'PlayStation 4';

    -- Valorant → PC
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'Valorant' AND p.nombre = 'PC';

    -- Tekken 8 → PS5
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'Tekken 8' AND p.nombre = 'PlayStation 5';

    -- Tekken 8 → Xbox Series X
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'Tekken 8' AND p.nombre = 'Xbox Series X';

    -- Tekken 8 → PC
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'Tekken 8' AND p.nombre = 'PC';

    -- Super Smash Bros → Nintendo Switch
    INSERT INTO juego_plataforma (juego_id, plataforma_id)
    SELECT j.id, p.id FROM juego j, plataforma p
    WHERE j.nombre = 'Super Smash Bros' AND p.nombre = 'Nintendo Switch';
END

-- ─────────────────────────────────────────────
-- EQUIPOS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM equipo WHERE nombre = 'Medellín Raiders')
BEGIN
    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel)
    SELECT 'Medellín Raiders', id, 120, 'plata' FROM juego WHERE nombre = 'League of Legends';

    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel)
    SELECT 'Antioquia FC E-Sports', id, 80, 'bronce' FROM juego WHERE nombre = 'FIFA 25';

    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel)
    SELECT 'Envigado Gamers', id, 200, 'oro' FROM juego WHERE nombre = 'Valorant';

    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel)
    SELECT 'Bello Titans', id, 150, 'plata' FROM juego WHERE nombre = 'Tekken 8';

    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel)
    SELECT 'Itagüí Legends', id, 300, 'elite' FROM juego WHERE nombre = 'League of Legends';
END

-- ─────────────────────────────────────────────
-- TROFEOS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM trofeo WHERE nombre = 'Campeón Regional')
BEGIN
    INSERT INTO trofeo (nombre, puntos, juego_id)
    SELECT 'Campeón Regional',  500, id FROM juego WHERE nombre = 'League of Legends';

    INSERT INTO trofeo (nombre, puntos, juego_id)
    SELECT 'MVP del Torneo',    300, id FROM juego WHERE nombre = 'League of Legends';

    INSERT INTO trofeo (nombre, puntos, juego_id)
    SELECT 'Mejor Delantero',   200, id FROM juego WHERE nombre = 'FIFA 25';

    INSERT INTO trofeo (nombre, puntos, juego_id)
    SELECT 'Primera Sangre',    100, id FROM juego WHERE nombre = 'Valorant';

    INSERT INTO trofeo (nombre, puntos, juego_id)
    SELECT 'Defensa de Hierro', 150, id FROM juego WHERE nombre = 'Tekken 8';
END

-- ─────────────────────────────────────────────
-- USUARIOS (el entrenador va primero para poder usarlo como árbitro)
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM usuario WHERE numero_documento = '71500001')
BEGIN
    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    VALUES
    ('CC', '71500001', 'Ricardo Montoya', 35, 'M',
     '10', 'Manrique', 'Calle 52 #33-10', '3111234567', 'entrenador', 'coach_rmontoya', 'hash_pw_3', NULL);
END

IF NOT EXISTS (SELECT 1 FROM usuario WHERE numero_documento = '1037654321')
BEGIN
    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    SELECT 'CC', '1037654321', 'Carlos Andrés Pérez', 22, 'M',
           '16', 'Belén', 'Cra 80 #35-12', '3001234567', 'atleta', 'caperez_gg', 'hash_pw_1', e.id
    FROM equipo e WHERE e.nombre = 'Medellín Raiders';

    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    SELECT 'CC', '1037654322', 'Valentina Gómez', 20, 'F',
           '14', 'El Poblado', 'Calle 10 #43-15', '3009876543', 'atleta', 'vgomez_gg', 'hash_pw_2', e.id
    FROM equipo e WHERE e.nombre = 'Medellín Raiders';

    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    SELECT 'CC', '1012345678', 'Luis Fernando Diaz', 24, 'M',
           '11', 'Laureles', 'Av 33 #76-20', '3123456789', 'atleta', 'lucho_d', 'hash_pw_4', e.id
    FROM equipo e WHERE e.nombre = 'Antioquia FC E-Sports';

    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    SELECT 'CC', '1045678901', 'Camila Osorio', 21, 'F',
           '7', 'Robledo', 'Cl 65 #80-10', '3156789012', 'atleta', 'camiosorio', 'hash_pw_5', e.id
    FROM equipo e WHERE e.nombre = 'Antioquia FC E-Sports';
END

-- ─────────────────────────────────────────────
-- TROFEOS ASIGNADOS A USUARIOS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM usuario_trofeo)
BEGIN
    -- Carlos → Campeón Regional
    INSERT INTO usuario_trofeo (usuario_id, trofeo_id)
    SELECT u.id, t.id FROM usuario u, trofeo t
    WHERE u.nickname = 'caperez_gg' AND t.nombre = 'Campeón Regional';

    -- Carlos → MVP del Torneo
    INSERT INTO usuario_trofeo (usuario_id, trofeo_id)
    SELECT u.id, t.id FROM usuario u, trofeo t
    WHERE u.nickname = 'caperez_gg' AND t.nombre = 'MVP del Torneo';

    -- Valentina → MVP del Torneo
    INSERT INTO usuario_trofeo (usuario_id, trofeo_id)
    SELECT u.id, t.id FROM usuario u, trofeo t
    WHERE u.nickname = 'vgomez_gg' AND t.nombre = 'MVP del Torneo';

    -- Luis → Mejor Delantero
    INSERT INTO usuario_trofeo (usuario_id, trofeo_id)
    SELECT u.id, t.id FROM usuario u, trofeo t
    WHERE u.nickname = 'lucho_d' AND t.nombre = 'Mejor Delantero';

    -- Camila → Primera Sangre
    INSERT INTO usuario_trofeo (usuario_id, trofeo_id)
    SELECT u.id, t.id FROM usuario u, trofeo t
    WHERE u.nickname = 'camiosorio' AND t.nombre = 'Primera Sangre';
END

-- ─────────────────────────────────────────────
-- TROFEOS ASIGNADOS A EQUIPOS
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM equipo_trofeo)
BEGIN
    -- Medellín Raiders → Campeón Regional
    INSERT INTO equipo_trofeo (equipo_id, trofeo_id)
    SELECT e.id, t.id FROM equipo e, trofeo t
    WHERE e.nombre = 'Medellín Raiders' AND t.nombre = 'Campeón Regional';

    -- Envigado Gamers → Primera Sangre
    INSERT INTO equipo_trofeo (equipo_id, trofeo_id)
    SELECT e.id, t.id FROM equipo e, trofeo t
    WHERE e.nombre = 'Envigado Gamers' AND t.nombre = 'Primera Sangre';

    -- Bello Titans → Defensa de Hierro
    INSERT INTO equipo_trofeo (equipo_id, trofeo_id)
    SELECT e.id, t.id FROM equipo e, trofeo t
    WHERE e.nombre = 'Bello Titans' AND t.nombre = 'Defensa de Hierro';
END

-- ─────────────────────────────────────────────
-- SESIONES DE ENTRENAMIENTO
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM sesion WHERE fecha_agendamiento = '2025-09-15')
BEGIN
    DECLARE @arbitro_id INT = (SELECT id FROM usuario WHERE nickname = 'coach_rmontoya');

    INSERT INTO sesion (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado, puntos_xp_asignados)
    SELECT '2025-09-15', '09:00', '11:00', j.id, @arbitro_id, e.id, 'agendada', 0
    FROM juego j, equipo e WHERE j.nombre = 'League of Legends' AND e.nombre = 'Medellín Raiders';

    INSERT INTO sesion (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado, puntos_xp_asignados)
    SELECT '2025-09-16', '10:00', '12:00', j.id, @arbitro_id, e.id, 'activa', 0
    FROM juego j, equipo e WHERE j.nombre = 'FIFA 25' AND e.nombre = 'Antioquia FC E-Sports';

    INSERT INTO sesion (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado, puntos_xp_asignados)
    SELECT '2025-09-17', '14:00', '16:00', j.id, @arbitro_id, e.id, 'cerrada', 20
    FROM juego j, equipo e WHERE j.nombre = 'Valorant' AND e.nombre = 'Envigado Gamers';

    INSERT INTO sesion (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado, puntos_xp_asignados)
    SELECT '2025-09-18', '16:00', '18:00', j.id, @arbitro_id, e.id, 'cancelada', 0
    FROM juego j, equipo e WHERE j.nombre = 'Tekken 8' AND e.nombre = 'Bello Titans';

    INSERT INTO sesion (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado, puntos_xp_asignados)
    SELECT '2025-09-19', '18:00', '20:00', j.id, @arbitro_id, e.id, 'agendada', 0
    FROM juego j, equipo e WHERE j.nombre = 'League of Legends' AND e.nombre = 'Itagüí Legends';
END

-- ─────────────────────────────────────────────
-- CONSOLAS / HARDWARE
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM consola)
BEGIN
    INSERT INTO consola (numero_serie, nombre, plataforma_id, cantidad_total, direccion_ip, mac_utp5, mac_inalambrica, total_controles)
    SELECT 'SN-PS5-001', 'PS5 Estación 1',  p.id, 1, '192.168.1.101', '00:1A:2B:3C:4D:5E', '00:1A:2B:3C:4D:5F', 2 FROM plataforma p WHERE p.nombre = 'PlayStation 5';

    INSERT INTO consola (numero_serie, nombre, plataforma_id, cantidad_total, direccion_ip, mac_utp5, mac_inalambrica, total_controles)
    SELECT 'SN-XBX-001', 'Xbox Estación 2', p.id, 1, '192.168.1.102', '00:1A:2B:3C:4D:60', '00:1A:2B:3C:4D:61', 2 FROM plataforma p WHERE p.nombre = 'Xbox Series X';

    INSERT INTO consola (numero_serie, nombre, plataforma_id, cantidad_total, direccion_ip, mac_utp5, mac_inalambrica, total_controles)
    SELECT 'SN-PC-001',  'PC Gamer 1',      p.id, 1, '192.168.1.103', '00:1A:2B:3C:4D:62', '00:1A:2B:3C:4D:63', 1 FROM plataforma p WHERE p.nombre = 'PC';

    INSERT INTO consola (numero_serie, nombre, plataforma_id, cantidad_total, direccion_ip, mac_utp5, mac_inalambrica, total_controles)
    SELECT 'SN-NSW-001', 'Switch Lounge 1', p.id, 1, '192.168.1.104', '00:1A:2B:3C:4D:64', '00:1A:2B:3C:4D:65', 4 FROM plataforma p WHERE p.nombre = 'Nintendo Switch';

    INSERT INTO consola (numero_serie, nombre, plataforma_id, cantidad_total, direccion_ip, mac_utp5, mac_inalambrica, total_controles)
    SELECT 'SN-PS5-002', 'PS5 Estación 3',  p.id, 1, '192.168.1.105', '00:1A:2B:3C:4D:66', '00:1A:2B:3C:4D:67', 2 FROM plataforma p WHERE p.nombre = 'PlayStation 5';
END

-- ─────────────────────────────────────────────
-- CONTROLES
-- ─────────────────────────────────────────────
IF NOT EXISTS (SELECT 1 FROM control)
BEGIN
    INSERT INTO control (numero_serie, plataforma_id, tipo)
    SELECT 'DS5-001', id, 'gamepad' FROM plataforma WHERE nombre = 'PlayStation 5';

    INSERT INTO control (numero_serie, plataforma_id, tipo)
    SELECT 'DS5-002', id, 'gamepad' FROM plataforma WHERE nombre = 'PlayStation 5';

    INSERT INTO control (numero_serie, plataforma_id, tipo)
    SELECT 'XBC-001', id, 'gamepad' FROM plataforma WHERE nombre = 'Xbox Series X';

    INSERT INTO control (numero_serie, plataforma_id, tipo)
    SELECT 'KBD-001', id, 'teclado' FROM plataforma WHERE nombre = 'PC';

    INSERT INTO control (numero_serie, plataforma_id, tipo)
    SELECT 'MSE-001', id, 'mouse' FROM plataforma WHERE nombre = 'PC';
END
GO
