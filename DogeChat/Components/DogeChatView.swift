//
//  DogeChatView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/20.
//

import SwiftUI
import WebKit
import MarkdownUI
import OpenAIStreamingCompletions

struct DogeChatView: View {
    @EnvironmentObject var appConfig: AppConfig

    @Binding var conversation: Conversation
    @Binding var messages: [OpenAIAPI.Message]
    @State var input = ""
    @State var sendButtonColor = Color.gray
    @State var showRetry = false
    @State var showConfirmClearAlert = false
    @State var showClearSuccess = false
    @State private var completion: StreamingCompletion? = nil
    
    var body: some View {
        VStack {
            HStack {
                Image("doge")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor.opacity(0.7), lineWidth: 4))
                    .padding()
                Text("修勾Chat")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button(action: {
                    appConfig.activeSheet = .bootstrapConfigSheet
                }) {
                    Image(systemName: "gear")
                         .resizable()
                         .frame(width: 25, height: 25)
                         .padding(.leading)
                }
                .disabled(completion != nil)
                Button(action: {
                    showConfirmClearAlert = true
                }) {
                    Image(systemName: "trash")
                         .resizable()
                         .frame(width: 25, height: 25)
                         .padding()
                }
                .disabled(completion != nil)
                .alert(isPresented: $showConfirmClearAlert) {
                    // Confirmation
                    // Are you sure you want to clear all messages?
                    Alert(title: Text("确认"), message: Text("清除所有消息嘛？"),
                        primaryButton: .cancel(Text("取消")), secondaryButton: .default(Text("是的"), action: {
                        messages = [
                            .init(role: .system, content: "你好，我是修勾。有什么要问我的?")
                        ]
                        showClearSuccess = true
                    }))
                }
            }
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack {
                        ForEach(messages.indices, id: \.self) { index in
                            if messages[index].role == .user {
                                HStack {
                                    Spacer()
                                    MessageView(message: messages[index].content, isMe: true, removeSelfMessage: {
                                        messages.remove(at: index)
                                    })
                                }
                            } else {
                                HStack {
                                    MessageView(message: messages[index].content, isMe: false, removeSelfMessage: {
                                        messages.remove(at: index)
                                    })
                                    Spacer()
                                }
                            }
                        }
                        if let completion = completion {
                            CompletionView(completion: completion, showRetry: $showRetry, messages: $messages, destructSelfCompletion: desctructCompletion)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages) { _ in
                    withAnimation {
                        scrollViewProxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
                .onAppear {
                    withAnimation {
                        scrollViewProxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            
            if showRetry {
                Button(action: {
                    Task {
                        showRetry = false
                        await _sendMessage()
                    }
                }) {
                    // Retry Send
                    Text("重试")
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
            }
            HStack {
                MonthlyCost()
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                // Ask something...
                TextField("问问看...", text: $input)
                    .padding(10)
                    .background(completion == nil ? Color.gray.opacity(0.2) : Color.gray.opacity(0.6))
                    .cornerRadius(30)
                    .onChange(of: input) { newValue in
                        withAnimation {
                            sendButtonColor = newValue.isEmpty ? Color("BaseBackground") : Color.accentColor
                        }
                    }
                    .disabled(completion != nil)
                if input != "" {
                    Button(action: {
                        Task {
                            await sendMessage()
                            appConfig.usage = await appConfig.openAIAPITools.usage()
                        }
                    }) {
                        VStack {
                            // Send
                            Text("发送")
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .animation(.linear, value: 0.3)
                                .background(sendButtonColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    .disabled(input.isEmpty)
                }
            }
            .padding([.horizontal, .bottom])
            .onTapGesture {
                // hide keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle(conversation.outline ?? "新的聊天")
        }
    }
    
    func desctructCompletion() {
        self.completion = nil
    }
    
    func sendMessage() async {
        if(input != "") {
            messages.append(.init(role: .user, content: input))
            input = ""
            await _sendMessage()
        }
    }
    
    func _sendMessage() async {
        withAnimation {
            self.completion = try! appConfig.openAI_API.completeChatStreamingWithObservableObject(.init(messages: messages))
        }
    }
}

struct DogeChatView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppConfig())
    }
}

struct MonthlyCost: View {
    @EnvironmentObject var appConfig: AppConfig
    var usage: UsageResponse {
        appConfig.usage
    }
    var body: some View {
        HStack {
            if let totalUsage = usage.total_usage {
                Text("该月已经消费: ")
                    .font(.system(size: 14))
                    .bold()
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.accentColor)
                Text("$\(String(format: "%.2f", totalUsage / 100))")
                    .font(.system(size: 14))
                    .bold()
            }
        }
        .foregroundColor(.accentColor)
    }
}
