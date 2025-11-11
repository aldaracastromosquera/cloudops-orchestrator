from flask import Flask, jsonify, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQ = Counter("http_requests_total", "Total HTTP requests", ["path"])

@app.route("/")
def root():
    REQ.labels("/").inc()
    return "CloudOps Orchestrator: OK\n", 200

@app.route("/health")
def health():
    REQ.labels("/health").inc()
    return jsonify(status="ok")

@app.route("/metrics")
def metrics():
    REQ.labels("/metrics").inc()
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
