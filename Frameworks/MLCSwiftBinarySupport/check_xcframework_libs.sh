#!/bin/bash

# 📍 預設 xcframework 路徑
XCFRAMEWORK_DIR="./build/MLCSwiftBinarySupport.xcframework"

# 🧱 你想檢查嘅 .a libraries 名
LIBS_TO_CHECK=(
    "libmlc_llm.a"
    "libmodel_iphone.a"
    "libsentencepiece.a"
    "libtokenizers_c.a"
    "libtokenizers_cpp.a"
    "libtvm_runtime.a"
)

# 🧠 對應符號 prefix，根據之前 undefined symbol 嘅類推（只列幾個足夠判斷）
SYMBOL_HINTS=(
    "tvm::runtime::"
    "mlc"
    "tokenizers"
    "sentencepiece"
)

echo "🔍 掃描 XCFramework: $XCFRAMEWORK_DIR"
echo "=============================="

# loop 所有 platform 內的 binary
find "$XCFRAMEWORK_DIR" -name "MLCSwiftBinarySupport" -type f | while read -r BIN; do
    echo "📦 檢查 binary: $BIN"

    FOUND=0

    # 用 nm 搵符號
    for HINT in "${SYMBOL_HINTS[@]}"; do
        nm -gU "$BIN" 2>/dev/null | c++filt | grep -q "$HINT"
        if [ $? -eq 0 ]; then
            echo "  ✅ 有包含關鍵符號: $HINT"
            FOUND=1
        fi
    done

    if [ $FOUND -eq 0 ]; then
        echo "  ❌ 無找到相關符號，可能未正確 link .a libraries"
    fi

    echo "------------------------------"
done