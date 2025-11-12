# Imagen base
FROM python:3.12-slim

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Dependencias del sistema mínimas
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates && rm -rf /var/lib/apt/lists/*

# Copia el requirements desde app/ del host al contenedor
COPY app/requirements.txt ./requirements.txt

# Instala dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la carpeta app/ al contenedor
COPY app/ .

# Expone el puerto de Flask
EXPOSE 8000

# Comando de arranque
CMD ["python", "main.py"]

