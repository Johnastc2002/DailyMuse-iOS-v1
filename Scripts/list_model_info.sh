#!/bin/bash

# ===================================================
# 🔍 Check built LLM bundle folder name and modelLib
# ===================================================

JSON_FILE="../Models/llm_models/bundle/mlc-app-config.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "❌ JSON file not found at: $JSON_FILE"
  exit 1
fi

echo -e "\033[1m📦 Extracting model info from:\033[0m $JSON_FILE"
echo ""

# ANSI color codes
bold=$(tput bold)
normal=$(tput sgr0)
color_model=$(tput setaf 6)  # Cyan
color_lib=$(tput setaf 3)    # Yellow

# Extract and print with formatting (value colored and bolded)
jq -r --arg bold "$bold" --arg normal "$normal" \
       --arg model_color "$color_model" --arg lib_color "$color_lib" '
.model_list[] |
"model folder path name: \($bold)\($model_color)\(.model_id)\($normal)\nmodelLib: \($bold)\($lib_color)\(.model_lib)\($normal)\n"
' "$JSON_FILE"