//
//  ContentView.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/4/23.
//

import ChatGPTPlugin
import PluginEngine
import SwiftUI
import MarkdownRenderingPlugin

struct ContentView: View {
    @EnvironmentObject var client: PluginClient
    @EnvironmentObject var engine: PluginEngine

    var body: some View {
        ChattingPage()
            .task {
                _ = try? await engine.addPlugin(ChatGPTPlugin(client: client))
                _ = try? await engine.addPlugin(MarkdownRenderingPlugin(client: client))
            }
    }
}
