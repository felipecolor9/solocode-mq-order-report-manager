#!/bin/bash

# Configurações do RabbitMQ
RABBITMQ_USER="solocodelocal"
RABBITMQ_PASS="pass"
RABBITMQ_HOST="localhost"
RABBITMQ_PORT="15672"
RABBITMQ_VHOST="%2F"
RABBITMQ_EXCHANGE="amq.default"
RABBITMQ_ROUTING_KEY="my_queue"

# Caminho para o arquivo JSON
JSON_FILE="order_message.json"

# Verifica se o arquivo JSON existe
if [ ! -f "$JSON_FILE" ]; then
  echo "Arquivo $JSON_FILE não encontrado!"
  exit 1
fi

# Lê o conteúdo do arquivo JSON
MESSAGE=$(cat "$JSON_FILE")

# Envia a mensagem para o RabbitMQ
curl -i -u $RABBITMQ_USER:$RABBITMQ_PASS -H "Content-Type: application/json" \
-X POST -d "$MESSAGE" \
http://$RABBITMQ_HOST:$RABBITMQ_PORT/api/exchanges/$RABBITMQ_VHOST/$RABBITMQ_EXCHANGE/publish \
-d '{
  "properties":{},
  "routing_key":"'"$RABBITMQ_ROUTING_KEY"'",
  "payload":"'"$MESSAGE"'",
  "payload_encoding":"string"
}'
