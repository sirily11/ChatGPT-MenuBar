//
//  ChatGPT_MenuBarApp.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/4/23.
//

import PluginEngine
import SwiftUI

@main
struct ChatGPT_MenuBarApp: App {
    @StateObject var pluginClient = PluginClient()
    @StateObject var pluginEngine = PluginEngine()

    var body: some Scene {
        MenuBarExtra("ChatGPT", systemImage: "character.bubble") {
            ContentView()
                .environmentObject(pluginClient)
                .environmentObject(pluginEngine)
        }
        .menuBarExtraStyle(.window)

        Settings {
            pluginEngine.renderSettingsView()
                .frame(minWidth: 400, minHeight: 300)
        }

        WindowGroup {
            Text("Home")
        }
    }
}
