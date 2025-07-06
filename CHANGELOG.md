# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Add cheat sheets for: sed, cron, netstat, lsof, nmap, ufw, make, package managers
- Add language support for: German (Deutsch), French (Français), Spanish (Español)
- Expand vim cheat sheet with more commands and modes

## [2.0.0] - 2025-07-06

### Added
- **Significantly expanded bash cheat sheet** with 123 comprehensive commands
- Organized into 15 logical categories:
  - File system operations (ls, cd, pwd, mkdir, rm, cp, mv, ln)
  - File viewing (cat, less, head, tail, nano, vim)
  - Search and filtering (grep, find, locate, which, whereis)
  - Process management (ps, top, htop, kill, jobs, fg, bg)
  - System information (df, du, free, uname, whoami, uptime)
  - Network commands (ping, netstat, ss, ifconfig, wget, curl, ssh, scp)
  - Archives and compression (tar, zip, gzip)
  - File permissions (chmod, chown, chgrp, umask)
  - Environment variables (export, env, set, unset)
  - I/O redirection (>, >>, <, 2>, |, &&, ||)
  - History and completion (history, !!, Ctrl+R, Tab)
  - Text utilities (sort, uniq, wc, cut, awk, sed, tr, xargs)
  - Monitoring and logs (dmesg, journalctl, watch, strace, lsof)
  - System administration (sudo, su, passwd, useradd, systemctl)
  - Useful aliases and bash functions

### Changed
- **BREAKING**: Changed translation key format from `{key}` to `[[key]]` to avoid conflicts with command syntax
- **BREAKING**: Reorganized translation files structure for better performance
  - Split large localization files into separate files per utility
  - New structure: `localizations/{lang}/{utility}.json`
  - Improved loading performance for large cheat sheets
- Expanded bash template from 5 to 123 translation keys
- Improved organization with clear section headers
- Enhanced usability with comprehensive command coverage
- **Fixed search functionality** to work with new `[[key]]` format
- Search now properly shows both commands and descriptions for matches

### Fixed
- Search function to display commands with descriptions
- Translation key conflicts with command syntax (especially in awk)
- Performance issues with large translation files
- Missing translation keys in all cheat sheets
- Empty descriptions in localization files

### Technical Improvements
- Replaced all `echo` calls with `printf '%s\n'` for better handling of special characters
- Optimized translation loading for better performance
- Improved search algorithm to find matches in commands, descriptions, keys, and translations
- Better error handling and fallback mechanisms

## [1.10.0] - 2025-07-06

### Added
- **Significantly expanded bash cheat sheet** with 123 comprehensive commands
- Organized into 15 logical categories:
  - File system operations (ls, cd, pwd, mkdir, rm, cp, mv, ln)
  - File viewing (cat, less, head, tail, nano, vim)
  - Search and filtering (grep, find, locate, which, whereis)
  - Process management (ps, top, htop, kill, jobs, fg, bg)
  - System information (df, du, free, uname, whoami, uptime)
  - Network commands (ping, netstat, ss, ifconfig, wget, curl, ssh, scp)
  - Archives and compression (tar, zip, gzip)
  - File permissions (chmod, chown, chgrp, umask)
  - Environment variables (export, env, set, unset)
  - I/O redirection (>, >>, <, 2>, |, &&, ||)
  - History and completion (history, !!, Ctrl+R, Tab)
  - Text utilities (sort, uniq, wc, cut, awk, sed, tr, xargs)
  - Monitoring and logs (dmesg, journalctl, watch, strace, lsof)
  - System administration (sudo, su, passwd, useradd, systemctl)
  - Useful aliases and bash functions
- Complete Russian and English translations for all new commands
- Practical examples and common use cases for each command

## [1.9.0] - 2025-07-06

### Added
- Comprehensive **awk** command cheat sheet with 50+ commands
- English and Russian translations for all awk commands
- Template: templates/awk.txt

### Changed
- **Performance optimization**: Reorganized translation files structure
  - Split large localization files into separate files per utility
  - New structure: `localizations/{lang}/{utility}.json`
  - Improved loading performance for large cheat sheets
  - Better maintainability and organization

## [1.8.0] - 2025-07-06

### Added
- Comprehensive **tar** command cheat sheet with detailed usage examples
- English and Russian translations for all tar commands
- Template: templates/tar.txt

## [1.7.0] - 2025-07-06

### Added
- Comprehensive status table showing all cheat sheets and languages
- Support for future languages: German (Deutsch), French (Français), Spanish (Español)
- Clear development roadmap with planned cheat sheets
- Improved project documentation structure

### Changed
- Replaced structure tree with status table in README files
- Updated both English and Russian README files

## [1.6.0] - 2025-07-06

### Added
- Comprehensive **find** command cheat sheet with file search patterns
- **tmux** cheat sheet with session, window, and pane management
- **htop** cheat sheet with process monitoring and keyboard shortcuts
- **curl** cheat sheet with HTTP methods, headers, and authentication
- **ssh** cheat sheet with key management, tunneling, and file transfer

### Fixed
- Duplicate translation keys in htop templates
- Template formatting with proper line breaks
- Search functionality with topic grouping

### Improved
- Translation lookup performance optimization
- Search results display with color coding

## [1.5.0] - 2025-07-06

### Added
- **systemctl** cheat sheet with service management, timers, and system control
- Enhanced search functionality to include new topics

## [1.4.2-beta] - 2025-07-05

### Fixed
- Pagination system using temporary files
- Search function to display commands with descriptions
- Color output in search results
- Performance optimization for large cheat sheets

## [1.4.1] - 2025-07-05

### Fixed
- Search functionality to show commands with descriptions

## [1.4.0] - 2025-07-05

### Added
- Expanded Git and Docker cheat sheets with comprehensive commands

## [1.3.0] - 2025-07-05

### Changed
- Reorganized documentation structure with language folders

## [1.2.0] - 2025-07-05

### Added
- Comprehensive contributing documentation and GitHub templates

## [1.1.0] - 2025-07-05

### Changed
- Migrated to centralized translation system with JSON files

## [1.0.0] - 2025-07-05

### Added
- Initial release with basic cheat sheets
- **bash** cheat sheet with basic commands
- **git** cheat sheet with version control commands
- **docker** cheat sheet with container management
- **vim** cheat sheet with basic editor commands
- Multi-language support (English/Russian)
- Template-based system with placeholder substitution
- Color-coded output
- Search functionality
- Language switching capability

--- 