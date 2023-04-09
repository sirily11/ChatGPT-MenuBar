//
//  ContentView.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/4/23.
//

import ChatGPTPlugin
import PluginEngine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var client: PluginClient
    @EnvironmentObject var engine: PluginEngine

    var body: some View {
        ChattingPage()
            .task {
                try? await engine.addPlugin(ChatGPTPlugin(client: client))
            }
    }
}
