# cli-cheatsheet

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20WSL-blue.svg)](https://en.wikipedia.org/wiki/Unix-like)

Интерактивная утилита для терминала — быстрая шпаргалка по командам.

## 🚀 Идея

Вызовите `cheat <тема>`, чтобы получить краткую и полезную шпаргалку по командам (bash, git, docker, vim, systemctl и др.).

## ✨ Функционал
- `cheat <тема>` — выводит текстовую шпаргалку по ключу
- Поддержка категорий: `cheat git`, `cheat bash`, `cheat docker`
- Цветной вывод (заголовки, команды, примеры)
- Автодополнение или вывод всех тем: `cheat list`
- Функция поиска: `cheat search <запрос>`
- Поддержка языков (en/ru)
- Поддержка тем (светлая/тёмная)
- Смена языка: `cheat lang <язык>`

## 📁 Структура
```
cheats/
├── en/
│   ├── bash.txt
│   ├── git.txt
│   └── docker.txt
└── ru/
    ├── bash.txt
    ├── git.txt
    └── docker.txt
cheat.sh
config.json
```

## 🛠️ Установка

### Быстрая установка (Рекомендуется)
```bash
git clone https://github.com/yourname/cli-cheatsheet.git
cd cli-cheatsheet
sudo ln -s "$(pwd)/cheat.sh" /usr/local/bin/cheat
```

**После установки вы можете использовать команду `cheat` из любой директории в системе!**

### Ручная установка
```bash
git clone https://github.com/yourname/cli-cheatsheet.git
cd cli-cheatsheet
chmod +x cheat.sh
./cheat.sh <тема>
```

## 📖 Примеры использования

### Показать шпаргалку
```bash
$ cheat git
# Git Шпаргалка

$ git status
> Показать статус рабочей директории

$ git add .
> Добавить все изменения в индекс

$ git commit -m "message"
> Зафиксировать изменения с сообщением

$ git log
> Показать журнал коммитов
```

### Список всех тем
```bash
$ cheat list
Available topics:
  - bash
  - docker
  - git
```

### Поиск в шпаргалках
```bash
$ cheat search commit
Searching for: commit
---
git:
$ git commit -m "message"
> Зафиксировать изменения с сообщением
```

### Смена языка
```bash
$ cheat lang en
Language changed to: en

$ cheat git
# Git Cheat Sheet

$ git status
> Show the working tree status
```

### Получить справку
```bash
$ cheat help
cli-cheatsheet - Interactive terminal utility

Usage:
  cheat <topic>           Show cheat sheet for topic
  cheat list              List all available topics
  cheat search <query>    Search in all cheat sheets
  cheat lang <language>   Change language (en/ru)
  cheat help              Show this help

Examples:
  cheat git               Show git cheat sheet
  cheat bash              Show bash cheat sheet
  cheat search commit     Search for 'commit' in all sheets
  cheat lang ru           Change language to Russian
  cheat lang en           Change language to English
```

## 🌍 Поддержка языков

### Смена языка через CLI
```bash
cheat lang ru    # Переключиться на русский
cheat lang en    # Переключиться на английский
```

### Смена языка через конфигурацию
Отредактируйте `config.json`:
```json
{
  "lang": "ru",
  "theme": "dark"
}
```

### Добавить новый язык
1. Создайте директорию: `cheats/ваш_язык/`
2. Добавьте файлы `.txt` с контентом на вашем языке
3. Используйте `cheat lang ваш_язык` для переключения

## 🎨 Цветовая схема
- **Заголовки** (`#`) - Голубые жирные
- **Команды** (`$`) - Зелёные
- **Описания** (`>`) - Жёлтые
- **Ошибки** - Красные
- **Результаты поиска** - Пурпурные

## 📝 Добавление новых тем

Создайте новый файл `cheats/ru/ваша_тема.txt`:
```
# Шпаргалка по вашей теме

$ пример команды
> Описание того, что делает эта команда

$ другая команда
> Другое описание
```

## 🤝 Участие в разработке

1. Форкните репозиторий
2. Создайте ветку для функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'feat: add amazing feature'`)
4. Отправьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для подробностей.

## 🙏 Благодарности

- Вдохновлён необходимостью быстрой справки по командам
- Построен на чистом bash для максимальной совместимости
- Поддержка цветов для лучшей читаемости 