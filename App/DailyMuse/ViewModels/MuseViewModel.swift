//
//  MuseViewModel.swift
//  DailyMuse
//
//  Created by tough on 23/5/2025.
//

import SwiftUI
import os.log
import Observation

@Observable final class MuseViewModel {
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.dailymuse", category: "MuseViewModel")
    private let llmService: LLMService
    private let stableDiffusionService: StableDiffusionService
    
    // State
    var isGenerating = false
    var error: Error?
    var generatedImage: UIImage?
    var generatedText: String = ""

    // MARK: - Initialization
    init(llmService: LLMService = LLMService(), 
         stableDiffusionService: StableDiffusionService? = nil) {
        self.llmService = llmService
        do {
            self.stableDiffusionService = try stableDiffusionService ?? StableDiffusionService()
        } catch {
            fatalError("Failed to initialize StableDiffusionService: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Actions
    func generateContent() async {
        logger.debug("Starting content generation")
        isGenerating = true
        error = nil
        
        do {
            // First generate text using LLM
            generatedText = await llmService.generateMuse()
//            generatedAnswer = await llmService.generateMuseAnswer(question: generatedQuestion)

            // Then generate image using Stable Diffusion
            try stableDiffusionService.initalize()
            let styles = [
                "digital art", "oil painting", "flat design",
                 "surrealism", "watercolor"
            ]

            let lighting = [
                "cinematic lighting", "soft light", "rim light", "studio lighting",
                "sunset lighting", "volumetric light"
            ]

            let palettes = [
                "pastel palette", "warm colors", "earth tones", "gradient tones"
            ]

            let mood = [
                "dreamy", "uplifting", "serene", "romantic"
            ]

            let prompt = """
            A calm, masterpiece painting visualization of \(generatedText), \(lighting.randomElement()!), \(palettes.randomElement()!), \(mood.randomElement()!), \(styles.randomElement()!)
            """
            generatedImage = try await stableDiffusionService.generateImage(from: prompt)
//            await MainActor.run {
//                self.generatedImage = image
//            }
            
            logger.debug("Content generation completed successfully")
        } catch {
            logger.error("Content generation failed: \(error.localizedDescription)")
            await MainActor.run {
                self.error = error
            }
        }
        
        await MainActor.run {
            isGenerating = false
        }
    }
} 
