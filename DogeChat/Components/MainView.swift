//
//  ContentView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appConfig: AppConfig
    @State var showConfigView: Bool = false
    var body: some View {
        ZStack {
            DogeChatView(showConfigView: $showConfigView)
                .onAppear {
                    let validateResult = appConfig.openAIAPITools.validateOpenAIAPIKey()
                    if  !validateResult {
                        showConfigView = true
                    }
                    Task {
                        appConfig.usage = await appConfig.openAIAPITools.usage()
                    }
                }
                .sheet(isPresented: $showConfigView, onDismiss: {
                    let validateResult = appConfig.openAIAPITools.validateOpenAIAPIKey()
                    if  !validateResult {
                        showConfigView = true
                    }
                }) {
                    if #available(iOS 16.0, *) {
                        ConfigView(showConfigView: $showConfigView)
                            .presentationDetents([.height(280), .medium, .large])
                            .presentationDragIndicator(.automatic)
                    } else {
                        // iOS 15 or earlier
                        ConfigView(showConfigView: $showConfigView)
                    }
                }
                    
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppConfig())
    }
}
