//
//  File.swift
//
//
//  Created by Qiwei Li on 4/9/23.
//

import Foundation
import MenuBarSDK

public class PluginClient: Client, ObservableObject {
    @Published public var textInputContent: String = ""
    @Published public var chatHistroy: [ChatMessage] = []
    
    public init() {
        chatHistroy =  ChatMessageModel.load()
    }
    
    @MainActor
    public func updateTextInput(text: String) {
        textInputContent = text
    }
    
    public func getTextInput() -> String {
        return textInputContent
    }
    
    public func getChatMessages() -> [MenuBarSDK.ChatMessage] {
        return chatHistroy
    }
    
    @MainActor
    public func addChatMessage(message: MenuBarSDK.ChatMessage) -> MenuBarSDK.AddMessageResponse {
        chatHistroy.append(message)
        return MenuBarSDK.AddMessageResponse(id: message.id.uuidString, message: message)
    }
    
    @MainActor
    public func removeChatMessage(id: String) {
        chatHistroy.removeAll(where: { $0.id.uuidString == id })
    }
    
    @MainActor
    public func updateChatMessage(id: String, message: MenuBarSDK.ChatMessage) -> MenuBarSDK.UpdateMessageResponse {
        for i in 0 ..< chatHistroy.count {
            let messageId = chatHistroy[i].id.uuidString
            if messageId == id {
                chatHistroy[i] = message
                break
            }
        }
        return MenuBarSDK.UpdateMessageResponse(id: message.id.uuidString, message: message)
    }
    
    public func saveMessages() {
        ChatMessageModel.save(with: chatHistroy)
    }
}
