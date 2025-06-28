# ---------- Etapa de runtime ----------
FROM python:3.12-slim AS runtime

# Evita que Python escriba .pyc y asegura logs en STDOUT.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Instala dependencias de sistema mínimas (libpq-dev por si usas Postgres).
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Crea un usuario no-root y carpeta de trabajo.
RUN useradd -m appuser
WORKDIR /app
COPY --chown=appuser:appuser requirements.txt ./

# Instala libs de Python sin caché.
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copia el código fuente.
COPY --chown=appuser:appuser api.py ./

USER appuser

# Expone el puerto que Cloud Run inyectará en $PORT (por defecto 8080).
EXPOSE 8080
CMD ["gunicorn", "-b", "0.0.0.0:${PORT:-8080}", "api:app"]
