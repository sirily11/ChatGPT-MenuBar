import ChatGPTSwift
import Foundation
import MenuBarSDK

enum ChatGPTPluginError: Error {
    case invalidAPIKey
}

public class ChatGPTPlugin: PluginInterface {
    public var client: MenuBarSDK.Client
    public var id: String = "chat-gpt-plugin"
    internal var chatGPT: ChatGPTAPI!

    public func initialize() async throws {
        guard let apiKey = UserDefaults.standard.string(forKey: "chat-gpt-plugin.apikey") else {
            throw ChatGPTPluginError.invalidAPIKey
        }
        chatGPT = ChatGPTAPI(apiKey: apiKey)
        let messages: [Message] = client.getChatMessages().map { m in
            let role = m.role == .sender ? "user" : "assistant"
            if let message = m.message, let text = message.value as? String {
                return Message(role: role, content: text)
            } else {
                return Message(role: role, content: "")
            }
        }
        chatGPT.replaceHistoryList(with: messages)
    }

    public func getName() -> String {
        "chat-gpt-plugin"
    }

    public func getIcon() -> String {
        "character.bubble.fill"
    }

    public init(client: MenuBarSDK.Client) {
        self.client = client
    }

    public func settings() -> (ExecutionResult, [Settings]) {
        return (.continueExecution, [
            .init(name: "chat-gpt-plugin.apikey", title: "OpenAI API Key", type: .string)
        ])
    }

    @MainActor
    public func afterSubmit(message: ChatMessage) async throws -> (ExecutionResult, ChatMessage) {
        if let value = message.message?.value, let text = value as? String {
            let stream = try await chatGPT.sendMessageStream(text: text)
            let addResponse = client.addChatMessage(message: .init(role: .receiver, message: nil))
            var message = addResponse.message
            // Get the realtime output from the ChatGPT Stream
            // and update the message with the new text together with the previous text
            var id: String = addResponse.id
            for try await line in stream {
                // if we do have the previous message, we append the new line to the previous text
                if let previousMessage = message.message, let previousTextMessage = previousMessage.value as? String {
                    let updateResponse = client.updateChatMessage(id: id, message: .init(role: .receiver, message: .init(previousTextMessage + line)))
                    message = updateResponse.message
                    id = updateResponse.id
                } else {
                    let updateResponse = client.updateChatMessage(id: id, message: .init(role: .receiver, message: .init(line)))
                    message = updateResponse.message
                    id = updateResponse.id
                }
            }
            return (.continueExecution, message)
        }
        return (.skip, message)
    }

    public func onHistoryClear() async throws -> ExecutionResult {
        chatGPT.deleteHistoryList()
        return .continueExecution
    }
}
