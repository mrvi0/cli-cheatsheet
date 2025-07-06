#!/bin/bash

# cli-cheatsheet - Interactive terminal utility for quick command reference
# Usage: ./cheat.sh <topic>|list|search <query>|lang [language]

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

# Configuration
CONFIG_FILE="$SCRIPT_DIR/config.json"
LOCALIZATIONS_DIR="$SCRIPT_DIR/localizations"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
DEFAULT_LANG="en"
DEFAULT_THEME="dark"

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        LANG=$(jq -r '.lang // "'$DEFAULT_LANG'"' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_LANG")
        THEME=$(jq -r '.theme // "'$DEFAULT_THEME'"' "$CONFIG_FILE" 2>/dev/null || echo "$DEFAULT_THEME")
    else
        LANG="$DEFAULT_LANG"
        THEME="$DEFAULT_THEME"
    fi
}

# Save configuration
save_config() {
    local lang="$1"
    local theme="$2"
    
    # Create config if it doesn't exist
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo '{"lang":"'$DEFAULT_LANG'","theme":"'$DEFAULT_THEME'"}' > "$CONFIG_FILE"
    fi
    
    # Update language
    if [[ -n "$lang" ]]; then
        jq '.lang = "'$lang'"' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo -e "${GREEN}Language changed to: $lang${NC}"
    fi
    
    # Update theme
    if [[ -n "$theme" ]]; then
        jq '.theme = "'$theme'"' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo -e "${GREEN}Theme changed to: $theme${NC}"
    fi
}

# Get available languages
list_languages() {
    echo -e "${MAGENTA}${BOLD}Available languages:${NC}"
    for lang_dir in "$LOCALIZATIONS_DIR"/*/; do
        if [[ -d "$lang_dir" ]]; then
            local lang_name=$(basename "$lang_dir")
            if [[ "$lang_name" == "$LANG" ]]; then
                echo -e "  - ${GREEN}$lang_name (current)${NC}"
            else
                echo "  - $lang_name"
            fi
        fi
    done
}

# Change language
change_lang() {
    local new_lang="$1"
    
    if [[ -z "$new_lang" ]]; then
        list_languages
        return 0
    fi
    
    # Check if language directory exists
    if [[ ! -d "$LOCALIZATIONS_DIR/$new_lang" ]]; then
        echo -e "${RED}Error: Language '$new_lang' not found${NC}"
        list_languages
        return 1
    fi
    
    save_config "$new_lang" ""
}

# Substitute translations in template
substitute_translations() {
    local template_file="$1"
    local lang_file="$2"
    local topic="$3"
    local lang="$4"
    
    if [[ ! -f "$template_file" ]]; then
        return 1
    fi
    
    # Load all translations into associative array for faster lookup
    declare -A translations
    
    if [[ -f "$lang_file" ]]; then
        while IFS=':' read -r key value; do
            if [[ -n "$key" && -n "$value" ]]; then
                # Remove quotes and escape sequences
                value=$(echo "$value" | sed 's/^"//;s/"$//;s/\\"/"/g;s/\\\\/\\/g')
                translations["$key"]="$value"
            fi
        done < <(jq -r 'to_entries[] | "\(.key):\(.value)"' "$lang_file" 2>/dev/null)
    fi
    
    # Read template and substitute translations
    while IFS= read -r line; do
        # Find all [[key]] patterns and substitute them
        local substituted_line="$line"
        while [[ "$substituted_line" =~ \[\[([^\]]+)\]\] ]]; do
            local key="${BASH_REMATCH[1]}"
            if [[ -n "${translations[$key]}" ]]; then
                local value="${translations[$key]}"
                substituted_line="${substituted_line//\[\[$key\]\]/$value}"
            else
                # If key not found, replace with empty string and break to avoid infinite loop
                substituted_line="${substituted_line//\[\[$key\]\]/}"
                break
            fi
        done
        echo "$substituted_line"
    done < "$template_file"
}

# Get available topics
list_topics() {
    local topics=()
    
    if [[ -d "$TEMPLATES_DIR" ]]; then
        for file in "$TEMPLATES_DIR"/*.txt; do
            if [[ -f "$file" ]]; then
                topics+=("$(basename "$file" .txt)")
            fi
        done
    fi
    
    printf '%s\n' "${topics[@]}"
}

# Show cheat sheet with colors and translations
show_cheat() {
    local topic="$1"
    local lang="$2"
    local template_file="$TEMPLATES_DIR/$topic.txt"
    local lang_file="$LOCALIZATIONS_DIR/$lang.json"
    
    if [[ ! -f "$template_file" ]]; then
        echo -e "${RED}No cheat sheet found for topic: $topic${NC}"
        return 1
    fi
    
    # Check if language directory exists
    if [[ ! -d "$LOCALIZATIONS_DIR/$lang" ]]; then
        echo -e "${RED}No language directory found for: $lang${NC}"
        return 1
    fi
    
    # Check if specific utility translation file exists
    local utility_lang_file="$LOCALIZATIONS_DIR/$lang/$topic.json"
    if [[ ! -f "$utility_lang_file" ]]; then
        echo -e "${RED}No translation file found for topic '$topic' in language '$lang'${NC}"
        return 1
    fi
    
    # Simple approach: output all content with colors
    # User can pipe to 'less' or 'more' for pagination if needed
    while IFS= read -r line; do
        if [[ "$line" =~ ^# ]]; then
            # Headers
            echo -e "${CYAN}${BOLD}$line${NC}"
        elif [[ "$line" =~ ^\$ ]]; then
            # Commands
            echo -e "${GREEN}$line${NC}"
        elif [[ "$line" =~ ^\> ]]; then
            # Descriptions
            echo -e "${YELLOW}$line${NC}"
        else
            # Regular text
            echo "$line"
        fi
    done < <(substitute_translations "$template_file" "$utility_lang_file" "$topic" "$lang")
}

# Search in cheat sheets
search_cheats() {
    local query="$1"
    local lang="$2"
    
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        echo -e "${RED}No cheat sheets found${NC}"
        return 1
    fi
    
    echo -e "${MAGENTA}${BOLD}Searching for: $query${NC}"
    echo "---"
    
    local found_matches=false
    local query_lower="${query,,}"
    
    for template_file in "$TEMPLATES_DIR"/*.txt; do
        if [[ ! -f "$template_file" ]]; then
            continue
        fi
        local topic=$(basename "$template_file" .txt)
        local lang_file="$LOCALIZATIONS_DIR/$lang/$topic.json"
        if [[ ! -f "$lang_file" ]]; then
            continue
        fi
        declare -A translations
        while IFS=':' read -r key value; do
            if [[ -n "$key" && -n "$value" ]]; then
                value=$(echo "$value" | sed 's/^"//;s/"$//;s/\\"/"/g;s/\\\\/\\/g')
                translations["$key"]="$value"
            fi
        done < <(jq -r 'to_entries[] | "\(.key):\(.value)"' "$lang_file" 2>/dev/null)
        local prev_command=""
        while IFS= read -r line; do
            if [[ "$line" =~ ^\$ ]]; then
                prev_command="$line"
                continue
            fi
            if [[ "$line" =~ ^\> ]]; then
                local cmd_line="$prev_command"
                local desc_line="$line"
                # Substitute translations
                local substituted_cmd="$cmd_line"
                while [[ "$substituted_cmd" =~ \[\[([^\]]+)\]\] ]]; do
                    local key="${BASH_REMATCH[1]}"
                    local value="${translations[$key]:-\[\[$key\]\]}"
                    substituted_cmd="${substituted_cmd//\[\[$key\]\]/$value}"
                done
                local substituted_desc="$desc_line"
                while [[ "$substituted_desc" =~ \[\[([^\]]+)\]\] ]]; do
                    local key="${BASH_REMATCH[1]}"
                    local value="${translations[$key]:-\[\[$key\]\]}"
                    substituted_desc="${substituted_desc//\[\[$key\]\]/$value}"
                done
                # Lowercase for search
                local cmd_lower="${substituted_cmd,,}"
                local desc_lower="${substituted_desc,,}"
                # Search in command, description, keys, and translations
                local match=false
                if [[ "$cmd_lower" == *$query_lower* ]] || [[ "$desc_lower" == *$query_lower* ]]; then
                    match=true
                else
                    # Check keys and translation values
                    for k in "${!translations[@]}"; do
                        local v="${translations[$k]}"
                        if [[ "${k,,}" == *$query_lower* ]] || [[ "${v,,}" == *$query_lower* ]]; then
                            if [[ "$cmd_line" == *"[[$k]]"* ]] || [[ "$desc_line" == *"[[$k]]"* ]]; then
                                match=true
                                break
                            fi
                        fi
                    done
                fi
                if [[ "$match" == true ]]; then
                    if [[ "$found_matches" == false ]]; then
                        echo -e "${CYAN}${BOLD}$topic:${NC}"
                        found_matches=true
                    fi
                    echo -e "${GREEN}$substituted_cmd${NC}"
                    echo -e "${YELLOW}$substituted_desc${NC}"
                    echo ""
                fi
            fi
        done < "$template_file"
    done
    if [[ "$found_matches" == false ]]; then
        echo -e "${YELLOW}No matches found for: $query${NC}"
    fi
}

# Update utility
update_utility() {
    echo -e "${CYAN}${BOLD}Updating cli-cheatsheet...${NC}"
    
    # Check if we're in a git repository
    if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
        echo -e "${RED}Error: Not a git repository. Cannot update.${NC}"
        echo -e "${YELLOW}Please reinstall from: https://github.com/mrvi0/cli-cheatsheet${NC}"
        return 1
    fi
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is not installed. Cannot update.${NC}"
        return 1
    fi
    
    # Store current branch
    local current_branch=$(git -C "$SCRIPT_DIR" branch --show-current 2>/dev/null)
    if [[ -z "$current_branch" ]]; then
        echo -e "${RED}Error: Could not determine current branch${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Current branch: $current_branch${NC}"
    
    # Fetch latest changes
    echo -e "${YELLOW}Fetching latest changes...${NC}"
    if ! git -C "$SCRIPT_DIR" fetch origin; then
        echo -e "${RED}Error: Failed to fetch latest changes${NC}"
        return 1
    fi
    
    # Check if there are updates
    local behind_count=$(git -C "$SCRIPT_DIR" rev-list --count HEAD..origin/$current_branch 2>/dev/null)
    if [[ "$behind_count" == "0" ]]; then
        echo -e "${GREEN}Already up to date!${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Found $behind_count new commit(s)${NC}"
    
    # Pull latest changes
    echo -e "${YELLOW}Pulling latest changes...${NC}"
    if ! git -C "$SCRIPT_DIR" pull origin "$current_branch"; then
        echo -e "${RED}Error: Failed to pull latest changes${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Successfully updated cli-cheatsheet!${NC}"
    echo -e "${YELLOW}You may need to restart your terminal or reload your shell configuration.${NC}"
}

# Show help
show_help() {
    echo -e "${GREEN}${BOLD}"
    echo "   ____ _     ___       ____ _   _ _____    _  _____ ____  _   _ _____ _____ _____ "
    echo "  / ___| |   |_ _|     / ___| | | | ____|  / \\|_   _/ ___|| | | | ____| ____|_   _|"
    echo " | |   | |    | |_____| |   | |_| |  _|   / _ \\ | | \\___ \\| |_| |  _| |  _|   | |  "
    echo " | |___| |___ | |_____| |___|  _  | |___ / ___ \\| |  ___) |  _  | |___| |___  | |  "
    echo "  \\____|_____|___|     \\____|_| |_|_____/_/   \\_\_| |____/|_| |_|_____|_____| |_|  "
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}The only CLI cheat sheet you need!${NC}"
    echo -e "Unified, translatable, and community-driven.\n"
    echo -e "${YELLOW}${BOLD}Available commands:${NC}"
    echo -e "  ${GREEN}cheat <topic>${NC}         Show cheat sheet for topic (e.g. bash, git, docker)"
    echo -e "  ${GREEN}cheat list${NC}            List all available topics"
    echo -e "  ${GREEN}cheat status${NC}          Show status tables for all utilities"
    echo -e "  ${GREEN}cheat search <query>${NC}  Search in all cheat sheets"
    echo -e "  ${GREEN}cheat lang${NC}            Show available languages"
    echo -e "  ${GREEN}cheat lang <lang>${NC}     Change language (en/ru)"
    echo -e "  ${GREEN}cheat update${NC}          Update to latest version"
    echo -e "  ${GREEN}cheat help${NC}            Show this help message\n"
    echo -e "${YELLOW}${BOLD}Usage examples:${NC}"
    echo -e "  ${GREEN}cheat bash${NC}           Bash cheat sheet"
    echo -e "  ${GREEN}cheat git${NC}            Git cheat sheet"
    echo -e "  ${GREEN}cheat --lang ru vim${NC}  Vim cheat sheet in Russian"
    echo -e "  ${GREEN}cheat list${NC}           List all available topics"
    echo -e "  ${GREEN}cheat search find${NC}    Search for 'find' in all topics\n"
    echo -e "${MAGENTA}${BOLD}Categories:${NC} System, Network, Security, Text, Files, Archiving, Containers, Dev, Packages\n"
    echo -e "${BOLD}Status:${NC}  ${GREEN}✅ Available${NC}   ${YELLOW}🔄 In progress${NC}   ❌ Not available\n"
    echo -e "Contribute: ${CYAN}https://github.com/mrvi0/cli-cheatsheet${NC}"
    echo -e "Type '${BOLD}cheat help${NC}' for more info.\n"
}

show_status() {
    echo -e "${CYAN}${BOLD}Cheat Sheets Status:${NC}\n"
    # System Utilities
    echo -e "${BOLD}🔧 System Utilities${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| bash        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| systemctl   | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| cron        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| htop        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| tmux        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ps          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| kill        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| top         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| iotop       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| useradd     | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| sudo        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| mount       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Network Utilities
    echo -e "${BOLD}🌐 Network Utilities${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| curl        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ssh         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| netstat     | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| nmap        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| lsof        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ping        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| traceroute  | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| dig         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| wget        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| rsync       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| nc          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| iftop       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Security & Firewalls
    echo -e "${BOLD}🛡️ Security & Firewalls${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| ufw         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| iptables    | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| fail2ban    | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| openssl     | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| gpg         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ssh-keygen  | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Text Processing
    echo -e "${BOLD}📝 Text Processing${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| vim         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| sed         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| awk         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| grep        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| cut         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| sort        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| wc          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| jq          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| nano        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # File System & Search
    echo -e "${BOLD}🔍 File System & Search${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| find        | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ls          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| cp          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| chmod       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| du          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| locate      | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| ripgrep     | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Archiving & Compression
    echo -e "${BOLD}📦 Archiving & Compression${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| tar         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| zip         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| gzip        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| bzip2       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| xz          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| zstd        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Containerization
    echo -e "${BOLD}🐳 Containerization${NC}"
    echo -e "| Utility         | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-----------------|-----|-----|-----|-----|-----|"
    echo -e "| docker          | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| docker-compose  | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| kubectl         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| podman          | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Development Tools
    echo -e "${BOLD}🔧 Development Tools${NC}"
    echo -e "| Utility     | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------|-----|-----|-----|-----|-----|"
    echo -e "| git         | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| make        | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| cmake       | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| gcc         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| gdb         | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| valgrind    | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    # Package Management
    echo -e "${BOLD}📦 Package Management${NC}"
    echo -e "| Utility           | EN  | RU  | DE  | FR  | ES  |"
    echo -e "|-------------------|-----|-----|-----|-----|-----|"
    echo -e "| package-managers  | ${GREEN}✅${NC}  | ${GREEN}✅${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| apt               | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| yum               | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| dnf               | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| pacman            | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| snap              | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |"
    echo -e "| flatpak           | ${YELLOW}🔄${NC}  | ${YELLOW}🔄${NC}  | ❌  | ❌  | ❌  |\n"
    echo -e "${BOLD}Legend:${NC}  ${GREEN}✅ Available${NC}   ${YELLOW}🔄 In progress${NC}   ❌ Not available\n"
}

# Main function
main() {
    load_config
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    case "$1" in
        "list")
            echo -e "${MAGENTA}${BOLD}Available topics:${NC}"
            while IFS= read -r topic; do
                if [[ -n "$topic" ]]; then
                    echo "  - $topic"
                fi
            done < <(list_topics)
            ;;
        "search")
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}Error: Please specify a search query${NC}"
                exit 1
            fi
            search_cheats "$2" "$LANG"
            ;;
        "lang")
            change_lang "$2"
            ;;
        "update")
            update_utility
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "status")
            show_status
            ;;
        *)
            show_cheat "$1" "$LANG"
            ;;
    esac
}

# Run main function with all arguments
main "$@" 