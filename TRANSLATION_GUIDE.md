# Translation Guide

This guide explains how to add new languages and translate content for cli-cheatsheet.

## 🌍 Language Selection

<details>
<summary>Choose your language / Выберите язык</summary>

| Language | Documentation |
|----------|---------------|
| 🇺🇸 English | [TRANSLATION_GUIDE.md](TRANSLATION_GUIDE.md) (current) |
| 🇷🇺 Русский | [docs/ru/TRANSLATION_GUIDE.md](docs/ru/TRANSLATION_GUIDE.md) |

</details>

## 📋 Table of Contents

- [Overview](#overview)
- [Adding a New Language](#adding-a-new-language)
- [Translation Process](#translation-process)
- [Translation Guidelines](#translation-guidelines)
- [Testing Translations](#testing-translations)
- [Common Issues](#common-issues)
- [Examples](#examples)

## 🎯 Overview

cli-cheatsheet uses a modular translation system with JSON files organized by utility. Each language has its own directory containing translation files for each supported utility.

### File Structure
```
localizations/
├── en/                    # English (base language)
│   ├── git.json          # Git translations
│   ├── docker.json       # Docker translations
│   ├── vim.json          # Vim translations
│   └── ...               # Other utilities
├── ru/                    # Russian
│   ├── git.json          # Git translations
│   ├── docker.json       # Docker translations
│   ├── vim.json          # Vim translations
│   └── ...               # Other utilities
└── your_lang/            # Your new language
    ├── git.json          # Git translations
    ├── docker.json       # Docker translations
    ├── vim.json          # Vim translations
    └── ...               # Other utilities
```

### Template System
Templates use a simple substitution system with `[[key]]` placeholders:
```
# [[git_title]]

$ git status
> [[git_status_description]]
```

## 🚀 Adding a New Language

### Step 1: Create Language Directory
Create a new directory in `localizations/`:

```bash
mkdir localizations/your_lang
```

### Step 2: Copy Translation Files
Copy all JSON files from `localizations/en/` to your new directory:

```bash
cp localizations/en/*.json localizations/your_lang/
```

### Step 3: Translate Values
For each utility file (e.g., `git.json`, `docker.json`), translate the values while keeping the keys unchanged:

```json
{
  "git_title": "Git Spickzettel",
  "git_status_description": "Status des Arbeitsverzeichnisses anzeigen",
  "git_add_description": "Alle Änderungen zum Staging hinzufügen"
}
```

### Step 4: Test Your Language
```bash
./cheat.sh lang your_lang
./cheat.sh list
./cheat.sh git
```

### Step 5: Update Documentation
1. Add your language to the language selector in `README.md`
2. Create translated documentation in `docs/`

## 📝 Translation Process

### 1. Understand the Context
- **Titles**: Used as headers in cheat sheets (e.g., `git_title`)
- **Descriptions**: Explain what commands do (e.g., `git_status_description`)
- **Commands**: Usually kept in English (technical terms)

### 2. Translation Priority
1. **High Priority**: Titles and descriptions
2. **Medium Priority**: Error messages and help text
3. **Low Priority**: Technical terms (can remain in English)

### 3. Consistency
- Use consistent terminology throughout all utility files
- Maintain the same tone and style across translations
- Keep translations concise but clear

## 📏 Translation Guidelines

### General Rules
- **Keep keys unchanged** - only translate values
- **Use proper grammar** - maintain sentence structure
- **Be consistent** - use the same terms for similar concepts across utilities
- **Keep it concise** - avoid overly long descriptions

### Technical Terms
- **Commands**: Usually kept in English (e.g., `git`, `docker`, `vim`)
- **File extensions**: Keep as is (e.g., `.txt`, `.json`)
- **Paths**: Keep as is (e.g., `/usr/local/bin`)
- **Flags and options**: Keep as is (e.g., `-m`, `--help`)

### Cultural Considerations
- **Date formats**: Use local conventions if mentioned
- **Number formats**: Use local conventions if needed
- **Examples**: Adapt to local context when appropriate

### JSON Formatting
```json
{
  "key_name": "Translation value",
  "another_key": "Another translation"
}
```

- Use 2-space indentation
- Sort keys alphabetically within each file
- Use descriptive key names
- Keep values on single lines when possible

## 🧪 Testing Translations

### Basic Testing
```bash
# Switch to your language
./cheat.sh lang your_lang

# Test all utilities
./cheat.sh bash
./cheat.sh git
./cheat.sh docker
./cheat.sh vim
./cheat.sh curl
./cheat.sh find
./cheat.sh awk
./cheat.sh tmux
./cheat.sh ssh
./cheat.sh systemctl
./cheat.sh tar
./cheat.sh htop

# Test search functionality
./cheat.sh search test

# Test help
./cheat.sh help
```

### Validation Checklist
- [ ] All utilities display correctly
- [ ] No missing translations (shows `{key}`)
- [ ] Text fits well in terminal
- [ ] No broken characters or encoding issues
- [ ] Search works with translated content
- [ ] All utility files are translated

## ⚠️ Common Issues

### Missing Translations
If you see `{key_name}` in output, the translation is missing:
```json
{
  "missing_key": "Add this translation"
}
```

### Missing Utility Files
If a utility doesn't work, check if the translation file exists:
```bash
ls localizations/your_lang/
```

### Encoding Issues
- Use UTF-8 encoding for all files
- Test with different terminal encodings
- Avoid special characters that might not display properly

### Long Translations
If translations are too long for terminal display:
- Make them more concise
- Use abbreviations where appropriate
- Consider breaking into multiple lines if needed

### Inconsistent Terminology
- Use a glossary of common terms
- Review all translations for consistency
- Ask native speakers to review

## 📚 Examples

### Good Translation (German)
```json
{
  "git_title": "Git Spickzettel",
  "git_status_description": "Status des Arbeitsverzeichnisses anzeigen",
  "git_add_description": "Alle Änderungen zum Staging hinzufügen",
  "git_commit_description": "Änderungen mit Nachricht committen"
}
```

### Bad Translation
```json
{
  "git_status_description": "This command shows the current status of your git repository working tree and staging area with detailed information about tracked and untracked files",
  "git_add_description": "Add all the changes that you have made to the files in your working directory to the staging area for the next commit"
}
```

### Complete Example Structure
```
localizations/de/
├── git.json          # Git translations
├── docker.json       # Docker translations
├── vim.json          # Vim translations
├── bash.json         # Bash translations
├── curl.json         # cURL translations
├── find.json         # Find translations
├── awk.json          # AWK translations
├── tmux.json         # Tmux translations
├── ssh.json          # SSH translations
├── systemctl.json    # Systemctl translations
├── tar.json          # Tar translations
└── htop.json         # htop translations
```

## 🔧 Utility-Specific Guidelines

### Git Translations
- Keep command names in English
- Translate descriptions to be clear and concise
- Use consistent terminology for Git concepts

### Docker Translations
- Keep Docker-specific terms in English when appropriate
- Translate descriptions to explain container concepts clearly

### Vim Translations
- Keep Vim modes and commands in English
- Translate descriptions to explain what each command does

### Bash Translations
- Keep shell syntax in English
- Translate descriptions to explain shell concepts

## 🤝 Getting Help

- **Issues**: Create an issue for translation problems
- **Discussions**: Use GitHub Discussions for questions
- **Review**: Ask native speakers to review your translations

## 🙏 Thank You

Thank you for helping make cli-cheatsheet available in more languages! Your contributions help users around the world. 