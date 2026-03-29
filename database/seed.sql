USE esports_center;
GO

-- Insert conditionally to avoid errors on multiple runs
IF NOT EXISTS (SELECT 1 FROM plataforma WHERE nombre = 'PlayStation 5')
BEGIN
    INSERT INTO plataforma (nombre, marca) VALUES
    ('PlayStation 5', 'Sony'),
    ('Xbox Series X', 'Microsoft'),
    ('PC', 'Custom'),
    ('Nintendo Switch', 'Nintendo');
END

IF NOT EXISTS (SELECT 1 FROM juego WHERE nombre = 'League of Legends')
BEGIN
    INSERT INTO juego (nombre, calificacion_esrb, estudio, num_jugadores, tipo, existencias) VALUES
    ('League of Legends', 'T', 'Riot Games', 10, 'digital', 0),
    ('FIFA 25', 'E', 'EA Sports', 22, 'fisico', 5),
    ('Valorant', 'T', 'Riot Games', 10, 'digital', 0),
    ('Tekken 8', 'T', 'Bandai Namco', 2, 'fisico', 3);
END

IF NOT EXISTS (SELECT 1 FROM equipo WHERE nombre = 'Medellín Raiders')
BEGIN
    INSERT INTO equipo (nombre, juego_id, horas_juego, nivel) VALUES
    ('Medellín Raiders', 1, 120, 'plata'),
    ('Antioquia FC E-Sports', 2, 80, 'bronce');
END

IF NOT EXISTS (SELECT 1 FROM trofeo WHERE nombre = 'Campeón Regional')
BEGIN
    INSERT INTO trofeo (nombre, puntos, juego_id) VALUES
    ('Campeón Regional', 500, 1),
    ('MVP del Torneo', 300, 1),
    ('Mejor Delantero', 200, 2);
END

IF NOT EXISTS (SELECT 1 FROM usuario WHERE numero_documento = '1037654321')
BEGIN
    INSERT INTO usuario
      (tipo_documento, numero_documento, nombre_completo, edad, sexo,
       comuna, barrio, direccion, telefono_movil, tipo_usuario, nickname, contrasena, equipo_id)
    VALUES
    ('CC', '1037654321', 'Carlos Andrés Pérez', 22, 'M',
     '16', 'Belén', 'Cra 80 #35-12', '3001234567', 'atleta', 'caperez_gg', 'hash_pw_1', 1),
    ('CC', '1037654322', 'Valentina Gómez', 20, 'F',
     '14', 'El Poblado', 'Calle 10 #43-15', '3009876543', 'atleta', 'vgomez_gg', 'hash_pw_2', 1),
    ('CC', '71500001',  'Ricardo Montoya', 35, 'M',
     '10', 'Manrique', 'Calle 52 #33-10', '3111234567', 'entrenador', 'coach_rmontoya', 'hash_pw_3', NULL);
END

IF NOT EXISTS (SELECT 1 FROM sesion)
BEGIN
    INSERT INTO sesion
      (fecha_agendamiento, hora_inicio, hora_fin, juego_id, arbitro_id, equipo_id, estado)
    VALUES
    ('2025-09-15', '09:00', '11:00', 1, 3, 1, 'agendada');
END
GO
