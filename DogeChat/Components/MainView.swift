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
                    if appConfig.OPEN_AI_API_KEY.isEmpty {
                        showConfigView = true
                    }
                }
                .sheet(isPresented: $showConfigView, onDismiss: {
                    if appConfig.OPEN_AI_API_KEY.isEmpty {
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
