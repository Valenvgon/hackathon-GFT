#!/usr/bin/env python3
"""
api.py – Flask app para Cloud Run.
  • POST /ingest  → escribe en BigQuery macs
  • POST /macs  → escribe en BigQuery buscar postgres el mac y poner otro key de nombre de usuario
  • GET  / → health-check para Cloud Run Load-Balancer
"""

import os
from datetime import datetime
from flask import Flask, request, jsonify
from google.cloud import bigquery
from google.api_core.exceptions import BadRequest, Forbidden, NotFound


PROJECT_ID  = os.getenv("PROJECT_ID")               
DATASET_ID  = os.getenv("BQ_DATASET")                   
TABLE_ID    = os.getenv("BQ_TABLE")                     
BQ_LOCATION = os.getenv("BQ_LOCATION")            

if not (DATASET_ID and TABLE_ID):
    raise RuntimeError("Debes definir BQ_DATASET y BQ_TABLE en las variables de entorno")

# Cliente global reutilizable   (Cloud Run inyecta las credenciales de la service-account)
bq_client = bigquery.Client(project=PROJECT_ID, location=BQ_LOCATION)
table_ref = bq_client.dataset(DATASET_ID).table(TABLE_ID)


app = Flask(__name__)

@app.route("/", methods=["GET"])
def health_check():
    """Endpoint de vida para Cloud Run / LB 7."""
    return "ok", 200


@app.route("/ingest", methods=["POST"])
def ingest():
    """Recibe JSON y lo inserta como nueva fila en BigQuery."""
    if not request.is_json:
        return jsonify(error="Content-Type debe ser application/json"), 415
    
    payload = request.get_json(silent=True)
    if payload is None:
        return jsonify(error="JSON malformado"), 400


    row = payload.copy()
    row["ingest_timestamp"] = datetime.utcnow().isoformat(timespec="seconds")  # ISO 8601 UTC

    try:
        errors = bq_client.insert_rows_json(table_ref, [row])
        if errors:                                  # ← lista de dicts con errores
            raise BadRequest(str(errors))
    except (BadRequest, Forbidden, NotFound) as exc:
        # Devuelve detalles del fallo al emisor para depuración
        return jsonify(error=f"BigQuery insert error: {exc}"), 400

    return jsonify(status="success"), 202



if __name__ == "__main__":
    # No uses debug en producción; Gunicorn gestionará workers y puerto.
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 8080)))
