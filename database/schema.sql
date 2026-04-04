-- SQL Server 2019+
USE master;
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'esports_center')
BEGIN
    CREATE DATABASE esports_center COLLATE Modern_Spanish_CI_AS;
END
GO

USE esports_center;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[plataforma]') AND type in (N'U'))
CREATE TABLE plataforma (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    marca  NVARCHAR(100) NOT NULL
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[juego]') AND type in (N'U'))
CREATE TABLE juego (
    id                 INT IDENTITY(1,1) PRIMARY KEY,
    nombre             NVARCHAR(200) NOT NULL,
    calificacion_esrb  NVARCHAR(5)  NOT NULL,
    estudio            NVARCHAR(200) NOT NULL,
    num_jugadores      SMALLINT      NOT NULL,
    tipo               NVARCHAR(10)  NOT NULL CHECK (tipo IN ('fisico','digital')),
    existencias        INT           NOT NULL DEFAULT 0
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[juego_plataforma]') AND type in (N'U'))
CREATE TABLE juego_plataforma (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    juego_id      INT NOT NULL REFERENCES juego(id),
    plataforma_id INT NOT NULL REFERENCES plataforma(id),
    CONSTRAINT UQ_juego_plataforma UNIQUE (juego_id, plataforma_id)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trofeo]') AND type in (N'U'))
CREATE TABLE trofeo (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  NVARCHAR(200) NOT NULL,
    puntos  INT           NOT NULL,
    juego_id INT          NOT NULL REFERENCES juego(id)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[equipo]') AND type in (N'U'))
CREATE TABLE equipo (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    nombre      NVARCHAR(100) NOT NULL UNIQUE,
    juego_id    INT           NOT NULL REFERENCES juego(id),
    horas_juego INT           NOT NULL DEFAULT 0,
    nivel       NVARCHAR(10)  NOT NULL DEFAULT 'bronce'
        CHECK (nivel IN ('bronce','plata','oro','elite'))
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usuario]') AND type in (N'U'))
CREATE TABLE usuario (
    id               INT IDENTITY(1,1) PRIMARY KEY,
    tipo_documento   NVARCHAR(5)  NOT NULL,
    numero_documento NVARCHAR(20) NOT NULL UNIQUE,
    nombre_completo  NVARCHAR(200) NOT NULL,
    edad             SMALLINT     NOT NULL,
    sexo             CHAR(1)      NOT NULL CHECK (sexo IN ('M','F','O')),
    comuna           NVARCHAR(100),
    barrio           NVARCHAR(100),
    direccion        NVARCHAR(255),
    telefono_movil   NVARCHAR(20),
    telefono_trabajo NVARCHAR(20),
    telefono_fijo    NVARCHAR(20),
    redes_sociales   NVARCHAR(MAX),  -- JSON
    tipo_usuario     NVARCHAR(20) NOT NULL,
    nickname         NVARCHAR(50) NOT NULL UNIQUE,
    contrasena       NVARCHAR(255) NOT NULL,
    acudiente_id     INT REFERENCES usuario(id),
    equipo_id        INT REFERENCES equipo(id)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usuario_trofeo]') AND type in (N'U'))
CREATE TABLE usuario_trofeo (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id      INT  NOT NULL REFERENCES usuario(id),
    trofeo_id       INT  NOT NULL REFERENCES trofeo(id),
    fecha_obtencion DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_usuario_trofeo UNIQUE (usuario_id, trofeo_id)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[equipo_trofeo]') AND type in (N'U'))
CREATE TABLE equipo_trofeo (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    equipo_id       INT  NOT NULL REFERENCES equipo(id),
    trofeo_id       INT  NOT NULL REFERENCES trofeo(id),
    fecha_obtencion DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_equipo_trofeo UNIQUE (equipo_id, trofeo_id)
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[consola]') AND type in (N'U'))
CREATE TABLE consola (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    numero_serie    NVARCHAR(100) NOT NULL UNIQUE,
    nombre          NVARCHAR(100) NOT NULL,
    plataforma_id   INT           NOT NULL REFERENCES plataforma(id),
    cantidad_total  SMALLINT      NOT NULL DEFAULT 1,
    direccion_ip    NVARCHAR(45)  NOT NULL,
    mac_utp5        NVARCHAR(17)  NOT NULL,
    mac_inalambrica NVARCHAR(17)  NOT NULL,
    total_controles SMALLINT      NOT NULL DEFAULT 0
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[control]') AND type in (N'U'))
CREATE TABLE control (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    numero_serie NVARCHAR(100) NOT NULL UNIQUE,
    plataforma_id INT          NOT NULL REFERENCES plataforma(id),
    tipo         NVARCHAR(15) NOT NULL
        CHECK (tipo IN ('teclado','mouse','gamepad','instrumento','volante','otro'))
);

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sesion]') AND type in (N'U'))
CREATE TABLE sesion (
    id                   INT IDENTITY(1,1) PRIMARY KEY,
    fecha_agendamiento   DATE     NOT NULL,
    hora_inicio          TIME     NOT NULL,
    hora_fin             TIME     NOT NULL,
    juego_id             INT      NOT NULL REFERENCES juego(id),
    arbitro_id           INT      NOT NULL REFERENCES usuario(id),
    equipo_id            INT      REFERENCES equipo(id),
    atleta_id            INT      REFERENCES usuario(id),
    estado               NVARCHAR(10) NOT NULL DEFAULT 'agendada'
        CHECK (estado IN ('agendada','activa','cerrada','cancelada')),
    puntos_xp_asignados  INT      NOT NULL DEFAULT 0,
    hora_real_inicio     TIME     NULL,
    motivo_cancelacion   NVARCHAR(255) NULL,
    CONSTRAINT chk_sesion_equipo_atleta
        CHECK (
            (equipo_id IS NOT NULL AND atleta_id IS NULL) OR
            (equipo_id IS NULL AND atleta_id IS NOT NULL)
        )
);
GO
