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
    
    /// Toast properties
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMessage = ""
    
//    init() {
//        clearConfig()
//    }
    
//    func clearConfig() {
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
//    }
}

