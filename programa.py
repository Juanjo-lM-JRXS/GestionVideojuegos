import mysql.connector
from mysql.connector import Error
import json
import heapq

# Clase para gestionar la conexión a la base de datos
class DatabaseManager:
    def __init__(self, host, user, password, database):
        self.connection = None
        try:
            self.connection = mysql.connector.connect(
                host="127.0.0.1",
                user="root",
                password="",
                database="videojuegomultijugador"
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

# Clase para representar el Grafo
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

# Clase para representar el Árbol Binario de Búsqueda
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

# Clase principal para la gestión del juego
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

    def registrar_partida(self, fecha, equipo1, equipo2, resultado):
        query = "CALL RegistrarPartida(%s, %s, %s, %s)"
        self.db.execute_query(query, (equipo1, equipo2, resultado, fecha))
        self.arbol_partidas.insertar(fecha, {"equipo1": equipo1, "equipo2": equipo2, "resultado": resultado})

# Menú principal
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
            print("Gestión de Inventarios: Opciones no implementadas aún.")
        elif opcion == "4":
            print("Sistema de Batallas y Partidas: Opciones no implementadas aún.")
        elif opcion == "5":
            print("Ranking Global: Opciones no implementadas aún.")
        elif opcion == "6":
            print("Equipos y Estadísticas: Opciones no implementadas aún.")
        elif opcion == "7":
            print("Consultas y Análisis: Opciones no implementadas aún.")
        elif opcion == "8":
            print("Saliendo del programa.")
            break
        else:
            print("Opción no válida. Intente de nuevo.")

# Menú de gestión de jugadores
def menu_gestion_jugadores(juego):
    while True:
        print("\n*************************** Gestión de Jugadores ***************************")
        print("1) Registrar nuevo jugador")
        print("2) Modificar datos de jugador")
        print("3) Eliminar jugador")
        print("4) Consultar datos de jugador")
        print("5) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            nombre = input("Ingrese el nombre de usuario: ")
            nivel = int(input("Ingrese el nivel del jugador: "))
            equipo = input("Ingrese el equipo del jugador: ")
            juego.registrar_jugador(nombre, nivel, equipo)
            print("Jugador registrado exitosamente.")
        elif opcion == "2":
            print("Funcionalidad no implementada aún.")
        elif opcion == "3":
            print("Funcionalidad no implementada aún.")
        elif opcion == "4":
            print("Funcionalidad no implementada aún.")
        elif opcion == "5":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

# Menú de gestión de mapas
def menu_gestion_mapas(juego):
    while True:
        print("\n*************************** Gestión de Mapas ***************************")
        print("1) Crear nuevo mapa")
        print("2) Agregar conexión a un mapa")
        print("3) Consultar rutas óptimas")
        print("4) Volver al menú principal")
        opcion = input("Ingrese una opción válida: ")

        if opcion == "1":
            nombre = input("Ingrese el nombre del mundo: ")
            juego.crear_mundo(nombre)
            print("Mapa creado exitosamente.")
        elif opcion == "2":
            nombre = input("Ingrese el nombre del mundo: ")
            origen = input("Ingrese el nodo de origen: ")
            destino = input("Ingrese el nodo de destino: ")
            peso = int(input("Ingrese el peso de la conexión: "))
            juego.agregar_conexion_mundo(nombre, origen, destino, peso)
            print("Conexión agregada exitosamente.")
        elif opcion == "3":
            print("Funcionalidad no implementada aún.")
        elif opcion == "4":
            break
        else:
            print("Opción no válida. Intente de nuevo.")

if __name__ == "__main__":
    menu_principal()