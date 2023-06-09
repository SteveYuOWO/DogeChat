//
//  ConfigView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/22.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var appConfig: AppConfig
    @State private var showAPIKeyError = false
    @State private var submitButtonBackground = Color.accentColor.opacity(0.7)
    @State private var show = true
    
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        VStack {
            if isPad {
                Image("doge")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .padding(.bottom, 40)
            }
            
            Text("设置 API KEY 后开始使用 APP")
                .bold()
                .font(.system(size: 20))
                .padding()
                .padding(.bottom, 14)
            
            SecureField("OpenAI API KEY", text: $appConfig.OPEN_AI_API_KEY)
                .frame(maxWidth: isPad ? 400: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color.accentColor, lineWidth: 1.0)
                )
                .padding(.bottom, 20)
                .onChange(of: appConfig.OPEN_AI_API_KEY) { newValue in
                    withAnimation {
                        submitButtonBackground = newValue == "" ? Color.accentColor.opacity(0.7) : Color.accentColor
                    }
                }
            
            Button(action: {
                if appConfig.openAIAPITools.validateOpenAIAPIKey() {
                    appConfig.activeSheet = nil
                } else {
                    appConfig.activeSheet = .bootstrapConfigSheet
                }
            }) {
                    Text("继续")
                        .frame(maxWidth: isPad ? 400: .infinity)
                        .foregroundColor(.white)
                        .padding()
            }
            .disabled(appConfig.OPEN_AI_API_KEY.isEmpty)
            .background(submitButtonBackground)
            
            Button(action: {
                UIApplication.shared.open(URL(string: appConfig.OPEN_AI_KEY_LINK)!)
            }) {
                Text("在 OpenAI 上寻找你的 API KEY")
                // Find your API KEY at OpenAI
                    .font(.caption)
                    .underline()
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .padding(.top, 50)
        .padding(.bottom, 25)
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .alert(isPresented: $showAPIKeyError) {
            Alert(
                title: Text("Invalid API KEY"),
                message: Text("The apikey is unavailable or has expired"),
                dismissButton: .default(Text("Close"))
            )
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppConfig())
    }
}
