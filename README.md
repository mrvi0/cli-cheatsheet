# cli-cheatsheet

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20WSL-blue.svg)](https://en.wikipedia.org/wiki/Unix-like)

An interactive terminal utility for quick command reference.

<details>
<summary>🌍 Choose your language / Выберите язык</summary>

| Language | Documentation |
|----------|---------------|
| 🇺🇸 English | [README.md](README.md) (current) |
| 🇷🇺 Русский | [docs/ru/README.md](docs/ru/README.md) |

</details>

## 🚀 Idea

Call `cheat <topic>` to display a concise and useful cheat sheet for commands (bash, git, docker, vim, systemctl, etc.).

## ✨ Features
- `cheat <topic>` — shows a text cheat sheet by key
- Category support: `cheat git`, `cheat bash`, `cheat docker`
- Colorful output (headers, commands, examples)
- Autocompletion or list all topics: `cheat list`
- Search functionality: `cheat search <query>`
- Multi-language support (en/ru)
- Theme support (light/dark)
- Language switching: `cheat lang <language>`

## 📁 Structure
```
cli-cheatsheet/
├── cheat.sh              # Main script
├── config.json           # Configuration
├── localizations/        # Translation files
│   ├── en.json          # English translations
│   └── ru.json          # Russian translations
├── templates/            # Cheat sheet templates
│   ├── bash.txt         # Bash template
│   ├── git.txt          # Git template
│   ├── docker.txt       # Docker template
│   └── vim.txt          # Vim template
└── docs/                # Documentation
    └── README.ru.md     # Russian documentation
```

## 🛠️ Installation

### Quick Install (Recommended)
```bash
git clone https://github.com/yourname/cli-cheatsheet.git
cd cli-cheatsheet
sudo ln -s "$(pwd)/cheat.sh" /usr/local/bin/cheat
```

**After installation, you can use `cheat` command from anywhere in your system!**

### Manual Install
```bash
git clone https://github.com/yourname/cli-cheatsheet.git
cd cli-cheatsheet
chmod +x cheat.sh
./cheat.sh <topic>
```

## 📖 Usage Examples

### Show cheat sheet
```bash
$ cheat git
# Git Cheat Sheet

$ git status
> Show the working tree status

$ git add .
> Add all changes to staging

$ git commit -m "message"
> Commit changes with a message

$ git log
> Show commit logs
```

### List all topics
```bash
$ cheat list
Available topics:
  - bash
  - docker
  - git
  - vim
```

### Search in cheat sheets
```bash
$ cheat search commit
Searching for: commit
---
git:
$ git commit -m "message"
> Commit changes with a message
```

### Change language
```bash
$ cheat lang ru
Language changed to: ru

$ cheat git
# Git Шпаргалка

$ git status
> Показать статус рабочей директории
```

### Get help
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

## 🌍 Language Support

### Change Language via CLI
```bash
cheat lang ru    # Switch to Russian
cheat lang en    # Switch to English
```

### Change Language via Config
Edit `config.json`:
```json
{
  "lang": "ru",
  "theme": "dark"
}
```

### Add New Language
1. Create file: `localizations/your_lang.json`
2. Add translations with keys matching templates
3. Use `cheat lang your_lang` to switch

## 🎨 Color Scheme
- **Headers** (`#`) - Cyan bold
- **Commands** (`$`) - Green
- **Descriptions** (`>`) - Yellow
- **Errors** - Red
- **Search results** - Magenta

## 📝 Adding New Topics

Create a new file `templates/your_topic.txt`:
```
# {your_topic_title}

$ command example
> {command_description}

$ another command
> {another_description}
```

Then add translations to `localizations/en.json`:
```json
{
  "your_topic_title": "Your Topic Cheat Sheet",
  "command_description": "Description of what this command does",
  "another_description": "Another description"
}
```

## 📚 Documentation

- [English Documentation](README.md) (current)
- [Russian Documentation](docs/ru/README.md)

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to contribute to this project.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for quick command reference
- Built with pure bash for maximum compatibility
- Color support for better readability 