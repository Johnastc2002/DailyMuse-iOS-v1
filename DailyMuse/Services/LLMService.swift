//
//  LLMService.swift
//  DailyMuse
//
//  Created by tough on 23/5/2025.
//

import Foundation
import os.log

#if !targetEnvironment(simulator)
import MLCSwift
#endif

class LLMService {
    // MARK: - Properties
#if !targetEnvironment(simulator)
    private let engine = MLCEngine()
#endif
    private let modelPath = "bundle/Llama-3.2-3B-Instruct-q4f16_1-MLC"
    private let modelLib = "llama_q4f16_1_d44304359a2802d16aa168086928bcad"
    private let logger = Logger(subsystem: "com.dailymuse", category: "LLMService")
    
    // MARK: - Initialization
    init() {
  
    }
    
    func runExample() async {
#if targetEnvironment(simulator)

#else
        Task {
            guard let modelURL = Bundle.main.url(forResource: modelPath, withExtension: nil) else {
                logger.error("Model folder not found at path: \(self.modelPath)")
                fatalError("Model folder not found")
            }
            
            print("modelURL.path = \(modelURL.path)")
            
            await engine.reload(modelPath: modelURL.path, modelLib: modelLib)
            
            // run chat completion as in OpenAI API style
            for await res in await engine.chat.completions.create(
                messages: [
                    ChatCompletionMessage(
                        role: .user,
                        content: "What is the meaning of life?"
                    )
                ]
            ) {
                print(res.choices[0].delta.content!.asText())
            }
        }
#endif
    }
}
