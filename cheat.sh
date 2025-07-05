#!/bin/bash

# cli-cheatsheet - Interactive terminal utility for quick command reference
# Usage: ./cheat.sh <topic>|list|search <query>|lang <language>

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="config.json"
CHEATS_DIR="cheats"
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

# Change language
change_lang() {
    local new_lang="$1"
    
    if [[ -z "$new_lang" ]]; then
        echo -e "${RED}Error: Please specify a language${NC}"
        echo "Available languages:"
        for lang_dir in "$CHEATS_DIR"/*/; do
            if [[ -d "$lang_dir" ]]; then
                local lang_name=$(basename "$lang_dir")
                echo "  - $lang_name"
            fi
        done
        return 1
    fi
    
    # Check if language directory exists
    if [[ ! -d "$CHEATS_DIR/$new_lang" ]]; then
        echo -e "${RED}Error: Language '$new_lang' not found${NC}"
        echo "Available languages:"
        for lang_dir in "$CHEATS_DIR"/*/; do
            if [[ -d "$lang_dir" ]]; then
                local lang_name=$(basename "$lang_dir")
                echo "  - $lang_name"
            fi
        done
        return 1
    fi
    
    save_config "$new_lang" ""
}

# Get available topics
list_topics() {
    local lang="$1"
    local topics=()
    local cheat_path="$CHEATS_DIR/$lang"
    
    # Fallback to default language if current doesn't exist
    if [[ ! -d "$cheat_path" ]]; then
        cheat_path="$CHEATS_DIR/$DEFAULT_LANG"
    fi
    
    if [[ -d "$cheat_path" ]]; then
        for file in "$cheat_path"/*.txt; do
            if [[ -f "$file" ]]; then
                topics+=("$(basename "$file" .txt)")
            fi
        done
    fi
    
    printf '%s\n' "${topics[@]}"
}

# Show cheat sheet with colors
show_cheat() {
    local topic="$1"
    local lang="$2"
    local cheat_file="$CHEATS_DIR/$lang/$topic.txt"
    
    # Fallback to default language
    if [[ ! -f "$cheat_file" ]]; then
        cheat_file="$CHEATS_DIR/$DEFAULT_LANG/$topic.txt"
    fi
    
    if [[ ! -f "$cheat_file" ]]; then
        echo -e "${RED}No cheat sheet found for topic: $topic${NC}"
        return 1
    fi
    
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
    done < "$cheat_file"
}

# Search in cheat sheets
search_cheats() {
    local query="$1"
    local lang="$2"
    local cheat_path="$CHEATS_DIR/$lang"
    
    # Fallback to default language
    if [[ ! -d "$cheat_path" ]]; then
        cheat_path="$CHEATS_DIR/$DEFAULT_LANG"
    fi
    
    if [[ ! -d "$cheat_path" ]]; then
        echo -e "${RED}No cheat sheets found${NC}"
        return 1
    fi
    
    echo -e "${MAGENTA}${BOLD}Searching for: $query${NC}"
    echo "---"
    
    while IFS= read -r -d '' file; do
        if grep -qi "$query" "$file"; then
            local topic=$(basename "$file" .txt)
            echo -e "${CYAN}${BOLD}$topic:${NC}"
            grep -i "$query" "$file" | head -3
            echo ""
        fi
    done < <(find "$cheat_path" -name "*.txt" -print0)
}

# Show help
show_help() {
    echo -e "${CYAN}${BOLD}cli-cheatsheet - Interactive terminal utility${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 <topic>           Show cheat sheet for topic"
    echo "  $0 list              List all available topics"
    echo "  $0 search <query>    Search in all cheat sheets"
    echo "  $0 lang <language>   Change language (en/ru)"
    echo "  $0 help              Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 git               Show git cheat sheet"
    echo "  $0 bash              Show bash cheat sheet"
    echo "  $0 search commit     Search for 'commit' in all sheets"
    echo "  $0 lang ru           Change language to Russian"
    echo "  $0 lang en           Change language to English"
}

# Main function
main() {
    load_config
    
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    case "$1" in
        "list")
            echo -e "${MAGENTA}${BOLD}Available topics:${NC}"
            while IFS= read -r topic; do
                if [[ -n "$topic" ]]; then
                    echo "  - $topic"
                fi
            done < <(list_topics "$LANG")
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
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            show_cheat "$1" "$LANG"
            ;;
    esac
}

# Run main function with all arguments
main "$@" 