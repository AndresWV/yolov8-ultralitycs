# Use the ultralytics image as the base image
FROM ultralytics/ultralytics:latest

# Instala Poetry
RUN pip install poetry

# Copia tu pyproject.toml y poetry.lock al contenedor
COPY pyproject.toml poetry.lock ./

# Instala las dependencias (incluyendo poethepoet)
RUN poetry install --no-root

# Copia el resto de tu aplicación al contenedor
COPY . .

# Ejecuta la tarea para correr el contenedor con todas las GPUs
RUN poetry run poe docker_run_all_gpus

# (Opcional) Ejecuta la tarea para correr el contenedor con GPUs específicas
# RUN poetry run poe docker_run_specific_gpus

# Configura el comando por defecto (puede ser tu aplicación principal)
CMD ["poetry", "run", "tu-comando-principal"]

