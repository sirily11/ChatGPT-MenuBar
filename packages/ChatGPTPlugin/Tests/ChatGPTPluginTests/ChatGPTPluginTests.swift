@testable import ChatGPTPlugin
import MenuBarSDK
import XCTest
import ChatGPTSwift

struct MockClient: Client {
    func updateTextInput(text: String) {}
    
    func getTextInput() -> String {
        "Hello world"
    }
    
    func getChatMessages() -> [MenuBarSDK.ChatMessage] {
        return []
    }
    
    func addChatMessage(message: MenuBarSDK.ChatMessage) -> MenuBarSDK.AddMessageResponse {
        return .init(id: "1", message: message)
    }
    
    func removeChatMessage(id: String) {}
    
    func updateChatMessage(id: String, message: MenuBarSDK.ChatMessage) -> MenuBarSDK.updateMessageResponse {
        return .init(id: id, message: message)
    }
}

final class ChatGPTPluginTests: XCTestCase {
    func testFailedToInitialize() async throws {
        let chatGPTPlugin = ChatGPTPlugin(client: MockClient())
        XCTAssertNil(chatGPTPlugin.chatGPT)
        // after calling initialize without valid apiKey
        do {
            try await chatGPTPlugin.initialize()
        } catch {
            XCTAssertEqual(error.localizedDescription, ChatGPTPluginError.invalidAPIKey.localizedDescription)
            XCTAssertNil(chatGPTPlugin.chatGPT)
        }
    }
    
    func testSuccessTpInitialize() async throws {
        let chatGPTPlugin = ChatGPTPlugin(client: MockClient())
        XCTAssertNil(chatGPTPlugin.chatGPT)
        UserDefaults.standard.set("somekey", forKey: "chat-gpt-plugin.apikey")
        try await chatGPTPlugin.initialize()
        XCTAssertNotNil(chatGPTPlugin.chatGPT)
    }
}
