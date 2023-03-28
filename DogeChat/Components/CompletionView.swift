//
//  CompletionView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/23.
//

import SwiftUI
import OpenAIStreamingCompletions

struct CompletionView: View {
    @ObservedObject var completion: StreamingCompletion
    @Binding var showRetry: Bool
    @State var showError: Bool = false
    @Binding var messages: [OpenAIAPI.Message]
    
    let destructSelfCompletion: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                MessageView(message: completion.text.isEmpty ? "...": completion.text, isMe: false)
                Spacer()
            }
        }
        .onReceive(completion.$status) { status in
            switch status {
            case .error:
                showError = true
                showRetry = true
            case .complete:
                messages.append(.init(role: .system, content: completion.text))
                destructSelfCompletion()
            case .loading:
                break
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Network Error"),
                message: Text("Please check your network"),
                dismissButton: .default(Text("Close"), action: destructSelfCompletion)
            )
        }
    }
}
