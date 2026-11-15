FROM confluentinc/cp-kafka-connect:7.7.1

# Переключаемся на root для установки пакета
USER root

# Устанавливаем unzip через microdnf (пакетный менеджер UBI Minimal)
RUN microdnf install -y unzip && microdnf clean all

# Копируем скачанный архив в образ
COPY confluentinc-kafka-connect-jdbc-10.8.0.zip /tmp/

# Распаковываем архив в директорию плагинов
RUN mkdir -p /usr/share/confluent-hub-components && \
    unzip /tmp/confluentinc-kafka-connect-jdbc-10.8.0.zip -d /usr/share/confluent-hub-components/

ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"