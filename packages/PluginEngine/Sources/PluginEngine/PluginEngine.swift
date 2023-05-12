import MenuBarSDK
import SwiftUI

public class PluginEngine: ObservableObject {
    private(set) var plugins: [any PluginInterface] = []
    public init() {}

    /**
     Adds a plugin to the plugin engine
     */
    public func addPlugin(_ plugin: any PluginInterface) async throws -> Self {
        try? await plugin.initialize()
        plugins.append(plugin)
        return self
    }

    public func removePlugin(_ plugin: any PluginInterface) -> Self {
        plugins.removeAll { $0.id == plugin.id }
        return self
    }

    public func getPlugin(id: String) -> (any PluginInterface)? {
        return plugins.first { $0.id == id }
    }

    public func getPlugin(by name: String) -> (any PluginInterface)? {
        return plugins.first { $0.getName() == name }
    }

    /**
      Called when the user clicks on the menu bar icon
     */
    @MainActor
    public func onTextInputChange(_ text: String) async throws {
        var inputText = text

        for plugin in plugins {
            let (result, text) = try await plugin.onTextInputChange(text: inputText)
            if result == .continueExecution {
                inputText = text
            }
            else if result == .skip {
                continue
            }
            else if result == .stop {
                break
            }
        }
    }

    @MainActor
    public func onSubmit(_ text: String) async throws -> String {
        var inputText = text
        for plugin in plugins {
            let (result, text) = try await plugin.onSubmit(text: inputText)
            if result == .continueExecution {
                inputText = text
            }
            else if result == .skip {
                continue
            }
            else if result == .stop {
                break
            }
        }
        return inputText
    }

    @MainActor
    public func afterSubmit(_ message: ChatMessage) async throws -> ChatMessage {
        var inputMessage = message
        for plugin in plugins {
            let (result, text) = try await plugin.afterSubmit(message: inputMessage)
            if result == .continueExecution {
                inputMessage = text
            }
            else if result == .skip {
                continue
            }
            else if result == .stop {
                break
            }
        }
        return inputMessage
    }

    @MainActor
    public func onHistoryClear() async throws {
        for plugin in plugins {
            let result = try await plugin.onHistoryClear()
            if result == .skip {
                continue
            }
            else if result == .stop {
                break
            }
        }
    }

    @ViewBuilder
    public func renderSettingsView() -> some View {
        SettingsView {
            self.getPluginsWithSettings().map { ($0.getName(), $0.getIcon()) }
        } getSettingsByName: { name in
            let plugin = self.getPlugin(by: name)
            if let plugin = plugin {
                let (_, settings) = plugin.settings()
                return settings
            }
            return nil
        } getSettingsViewByName: { name in
            let plugin = self.getPlugin(by: name)
            if let plugin = plugin {
                let (_, view) = plugin.renderSettingsView()
                return view
            }
            return nil
        } refresh: { name in
            let plugin = self.getPlugin(by: name)
            if let plugin = plugin {
                try? await plugin.initialize()
            }
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}

extension PluginEngine {
    func getPluginsWithSettings() -> [any PluginInterface] {
        return plugins.filter {
            let (settingsViewResult, _) = $0.renderSettingsView()
            let (settingsResult, _) = $0.settings()
            return settingsResult != .skip || settingsViewResult != .skip
        }
    }
}
