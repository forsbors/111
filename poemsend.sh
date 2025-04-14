#!/bin/bash

# Настройки
BOT_TOKEN="6358738990:AAEBRPzqmIy2O6iFV1-5W9W72wVmToHzpWo"
CHAT_ID="507394248"

# Стихи с корректными переносами строк
POEM1=$'🌸 Твои глаза – озёра чистоты,\nВ них тонет месяц, прячутся цветы.\nЛюблю без слов, люблю безмолвной тенью,\nМолюсь душой на их живое пенье. ❤️'
POEM2=$'🍁\nВолосы струятся чёрной ночью,\nЗвёзды в них запутались давно.\nМоя звезда, мое светило,\nТы освещаешь всё вокруг, как солнце в небесах. ✨'

# Функция для отправки сообщения через Telegram Bot API
send_message() {
    local text="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$text" \
        -d parse_mode="HTML"
}

# Отправка первого стиха
echo "Отправляю первый стих..."
send_message "$POEM1"
if [ $? -eq 0 ]; then
    echo "Первый стих успешно отправлен!"
else
    echo "Ошибка при отправке первого стиха."
fi

# Ожидание 5 минут (300 секунд)
echo "Ожидаю 5 минут перед отправкой второго стиха..."
sleep 300

# Отправка второго стиха
echo "Отправляю второй стих..."
send_message "$POEM2"
if [ $? -eq 0 ]; then
    echo "Второй стих успешно отправлен!"
else
    echo "Ошибка при отправке второго стиха."
fi

echo "Скрипт завершил работу."
