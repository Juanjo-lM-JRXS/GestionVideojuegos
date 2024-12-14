import mysql.connector
from mysql.connector import Error
import json
import heapq

class DatabaseManager:
    def __init__(self, host, user, password, database):
        self.connection = None
        try:
            self.connection = mysql.connector.connect(
                host=host,
                user=user,
                password=password,
                database=database
            )
            if self.connection.is_connected():
                print("Conexión exitosa a la base de datos")
        except Error as e:
            print(f"Error al conectar a la base de datos: {e}")

    def execute_query(self, query, params=None):
        try:
            cursor = self.connection.cursor()
            cursor.execute(query, params)
            self.connection.commit()
            return cursor
        except Error as e:
            print(f"Error al ejecutar la consulta: {e}")
            return None

    def fetch_results(self, query, params=None):
        try:
            cursor = self.connection.cursor(dictionary=True)
            cursor.execute(query, params)
            return cursor.fetchall()
        except Error as e:
            print(f"Error al obtener resultados: {e}")
            return None

class Grafo:
    def __init__(self):
        self.ubicaciones = {}

    def agregar_nodo(self, nodo):
        if nodo not in self.ubicaciones:
            self.ubicaciones[nodo] = {}

    def agregar_arista(self, origen, destino, peso):
        self.agregar_nodo(origen)
        self.agregar_nodo(destino)
        self.ubicaciones[origen][destino] = peso

    def encontrar_ruta_mas_corta(self, inicio, destino):
        distancias = {nodo: float('inf') for nodo in self.ubicaciones}
        distancias[inicio] = 0
        prioridad = [(0, inicio)]
        while prioridad:
            distancia_actual, nodo_actual = heapq.heappop(prioridad)
            if nodo_actual == destino:
                return distancia_actual
            for vecino, peso in self.ubicaciones[nodo_actual].items():
                nueva_distancia = distancia_actual + peso
                if nueva_distancia < distancias[vecino]:
                    distancias[vecino] = nueva_distancia
                    heapq.heappush(prioridad, (nueva_distancia, vecino))
        return float('inf')

class NodoArbol:
    def __init__(self, fecha, datos):
        self.fecha = fecha
        self.datos = datos
        self.izquierda = None
        self.derecha = None

class ArbolBinario:
    def __init__(self):
        self.raiz = None

    def insertar(self, fecha, datos):
        if not self.raiz:
            self.raiz = NodoArbol(fecha, datos)
        else:
            self._insertar(self.raiz, fecha, datos)

    def _insertar(self, nodo, fecha, datos):
        if fecha < nodo.fecha:
            if nodo.izquierda is None:
                nodo.izquierda = NodoArbol(fecha, datos)
            else:
                self._insertar(nodo.izquierda, fecha, datos)
        else:
            if nodo.derecha is None:
                nodo.derecha = NodoArbol(fecha, datos)
            else:
                self._insertar(nodo.derecha, fecha, datos)

    def buscar_rango(self, fecha_inicio, fecha_fin):
        resultados = []
        self._buscar_rango(self.raiz, fecha_inicio, fecha_fin, resultados)
        return resultados

    def _buscar_rango(self, nodo, fecha_inicio, fecha_fin, resultados):
        if nodo:
            if fecha_inicio <= nodo.fecha <= fecha_fin:
                resultados.append(nodo.datos)
            if fecha_inicio < nodo.fecha:
                self._buscar_rango(nodo.izquierda, fecha_inicio, fecha_fin, resultados)
            if nodo.fecha < fecha_fin:
                self._buscar_rango(nodo.derecha, fecha_inicio, fecha_fin, resultados)

class Videojuego:
    def __init__(self, db_manager):
        self.db = db_manager
        self.grafos = {}
        self.arbol_partidas = ArbolBinario()

    def registrar_jugador(self, nombre_usuario, nivel, equipo):
        query = """
        INSERT INTO Jugadores (NombreUsuario, Nivel, Equipo, Inventario)
        VALUES (%s, %s, %s, '{}')
        """
        self.db.execute_query(query, (nombre_usuario, nivel, equipo))

    def modificar_jugador(self, nombre_usuario, nivel=None, equipo=None):
        partes = []
        params = []
        if nivel is not None:
            partes.append("Nivel = %s")
            params.append(nivel)
        if equipo is not None:
            partes.append("Equipo = %s")
            params.append(equipo)
        params.append(nombre_usuario)
        query = f"UPDATE Jugadores SET {', '.join(partes)} WHERE NombreUsuario = %s"
        self.db.execute_query(query, params)

    def eliminar_jugador(self, nombre_usuario):
        query = "DELETE FROM Jugadores WHERE NombreUsuario = %s"
        self.db.execute_query(query, (nombre_usuario,))

    def consultar_jugador(self, nombre_usuario):
        query = "SELECT * FROM Jugadores WHERE NombreUsuario = %s"
        return self.db.fetch_results(query, (nombre_usuario,))

    def crear_mundo(self, nombre_mundo):
        grafo = Grafo()
        self.grafos[nombre_mundo] = grafo
        grafo_serializado = json.dumps({"nodos": [], "aristas": []})
        query = """
        INSERT INTO Mundos (NombreMundo, GrafoSerializado)
        VALUES (%s, %s)
        """
        self.db.execute_query(query, (nombre_mundo, grafo_serializado))

    def agregar_conexion_mundo(self, nombre_mundo, origen, destino, peso):
        if nombre_mundo in self.grafos:
            grafo = self.grafos[nombre_mundo]
            grafo.agregar_arista(origen, destino, peso)
            grafo_serializado = json.dumps(grafo.ubicaciones)
            query = """
            UPDATE Mundos
            SET GrafoSerializado = %s
            WHERE NombreMundo = %s
            """
            self.db.execute_query(query, (grafo_serializado, nombre_mundo))

    def consultar_ruta_optima(self, nombre_mundo, origen, destino):
        if nombre_mundo in self.grafos:
            grafo = self.grafos[nombre_mundo]
            return grafo.encontrar_ruta_mas_corta(origen, destino)
        return float('inf')

    def registrar_partida(self, fecha, equipo1, equipo2, resultado):
        query = "CALL RegistrarPartida(%s, %s, %s, %s)"
        self.db.execute_query(query, (equipo1, equipo2, resultado, fecha))
        self.arbol_partidas.insertar(fecha, {"equipo1": equipo1, "equipo2": equipo2, "resultado": resultado})

    def consultar_partidas_rango(self, fecha_inicio, fecha_fin):
        return self.arbol_partidas.buscar_rango(fecha_inicio, fecha_fin)

def menu_principal():
    db_manager = DatabaseManager(host="localhost", user="root", password="", database="VideojuegoMultijugador")
    juego = Videojuego(db_manager)

    while True:
        print("\n*************************** Menú Principal ***************************")
        print("1) Gestión de Jugadores")
        print("2) Gestión de Mapas")
        print("3) Gestión de Inventarios")
        print("4) Sistema de Batallas y Partidas")
        print("5) Ranking Global")
        print("6) Equipos y Estadísticas")
        print("7) Consultas y Análisis")
        print("8) Salir")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            menu_gestion_jugadores(juego)
        elif opcion == "2":
            menu_gestion_mapas(juego)
        elif opcion == "3":
            menu_gestion_inventarios(juego)
        elif opcion == "4":
            menu_sistema_batallas(juego)
        elif opcion == "5":
            menu_ranking_global(juego)
        elif opcion == "6":
            menu_equipos_estadisticas(juego)
        elif opcion == "7":
            menu_consultas_analisis(juego)
        elif opcion == "8":
            print("Saliendo del programa.")
            break
        else:
            print("Opción no válida. Intente de nuevo.")

def menu_gestion_jugadores(juego):
    while True:
        print("\n*************************** Gestión de Jugadores ***************************")
        print("1) Registrar jugador")
        print("2) Modificar jugador")
        print("3) Eliminar jugador")
        print("4) Consultar jugador")
        print("5) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            nombre = input("Ingrese el nombre del jugador: ")
            nivel = int(input("Ingrese el nivel del jugador: "))
            equipo = input("Ingrese el nombre del equipo: ")
            juego.registrar_jugador(nombre, nivel, equipo)
            print(f"Jugador {nombre} registrado exitosamente.")
        elif opcion == "2":
            nombre = input("Ingrese el nombre del jugador a modificar: ")
            nivel = input("Ingrese el nuevo nivel del jugador (deje en blanco para no modificar): ")
            equipo = input("Ingrese el nuevo equipo del jugador (deje en blanco para no modificar): ")
            nivel = int(nivel) if nivel else None
            equipo = equipo if equipo else None
            juego.modificar_jugador(nombre, nivel, equipo)
            print(f"Jugador {nombre} modificado exitosamente.")
        elif opcion == "3":
            nombre = input("Ingrese el nombre del jugador a eliminar: ")
            juego.eliminar_jugador(nombre)
            print(f"Jugador {nombre} eliminado exitosamente.")
        elif opcion == "4":
            nombre = input("Ingrese el nombre del jugador: ")
            jugador = juego.consultar_jugador(nombre)
            if jugador:
                print("Información del jugador:")
                print(jugador[0])
            else:
                print("Jugador no encontrado.")
        elif opcion == "5":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

def menu_gestion_mapas(juego):
    while True:
        print("\n*************************** Gestión de Mapas ***************************")
        print("1) Crear un nuevo mundo")
        print("2) Agregar una conexión entre ubicaciones")
        print("3) Consultar ruta óptima entre ubicaciones")
        print("4) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            nombre_mundo = input("Ingrese el nombre del nuevo mundo: ")
            juego.crear_mundo(nombre_mundo)
            print(f"Mundo '{nombre_mundo}' creado exitosamente.")
        elif opcion == "2":
            nombre_mundo = input("Ingrese el nombre del mundo: ")
            origen = input("Ingrese el nombre de la ubicación de origen: ")
            destino = input("Ingrese el nombre de la ubicación de destino: ")
            peso = int(input("Ingrese el peso de la conexión (distancia o costo): "))
            juego.agregar_conexion_mundo(nombre_mundo, origen, destino, peso)
            print(f"Conexión de {origen} a {destino} con peso {peso} añadida en el mundo '{nombre_mundo}'.")
        elif opcion == "3":
            nombre_mundo = input("Ingrese el nombre del mundo: ")
            origen = input("Ingrese el nombre de la ubicación de origen: ")
            destino = input("Ingrese el nombre de la ubicación de destino: ")
            distancia = juego.consultar_ruta_optima(nombre_mundo, origen, destino)
            if distancia != float('inf'):
                print(f"La distancia óptima entre {origen} y {destino} en el mundo '{nombre_mundo}' es {distancia}.")
            else:
                print(f"No se encontró una ruta entre {origen} y {destino} en el mundo '{nombre_mundo}'.")
        elif opcion == "4":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

def menu_gestion_inventarios(juego):
    while True:
        print("\n*************************** Gestión de Inventarios ***************************")
        print("1) Consultar inventario")
        print("2) Modificar inventario")
        print("3) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            nombre = input("Ingrese el nombre del jugador: ")
            jugador = juego.consultar_jugador(nombre)
            if jugador:
                print(f"Inventario de {nombre}: {jugador[0]['Inventario']}")
            else:
                print("Jugador no encontrado.")
        elif opcion == "2":
            nombre = input("Ingrese el nombre del jugador: ")
            inventario = input("Ingrese el nuevo inventario en formato JSON: ")
            try:
                json.loads(inventario)  # Verifica si es JSON válido
                query = "UPDATE Jugadores SET Inventario = %s WHERE NombreUsuario = %s"
                juego.db.execute_query(query, (inventario, nombre))
                print("Inventario actualizado.")
            except json.JSONDecodeError:
                print("Formato de inventario no válido.")
        elif opcion == "3":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

def menu_sistema_batallas(juego):
    while True:
        print("\n*************************** Sistema de Batallas ***************************")
        print("1) Registrar partida")
        print("2) Consultar partidas por rango de fechas")
        print("3) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            fecha = input("Ingrese la fecha (YYYY-MM-DD): ")
            equipo1 = input("Ingrese el nombre del equipo 1: ")
            equipo2 = input("Ingrese el nombre del equipo 2: ")
            resultado = input("Ingrese el resultado (Ej: 'Equipo1 ganó'): ")
            juego.registrar_partida(fecha, equipo1, equipo2, resultado)
            print("Partida registrada exitosamente.")
        elif opcion == "2":
            fecha_inicio = input("Ingrese la fecha de inicio (YYYY-MM-DD): ")
            fecha_fin = input("Ingrese la fecha de fin (YYYY-MM-DD): ")
            partidas = juego.consultar_partidas_rango(fecha_inicio, fecha_fin)
            if partidas:
                print("Partidas registradas:")
                for partida in partidas:
                    print(partida)
            else:
                print("No se encontraron partidas en el rango especificado.")
        elif opcion == "3":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

def menu_ranking_global(juego):
    print("\n*************************** Ranking Global ***************************")
    query = """
    SELECT NombreUsuario, Nivel
    FROM Jugadores
    ORDER BY Nivel DESC
    LIMIT 10
    """
    resultados = juego.db.fetch_results(query)
    if resultados:
        print("Top 10 Jugadores:")
        for jugador in resultados:
            print(f"{jugador['NombreUsuario']} - Nivel: {jugador['Nivel']}")
    else:
        print("No se encontraron jugadores.")

def menu_equipos_estadisticas(juego):
    print("\n*************************** Equipos y Estadísticas ***************************")
    query = """
    SELECT Equipo, COUNT(*) AS NumJugadores, AVG(Nivel) AS NivelPromedio
    FROM Jugadores
    GROUP BY Equipo
    """
    resultados = juego.db.fetch_results(query)
    if resultados:
        print("Estadísticas de equipos:")
        for equipo in resultados:
            print(f"Equipo: {equipo['Equipo']} - Jugadores: {equipo['NumJugadores']} - Nivel Promedio: {equipo['NivelPromedio']:.2f}")
    else:
        print("No se encontraron estadísticas de equipos.")

def menu_consultas_analisis(juego):
    print("\n*************************** Consultas y Análisis ***************************")
    print("Consulta personalizada sobre los datos del juego.")
    consulta = input("Ingrese una consulta SQL válida: ")
    try:
        resultados = juego.db.fetch_results(consulta)
        if resultados:
            for resultado in resultados:
                print(resultado)
        else:
            print("Sin resultados para la consulta.")
    except Error as e:
        print(f"Error en la consulta: {e}")

if __name__ == "__main__":
    menu_principal()
