# Flask para crear la API web
from flask import Flask, jsonify
# getenv para leer variables de entorno
from os import getenv
# prometheus_client permite crear métricas para monitorizar la app
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST


# ------------------------------------------------------------
# Inicialización de la aplicación Flask
# ------------------------------------------------------------
app = Flask(__name__)


# ------------------------------------------------------------
# Métrica Prometheus: contador de peticiones
# ------------------------------------------------------------
# Creamos un contador llamado 'app_requests_total' con una etiqueta 'endpoint'
# que registrará cuántas veces se llama a cada ruta (/ , /health, /metrics)
REQUESTS = Counter('app_requests_total', 'Total de peticiones', ['endpoint'])


# ------------------------------------------------------------
# Endpoint principal "/"
# ------------------------------------------------------------
@app.route('/')
def index():
    # Incrementamos el contador de métricas para esta ruta
    REQUESTS.labels('/').inc()
    # Leemos el nombre de la app desde las variables de entorno
    # Si no existe, usamos un valor por defecto
    app_name = getenv('APP_NAME', 'CloudOps Orchestrator')
    # Devolvemos una respuesta JSON con el mensaje y el host de la base de datos
    return jsonify({
        'message': f'Hola desde {app_name}!',
        'db_host': getenv('DB_HOST', 'db'),
    })


# ------------------------------------------------------------
# Endpoint "/health" - para comprobar si la app está viva
# ------------------------------------------------------------
@app.route('/health')
def health():
    # Incrementamos el contador de métricas también aquí
    REQUESTS.labels('/health').inc()
    # Devolvemos una respuesta simple con estado "ok"
    return jsonify({'status': 'ok'})


# ------------------------------------------------------------
# Endpoint "/metrics" - para Prometheus
# ------------------------------------------------------------
@app.route('/metrics')
def metrics():
    # Devuelve todas las métricas recolectadas en formato Prometheus
    # CONTENT_TYPE_LATEST define el tipo de contenido correcto (texto plano)    
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}


# ------------------------------------------------------------
# Punto de entrada principal
# ------------------------------------------------------------
if __name__ == '__main__':
    # Inicia el servidor Flask escuchando en todas las interfaces (0.0.0.0) con puerto 8000 para que coincida con la configuración de Docker
    app.run(host='0.0.0.0', port=8000)

