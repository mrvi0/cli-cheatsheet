#!/bin/bash

set -e

LANGS=(ru en)

for template in templates/*.txt; do
    topic=$(basename "$template" .txt)
    echo "Processing $topic..."
    # Собрать все ключи из шаблона
    mapfile -t keys < <(grep -o '\[\[[^]]*\]\]' "$template" | sed 's/\[\[//;s/\]\]//')
    for lang in "${LANGS[@]}"; do
        loc_file="localizations/$lang/$topic.json"
        # Если файла нет — создать пустой JSON
        if [[ ! -f "$loc_file" ]]; then
            echo "{}" > "$loc_file"
        fi
        # Считать существующие ключи
        mapfile -t existing < <(jq -r 'keys[]' "$loc_file")
        # Добавить недостающие ключи
        updated=0
        for key in "${keys[@]}"; do
            if ! printf '%s\n' "${existing[@]}" | grep -qx "$key"; then
                jq --arg k "$key" '. + {($k): ""}' "$loc_file" > "$loc_file.tmp" && mv "$loc_file.tmp" "$loc_file"
                echo "  Added missing key: $key ($lang)"
                updated=1
            fi
        done
        if [[ $updated -eq 1 ]]; then
            echo "  $lang: updated $loc_file"
        fi
    done
done

echo "Done!" 