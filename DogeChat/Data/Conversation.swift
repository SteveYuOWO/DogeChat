//
//  Conversations.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/31.
//

import Foundation
import OpenAIStreamingCompletions

class Conversation: Identifiable, ObservableObject {
    let id: Int
    @Published var messages: [OpenAIAPI.Message]
    @Published var isActive: Bool = false
    var input: String?
    var outline: String?

    init(id: Int, messages: [OpenAIAPI.Message], input: String? = nil, outline: String? = nil) {
        self.id = id
        self.messages = messages
        self.input = input
        self.outline = outline
    }
}

struct ConversationData: Codable {
    var id: Int
    var messages: [OpenAIAPI.Message]
    var outline: String?
    
    init(id: Int, messages: [OpenAIAPI.Message], outline: String? = nil) {
        self.id = id
        self.messages = messages
        self.outline = outline
    }
}

class ConversationStore: ObservableObject {
    @Published var conversations: [Conversation] = Conversation.sampleData
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("dogechat.conversations")
    }
    
    init() {
        self.load()
    }
    
    public func load() {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try ConversationStore.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        self.conversations = Conversation.sampleData
                    }
                    return
                }
                let decodedConversationsData = try JSONDecoder().decode([ConversationData].self, from: file.availableData)
                DispatchQueue.main.async {
                    self.conversations = decodedConversationsData.map{ Conversation(id: $0.id, messages: $0.messages, outline: $0.outline) }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func save() {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(self.conversations.map{ConversationData(id: $0.id, messages: $0.messages, outline: $0.outline)})
                let outfile = try ConversationStore.fileURL()
                try data.write(to: outfile)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
