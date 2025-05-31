//
//  SettingsScreen.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import os.log

struct SettingsScreen: View {
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    @State private var settings = AppSettings.shared
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("Image Settings") {
                    Toggle("Show Date Stamp", isOn: Binding(
                        get: { settings.showDateStamp },
                        set: { settings.showDateStamp = $0 }
                    ))
                    
                    Toggle("Save to Photos", isOn: Binding(
                        get: { settings.saveToPhotos },
                        set: { settings.saveToPhotos = $0 }
                    ))
                    
                    Picker("Style", selection: Binding(
                        get: { settings.imageStyle },
                        set: { settings.imageStyle = $0 }
                    )) {
                        Text("Vibrant").tag("vibrant")
                        Text("Muted").tag("muted")
                        Text("Sketch").tag("sketch")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsScreen()
} 