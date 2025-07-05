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

cli-cheatsheet uses a centralized translation system with JSON files. Each language has its own translation file containing all the text used in the application.

### File Structure
```
localizations/
├── en.json          # English (base language)
├── ru.json          # Russian
└── your_lang.json   # Your new language
```

## 🚀 Adding a New Language

### Step 1: Create Translation File
Create a new JSON file in the `localizations/` directory:

```bash
touch localizations/your_lang.json
```

### Step 2: Copy Base Translations
Copy all keys from `localizations/en.json` to your new file:

```json
{
  "bash_title": "",
  "git_title": "",
  "docker_title": "",
  "vim_title": "",
  "ls_description": "",
  "cd_description": "",
  "grep_description": "",
  "cat_description": "",
  "git_status_description": "",
  "git_add_description": "",
  "git_commit_description": "",
  "git_log_description": "",
  "git_push_description": "",
  "git_pull_description": "",
  "docker_ps_description": "",
  "docker_images_description": "",
  "docker_run_description": "",
  "docker_build_description": "",
  "vim_open_description": "",
  "vim_save_description": "",
  "vim_quit_description": "",
  "vim_save_quit_description": "",
  "vim_insert_description": "",
  "vim_exit_insert_description": "",
  "vim_delete_line_description": "",
  "vim_copy_line_description": "",
  "vim_paste_description": ""
}
```

### Step 3: Translate Values
Fill in the empty strings with your translations. Keep the keys unchanged!

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
- **Titles**: Used as headers in cheat sheets
- **Descriptions**: Explain what commands do
- **Commands**: Usually kept in English (technical terms)

### 2. Translation Priority
1. **High Priority**: Titles and descriptions
2. **Medium Priority**: Error messages and help text
3. **Low Priority**: Technical terms (can remain in English)

### 3. Consistency
- Use consistent terminology throughout
- Maintain the same tone and style
- Keep translations concise but clear

## 📏 Translation Guidelines

### General Rules
- **Keep keys unchanged** - only translate values
- **Use proper grammar** - maintain sentence structure
- **Be consistent** - use the same terms for similar concepts
- **Keep it concise** - avoid overly long descriptions

### Technical Terms
- **Commands**: Usually kept in English (e.g., `git`, `docker`)
- **File extensions**: Keep as is (e.g., `.txt`, `.json`)
- **Paths**: Keep as is (e.g., `/usr/local/bin`)

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
- Sort keys alphabetically
- Use descriptive key names
- Keep values on single lines when possible

## 🧪 Testing Translations

### Basic Testing
```bash
# Switch to your language
./cheat.sh lang your_lang

# Test all topics
./cheat.sh bash
./cheat.sh git
./cheat.sh docker
./cheat.sh vim

# Test search functionality
./cheat.sh search test

# Test help
./cheat.sh help
```

### Validation Checklist
- [ ] All topics display correctly
- [ ] No missing translations (shows `{key}`)
- [ ] Text fits well in terminal
- [ ] No broken characters or encoding issues
- [ ] Search works with translated content

## ⚠️ Common Issues

### Missing Translations
If you see `{key_name}` in output, the translation is missing:
```json
{
  "missing_key": "Add this translation"
}
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

### Good Translation
```json
{
  "git_status_description": "Show the working tree status",
  "git_add_description": "Add all changes to staging"
}
```

### Bad Translation
```json
{
  "git_status_description": "This command shows the current status of your git repository working tree and staging area",
  "git_add_description": "Add all the changes that you have made to the files in your working directory to the staging area"
}
```

### Complete Example (German)
```json
{
  "bash_title": "Bash Spickzettel",
  "git_title": "Git Spickzettel",
  "docker_title": "Docker Spickzettel",
  "vim_title": "Vim Spickzettel",
  "ls_description": "Dateien im Langformat anzeigen",
  "cd_description": "Verzeichnis wechseln",
  "grep_description": "Nach Muster in Datei suchen",
  "cat_description": "Dateiinhalt anzeigen",
  "git_status_description": "Status des Arbeitsverzeichnisses anzeigen",
  "git_add_description": "Alle Änderungen zum Staging hinzufügen",
  "git_commit_description": "Änderungen mit Nachricht committen",
  "git_log_description": "Commit-Protokoll anzeigen",
  "git_push_description": "Änderungen zum Remote-Repository pushen",
  "git_pull_description": "Änderungen vom Remote-Repository pullen"
}
```

## 🤝 Getting Help

- **Issues**: Create an issue for translation problems
- **Discussions**: Use GitHub Discussions for questions
- **Review**: Ask native speakers to review your translations

## 🙏 Thank You

Thank you for helping make cli-cheatsheet available in more languages! Your contributions help users around the world. 