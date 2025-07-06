# cli-cheatsheet

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20WSL-blue.svg)](https://en.wikipedia.org/wiki/Unix-like)

Интерактивная утилита для терминала — быстрая шпаргалка по командам.

## 🚀 Идея

Вызовите `cheat <тема>`, чтобы получить краткую и полезную шпаргалку по командам (bash, git, docker, vim, systemctl и др.).

## ✨ Функционал
- `cheat <тема>` — выводит текстовую шпаргалку по ключу
- **Расширенная поддержка тем**: `cheat git`, `cheat bash`, `cheat docker`, `cheat systemctl`, `cheat tmux`, `cheat htop`, `cheat curl`, `cheat ssh`, `cheat find`
- **Цветной вывод** (заголовки, команды, описания)
- **Автодополнение или вывод всех тем**: `cheat list`
- **Продвинутая функция поиска**: `cheat search <запрос>` с группировкой результатов по темам
- **Поддержка языков** (en/ru) с JSON-переводами
- **Поддержка тем** (светлая/тёмная)
- **Смена языка**: `cheat lang <язык>`
- **Система шаблонов** с подстановкой плейсхолдеров
- **Оптимизированная производительность** с эффективным поиском переводов

## 📊 Статус шпаргалок

| Утилита | 🇺🇸 English | 🇷🇺 Русский | 🇩🇪 Deutsch | 🇫🇷 Français | 🇪🇸 Español |
|---------|-------------|-------------|-------------|--------------|-------------|
| bash | ✅ | ✅ | ❌ | ❌ | ❌ |
| git | ✅ | ✅ | ❌ | ❌ | ❌ |
| docker | ✅ | ✅ | ❌ | ❌ | ❌ |
| vim | ✅ | ✅ | ❌ | ❌ | ❌ |
| systemctl | ✅ | ✅ | ❌ | ❌ | ❌ |
| tmux | ✅ | ✅ | ❌ | ❌ | ❌ |
| htop | ✅ | ✅ | ❌ | ❌ | ❌ |
| curl | ✅ | ✅ | ❌ | ❌ | ❌ |
| ssh | ✅ | ✅ | ❌ | ❌ | ❌ |
| find | ✅ | ✅ | ❌ | ❌ | ❌ |
| tar | ✅ | ✅ | ❌ | ❌ | ❌ |
| awk | ✅ | ✅ | ❌ | ❌ | ❌ |
| cron | ✅ | ✅ | ❌ | ❌ | ❌ |
| sed | ✅ | ✅ | ❌ | ❌ | ❌ |
| netstat | ✅ | ✅ | ❌ | ❌ | ❌ |
| lsof | 🔄 | 🔄 | ❌ | ❌ | ❌ |
| nmap | 🔄 | 🔄 | ❌ | ❌ | ❌ |
| ufw | 🔄 | 🔄 | ❌ | ❌ | ❌ |
| make | 🔄 | 🔄 | ❌ | ❌ | ❌ |
| package managers | 🔄 | 🔄 | ❌ | ❌ | ❌ |

**Условные обозначения:**
- ✅ Доступно - Полная шпаргалка с переводами
- ❌ Недоступно - Шпаргалка или переводы отсутствуют
- 🔄 В разработке - В настоящее время разрабатывается

## 📁 Структура проекта
```
cli-cheatsheet/
├── cheat.sh              # Основной скрипт
├── config.json           # Конфигурация
├── localizations/        # Файлы переводов по языкам
│   ├── en/              # Английские переводы
│   │   ├── bash.json    # Переводы для bash
│   │   ├── git.json     # Переводы для git
│   │   ├── docker.json  # Переводы для docker
│   │   ├── vim.json     # Переводы для vim
│   │   ├── systemctl.json # Переводы для systemctl
│   │   ├── tmux.json    # Переводы для tmux
│   │   ├── htop.json    # Переводы для htop
│   │   ├── curl.json    # Переводы для curl
│   │   ├── ssh.json     # Переводы для ssh
│   │   ├── find.json    # Переводы для find
│   │   ├── tar.json     # Переводы для tar
│   │   └── awk.json     # Переводы для awk
│   └── ru/              # Русские переводы
│       ├── bash.json    # Переводы для bash
│       ├── git.json     # Переводы для git
│       ├── docker.json  # Переводы для docker
│       ├── vim.json     # Переводы для vim
│       ├── systemctl.json # Переводы для systemctl
│       ├── tmux.json    # Переводы для tmux
│       ├── htop.json    # Переводы для htop
│       ├── curl.json    # Переводы для curl
│       ├── ssh.json     # Переводы для ssh
│       ├── find.json    # Переводы для find
│       ├── tar.json     # Переводы для tar
│       └── awk.json     # Переводы для awk
├── templates/            # Шаблоны шпаргалок
│   ├── bash.txt         # Шаблон bash
│   ├── git.txt          # Шаблон git
│   ├── docker.txt       # Шаблон docker
│   ├── vim.txt          # Шаблон vim
│   ├── systemctl.txt    # Шаблон systemctl
│   ├── tmux.txt         # Шаблон tmux
│   ├── htop.txt         # Шаблон htop
│   ├── curl.txt         # Шаблон curl
│   ├── ssh.txt          # Шаблон ssh
│   ├── find.txt         # Шаблон find
│   ├── tar.txt          # Шаблон tar
│   └── awk.txt          # Шаблон awk
└── docs/                # Документация
    └── ru/              # Русская документация
        └── README.md    # Русский README
```

## 🛠️ Установка

### Быстрая установка (Рекомендуется)
```bash
git clone https://github.com/mrvi0/cli-cheatsheet.git
cd cli-cheatsheet
sudo ln -s "$(pwd)/cheat.sh" /usr/local/bin/cheat
```

**После установки вы можете использовать команду `cheat` из любой директории в системе!**

### Ручная установка
```bash
git clone https://github.com/mrvi0/cli-cheatsheet.git
cd cli-cheatsheet
chmod +x cheat.sh
./cheat.sh <тема>
```

## 📸 Скриншоты

<div align="center">
  <img src="../images/help.png" alt="Команда Help" width="600"/>
  <p><em>Вывод команды help и инструкции по использованию</em></p>
</div>

<div align="center">
  <img src="../images/git.png" alt="Команды Git и смена языка" width="600"/>
  <p><em>Шпаргалка Git с примером смены языка</em></p>
</div>

<div align="center">
  <img src="../images/list.png" alt="Список тем" width="600"/>
  <p><em>Список доступных тем и утилит</em></p>
</div>

<div align="center">
  <img src="../images/search.png" alt="Функция поиска" width="600"/>
  <p><em>Продвинутый поиск по всем шпаргалкам</em></p>
</div>

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
  - awk
  - bash
  - cron
  - curl
  - docker
  - find
  - git
  - htop
  - sed
  - ssh
  - systemctl
  - tar
  - tmux
  - vim
```

### Поиск в шпаргалках
```bash
$ cheat search commit
Searching for: commit
---
git:
$ git commit -m "message"
> Зафиксировать изменения с сообщением

$ cheat search find
Searching for: find
---
find:
$ find . -name "filename"
> Найти файлы по точному имени

$ find . -type f -name "*.txt"
> Найти текстовые файлы
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

### Обновление утилиты
```bash
$ cheat update
Updating cli-cheatsheet...
Current branch: main
Fetching latest changes...
Found 3 new commit(s)
Pulling latest changes...
Successfully updated cli-cheatsheet!
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
  cheat update            Update to latest version
  cheat help              Show this help

Examples:
  cheat git               Show git cheat sheet
  cheat bash              Show bash cheat sheet
  cheat search commit     Search for 'commit' in all sheets
  cheat lang ru           Change language to Russian
  cheat lang en           Change language to English
  cheat update            Update to latest version
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
1. Создайте файл: `localizations/ваш_язык.json`
2. Добавьте переводы с ключами, соответствующими шаблонам
3. Используйте `cheat lang ваш_язык` для переключения

## 🎨 Цветовая схема
- **Заголовки** (`#`) - Голубые жирные
- **Команды** (`$`) - Зелёные
- **Описания** (`>`) - Жёлтые
- **Ошибки** - Красные
- **Результаты поиска** - Пурпурные

## 📝 Добавление новых тем

Создайте новый файл `templates/ваша_тема.txt`:
```
# {ваша_тема_title}

$ пример команды
> {описание_команды}

$ другая команда
> {другое_описание}
```

Затем добавьте переводы в `localizations/ru.json` и `localizations/en.json`:
```json
{
  "ваша_тема_title": "Шпаргалка по вашей теме",
  "описание_команды": "Описание того, что делает эта команда",
  "другое_описание": "Другое описание"
}
```

### Формат шаблона
- Используйте плейсхолдеры `{имя_ключа}` для переводов
- Команды начинаются с `$`
- Описания начинаются с `>`
- Заголовки начинаются с `#`
- Добавляйте пустые строки между командами для лучшей читаемости

## 📚 Документация

- [English Documentation](../README.md)
- [Russian Documentation](README.md) (current)
- [Changelog](../CHANGELOG.md) - Полная история версий

## 🤝 Участие в разработке

Мы приветствуем вклад в развитие проекта! Пожалуйста, ознакомьтесь с [CONTRIBUTING.md](CONTRIBUTING.md) для подробных руководств по участию в разработке этого проекта.

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](../LICENSE) для подробностей.

## 🙏 Благодарности

- Вдохновлён необходимостью быстрой справки по командам
- Построен на чистом bash для максимальной совместимости
- Поддержка цветов для лучшей читаемости 

$ cheat sed           # Шпаргалка по sed 