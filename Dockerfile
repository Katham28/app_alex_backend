# Etapa de build
FROM dart:stable AS build

WORKDIR /app

# Copiar pubspec.* primero (para aprovechar cache de Docker)
COPY pubspec.* ./

# Instalar dependencias dentro del contenedor
RUN dart pub get

# Copiar el resto del proyecto (sin .dart_tool ni .pub-cache gracias al .dockerignore)
COPY . .

# Compilar a ejecutable nativo
RUN dart compile exe bin/server.dart -o bin/server

# Imagen final liviana
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

CMD ["/app/bin/server"]
