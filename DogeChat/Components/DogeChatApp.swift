//
//  DogeChatApp.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI

@main
struct DogeChatApp: App {
    @StateObject var appConfig = AppConfig()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appConfig)
                .onTapGesture {
                    // hide keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
    }
}
