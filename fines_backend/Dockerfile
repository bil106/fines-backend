# СТАДИЯ СБОРКИ
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
# Компилируем в файл 'server'
RUN dart compile exe bin/fines_backend.dart -o bin/server

# СТАДИЯ ЗАПУСКА
# Используем максимально легкий и совместимый образ
FROM debian:bookworm-slim

# Копируем только скомпилированный бинарник
# Мы создаем отдельную папку /app, чтобы не копировать в корень
WORKDIR /app
COPY --from=build /app/bin/server /app/bin/server

# Устанавливаем необходимые зависимости для работы сетевых запросов (SSL/TLS)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Даем права на выполнение
RUN chmod +x /app/bin/server

# Настройка порта
ENV PORT=8080
EXPOSE 8080

# Запуск
CMD ["/app/bin/server"]