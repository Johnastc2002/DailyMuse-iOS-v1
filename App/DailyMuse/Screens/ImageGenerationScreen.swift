//
//  ImageGenerationScreen.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import os.log

struct ImageGenerationScreen: View {
    // MARK: - Properties
    @State private var promptText = "Happy dog"
    @State private var showingSettings = false
    @State private var viewModel = ImageGenerationViewModel()
    
    private let logger = Logger(subsystem: "com.dailymuse", category: "ImageGenerationScreen")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Prompt Input
                TextField("Enter your creative prompt...", text: $promptText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disabled(viewModel.isGenerating)
                
                // Generate Button
                Button(action: generateImage) {
                    HStack {
                        if viewModel.isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                        Text(viewModel.isGenerating ? "Generating..." : "Generate Art")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(promptText.isEmpty || viewModel.isGenerating)
                
                // Error View
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Generated Image View
                if let image = viewModel.generatedImage {
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding()
                        
                        // Share Button
                        ShareLink(item: Image(uiImage: image), preview: SharePreview("Generated Art")) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("DailyMuse")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
                
                if viewModel.generatedImage != nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { viewModel.clearGeneratedImage() }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsScreen()
            }
        }
    }
    
    // MARK: - Actions
    private func generateImage() {
        Task {
            await viewModel.generateImage(from: promptText)
        }
    }
}

#Preview {
    ImageGenerationScreen()
} 