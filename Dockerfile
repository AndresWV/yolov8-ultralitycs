# Usa una imagen base de NVIDIA con CUDA 11.6.1 y soporte de desarrollo
FROM nvidia/cuda:11.6.1-devel-ubuntu20.04 as cuda-base

# Establece la variable de entorno para CUDA
ENV PATH /usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Establece la variable de entorno para evitar preguntas interactivas durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias básicas
RUN apt-get update && apt-get install -y \
    python3-pip \
    curl \
    git \
    python3-dev \
    build-essential \
    libbz2-dev \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libsqlite3-dev \
    libreadline-dev \
    libffi-dev \
    liblzma-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala pyenv y Python 3.12.4
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN pyenv install 3.12.4 && pyenv global 3.12.4

# Actualiza pip y instala Poetry
RUN pip install --upgrade pip \
    && pip install poetry

# Copia tu pyproject.toml y poetry.lock al contenedor
COPY pyproject.toml poetry.lock ./

# Instala las dependencias sin crear un entorno virtual
RUN poetry config virtualenvs.create false && poetry install --no-root

# Copia el resto de tu aplicación al contenedor
COPY . .

# Ejecuta las tareas específicas de poe, si están definidas en pyproject.toml
RUN poetry run poe ultralitycs
RUN poetry run poe torch

# Expone el puerto necesario (ajusta según sea necesario)
EXPOSE 8000

# Configura el comando por defecto (ajusta según tu aplicación principal)
CMD ["poetry", "run", "python", "yolov8-ultralitycs/train.py"]
