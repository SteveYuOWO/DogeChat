//
//  AppConfig.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI
import OpenAIStreamingCompletions

class AppConfig: ObservableObject {
    /// Basic properties
    @AppStorage("OPEN_AI_API_KEY")
    var OPEN_AI_API_KEY: String = ""
    @AppStorage("OPEN_AI_ORIGIN")
    var OPEN_AI_ORIGIN = "http://170.106.171.202"
    
    @Published var usage: UsageResponse = UsageResponse()
    @Published
    var activeSheet: ActiveSheet?
    
    /// constant variables
    let OPEN_AI_KEY_LINK = "https://platform.openai.com/account/api-keys"
    
    /// calculation variables
    var openAIAPITools: OpenAIAPITools {
        OpenAIAPITools(OPEN_AI_API_KEY: OPEN_AI_API_KEY, OPEN_AI_ORIGIN: OPEN_AI_ORIGIN)
    }
    var openAI_API: OpenAIAPI {
        OpenAIAPI(apiKey: OPEN_AI_API_KEY, origin: OPEN_AI_ORIGIN)
    }
}

enum ActiveSheet: Identifiable {
    case bootstrapConfigSheet, settingSheet
    
    var id: Int {
        hashValue
    }
}
