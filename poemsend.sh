#!/bin/bash

# Настройки
BOT_TOKEN="6358738990:AAEBRPzqmIy2O6iFV1-5W9W72wVmToHzpWo"
CHAT_ID="507394248"

# Стихи с корректными переносами строк (%0A для Telegram)
POEMS=(
    "🌸 Твои глаза – озёра чистоты,%0AВ них тонет месяц, прячутся цветы.%0AЛюблю... ❤️"
    "🍁%0AВолосы струятся чёрной ночью,%0AЗвёзды в них запутались давно.%0AМоя звезда... ✨"
    "🌸%0AТвой смех — как утренняя роса,%0AИскрится на лепестках цветов.%0AТы — бриллиант рассвета... 💎"
    "Солнце встаёт вновь,%0AТепло твоих рук рядом,%0AСчастье — быть с тобой. ☀️"
    "🍁%0AУлыбка твоя — осенний закат,%0AРаскрашивает небо в теплые тона.%0AТы — живое пламя красоты... 🔥"
    "🌸%0AТень твоя — как танец облаков,%0AПлывёт легко среди забот.%0AМой воздух... ☁️"
    "Ты гладишь щенка —%0AВ его глазах отражается%0AМоя зависть. 🐶💕"
    "Ночь укроет нас,%0AЗвезды шепчут о любви,%0AТы — моя мечта. 🌌"
    "🌙%0AКожа светится жемчужным блеском,%0AОтражает лунный свет в ночи.%0AТы — само совершенство... 💝"
    "Утро. Ты спишь так,%0AЧто даже солнце встаёт%0AНа цыпочках тихо. 🌄"
    "Ты одеваешься, чуть склонившись,%0AЯ любуюсь на черты...%0AБоже, как же это чудно -%0AВидеть ангела мечты! 😇"
)

# Функция для отправки сообщения через Telegram Bot API
send_message() {
    local text="$1"
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$text" \
        -d parse_mode="HTML"
}

# Отправка всех стихов с интервалом в 5 минут
for poem in "${POEMS[@]}"; do
    echo "Отправляю стих..."
    send_message "$poem"
    if [ $? -eq 0 ]; then
        echo "Строк успешно отправлен!"
    else
        echo "Ошибка при отправке стиха."
    fi

    # Ожидание 5 минут (300 секунд) перед отправкой следующего стиха
    echo "Ожидаю 5 минут перед отправкой следующего стиха..."
    sleep 300
done

echo "Скрипт завершил работу."
