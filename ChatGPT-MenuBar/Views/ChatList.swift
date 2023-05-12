//
//  ChatList.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/5/23.
//

import AnyCodable
import MarkdownUI
import MenuBarSDK
import PluginEngine
import SwiftUI

struct ChatList: View {
    @EnvironmentObject var engine: PluginEngine
    let chatHistory: [ChatMessage]

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(chatHistory) { history in
                        Group {
                            if history.role == .sender {
                                ChatBubble(direction: .right) {
                                    engine.renderMessage(message: history)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.blue)
                                }
                            } else {
                                ChatBubble(direction: .left) {
                                    engine.renderMessage(message: history)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color(NSColor.darkGray))
                                }
                            }
                        }.id(history.id)
                            .contextMenu {
                                if let message = history.message, let text = message.value as? String {
                                    Button("Copy") {
                                        NSPasteboard.general.clearContents()
                                        NSPasteboard.general.setString(text, forType: .string)
                                    }
                                }
                            }
                    }
                }
                .onChange(of: chatHistory, perform: { newHistory in
                    if newHistory.endIndex > 0 {
                        scrollView.scrollTo(newHistory[newHistory.endIndex - 1].id)
                    }
                })
            }
        }
    }
}

// struct ChatList_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatList(chatHistory: [
//            .init(role: .sender, message: """
//            # Hello world
//            ```swift
//            print("Hello world")
//            ```
//            """),
//            .init(role: .receiver, message: "World")
//        ])
//    }
// }
