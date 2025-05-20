//
//  StableDiffusionError.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import Foundation

enum StableDiffusionError: LocalizedError {
    case modelLoadFailed
    case generationFailed
    
    var errorDescription: String? {
        switch self {
        case .modelLoadFailed:
            return "Failed to load Stable Diffusion model"
        case .generationFailed:
            return "Failed to generate image"
        }
    }
} 