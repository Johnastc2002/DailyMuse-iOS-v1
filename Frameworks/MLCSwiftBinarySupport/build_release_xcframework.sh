#!/bin/bash

set -e

# 預設 scheme
DEFAULT_SCHEME="MLCSwiftBinarySupport"

SCHEME=${1:-$DEFAULT_SCHEME}

BUILD_DIR="$(pwd)/build"

echo "Removing existing build dir"
rm -rf $BUILD_DIR

echo "Building Release xcframework for scheme: $SCHEME"
echo "Build output dir: $BUILD_DIR"

# Build iOS 真機
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/$SCHEME-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build iOS Simulator
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/$SCHEME-iOSSimulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build macOS
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=macOS" \
  -archivePath "$BUILD_DIR/$SCHEME-macOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create xcframework
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/$SCHEME-iOS.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$BUILD_DIR/$SCHEME-iOSSimulator.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -framework "$BUILD_DIR/$SCHEME-macOS.xcarchive/Products/Library/Frameworks/$SCHEME.framework" \
  -output "$BUILD_DIR/$SCHEME.xcframework"

echo "Done! Your xcframework is located at:"
echo "$BUILD_DIR/$SCHEME.xcframework"