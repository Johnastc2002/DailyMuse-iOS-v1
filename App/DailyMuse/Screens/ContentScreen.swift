//
//  ContentScreen.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import os.log

struct ContentScreen: View {
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.dailymuse", category: "ContentScreen")
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to DailyMuse")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: MuseScreen()) {
                    Text("Start Creating")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentScreen()
} 