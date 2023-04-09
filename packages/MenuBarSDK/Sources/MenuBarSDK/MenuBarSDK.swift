import AnyCodable
import Foundation
import SwiftUI

public protocol Client {
    /**
     Update the text input
     */
    func updateTextInput(text: String)

    /**
     Get the text input
     */
    func getTextInput() -> String

    /**
        Get the chat messages
     - Returns All of chat messages
     */
    func getChatMessages() -> [ChatMessage]

    /**
     Add a new message to the end of the chat history
     - Returns id: Message ID
     */
    func addChatMessage(message: ChatMessage) -> AddMessageResponse

    /**
     Remove chat message by id
     */
    func removeChatMessage(id: String)

    /**
     Update existing chat message
     - Parameter message: New Chat Message
     - Parameter id: Id of the message to update
     */
    func updateChatMessage(id: String, message: ChatMessage) -> UpdateMessageResponse
}

public protocol PluginInterface: Identifiable {
    var id: String { get }

    var client: Client { get }

    /**
     * Initialize the Plugin
     */
    func initialize() async throws

    /**
     * Get the Plugin Name
     */
    func getName() -> String

    /**
     System Image Name
     */
    func getIcon() -> String

    /**
     On input file
     */
    func onFile(fileURL: URL) async throws -> (ExecutionResult, URL)

    /**
     On textinput change
     */
    func onTextInputChange(text: String) async throws -> (ExecutionResult, String)

    /**
     On textinput submit
     */
    func onSubmit(text: String) async throws -> (ExecutionResult, String)

    func afterSubmit(message: ChatMessage) async throws -> (ExecutionResult, ChatMessage)

    /**
     On receive message
     */
    func onMessage(message: ChatMessage) async throws -> (ExecutionResult, ChatMessage)

    /**
     Render the message
     */
    func renderMessage(message: ChatMessage) -> (ExecutionResult, AnyView?)

    /**
     Render the bottom bar
     */
    func renderBottomBar(message: ChatMessage) -> (ExecutionResult, AnyView?)

    /**
     Render settings view
     */
    func renderSettingsView() -> (ExecutionResult, AnyView?)

    /**
     You can define the settings using either SettingsView or Settings.
     Only one of them should be implemented.
     */
    func settings() -> (ExecutionResult, [Settings])

    /**
     On history cleared
     */
    func onHistoryClear() async throws -> ExecutionResult

    /**
     Called on message delete
     */
    func onMessageDelete(id: String) async throws -> ExecutionResult

    /**
        Called on message update
     */
    func onMessageUpdate(id: String, message: ChatMessage) async throws -> ExecutionResult
}

public extension PluginInterface {
    func onFile(fileURL: URL) async throws -> (ExecutionResult, URL) {
        return (.skip, fileURL)
    }

    func onTextInputChange(text: String) async throws -> (ExecutionResult, String) {
        return (.skip, text)
    }

    func onSubmit(text: String) async throws -> (ExecutionResult, String) {
        return (.skip, text)
    }

    func afterSubmit(message: ChatMessage) async throws -> (ExecutionResult, ChatMessage) {
        return (.skip, message)
    }

    func onMessage(message: ChatMessage) async throws -> (ExecutionResult, ChatMessage) {
        return (.skip, message)
    }

    func renderMessage(message: ChatMessage) -> (ExecutionResult, AnyView?) {
        return (.skip, nil)
    }

    func renderBottomBar(message: ChatMessage) -> (ExecutionResult, AnyView?) {
        return (.skip, nil)
    }

    func renderSettingsView() -> (ExecutionResult, AnyView?) {
        return (.skip, nil)
    }

    func onHistoryClear() async throws -> ExecutionResult {
        return .skip
    }

    func onMessageDelete(id: String) async throws -> ExecutionResult {
        return .skip
    }

    func onMessageUpdate(id: String, message: ChatMessage) async throws -> ExecutionResult {
        return .skip
    }

    func settings() -> (ExecutionResult, [Settings]) {
        return (.skip, [])
    }
}
