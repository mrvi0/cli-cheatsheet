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

# Configuration
CONFIG_FILE="config.json"
LOCALIZATIONS_DIR="localizations"
TEMPLATES_DIR="templates"
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

# Show help
show_help() {
    echo -e "${CYAN}${BOLD}cli-cheatsheet - Interactive terminal utility${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 <topic>           Show cheat sheet for topic"
    echo "  $0 list              List all available topics"
    echo "  $0 search <query>    Search in all cheat sheets"
    echo "  $0 lang              Show available languages"
    echo "  $0 lang <language>   Change language (en/ru)"
    echo "  $0 help              Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 git               Show git cheat sheet"
    echo "  $0 bash              Show bash cheat sheet"
    echo "  $0 search commit     Search for 'commit' in all sheets"
    echo "  $0 lang              Show available languages"
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