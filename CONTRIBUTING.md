# Contributing to cli-cheatsheet

Thank you for your interest in contributing to cli-cheatsheet! This document provides guidelines and information for contributors.

## 🌍 Language Selection

<details>
<summary>Choose your language / Выберите язык</summary>

| Language | Documentation |
|----------|---------------|
| 🇺🇸 English | [CONTRIBUTING.md](CONTRIBUTING.md) (current) |
| 🇷🇺 Русский | [docs/ru/CONTRIBUTING.md](docs/ru/CONTRIBUTING.md) |

</details>

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Adding New Topics](#adding-new-topics)
- [Adding New Languages](#adding-new-languages)
- [Code Style](#code-style)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Translation Guide](#translation-guide)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## 🚀 How Can I Contribute?

### Reporting Bugs
- Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md)
- Provide detailed information about your environment
- Include steps to reproduce the issue

### Suggesting Enhancements
- Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md)
- Describe the problem and proposed solution
- Consider the impact on existing functionality

### Adding New Topics
- Follow the [Adding New Topics](#adding-new-topics) guide
- Ensure translations are provided for all supported languages
- Test your changes thoroughly

### Adding New Languages
- Follow the [Translation Guide](TRANSLATION_GUIDE.md)
- Create translation files for all existing topics
- Update documentation

## 🛠️ Development Setup

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/cli-cheatsheet.git
   cd cli-cheatsheet
   ```

2. **Create a virtual environment** (optional but recommended)
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   # No external dependencies required - pure bash!
   ```

4. **Test your setup**
   ```bash
   ./cheat.sh help
   ./cheat.sh list
   ```

## 📝 Adding New Topics

### 1. Create Template File
Create a new file in `templates/your_topic.txt`:

```
# {your_topic_title}

$ command example
> {command_description}

$ another command
> {another_description}
```

### 2. Add Translations
Add translations to all language files:

**localizations/en.json:**
```json
{
  "your_topic_title": "Your Topic Cheat Sheet",
  "command_description": "Description of what this command does",
  "another_description": "Another description"
}
```

**localizations/ru.json:**
```json
{
  "your_topic_title": "Шпаргалка по вашей теме",
  "command_description": "Описание того, что делает эта команда",
  "another_description": "Другое описание"
}
```

### 3. Test Your Changes
```bash
./cheat.sh your_topic
./cheat.sh lang ru
./cheat.sh your_topic
```

## 🌍 Adding New Languages

1. **Create translation file**
   ```bash
   touch localizations/your_lang.json
   ```

2. **Add translations for all keys**
   - Copy from `localizations/en.json`
   - Translate all values
   - Keep keys unchanged

3. **Test the new language**
   ```bash
   ./cheat.sh lang your_lang
   ./cheat.sh list
   ```

4. **Update documentation**
   - Add to language selector in README.md
   - Create translated documentation in `docs/`

## 📏 Code Style

### Bash Script Guidelines
- Use meaningful variable names
- Add comments for complex logic
- Follow shellcheck recommendations
- Use consistent indentation (2 spaces)

### File Naming
- Templates: `templates/topic.txt`
- Translations: `localizations/lang.json`
- Documentation: `docs/README.lang.md`

### JSON Format
- Use 2-space indentation
- Sort keys alphabetically
- Use descriptive key names

## 📝 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples
```bash
git commit -m "feat: add kubernetes cheat sheet"
git commit -m "fix: resolve language switching issue"
git commit -m "docs: update installation instructions"
git commit -m "feat: add German language support"
```

## 🔄 Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the coding guidelines
   - Add tests if applicable
   - Update documentation

3. **Test thoroughly**
   ```bash
   ./cheat.sh list
   ./cheat.sh your_new_topic
   ./cheat.sh lang ru
   ./cheat.sh search test
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Use the [PR template](.github/pull_request_template.md)
   - Describe your changes clearly
   - Link related issues

## 🌐 Translation Guide

For detailed translation guidelines, see [TRANSLATION_GUIDE.md](TRANSLATION_GUIDE.md).

## 📞 Getting Help

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Documentation**: Check the [docs/](docs/) folder for language-specific guides

## 🙏 Thank You

Thank you for contributing to cli-cheatsheet! Your contributions help make this tool better for everyone. 