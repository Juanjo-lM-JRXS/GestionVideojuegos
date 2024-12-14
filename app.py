from flask import Flask, render_template, request, redirect, url_for
from mysql.connector import connect, Error
import json

app = Flask(__name__)

# Conexión a la base de datos
class DatabaseManager:
    def __init__(self, host, user, password, database):
        self.connection = None
        try:
            self.connection = connect(
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
        cursor = self.connection.cursor()
        cursor.execute(query, params)
        self.connection.commit()

# Crear instancia de DatabaseManager
db_manager = DatabaseManager(host="localhost", user="root", password="", database="VideojuegoMultijugador")

# Rutas de la aplicación web
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/gestion_jugadores')
def gestion_jugadores():
    return render_template('gestion_jugadores.html')

@app.route('/registrar_jugador', methods=['POST'])
def registrar_jugador():
    nombre = request.form['nombre']
    nivel = request.form['nivel']
    equipo = request.form['equipo']
    query = """
        INSERT INTO Jugadores (NombreUsuario, Nivel, Equipo, Inventario)
        VALUES (%s, %s, %s, '{}')
    """
    db_manager.execute_query(query, (nombre, nivel, equipo))
    return redirect(url_for('gestion_jugadores'))

@app.route('/gestion_mapas')
def gestion_mapas():
    return render_template('gestion_mapas.html')

@app.route('/crear_mapa', methods=['POST'])
def crear_mapa():
    nombre = request.form['nombre']
    query = """
        INSERT INTO Mundos (NombreMundo, GrafoSerializado)
        VALUES (%s, '{}')
    """
    db_manager.execute_query(query, (nombre,))
    return redirect(url_for('gestion_mapas'))

if __name__ == "__main__":
    app.run(debug=True)
