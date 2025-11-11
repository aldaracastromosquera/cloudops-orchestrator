# Imagen base ligera de Python
FROM python:3.12-slim


# ------------------------------------------------------------
# Variables de entorno globales : Reglas para que Python funcione sin generar archivos temporales y con logs visibles
# ------------------------------------------------------------
# Evita generar archivos .pyc (bytecode innecesario)
ENV PYTHONDONTWRITEBYTECODE=1 \ 
# Muestra logs en tiempo real (sin buffering)        
    PYTHONUNBUFFERED=1 \          
# Desactiva la comprobación de versión de pip          
    PIP_DISABLE_PIP_VERSION_CHECK=on \
# Evita guardar caché para reducir el tamaño de la imagen
    PIP_NO_CACHE_DIR=on


# ------------------------------------------------------------
# Establece el directorio de trabajo dentro del contenedor
# ------------------------------------------------------------
WORKDIR /app

# ------------------------------------------------------------
# Instala dependencias del sistema mínimas
# ------------------------------------------------------------
# - Actualiza el índice de paquetes
# - Instala certificados raíz (necesarios para HTTPS, pip, etc.)
# - Limpia la caché de apt para mantener la imagen ligera
RUN apt-get update -y && apt-get install -y --no-install-recommends \
ca-certificates && rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------
# Instala dependencias de Python
# ------------------------------------------------------------
# Copia el archivo requirements.txt dentro del contenedor
COPY app/requirements.txt ./requirements.txt
# Instala las librerías necesarias para la app
RUN pip install -r requirements.txt

# ------------------------------------------------------------
# Copia el código fuente de la aplicación
# ------------------------------------------------------------
# Copia todo el contenido de la carpeta app/ desde el host hacia el directorio /app dentro del contenedor
COPY app/ .

# ------------------------------------------------------------
# Expone el puerto por donde escuchará la aplicación Flask
# ------------------------------------------------------------
EXPOSE 8000


# ------------------------------------------------------------
# Comando de inicio del contenedor
# ------------------------------------------------------------
# Ejecuta la aplicación usando Python
# Flask escuchará en 0.0.0.0:8000 según el main.py
CMD ["python", "main.py"]