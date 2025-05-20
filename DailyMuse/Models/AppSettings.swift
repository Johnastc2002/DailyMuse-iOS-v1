//
//  AppSettings.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import Observation

@Observable final class AppSettings {
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    
    var showDateStamp: Bool {
        get { defaults.bool(forKey: "showDateStamp") }
        set { defaults.set(newValue, forKey: "showDateStamp") }
    }
    
    var saveToPhotos: Bool {
        get { defaults.bool(forKey: "saveToPhotos") }
        set { defaults.set(newValue, forKey: "saveToPhotos") }
    }
    
    var imageStyle: String {
        get { defaults.string(forKey: "imageStyle") ?? "vibrant" }
        set { defaults.set(newValue, forKey: "imageStyle") }
    }
    
    // MARK: - Singleton
    static let shared = AppSettings()
    
    // MARK: - Initialization
    init() {
        // Set default values if not already set
        if !defaults.contains(key: "showDateStamp") {
            defaults.set(true, forKey: "showDateStamp")
        }
        if !defaults.contains(key: "saveToPhotos") {
            defaults.set(true, forKey: "saveToPhotos")
        }
        if !defaults.contains(key: "imageStyle") {
            defaults.set("vibrant", forKey: "imageStyle")
        }
    }
}

// MARK: - UserDefaults Extension
private extension UserDefaults {
    func contains(key: String) -> Bool {
        return object(forKey: key) != nil
    }
} 