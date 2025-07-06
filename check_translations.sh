#!/bin/bash

# Script to check if all translation keys from templates exist in translation files

echo "Checking translation keys..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to extract keys from template
extract_keys_from_template() {
    local template_file="$1"
    local keys=()
    
    if [[ -f "$template_file" ]]; then
        while IFS= read -r line; do
            if [[ "$line" =~ \[\[([^\]]+)\]\] ]]; then
                keys+=("${BASH_REMATCH[1]}")
            fi
        done < "$template_file"
    fi
    
    printf '%s\n' "${keys[@]}"
}

# Function to extract keys from JSON file
extract_keys_from_json() {
    local json_file="$1"
    local keys=()
    
    if [[ -f "$json_file" ]]; then
        while IFS= read -r line; do
            if [[ "$line" =~ \"([^\"]+)\":[[:space:]]*\"([^\"]*)\" ]]; then
                keys+=("${BASH_REMATCH[1]}")
            fi
        done < "$json_file"
    fi
    
    printf '%s\n' "${keys[@]}"
}

# Function to check missing keys
check_missing_keys() {
    local template_keys=("$@")
    local json_keys=("$@")
    
    local missing_keys=()
    
    for template_key in "${template_keys[@]}"; do
        local found=false
        for json_key in "${json_keys[@]}"; do
            if [[ "$template_key" == "$json_key" ]]; then
                found=true
                break
            fi
        done
        
        if [[ "$found" == false ]]; then
            missing_keys+=("$template_key")
        fi
    done
    
    printf '%s\n' "${missing_keys[@]}"
}

# Main check
total_missing=0

for template_file in templates/*.txt; do
    if [[ -f "$template_file" ]]; then
        topic=$(basename "$template_file" .txt)
        echo -e "\n${YELLOW}Checking $topic...${NC}"
        
        # Extract keys from template
        mapfile -t template_keys < <(extract_keys_from_template "$template_file")
        
        if [[ ${#template_keys[@]} -eq 0 ]]; then
            echo -e "${GREEN}✓ No translation keys found in template${NC}"
            continue
        fi
        
        echo "Found ${#template_keys[@]} keys in template"
        
        # Check Russian translations
        ru_file="localizations/ru/$topic.json"
        if [[ -f "$ru_file" ]]; then
            mapfile -t ru_keys < <(extract_keys_from_json "$ru_file")
            
            # Find missing keys
            missing_ru=()
            for template_key in "${template_keys[@]}"; do
                found=false
                for ru_key in "${ru_keys[@]}"; do
                    if [[ "$template_key" == "$ru_key" ]]; then
                        found=true
                        break
                    fi
                done
                
                if [[ "$found" == false ]]; then
                    missing_ru+=("$template_key")
                fi
            done
            
            if [[ ${#missing_ru[@]} -eq 0 ]]; then
                echo -e "${GREEN}✓ All keys found in Russian translations${NC}"
            else
                echo -e "${RED}✗ Missing ${#missing_ru[@]} keys in Russian translations:${NC}"
                printf '  %s\n' "${missing_ru[@]}"
                total_missing=$((total_missing + ${#missing_ru[@]}))
            fi
        else
            echo -e "${RED}✗ Russian translation file not found: $ru_file${NC}"
            total_missing=$((total_missing + ${#template_keys[@]}))
        fi
        
        # Check English translations
        en_file="localizations/en/$topic.json"
        if [[ -f "$en_file" ]]; then
            mapfile -t en_keys < <(extract_keys_from_json "$en_file")
            
            # Find missing keys
            missing_en=()
            for template_key in "${template_keys[@]}"; do
                found=false
                for en_key in "${en_keys[@]}"; do
                    if [[ "$template_key" == "$en_key" ]]; then
                        found=true
                        break
                    fi
                done
                
                if [[ "$found" == false ]]; then
                    missing_en+=("$template_key")
                fi
            done
            
            if [[ ${#missing_en[@]} -eq 0 ]]; then
                echo -e "${GREEN}✓ All keys found in English translations${NC}"
            else
                echo -e "${RED}✗ Missing ${#missing_en[@]} keys in English translations:${NC}"
                printf '  %s\n' "${missing_en[@]}"
                total_missing=$((total_missing + ${#missing_en[@]}))
            fi
        else
            echo -e "${RED}✗ English translation file not found: $en_file${NC}"
            total_missing=$((total_missing + ${#template_keys[@]}))
        fi
    fi
done

echo -e "\n${YELLOW}Summary:${NC}"
if [[ $total_missing -eq 0 ]]; then
    echo -e "${GREEN}✓ All translation keys are present!${NC}"
else
    echo -e "${RED}✗ Total missing keys: $total_missing${NC}"
fi 