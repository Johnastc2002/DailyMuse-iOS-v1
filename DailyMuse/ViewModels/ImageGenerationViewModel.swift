//
//  ImageGenerationViewModel.swift
//  DailyMuse
//
//  Created by tough on 16/5/2025.
//

import SwiftUI
import os.log
import Observation

@Observable final class ImageGenerationViewModel {
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.dailymuse", category: "ImageGeneration")
    private let service: StableDiffusionService?
    private let settings: AppSettings
    
    // State
    var isGenerating = false
    var error: Error?
    var generatedImage: UIImage?
    
    // MARK: - Initialization
    init(service: StableDiffusionService? = nil, settings: AppSettings = AppSettings()) {
        do {
            self.service = try service ?? StableDiffusionService()
            self.settings = settings
        } catch {
            // Handle initialization error
            logger.error("Failed to initialize StableDiffusionService: \(error.localizedDescription)")
            self.service = nil
            self.settings = settings
        }
    }
    
    // MARK: - Actions
    func generateImage(from prompt: String) async {
        guard !prompt.isEmpty else { return }
        
        logger.debug("Starting image generation for prompt: \(prompt)")
        isGenerating = true
        error = nil
        
        do {
            let image = try await service?.generateImage(from: prompt)
            
            await MainActor.run {
                generatedImage = image
                isGenerating = false
            }
            
            if settings.saveToPhotos {
                saveImage()
            }
            
            logger.debug("Image generation completed successfully")
        } catch {
            logger.error("Image generation failed: \(error.localizedDescription)")
            
            await MainActor.run {
                self.error = error
                isGenerating = false
            }
        }
    }
    
    func clearGeneratedImage() {
        generatedImage = nil
        error = nil
    }
    
    private func saveImage() {
        guard let image = generatedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
} 