//
//  LLMView.swift
//  DailyMuse
//
//  Created by tough on 23/5/2025.
//

import SwiftUI
import os.log

struct LLMView: View {
    @State private var prompt: String = "TTT"
    @State private var generatedText: String = ""
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String?
    
    private let logger = Logger(subsystem: "com.dailymuse", category: "LLMView")
    
    var body: some View {
        VStack {
            TextField("Enter your prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Task {
                    await generateText()
                }
            }) {
                Text("Generate Text")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(prompt.isEmpty || isGenerating)
            
            if isGenerating {
                ProgressView()
                    .padding()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !generatedText.isEmpty {
                Text(generatedText)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            printAllBundleFiles()
        }
    }
    
    private func generateText() async {
        logger.debug("Starting text generation with prompt: \(prompt)")
        isGenerating = true
        errorMessage = nil
        
        do {
            // Call LLMService.runExample() to generate text
            let service = LLMService()
            await service.runExample()
            generatedText = "Generated text for: \(prompt)"
            logger.debug("Text generated successfully")
        } catch {
            errorMessage = "Failed to generate text: \(error.localizedDescription)"
            logger.error("Text generation failed: \(error.localizedDescription)")
        }
        
        isGenerating = false
    }
    
    private func printAllBundleFiles() {
        let fileManager = FileManager.default
            let bundleURL = Bundle.main.bundleURL

            do {
                let items = try fileManager.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil)
                for item in items {
                    print(item.lastPathComponent)
                }
            } catch {
                print("❌ Failed to list top-level bundle files: \(error)")
            }
    }
}

#Preview {
    LLMView()
}
