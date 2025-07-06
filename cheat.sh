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
    for lang_file in "$LOCALIZATIONS_DIR"/*.json; do
        if [[ -f "$lang_file" ]]; then
            local lang_name=$(basename "$lang_file" .json)
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
    
    # Check if language file exists
    if [[ ! -f "$LOCALIZATIONS_DIR/$new_lang.json" ]]; then
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
    
    if [[ ! -f "$template_file" ]] || [[ ! -f "$lang_file" ]]; then
        return 1
    fi
    
    # Load all translations into associative array for faster lookup
    declare -A translations
    while IFS=':' read -r key value; do
        if [[ -n "$key" && -n "$value" ]]; then
            # Remove quotes and escape sequences
            value=$(echo "$value" | sed 's/^"//;s/"$//;s/\\"/"/g;s/\\\\/\\/g')
            translations["$key"]="$value"
        fi
    done < <(jq -r 'to_entries[] | "\(.key):\(.value)"' "$lang_file" 2>/dev/null)
    
    # Read template and substitute translations
    while IFS= read -r line; do
        # Find all {key} patterns and substitute them
        local substituted_line="$line"
        while [[ "$substituted_line" =~ \{([^}]+)\} ]]; do
            local key="${BASH_REMATCH[1]}"
            local value="${translations[$key]:-\{$key\}}"
            substituted_line="${substituted_line//\{$key\}/$value}"
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
    
    # Fallback to default language
    if [[ ! -f "$lang_file" ]]; then
        lang_file="$LOCALIZATIONS_DIR/$DEFAULT_LANG.json"
    fi
    
    if [[ ! -f "$template_file" ]]; then
        echo -e "${RED}No cheat sheet found for topic: $topic${NC}"
        return 1
    fi
    
    if [[ ! -f "$lang_file" ]]; then
        echo -e "${RED}No language file found for: $lang${NC}"
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
    done < <(substitute_translations "$template_file" "$lang_file")
}

# Search in cheat sheets
search_cheats() {
    local query="$1"
    local lang="$2"
    local lang_file="$LOCALIZATIONS_DIR/$lang.json"
    
    # Fallback to default language
    if [[ ! -f "$lang_file" ]]; then
        lang_file="$LOCALIZATIONS_DIR/$DEFAULT_LANG.json"
    fi
    
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        echo -e "${RED}No cheat sheets found${NC}"
        return 1
    fi
    
    echo -e "${MAGENTA}${BOLD}Searching for: $query${NC}"
    echo "---"
    
    # Load all translations into associative array for faster lookup
    declare -A translations
    while IFS=':' read -r key value; do
        if [[ -n "$key" && -n "$value" ]]; then
            # Remove quotes and escape sequences
            value=$(echo "$value" | sed 's/^"//;s/"$//;s/\\"/"/g;s/\\\\/\\/g')
            translations["$key"]="$value"
        fi
    done < <(jq -r 'to_entries[] | "\(.key):\(.value)"' "$lang_file" 2>/dev/null)
    
    # Find matching keys first
    local matching_keys=()
    for key in "${!translations[@]}"; do
        if echo "$key" | grep -qi "$query" || echo "${translations[$key]}" | grep -qi "$query"; then
            matching_keys+=("$key")
        fi
    done
    
    # Group keys by topic
    declare -A topic_matches
    for key in "${matching_keys[@]}"; do
        local topic=""
        case "$key" in
            git_*) topic="git" ;;
            docker_*) topic="docker" ;;
            bash_*) topic="bash" ;;
            vim_*) topic="vim" ;;
            systemctl_*) topic="systemctl" ;;
            journalctl_*) topic="systemctl" ;;
            tmux_*) topic="tmux" ;;
            htop_*) topic="htop" ;;
            curl_*) topic="curl" ;;
            ssh_*) topic="ssh" ;;
            find_*) topic="find" ;;
            *) continue ;;
        esac
        
        if [[ -n "$topic" ]]; then
            topic_matches["$topic"]="${topic_matches[$topic]} $key"
        fi
    done
    
    # Show results for each topic
    for topic in "${!topic_matches[@]}"; do
        echo -e "${CYAN}${BOLD}$topic:${NC}"
        local keys=(${topic_matches[$topic]})
        local count=0
        
        for key in "${keys[@]}"; do
            if [[ $count -ge 3 ]]; then
                break
            fi
            
            # Find the command in template
            local template_file="$TEMPLATES_DIR/$topic.txt"
            if [[ -f "$template_file" ]]; then
                local found_command=false
                while IFS= read -r line; do
                    if [[ "$line" =~ \{$key\} ]]; then
                        # Substitute the key
                        local substituted_line="${line//\{$key\}/${translations[$key]}}"
                        
                        # If this is a description line, find the command above it
                        if [[ "$line" =~ ^\> ]]; then
                            # Look for the command line above this description
                            local command_line=$(grep -B1 "^$line$" "$template_file" | head -1)
                            if [[ "$command_line" =~ ^\$ ]]; then
                                local substituted_command="${command_line//\{$key\}/${translations[$key]}}"
                                echo -e "${GREEN}$substituted_command${NC}"
                            fi
                        fi
                        
                        # Apply colors based on line type
                        if [[ "$line" =~ ^\> ]]; then
                            echo -e "${YELLOW}$substituted_line${NC}"
                        elif [[ "$line" =~ ^\$ ]]; then
                            echo -e "${GREEN}$substituted_line${NC}"
                        elif [[ "$line" =~ ^# ]]; then
                            echo -e "${CYAN}${BOLD}$substituted_line${NC}"
                        else
                            echo "$substituted_line"
                        fi
                        
                        found_command=true
                        break
                    fi
                done < "$template_file"
                
                # If we didn't find the key in descriptions, look for it in commands
                if [[ "$found_command" == false ]]; then
                    while IFS= read -r line; do
                        if [[ "$line" =~ \{$key\} ]]; then
                            local substituted_line="${line//\{$key\}/${translations[$key]}}"
                            
                            # Apply colors based on line type
                            if [[ "$line" =~ ^\> ]]; then
                                echo -e "${YELLOW}$substituted_line${NC}"
                            elif [[ "$line" =~ ^\$ ]]; then
                                echo -e "${GREEN}$substituted_line${NC}"
                            elif [[ "$line" =~ ^# ]]; then
                                echo -e "${CYAN}${BOLD}$substituted_line${NC}"
                            else
                                echo "$substituted_line"
                            fi
                            
                            # Show next line if it's a description
                            local next_line=$(grep -A1 "^$line$" "$template_file" | tail -1)
                            if [[ "$next_line" =~ ^\> ]]; then
                                local substituted_next_line="$next_line"
                                while [[ "$substituted_next_line" =~ \{([^}]+)\} ]]; do
                                    local next_key="${BASH_REMATCH[1]}"
                                    local next_value="${translations[$next_key]:-\{$next_key\}}"
                                    substituted_next_line="${substituted_next_line//\{$next_key\}/$next_value}"
                                done
                                echo -e "${YELLOW}$substituted_next_line${NC}"
                            fi
                            break
                        fi
                    done < "$template_file"
                fi
            fi
            count=$((count + 1))
        done
        echo ""
    done
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