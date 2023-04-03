//
//  ConversationListView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/4/1.
//

import SwiftUI
import OpenAIStreamingCompletions

struct ConversationListView: View {
    @StateObject var conversationsStore: ConversationStore = ConversationStore()
    private var defaultMessage: [OpenAIAPI.Message] = [.init(role: .system, content: "你好，我是修勾。有什么要问我的?")]
    var body: some View {
        NavigationView {
            List {
                // Conversations
                Section(header:
                            HStack {
                        Text("对话")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                conversationsStore.conversations.append(.init(id: conversationsStore.conversations.count, messages: defaultMessage))
                                conversationsStore.conversations[conversationsStore.conversations.count - 1].isActive = true
                            }
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .foregroundColor(.accentColor)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 12)
                    }
                ) {
                    ForEach($conversationsStore.conversations, id: \.id) { $conversation in
                        NavigationLink(destination: DogeChatView(conversation: $conversation, messages: $conversation.messages), isActive: $conversation.isActive) {
                            Label(conversation.outline ?? "新的聊天", systemImage: "captions.bubble")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .onDelete { offsets in
                        conversationsStore.conversations.remove(atOffsets: offsets)
                    }
                    .onMove { from, to in
                        conversationsStore.conversations.move(fromOffsets: from, toOffset: to)
                    }
                }
                .onReceive(conversationsStore.$conversations) { value in
                    conversationsStore.save()
                }
                
//                // Prompt Template
//                Section(header:
//                    Text("提示词模板")
//                        .font(.title3)
//                        .bold()
//                        .padding(.bottom, 12)
//                ) {
//                    Label("翻译文本", systemImage: "character.bubble")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                    Label("求职练习", systemImage: "doc.text")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                    Label("逻辑计算", systemImage: "captions.bubble")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                    Label("小红书", systemImage: "captions.bubble")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                }
//
//                // Online Store
//                Section(header:
//                    Text("在线商店")
//                        .font(.title3)
//                        .bold()
//                        .padding(.bottom, 12)
//                ) {
//                    Label("笑话生成器", systemImage: "captions.bubble")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                    Label("AI 佛祖普渡众生", systemImage: "captions.bubble")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                    Label("查看更多", systemImage: "ellipsis")
//                        .font(.headline)
//                        .foregroundColor(.accentColor)
//                }
           }
        }
    }
}
