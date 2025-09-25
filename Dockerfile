# Etapa de build
FROM dart:stable AS build

WORKDIR /app

# Copiar pubspec y resolver dependencias en Linux
COPY pubspec.yaml ./
RUN dart pub get

# Copiar el resto del código
COPY . .

# Compilar a ejecutable nativo
RUN dart compile exe bin/server.dart -o bin/server

# Imagen final mínima
FROM debian:bullseye-slim
WORKDIR /app

# Copiar el ejecutable desde la etapa de build
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8080
CMD ["/app/bin/server"]
