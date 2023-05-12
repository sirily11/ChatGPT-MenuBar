import MarkdownUI
import MenuBarSDK
import SwiftUI

public class MarkdownRenderingPlugin: PluginInterface {
    public var id: String = "markdown-rendering"
    
    public var client: MenuBarSDK.Client
    
    public init(client: MenuBarSDK.Client) {
        self.client = client
    }
    
    public func initialize() async throws {}
    
    public func getName() -> String {
        return "MarkdownRendering"
    }
    
    public func getIcon() -> String {
        "text.badge.minus"
    }
    
    public func settings() -> (ExecutionResult, [MenuBarSDK.Settings]) {
        return (ExecutionResult.continueExecution, [])
    }
    
    public func renderMessage(message: ChatMessage) -> (ExecutionResult, AnyView?) {
        if let message = message.message?.value as? String {
            return (ExecutionResult.continueExecution, AnyView(Markdown(message)
                    .markdownTheme(.chatTheme)
                    .markdownCodeSyntaxHighlighter(SplashCodeSyntaxHighlighter(theme: .wwdc18(withFont: .init(size: 14))))
                    .textSelection(.enabled))) // TODO: render
        }
        return (ExecutionResult.skip, nil)
    }
}
