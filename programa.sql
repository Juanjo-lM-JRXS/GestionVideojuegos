-- Creación de la base de datos
CREATE DATABASE VideojuegoMultijugador;
USE VideojuegoMultijugador;

-- Tabla para gestionar los jugadores
CREATE TABLE Jugadores (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Nivel INT NOT NULL,
    Puntuacion INT DEFAULT 0,
    Equipo VARCHAR(50),
    Inventario JSON
);

-- Tabla para almacenar información de las partidas
CREATE TABLE Partidas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL,
    Equipo1 VARCHAR(50) NOT NULL,
    Equipo2 VARCHAR(50) NOT NULL,
    Resultado VARCHAR(50) NOT NULL
);

-- Tabla para gestionar los mundos virtuales
CREATE TABLE Mundos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NombreMundo VARCHAR(50) NOT NULL UNIQUE,
    GrafoSerializado JSON NOT NULL
);

-- Tabla para el ranking global
CREATE TABLE Ranking (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Jugador INT NOT NULL,
    Puntuacion INT NOT NULL,
    Posicion INT NOT NULL,
    FOREIGN KEY (ID_Jugador) REFERENCES Jugadores(ID)
);

-- Procedimiento almacenado para actualizar el ranking
DELIMITER //
CREATE PROCEDURE ActualizarRanking()
BEGIN
    SET @posicion = 0;
    UPDATE Ranking r
    JOIN (
        SELECT ID AS ID_Jugador, Puntuacion,
               RANK() OVER (ORDER BY Puntuacion DESC) AS NuevaPosicion
        FROM Jugadores
    ) subquery
    ON r.ID_Jugador = subquery.ID_Jugador
    SET r.Posicion = subquery.NuevaPosicion;
END //
DELIMITER ;

-- Procedimiento almacenado para registrar los resultados de las partidas
DELIMITER //
CREATE PROCEDURE RegistrarPartida(
    IN equipo1 VARCHAR(50),
    IN equipo2 VARCHAR(50),
    IN resultado VARCHAR(50),
    IN fecha DATETIME
)
BEGIN
    INSERT INTO Partidas (Fecha, Equipo1, Equipo2, Resultado)
    VALUES (fecha, equipo1, equipo2, resultado);
    
    -- Actualizar puntuaciones de los jugadores involucrados (simplificado para el ejemplo)
    UPDATE Jugadores
    SET Puntuacion = Puntuacion + 10
    WHERE Equipo = equipo1 OR Equipo = equipo2;
    
    CALL ActualizarRanking();
END //
DELIMITER ;

-- Procedimiento almacenado para insertar nuevas conexiones entre ubicaciones en un mundo
DELIMITER //
CREATE PROCEDURE InsertarConexion(
    IN idMundo INT,
    IN nodo1 VARCHAR(50),
    IN nodo2 VARCHAR(50),
    IN peso INT
)
BEGIN
    DECLARE grafoActual JSON;
    
    SELECT GrafoSerializado INTO grafoActual
    FROM Mundos
    WHERE ID = idMundo;
    
    -- Agregar la conexión al grafo actual (simplificado, requiere lógica para manejar JSON específico)
    SET grafoActual = JSON_ARRAY_APPEND(grafoActual, '$.aristas', JSON_OBJECT('nodo1', nodo1, 'nodo2', nodo2, 'peso', peso));
    
    UPDATE Mundos
    SET GrafoSerializado = grafoActual
    WHERE ID = idMundo;
END //
DELIMITER ;

-- Consultas iniciales para pruebas
-- Insertar jugadores de ejemplo
INSERT INTO Jugadores (NombreUsuario, Nivel, Puntuacion, Equipo, Inventario)
VALUES ('Jugador1', 5, 100, 'EquipoA', '{"item1": "Espada", "item2": "Escudo"}'),
       ('Jugador2', 3, 150, 'EquipoB', '{"item1": "Arco", "item2": "Flechas"}');

-- Insertar un mundo con un grafo inicial
INSERT INTO Mundos (NombreMundo, GrafoSerializado)
VALUES ('Mundo1', '{"nodos": ["Ciudad1", "Ciudad2"], "aristas": [{"nodo1": "Ciudad1", "nodo2": "Ciudad2", "peso": 10}]}');

-- Consultar el ranking inicial
CALL ActualizarRanking();
SELECT * FROM Ranking;