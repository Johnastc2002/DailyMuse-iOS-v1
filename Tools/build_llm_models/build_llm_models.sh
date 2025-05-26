#!/bin/bash

# Description: This script runs the 'mlc_llm package' command with iOS Simulator support
# ==============================================================================
# 🚨🚨🚨 MUST: Setup mlc_llm + set your CONDA_VENV_NAME first! 🚨🚨🚨
#
# This script REQUIRES mlc_llm to be installed and set up beforehand.
# You MUST replace the CONDA_VENV_NAME with your own Conda environment name.
# Guide to install mlc_llm: https://llm.mlc.ai/docs/install/mlc_llm.html#:~:text=built%20from%20source.-,Option%201.%20Prebuilt%20Package,operating%20system/compute%20platform%20and%20run%20the%20command%20in%20your%20terminal%3A,-Note 
# ==============================================================================

# Conda venv name ⚠️⚠️⚠️ USE YOUR OWN ONE ⚠️⚠️⚠️
CONDA_VENV_NAME="mlc-llm-env"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MLC_LLM_DIR="$PROJECT_ROOT/Submodules/mlc-llm"
LLM_MODEL_DIR="$PROJECT_ROOT/Models/llm_models"

# Ensure script run exactly in this file path
cd "$SCRIPT_DIR"

# Update mlc-llm submodules
git -C "$MLC_LLM_DIR" submodule update --init --recursive

# Remove old models
rm -rf "$LLM_MODEL_DIR/bundle"
rm -rf "$LLM_MODEL_DIR/lib"

echo "Running mlc_llm package..."

# Activate conda venv
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$CONDA_VENV_NAME"

# Package the models
cd "$MLC_LLM_DIR/ios"
mlc_llm package --package-config "$SCRIPT_DIR/mlc-package-config.json" \
    --mlc-llm-source-dir "$PROJECT_ROOT/Submodules/mlc-llm"

# ==============================================================================
# ⬇️ The following command starts building the simulator-compatible .a files
# PURPOSE: Build extra .a files for iOS Simulator (arm64 only) & SwiftUI Previews
#
# Normally, `mlc_llm package` is sufficient to produce static libraries for iOS devices.
# However, to support SwiftUI Previews and running in the iOS Simulator (on Apple Silicon),
# we must generate additional `.a` files targeting the arm64 simulator architecture.
#
# ⚠️ Note: `libmodel_iphone.a` does NOT need to be rebuilt — it contains only
# platform-agnostic object (.o) files like model weights, which are safe to reuse across
# device and simulator builds.
# ==============================================================================
mkdir -p ./dist/lib/ios
mkdir -p ./dist/lib/ios-simulator
cp ./dist/lib/libmodel_iphone.a ./dist/lib/ios-simulator/
mv ./dist/lib/*.a ./dist/lib/ios/

# Explicitly build iOS Simulator static libraries (except libmodel_iphone.a)
export MLC_LLM_SOURCE_DIR=$MLC_LLM_DIR
./prepare_libs.sh -s

cp ./build/lib/*.a ./dist/lib/ios-simulator/

# Move the built libraries to destination folder
mv ./dist/bundle $LLM_MODEL_DIR
mv ./dist/lib $LLM_MODEL_DIR

# Clean up
rm -rf ./build
rm -rf ./dist
