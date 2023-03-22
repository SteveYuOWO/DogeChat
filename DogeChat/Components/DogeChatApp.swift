//
//  DogeChatApp.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI

@main
struct DogeChatApp: App {
    var appConfig = AppConfig()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appConfig)
        }
    }
}
