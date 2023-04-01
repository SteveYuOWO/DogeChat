//
//  ContentView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appConfig: AppConfig
    var body: some View {
        ConversationListView()
            .onAppear {
                let validateResult = appConfig.openAIAPITools.validateOpenAIAPIKey()
                if  !validateResult {
                    appConfig.activeSheet = .bootstrapConfigSheet
                }
                Task {
                    appConfig.usage = await appConfig.openAIAPITools.usage()
                }
            }
            .sheet(item: $appConfig.activeSheet, onDismiss: {
                // onDismiss and no apikey, activate the bootstrapConfig
                let validateResult = appConfig.openAIAPITools.validateOpenAIAPIKey()
                if  !validateResult {
                    appConfig.activeSheet = .bootstrapConfigSheet
                }
            }) { item in
                switch item {
                case .bootstrapConfigSheet:
                    if #available(iOS 16.0, *) {
                        ConfigView()
                            .presentationDetents([.height(280), .medium, .large])
                            .presentationDragIndicator(.automatic)
                    } else {
                        // iOS 15 or earlier
                        ConfigView()
                    }
                case .settingSheet:
                    SettingView()
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
