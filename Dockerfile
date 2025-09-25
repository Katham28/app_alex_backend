# Imagen oficial de Dart
FROM dart:stable AS build
WORKDIR /app
# Copiar pubspec y resolver dependencias
COPY pubspec.* ./
RUN dart pub get
# Copiar el resto del código
COPY . .
# Compilar a ejecutable nativo
RUN dart compile exe bin/server.dart -o bin/server
# Imagen final más liviana
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
EXPOSE 8080
CMD ["/app/bin/server"]
