//
//  MuseScreen.swift
//  DailyMuse
//
//  Created by tough on 23/5/2025.
//

import SwiftUI
import os.log

struct MuseScreen: View {
    // MARK: - Properties
    @State private var viewModel = MuseViewModel()
    private let logger = Logger(subsystem: "com.dailymuse", category: "MuseScreen")
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background Color / Image 可放呢度
            
            VStack {
                Spacer() // 推動內容去垂直中間
                
                VStack(spacing: 20) {
                    Text("Your Muse:")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text(viewModel.generatedText)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Spacer() // 保持中間
                
                // Button 固定底部
                Button(action: {
                    Task {
                        await viewModel.generateContent()
                    }
                }) {
                    HStack {
                        if viewModel.isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                        Text(viewModel.isGenerating ? "Generating..." : "Generate")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isGenerating)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            
            // Error View
            if let error = viewModel.error {
                VStack {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .background(
            Group {
                if let image = viewModel.generatedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
    }
}

#Preview {
    MuseScreen()
} 
