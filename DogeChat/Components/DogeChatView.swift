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

struct HTMLView: UIViewRepresentable {
    let htmlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}

struct DogeChatView: View {
    @EnvironmentObject var appConfig: AppConfig
    @State var messages: [OpenAIAPI.Message] = [
        .init(role: .system, content: "你好，我是修勾。有什么要问我的?")
    ]
    @State var messageStream = ""
    @State var input = ""
    @State var sendButtonColor = Color.gray
    @State var showRetry = false
    @State var confirmClear = false
    
    @State private var completion: StreamingCompletion? = nil
    
    @Binding var showConfigView: Bool
    
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
                    showConfigView = true
                }) {
                    Image(systemName: "gear")
                         .resizable()
                         .frame(width: 25, height: 25)
                         .padding(.leading)
                }
                Button(action: {
                    self.confirmClear = true
                }) {
                    Image(systemName: "trash")
                         .resizable()
                         .frame(width: 25, height: 25)
                         .padding()
                }
                .alert(isPresented: $confirmClear) {
                    // Confirmation
                    // Are you sure you want to clear all messages?
                    Alert(title: Text("确认"), message: Text("清楚所有消息嘛？"),
                        primaryButton: .cancel(Text("取消")), secondaryButton: .default(Text("是的"), action: {
                        messages = [
                            .init(role: .system, content: "你好，我是修勾。有什么要问我的?")
                        ]
                        appConfig.toastTitle = "清除成功"
                        appConfig.showToast = true
                    }))
                }
            }
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
                        CompletionView(completion: completion, showRetry: $showRetry, destructSelfCompletion: desctructCompletion, appendMessage: { message in
                                messages.append(message)
                            }
                        )
                    }
                }
                .padding()
            }
            
            if showRetry {
                Button(action: {
                    Task {
                        showRetry = false
                        await _sendMessage()
                    }
                }) {
                    Text("Retry Send")
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
            }
            
            HStack {
                TextField("Ask something...", text: $input)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                    .onChange(of: input) { newValue in
                        withAnimation {
                            sendButtonColor = newValue.isEmpty ? Color.white : Color.accentColor
                        }
                    }
                if input != "" {
                    Button(action: {
                        Task {
                            await sendMessage()
                        }
                    }) {
                        Text("Send")
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .animation(.linear, value: 0.3)
                            .background(sendButtonColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .disabled(input.isEmpty)
                }
            }
            .padding([.horizontal, .bottom])
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
        self.completion = try! OpenAIAPI(apiKey: appConfig.OPEN_AI_API_KEY, origin: "http://66.135.0.79:443").completeChatStreamingWithObservableObject(.init(messages: messages))
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
}

struct ChatBubble: Shape {
    var isMe: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isMe ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        return Path(path.cgPath)
    }
}

struct MessageView: View {
    var message: String
    var isMe: Bool
    var removeSelfMessage: (() -> Void)?
    var body: some View {
        Markdown(message)
            .padding()
            .background(isMe ? Color.accentColor: Color("BubbleBackground"))
            .markdownTextStyle {
                ForegroundColor(Color("BubbleText"))
            }
            .clipShape(ChatBubble(isMe: isMe))
            .contextMenu {
                Button("复制") {
                    UIPasteboard.general.string = message
                }
                
                if let removeSelfMessage = removeSelfMessage {
                    Button("删除") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            removeSelfMessage()
                        }
                    }
                }
            }
    }
}

struct CompletionView: View {
    @ObservedObject var completion: StreamingCompletion
    @Binding var showRetry: Bool
    @State var showError: Bool = false
    var destructSelfCompletion: () -> Void
    var appendMessage: (_: OpenAIAPI.Message) -> Void
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
                appendMessage(.init(role: .system, content: completion.text))
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

struct DogeChatView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppConfig())
    }
}
