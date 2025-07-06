# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **feat(ufw)**: add comprehensive UFW firewall cheat sheet with translation support
- Essential UFW commands for firewall management and configuration
- Support for rule management, logging, and application profiles
- English and Russian translations for UFW cheat sheet
- **feat(package-managers)**: add comprehensive package managers cheat sheet with translation support
- Covers APT, DNF, YUM, Pacman, Zypper, Snap, and Flatpak
- Essential commands for package installation, removal, and management
- English and Russian translations for package managers cheat sheet
- **feat(iptables)**: add comprehensive iptables firewall cheat sheet with translation support
- Covers basic commands, input/output/forward chains, NAT rules, and advanced features
- Essential commands for firewall management, rule creation, and network security
- English and Russian translations for iptables cheat sheet
- **docs**: reorganize cheat sheets into logical categories and add planned utilities to tables
- Categorized existing utilities into System, Network, Security, Text Processing, etc.
- Added planned utilities directly to tables with 🔄 status indicators
- Updated both English and Russian README files with improved structure

### Planned
- Add cheat sheets for: make, ps, kill, grep, rsync, dig, jq
- Add language support for: German (Deutsch), French (Français), Spanish (Español)
- Expand vim cheat sheet with more commands and modes
- Reorganize cheat sheets into logical categories (System, Network, Security, etc.)

## [2.6.0] - 2025-07-06

### Added
- **feat(nmap)**: add compact nmap cheat sheet with country code info for geolocation scripts
- Comprehensive nmap commands for network scanning and security testing
- Support for ip-geolocation-ipapi scripts with country code examples
- English and Russian translations for nmap cheat sheet

## [2.5.0] - 2025-07-06

### Added
- **feat(lsof)**: add comprehensive lsof cheat sheet with translation support
- Complete lsof commands for file and network connection monitoring
- Support for process, user, and directory filtering
- TCP/UDP connection state filtering
- English and Russian translations for lsof cheat sheet

## [2.4.0] - 2025-07-06

### Added
- **feat(netstat)**: add compact netstat cheat sheet with translation support
- Essential netstat commands for network connection monitoring
- Port-specific filtering for common services (SSH, HTTP, MySQL, etc.)
- Connection state filtering (ESTABLISHED, TIME_WAIT, CLOSE_WAIT)
- English and Russian translations for netstat cheat sheet

## [2.3.0] - 2025-07-06

### Added
- **feat(sed)**: add full sed cheat sheet with translation support and update docs
- Comprehensive sed commands for text processing and file manipulation
- Support for substitution, deletion, insertion, and transformation operations
- Advanced features like capture groups, in-place editing, and character translation
- English and Russian translations for sed cheat sheet

## [2.2.0] - 2025-07-06

### Added
- **feat(update)**: add automatic update functionality
- New `cheat update` command to fetch latest version via git
- Support for automatic backup creation during updates
- Progress indicators and error handling for update process

### Changed
- **fix(translations)**: replace hardcoded Russian section headers with translatable keys
- Updated all cheat sheet templates to use `[[key]]` format for section headers
- Added corresponding English and Russian translations for all section headers
- Improved consistency across all cheat sheets

### Fixed
- Section headers in cron and bash cheat sheets now support proper localization
- All cheat sheets now use consistent translation key format

## [2.1.0] - 2025-07-06

### Added
- **feat(cron)**: add comprehensive cron cheat sheet
- Complete cron syntax and examples
- Special time strings and shortcuts
- Environment variables and logging options
- English and Russian translations

### Changed
- Updated README files to include cron in supported topics
- Enhanced documentation with cron examples

## [2.0.0] - 2025-07-06

### Added
- **feat(translations)**: implement comprehensive translation system
- JSON-based translation files for English and Russian
- Template system with placeholder substitution
- Language switching via `cheat lang <language>`
- Support for multiple languages with easy extensibility

### Changed
- **refactor(architecture)**: complete rewrite of translation system
- Moved from hardcoded strings to template-based system
- Implemented efficient translation lookup with associative arrays
- Added support for complex placeholder substitution
- Improved performance with optimized translation loading

### Added
- **feat(search)**: enhanced search functionality
- Search across all cheat sheets with grouped results
- Support for searching in translated content
- Improved search result formatting with color coding

### Added
- **feat(cheatsheets)**: comprehensive cheat sheet collection
- bash: Shell scripting and command line operations
- git: Version control and repository management
- docker: Container management and orchestration
- vim: Text editor commands and modes
- systemctl: System service management
- tmux: Terminal multiplexer
- htop: Process monitoring
- curl: HTTP client and API testing
- ssh: Secure shell connections
- find: File system search and operations
- tar: Archive creation and extraction
- awk: Text processing and data manipulation

### Changed
- **refactor(colors)**: improved color scheme and output formatting
- Enhanced readability with better color contrast
- Consistent color coding across all output types
- Support for both light and dark themes

### Added
- **feat(config)**: configuration system
- JSON-based configuration file
- Persistent language and theme settings
- Easy configuration management

## [1.0.0] - 2025-07-06

### Added
- Initial release of cli-cheatsheet
- Basic command reference functionality
- Support for multiple topics
- Color-coded output
- Simple help system

[Unreleased]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.6.0...HEAD
[2.6.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/mrvi0/cli-cheatsheet/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/mrvi0/cli-cheatsheet/releases/tag/v1.0.0

--- 