//
//  ChatList.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/5/23.
//

import AnyCodable
import MarkdownUI
import MenuBarSDK
import SwiftUI

struct ChatList: View {
    let chatHistory: [ChatMessage]

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(chatHistory) { history in
                        Group {
                            if history.role == .sender {
                                ChatBubble(direction: .right) {
                                    buildContentView(message: history.message)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.blue)
                                }
                            } else {
                                ChatBubble(direction: .left) {
                                    buildContentView(message: history.message)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.gray)
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

    @ViewBuilder
    func buildContentView(message: AnyCodable?) -> some View {
        if let message = message?.value as? String {
            Markdown(message)
                .markdownTheme(.chatTheme)
                .markdownCodeSyntaxHighlighter(SplashCodeSyntaxHighlighter(theme: .wwdc18(withFont: .init(size: 14))))
                .textSelection(.enabled)
        }
        EmptyView()
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList(chatHistory: [
            .init(role: .sender, message: """
            # Hello world
            ```swift
            print("Hello world")
            ```
            """),
            .init(role: .receiver, message: "World")
        ])
    }
}
