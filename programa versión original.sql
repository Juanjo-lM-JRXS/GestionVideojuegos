-- 1. Gestión de Jugadores:

-- Administración de la información de los usuarios:

-- Creación de la base de datos:
CREATE DATABASE CallOfDutyBlackOpsII_DB;
USE CallOfDutyBlackOpsII_DB;

-- Creación de la tabla equipos:
CREATE TABLE Equipos (
    IDEquipo INT PRIMARY KEY,
    NombreEquipo VARCHAR(50) NOT NULL UNIQUE,
    PuntuaciónEquipo INT NOT NULL DEFAULT 0
);

-- Creación de la tabla de jugadores:
CREATE TABLE Jugadores (
    IDJugador INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Nivel INT NOT NULL,
    PuntuaciónJugador INT NOT NULL DEFAULT 0,
    IDEquipo INT NOT NULL,
    NombreEquipo VARCHAR(50) NOT NULL,
    InventarioJugador TEXT,
    FOREIGN KEY (IDEquipo) REFERENCES Equipos(IDEquipo)
);

-- Creación de la tabla de partidas:
CREATE TABLE Partidas (
    IDPartida INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATE NOT NULL,
    IDEquipo INT NOT NULL,
    NombreEquipo VARCHAR(50) NOT NULL,
    PuntuaciónEquipo INT NOT NULL,
    IDJugador INT NOT NULL,
    NombreUsuario VARCHAR(50) NOT NULL,
    PuntuaciónJugador INT NOT NULL,
    FOREIGN KEY (IDEquipo) REFERENCES Equipos(IDEquipo),
    FOREIGN KEY (IDJugador) REFERENCES Jugadores(IDJugador)
);

-- Creación de la tabla mapas:
CREATE TABLE Mapas (
    IDMapa INT PRIMARY KEY,
    NombreMapa VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Conexiones (
    IDConexion INT AUTO_INCREMENT PRIMARY KEY,
    IDMapa INT NOT NULL,
    PuntoOrigenNombre VARCHAR(50) NOT NULL,
    PuntoDestinoNombre VARCHAR(50) NOT NULL,
    FOREIGN KEY (IDMapa) REFERENCES Mapas(IDMapa)
);

-- Inserción de la información de los equipos:
INSERT INTO Equipos (IDEquipo, NombreEquipo, PuntuaciónEquipo)
VALUES 
(1, 'SEAL TEAM 6', '24700'),
(2, 'SOG', '31900'),
(3, 'Mercs', '36100'),
(4, 'Militia', '28400'),
(5, 'ISA', '33300'),
(6, 'FBI', '36300'),
(7, 'PMC', '29500'),
(8, 'Cartel', '32100');

-- Inserción de la información de los jugadores:
INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('ShadowEagle', 25, 7500, 1, 'SEAL TEAM 6', 'Primaria: Subfusil: MP7 - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Semtex, Táctica: Granada de humo'),
('IronWolf', 30, 9500, 1, 'SEAL TEAM 6', 'Primaria: Rifle de asalto: M27 - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Granada de fragmentación, Táctica: Granada aturdidora'),
('CrimsonBlade', 15, 4500, 1, 'SEAL TEAM 6', 'Primaria: Escopeta: Remington 870 MCS - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: C4, Táctica: Carga de choque'),
('SilverHawk', 10, 3200, 1, 'SEAL TEAM 6', 'Primaria: Subfusil: Chicom CQB - Secundaria: Pistola: Verdugo - Equipamiento: Letal: Claymore, Táctica: Granada EMP');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('NightShadow', 40, 12000, 2, 'SOG', 'Primaria: Rifle de francotirador: Balista - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Hacha de combate, Táctica: Granada con sensor'),
('GhostHunter', 20, 5800, 2, 'SOG', 'Primaria: Rifle de asalto: AN-94 - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Semtex, Táctica: Sombrero negro'),
('DarkPhoenix', 35, 10500, 2, 'SOG', 'Primaria: Ametralladora ligera: LSAT - Secundaria: Pistola: B23R - Equipamiento: Letal: Granada de fragmentación, Táctica: Granada de conmoción'),
('FrostFang', 12, 3600, 2, 'SOG', 'Primaria: Subfusil: Skorpion EVO - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: Rebotante Betty, Táctica: Granada aturdidora');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('BlackVenom', 28, 8400, 3, 'Mercs', 'Primaria: Escopeta: KSG - Secundaria: Pistola: B23R - Equipamiento: Letal: Semtex, Táctica: Granada EMP'),
('SteelRanger', 50, 15000, 3, 'Mercs', 'Primaria: Rifle de francotirador: DSR 50 - Secundaria: Pistola: Verdugo - Equipamiento: Letal: C4, Táctica: Granada de humo'),
('ShadowClaw', 18, 5200, 3, 'Mercs', 'Primaria: Subfusil: Vector K10 - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Rebotante Betty, Táctica: Carga de choque'),
('BlazingHawk', 25, 7500, 3, 'Mercs', 'Primaria: Rifle de asalto: SCAR-H - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Granada de fragmentación, Táctica: Sombrero negro');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('IronFist', 22, 6400, 4, 'Militia', 'Primaria: Subfusil: MSC - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: Hacha de combate, Táctica: Granada de conmoción'),
('CrimsonWraith', 14, 4000, 4, 'Militia', 'Primaria: Escopeta: M1216 - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Semtex, Táctica: Carga de choque'),
('FrostWolf', 34, 10000, 4, 'Militia', 'Primaria: Ametralladora ligera: Hamer - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: C4, Táctica: Granada EMP'),
('DarkRaven', 27, 8000, 4, 'Militia', 'Primaria: Rifle de francotirador: XPR-50 - Secundaria: Pistola: B23R - Equipamiento: Letal: Claymore, Táctica: Granada con sensor');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('SilentWolf', 17, 4800, 5, 'ISA', 'Primaria: Rifle de asalto: Tipo 25 - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: Rebotante Betty, Táctica: Granada de humo'),
('PhantomBlade', 45, 13500, 5, 'ISA', 'Primaria: Rifle de francotirador: SVU-AS - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Semtex, Táctica: Sombrero negro'),
('SteelHawk', 21, 6000, 5, 'ISA', 'Primaria: Subfusil: PDW-57 - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Granada de fragmentación, Táctica: Granada EMP'),
('BlazingFury', 30, 9000, 5, 'ISA', 'Primaria: Ametralladora ligera: Mk 48 - Secundaria: Pistola: Verdugo - Equipamiento: Letal: C4, Táctica: Granada aturdidora');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('NightHunter', 26, 7800, 6, 'FBI', 'Primaria: Subfusil: MP7 - Secundaria: Pistola: B23R - Equipamiento: Letal: Claymore, Táctica: Granada de conmoción'),
('GhostRider', 40, 12000, 6, 'FBI', 'Primaria: Rifle de asalto: M8A1 - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Rebotante Betty, Táctica: Carga de choque'),
('ShadowFang', 19, 5500, 6, 'FBI', 'Primaria: Subfusil: Skorpion EVO - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Semtex, Táctica: Sombrero negro'),
('IronPhoenix', 35, 11000, 6, 'FBI', 'Primaria: Escopeta: Remington 870 MCS - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: Hacha de combate, Táctica: Granada con sensor');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('DarkViper', 12, 3600, 7, 'PMC', 'Primaria: Rifle de asalto: MTAR - Secundaria: Pistola: Verdugo - Equipamiento: Letal: Semtex, Táctica: Granada EMP'),
('CrimsonHawk', 38, 11500, 7, 'PMC', 'Primaria: Rifle de francotirador: Balista - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Rebotante Betty, Táctica: Carga de choque'),
('BlazingShadow', 20, 5800, 7, 'PMC', 'Primaria: Subfusil: MSC - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: C4, Táctica: Granada de conmoción'),
('PhantomStrike', 28, 8600, 7, 'PMC', 'Primaria: Ametralladora ligera: LSAT - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Semtex, Táctica: EMP');

INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador) VALUES
('ShadowSerpent', 22, 6700, 8, 'Cartel', 'Primaria: Rifle de asalto: FAL OSW - Secundaria: Pistola: Tac-45 - Equipamiento: Letal: Semtex, Táctica: Granada EMP'),
('IronGhost', 30, 9400, 8, 'Cartel', 'Primaria: Subfusil: Chicom CQB - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Hacha de combate, Táctica: Sombrero negro'),
('CrimsonShadow', 18, 5200, 8, 'Cartel', 'Primaria: Ametralladora ligera: QBB LSW - Secundaria: Pistola: Cinco-siete - Equipamiento: Letal: C4, Táctica: Granada de conmoción'),
('SilverViper', 35, 10800, 8, 'Cartel', 'Primaria: Escopeta: S12 - Secundaria: Pistola: B23R - Equipamiento: Letal: Granada de fragmentación, Táctica: Granada aturdidora');

-- Inserciones de la información de las partidas:
INSERT INTO Partidas (Fecha, IDEquipo, NombreEquipo, PuntuaciónEquipo, IDJugador, NombreUsuario, PuntuaciónJugador)
VALUES

('2024-12-13', 1, 'SEAL TEAM 6', 24700, 1, 'ShadowEagle', 7500),
('2024-12-13', 1, 'SEAL TEAM 6', 24700, 2, 'IronWolf', 9500),
('2024-12-13', 1, 'SEAL TEAM 6', 24700, 3, 'CrimsonBlade', 4500),
('2024-12-13', 1, 'SEAL TEAM 6', 24700, 4, 'SilverHawk', 3200),
('2024-12-13', 2, 'SOG', 31900, 5, 'NightShadow', 12000),
('2024-12-13', 2, 'SOG', 31900, 6, 'GhostHunter', 5800),
('2024-12-13', 2, 'SOG', 31900, 7, 'DarkPhoenix', 10500),
('2024-12-13', 2, 'SOG', 31900, 8, 'FrostFang', 3600),

('2024-12-14', 3, 'Mercs', 36100, 9, 'BlackVenom', 8400),
('2024-12-14', 3, 'Mercs', 36100, 10, 'SteelRanger', 15000),
('2024-12-14', 3, 'Mercs', 36100, 11, 'ShadowClaw', 5200),
('2024-12-14', 3, 'Mercs', 36100, 12, 'BlazingHawk', 7500),
('2024-12-14', 4, 'Militia', 28400, 13, 'IronFist', 6400),
('2024-12-14', 4, 'Militia', 28400, 14, 'CrimsonWraith', 4000),
('2024-12-14', 4, 'Militia', 28400, 15, 'FrostWolf', 10000),
('2024-12-14', 4, 'Militia', 28400, 16, 'DarkRaven', 8000),

('2024-12-15', 5, 'ISA', 33300, 17, 'SilentWolf', 4800),
('2024-12-15', 5, 'ISA', 33300, 18, 'PhantomBlade', 13500),
('2024-12-15', 5, 'ISA', 33300, 19, 'SteelHawk', 6000),
('2024-12-15', 5, 'ISA', 33300, 20, 'BlazingFury', 9000),
('2024-12-15', 6, 'FBI', 36300, 21, 'NightHunter', 7800),
('2024-12-15', 6, 'FBI', 36300, 22, 'GhostRider', 12000),
('2024-12-15', 6, 'FBI', 36300, 23, 'ShadowFang', 5500),
('2024-12-15', 6, 'FBI', 36300, 24, 'IronPhoenix', 11000),

('2024-12-16', 7, 'PMC', 29500, 25, 'DarkViper', 3600),
('2024-12-16', 7, 'PMC', 29500, 26, 'CrimsonHawk', 11500),
('2024-12-16', 7, 'PMC', 29500, 27, 'BlazingShadow', 5800),
('2024-12-16', 7, 'PMC', 29500, 28, 'PhantomStrike', 8600),
('2024-12-16', 8, 'Cartel', 32100, 29, 'ShadowSerpent', 6700),
('2024-12-16', 8, 'Cartel', 32100, 30, 'IronGhost', 9400),
('2024-12-16', 8, 'Cartel', 32100, 31, 'CrimsonShadow', 5200),
('2024-12-16', 8, 'Cartel', 32100, 32, 'SilverViper', 10800);

-- Inserción de la información de los mapas:
INSERT INTO Mapas (IDMapa, NombreMapa) VALUES
(1, 'Aftermath'),
(2, 'Cargo'),
(3, 'Hijacked');

-- Inserciones de la información de las conexiones:
INSERT INTO Conexiones (IDMapa, PuntoOrigenNombre, PuntoDestinoNombre) VALUES
(1, 'Ruinas', 'Centro'),
(1, 'Centro', 'Puente'),
(1, 'Puente', 'Ruinas');

-- Inserción de conexiones para el mapa Cargo
INSERT INTO Conexiones (IDMapa, PuntoOrigenNombre, PuntoDestinoNombre) VALUES
(2, 'Almacén', 'Muelles'),
(2, 'Muelles', 'Zona de Carga'),
(2, 'Zona de Carga', 'Pasarela');

INSERT INTO Conexiones (IDMapa, PuntoOrigenNombre, PuntoDestinoNombre) VALUES
(3, 'Proa', 'Cubierta Media'),
(3, 'Cubierta Media', 'Popa'),
(3, 'Popa', 'Proa');

USE CallOfDutyBlackOpsII_DB;

-- 1. Registro de nuevos jugadores:
DELIMITER //
CREATE PROCEDURE RegistrarJugadorNuevo(
    IN J_NombreUsuario VARCHAR(50),
    IN J_Nivel INT,
    IN J_PuntuaciónJugador INT,
    IN J_IDEquipo INT,
    IN J_NombreEquipo VARCHAR(50),
    IN J_InventarioJugador TEXT
)
BEGIN
    INSERT INTO Jugadores (NombreUsuario, Nivel, PuntuaciónJugador, IDEquipo, NombreEquipo, InventarioJugador)
    VALUES (J_NombreUsuario, J_Nivel, J_PuntuaciónJugador, J_IDEquipo, J_NombreEquipo, J_InventarioJugador);
END //
DELIMITER ;

CALL RegistrarJugadorNuevo('DismalSkull', 616, 999999, 1, 'SEAL TEAM 6', 'Primaria: Subfusil: MP7 - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Semtex, Táctica: Granada de humo');

-- 2. Consulta de un jugador de manera individual:
DELIMITER //
CREATE PROCEDURE ConsultarJugadorÚnico (
    IN J_ID INT
)
BEGIN
    SELECT * FROM Jugadores WHERE IDJugador = J_ID;
END //
DELIMITER ;

CALL ConsultarJugadorÚnico('1');

-- 2.1. Consulta de todos los jugadores actuales:
DELIMITER //
CREATE PROCEDURE ConsultarListaJugadores (
)
BEGIN
    SELECT * FROM Jugadores;
END //
DELIMITER ;

CALL ConsultarListaJugadores();

-- 3. Modificación de la información de un jugador
DELIMITER //
CREATE PROCEDURE ModificarInformaciónJugador (
    IN J_ID INT,
    IN J_NombreUsuario VARCHAR(50),
    IN J_Nivel INT,
    IN J_PuntuaciónJugador INT,
    IN J_IDEquipo INT,
    IN J_NombreEquipo VARCHAR(50),
    IN J_InventarioJugador TEXT
)
BEGIN
    UPDATE Jugadores SET IDJugador = J_ID WHERE IDJugador = J_ID;
    UPDATE Jugadores SET NombreUsuario = J_NombreUsuario WHERE IDJugador = J_ID;
    UPDATE Jugadores SET Nivel = J_Nivel WHERE IDJugador = J_ID;
    UPDATE Jugadores SET PuntuaciónJugador = J_PuntuaciónJugador WHERE IDJugador = J_ID;
    UPDATE Jugadores SET IDEquipo = J_IDEquipo WHERE IDJugador = J_ID;
    UPDATE Jugadores SET NombreEquipo = J_NombreEquipo WHERE IDJugador = J_ID;
    UPDATE Jugadores SET InventarioJugador = J_InventarioJugador WHERE IDJugador = J_ID;
END //
DELIMITER ;

CALL ModificarInformaciónJugador(34, 'Corpsegrinder', 700, 100000, 1, 'SEAL TEAM 6', 'Primaria: Subfusil: MP7 - Secundaria: Pistola: KAP-40 - Equipamiento: Letal: Semtex, Táctica: Granada de humo');


-- 4. Supresión de un jugador en concreto
DELIMITER //
CREATE PROCEDURE EliminarJugadorEspecífico (
    IN J_ID INT
)
BEGIN
    DELETE FROM Jugadores WHERE IDJugador = J_ID;
END //
DELIMITER ;

CALL EliminarJugadorEspecífico(33);

-- 5. Ranking Global:

/* Consulta y actualización del ranking global basado en la puntuación de los jugadores,
calculando las posiciones mediante un procedimiento almacenado: */

USE CallOfDutyBlackOpsII_DB;

-- Consultar el ranking global jugadores
DELIMITER //
CREATE PROCEDURE ConsultarRankingGlobalJugadores()
BEGIN
	SELECT IDJugador, NombreUsuario, Nivel, PuntuaciónJugador,
    ROW_NUMBER() OVER (ORDER BY PuntuaciónJugador DESC) AS PosiciónRankingGlobal
    FROM Jugadores
    ORDER BY PuntuaciónJugador DESC;
END //
DELIMITER ;

CALL ConsultarRankingGlobalJugadores()

-- Consultar el ranking global equipos
DELIMITER //
CREATE PROCEDURE ConsultarRankingGlobalEquipos()
BEGIN
	SELECT IDEquipo, NombreEquipo, PuntuaciónEquipo,
    ROW_NUMBER() OVER (ORDER BY PuntuaciónEquipo DESC) AS PosiciónRankingGlobal
    FROM Equipos
    ORDER BY PuntuaciónEquipo DESC;
END //
DELIMITER ;

CALL ConsultarRankingGlobalEquipos()

-- 7. Consultas y Análisis:

-- Consultas SQL para:
-- Obtener los 10 jugadores con mayor puntuación:

USE CallOfDutyBlackOpsII_DB;

DELIMITER //
CREATE PROCEDURE DiezMejoresJugadores()
BEGIN
SELECT IDJugador, NombreUsuario, PuntuaciónJugador, Nivel, NombreEquipo
FROM Jugadores
ORDER BY PuntuaciónJugador DESC
LIMIT 10;
END //
DELIMITER ;

CALL DiezMejoresJugadores()

-- Verificar el inventario de un jugador específico:

DELIMITER //
CREATE PROCEDURE VerificarInventarioJugador (
    IN P_IDJugador INT
)
BEGIN
    SELECT IDJugador, NombreUsuario, InventarioJugador
    FROM Jugadores
    WHERE IDJugador = P_IDJugador;
END //
DELIMITER ;

CALL VerificarInventarioJugador(1)

-- Listar todas las partidas de un jugador en un rango de fechas:

DELIMITER //
CREATE PROCEDURE ListarPartidasJugador(
    IN NombreJugador VARCHAR(50),
    IN FechaInicio DATE,
    IN FechaFin DATE
)
BEGIN
    SELECT P.Fecha, P.IDEquipo, P.NombreEquipo, P.PuntuaciónEquipo, J.IDJugador, J.NombreUsuario, J.PuntuaciónJugador
    FROM Partidas P
    INNER JOIN Jugadores J
    ON P.IDJugador = J.IDJugador
    WHERE J.NombreUsuario = NombreJugador
	AND P.Fecha BETWEEN FechaInicio AND FechaFin
    ORDER BY P.Fecha ASC;
END //
DELIMITER ;

CALL ListarPartidasJugador('ShadowEagle', '2024-12-01', '2024-12-31');

-- Procedimiento para crear una conexión:
DELIMITER //
CREATE PROCEDURE CrearConexion(
    IN p_IDMapa INT,
    IN p_PuntoOrigenNombre VARCHAR(50),
    IN p_PuntoDestinoNombre VARCHAR(50)
)
BEGIN
    INSERT INTO Conexiones (IDMapa, PuntoOrigenNombre, PuntoDestinoNombre)
    VALUES (p_IDMapa, p_PuntoOrigenNombre, p_PuntoDestinoNombre);
END //
DELIMITER ;

CALL CrearConexion(2, 'Almacén', 'Muelles');

-- Procedimiento para leer las conexiones:
DELIMITER //
CREATE PROCEDURE LeerConexionesPorMapa(
    IN p_IDMapa INT
)
BEGIN
    SELECT * FROM Conexiones WHERE IDMapa = p_IDMapa;
END //
DELIMITER ;

CALL LeerConexionesPorMapa(2);

-- Procedimiento para actualizar una conexión:
DELIMITER //
CREATE PROCEDURE ActualizarConexion(
    IN p_IDConexion INT,
    IN p_NuevoPuntoOrigenNombre VARCHAR(50),
    IN p_NuevoPuntoDestinoNombre VARCHAR(50)
)
BEGIN
    UPDATE Conexiones
    SET PuntoOrigenNombre = p_NuevoPuntoOrigenNombre,
        PuntoDestinoNombre = p_NuevoPuntoDestinoNombre
    WHERE IDConexion = p_IDConexion;
END //
DELIMITER ;

CALL ActualizarConexion(1, 'Almacén', 'Zona de Carga');

-- Procedimiento para eliminar una conexión:
DELIMITER //
CREATE PROCEDURE EliminarConexion(
    IN p_IDConexion INT
)
BEGIN
    DELETE FROM Conexiones WHERE IDConexion = p_IDConexion;
END //
DELIMITER ;

CALL EliminarConexion(1);