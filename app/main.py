from flask import Flask, jsonify
from os import getenv
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUESTS = Counter('app_requests_total', 'Total de peticiones', ['endpoint'])

@app.route('/')
def index():
    REQUESTS.labels('/').inc()
    app_name = getenv('APP_NAME', 'CloudOps Orchestrator')
    return jsonify({
        'message': f'Hola desde {app_name}!',
        'db_host': getenv('DB_HOST', 'db'),
    })

@app.route('/health')
def health():
    REQUESTS.labels('/health').inc()
    return jsonify({'status': 'ok'})

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
