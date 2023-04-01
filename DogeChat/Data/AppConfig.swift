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
    
    /// constant variables
    let OPEN_AI_KEY_LINK = "https://platform.openai.com/account/api-keys"
    let OPEN_AI_ORIGIN = "http://170.106.171.202"
    
    var openAIAPITools: OpenAIAPITools {
        OpenAIAPITools(OPEN_AI_API_KEY: OPEN_AI_API_KEY, OPEN_AI_ORIGIN: OPEN_AI_ORIGIN)
    }
//    init() {
//        clearConfig()
//    }
    
//    func clearConfig() {
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
//    }
}

