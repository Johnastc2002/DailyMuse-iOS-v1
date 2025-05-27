# DailyMuse

DailyMuse is an app that generates unique motivational quotes and images using local AI models directly on your device, providing fresh daily inspiration without needing an internet connection and ensuring user privacy.

## Technology Stack

- **MLC LLM**: Local AI model inference engine for efficient on-device processing.
- **Swift & SwiftUI**: Modern iOS development using Swift language and SwiftUI framework for UI.
- **Xcode 16.3**: Development environment for building and running the app.
- **Git Submodules**: Used to integrate external dependencies, including the mlc-llm repository.
- **Conda**: Environment management tool for Python dependencies related to model building.

## Installation & Setup

1. Clone this repository:
    ```bash
    git clone git@github.com:Johnastc2002/DailyMuse-iOS-v1.git
    ```
2. Initialize and update submodules:
    ```bash
    cd DailyMuse-iOS-v1
    git submodule update --init --recursive
    ```
3. Open the project workspace in Xcode:
    ```bash
    open DailyMuse.xcworkspace
    ```
4. Build and run the app on your device or simulator.

## mlc-llm Integration and SwiftUI Preview Support

Integrating MLC LLM into this project involved additional adjustments to support iOS simulators and SwiftUI previews effectively:

- Simulator-compatible static libraries were created, limited to the ARM64 architecture for simplicity.
- Both real device and simulator static libraries were bundled into a dynamic framework named `MLCSwiftBinarySupport`. This wrapper framework enables SwiftUI previews to function properly, as dynamic linking is necessary for simulator compatibility.
- **Important:** Due to a known issue in Xcode 16.3, enable **"Use Legacy Previews Execution"** by navigating to the top menu bar: **Editor -> Canvas -> Use Legacy Previews Execution** to avoid preview failures.

This approach maintains a smooth development experience while leveraging efficient local AI inference on-device.

---

For more details on MLC LLM and model building, please refer to [MLC LLM documentation](https://llm.mlc.ai/docs/install/mlc_llm.html).
