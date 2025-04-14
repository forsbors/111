#!/bin/bash

# Настройки
BOT_TOKEN="6358738990:AAEBRPzqmIy2O6iFV1-5W9W72wVmToHzpWo"
CHAT_ID="507394248"

# Стихи
POEM1="🌸 Твои глаза – озёра чистоты,\nВ них тонет месяц, прячутся цветы.\nЛюблю... ❤️"
POEM2="🍁\nВолосы струятся чёрной ночью,\nЗвёзды в них запутались давно.\nМоя звезда... ✨"

# Функция для отправки сообщения через Telegram Bot API
send_message() {
    local text="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$text" \
        -d parse_mode="HTML"
}

# Отправка первого стиха
send_message "$POEM1"

# Ожидание 5 минут (300 секунд)
sleep 300

# Отправка второго стиха
send_message "$POEM2"
