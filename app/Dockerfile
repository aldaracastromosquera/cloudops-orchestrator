# Imagen base ligera de Python
FROM python:3.12-slim


# Evitar bytecode y buffering
ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PIP_DISABLE_PIP_VERSION_CHECK=on \
PIP_NO_CACHE_DIR=on


WORKDIR /app


# Dependencias del sistema mínimas
RUN apt-get update -y && apt-get install -y --no-install-recommends \
ca-certificates && rm -rf /var/lib/apt/lists/*


COPY app/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt


COPY app/ .


EXPOSE 8000
CMD ["python", "main.py"]