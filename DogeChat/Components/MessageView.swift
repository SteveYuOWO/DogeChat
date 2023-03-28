//
//  MessageView.swift
//  DogeChat
//
//  Created by Steve Yu on 2023/3/23.
//

import SwiftUI
import MarkdownUI

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
