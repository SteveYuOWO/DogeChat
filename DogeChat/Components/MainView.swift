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
            NavigationView {
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
                        ConfigView(showConfigView: $showConfigView)
                            .presentationDetents([.height(280), .medium, .large])
//                            .presentationDetents([.height(420), .medium, .large])
                            .presentationDragIndicator(.automatic)
                    }
                    
            }
            .alert(isPresented: $appConfig.showToast) {
                Alert(title: Text(appConfig.toastTitle),
                      message: Text(appConfig.toastMessage),
                      dismissButton: .default(Text("好的")))
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
