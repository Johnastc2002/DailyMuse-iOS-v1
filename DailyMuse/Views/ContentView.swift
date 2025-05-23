//
//  ContentView.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import os.log

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to DailyMuse")
                    .font(.largeTitle)
                    .padding()
                
//                NavigationLink(destination: ImageGenerationView()) {
//                    Text("Generate Image")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
                
                NavigationLink(destination: LLMView()) {
                    Text("Chat with LLM")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
} 
