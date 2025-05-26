#!/bin/bash

# Description: Analyze .a files under the specified directory recursively,
# and display architectures & LC_BUILD_VERSION platforms in a tree-like structure.

# Accept parameter or fallback to default path
ROOT_DIR="${1:-../Models/llm_models/lib}"

bold=$(tput bold)
normal=$(tput sgr0)

# Architecture colors
color_arch_arm64=$(tput setaf 1)      # Red
color_arch_x86_64=$(tput setaf 2)     # Green
color_arch_armv7=$(tput setaf 3)      # Yellow
color_arch_unknown=$(tput setaf 5)    # Magenta

# Platform colors
color_platform_macOS=$(tput setaf 4)           # Blue
color_platform_iOS=$(tput setaf 6)             # Cyan
color_platform_tvOS=$(tput setaf 3)             # Yellow (diff from arch)
color_platform_watchOS=$(tput setaf 2)         # Green (diff from arch)
color_platform_bridgeOS=$(tput setaf 1)        # Red (diff from arch)
color_platform_macCatalyst=$(tput setaf 7)     # White/Grey
color_platform_iOSSimulator=$(tput setaf 202)    # Orange
color_platform_tvOSSimulator=$(tput setaf 9)   # Light Red
color_platform_watchOSSimulator=$(tput setaf 10)# Light Green
color_platform_driverKit=$(tput setaf 11)      # Light Yellow
color_platform_missing=$(tput setaf 12)        # Light Blue
color_platform_unknown=$(tput setaf 13)        # Light Magenta

echo -e "${bold}This script analyzes .a files for architectures and LC_BUILD_VERSION platforms in a tree format under ${ROOT_DIR}.${normal}\n"

print_tree() {
    local dir_path="$1"
    local prefix="$2"

    local entries=()
    while IFS= read -r -d $'\0' entry; do
        entries+=("$entry")
    done < <(find "$dir_path" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    local total=${#entries[@]}
    local count=0

    for entry in "${entries[@]}"; do
        count=$((count + 1))
        local base=$(basename "$entry")

        if [[ $count -eq $total ]]; then
            branch="└─ "
            next_prefix="${prefix}   "
        else
            branch="├─ "
            next_prefix="${prefix}│  "
        fi

        if [[ -d "$entry" ]]; then
            echo "${prefix}${branch}${bold}${base}/${normal}"
            print_tree "$entry" "$next_prefix"
        else
            # Skip non-.a files
            if [[ "$base" != *.a ]]; then
                continue
            fi

            echo "${prefix}${branch}${bold}${base}${normal}"

            # Architecture extraction
            arch=$(lipo -info "$entry" 2>/dev/null | rev | cut -d ' ' -f1 | rev)
            case "$arch" in
                arm64)   arch_color=$color_arch_arm64 ;;
                x86_64)  arch_color=$color_arch_x86_64 ;;
                armv7)   arch_color=$color_arch_armv7 ;;
                *)       arch_color=$color_arch_unknown ;;
            esac

            echo "${prefix}│  Architecture: ${bold}${arch_color}${arch}${normal}"

            # Platform extraction
            platforms=$(otool -l "$entry" 2>/dev/null | awk '
                $1 == "cmd" && $2 == "LC_BUILD_VERSION" { show = 1 }
                show && $1 == "platform" {
                    print $2
                    show = 0
                }
            ' | sort -n | uniq)

            echo -n "${prefix}│  Platforms in LC_BUILD_VERSION: "

            if [ -z "$platforms" ]; then
                echo -e "${bold}${color_platform_missing}Missing platform (no LC_BUILD_VERSION found)${normal}"
            else
                printed_any=false
                for platform in $platforms; do
                    case $platform in
                        1)  name="macOS";             color=$color_platform_macOS ;;
                        2)  name="iOS";               color=$color_platform_iOS ;;
                        3)  name="tvOS";              color=$color_platform_tvOS ;;
                        4)  name="watchOS";           color=$color_platform_watchOS ;;
                        5)  name="bridgeOS";          color=$color_platform_bridgeOS ;;
                        6)  name="Mac Catalyst";      color=$color_platform_macCatalyst ;;
                        7)  name="iOS Simulator";     color=$color_platform_iOSSimulator ;;
                        8)  name="tvOS Simulator";    color=$color_platform_tvOSSimulator ;;
                        9)  name="watchOS Simulator"; color=$color_platform_watchOSSimulator ;;
                        10) name="DriverKit";         color=$color_platform_driverKit ;;
                        *)  name="Unknown ($platform)"; color=$color_platform_unknown ;;
                    esac

                    if [ "$printed_any" = true ]; then
                        echo -n ", "
                    fi
                    echo -n "${bold}${color}${name}${normal}"
                    printed_any=true
                done
                echo ""
            fi
        fi
    done
}

if [ ! -d "$ROOT_DIR" ]; then
    echo "Directory $ROOT_DIR does not exist."
    exit 1
fi

echo "${ROOT_DIR}/"
print_tree "$ROOT_DIR" ""
