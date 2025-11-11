# Imagen base
FROM python:3.12-slim

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias del sistema (opcional, útil para compilación)
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Copia requirements.txt desde la RAÍZ del repo
COPY requirements.txt ./requirements.txt

# Instala dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código de la RAÍZ del repo
COPY . .

# Expone el puerto que usa Flask
EXPOSE 8000

# Comando de arranque
CMD ["python", "main.py"]
