//
//  OpenAI.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/21.
//

import Foundation
import OpenAIStreamingCompletions

let OPEN_AI_KEY_LINK = "https://platform.openai.com/account/api-keys"
let OPEN_AI_ORIGIN = "http://66.135.0.79:443"

func validateOpenAIAPIKey(apiKey key: String) -> Bool {
    guard key.count == 51 else { return false }
    guard key.hasPrefix("sk-") else { return false }
    return true
}
