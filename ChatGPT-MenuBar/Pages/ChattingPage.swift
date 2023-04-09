//
//  ChattingPage.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 4/5/23.
//

import MenuBarSDK
import PluginEngine
import SwiftUI

struct ChattingPage: View {
    @EnvironmentObject var pluginClient: PluginClient
    @EnvironmentObject var pluginEngine: PluginEngine

    var body: some View {
        VStack {
            HStack {
                Text("GPT Swift")
                    .fontWeight(.bold)
                Spacer()
                Button {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
            ChatList(chatHistory: pluginClient.chatHistroy)
            Spacer()
            HStack {
                Button {
                    pluginClient.clearMessages()
                } label: {
                    Image(systemName: "trash.fill")
                }

                TextField("Message", text: $pluginClient.textInputContent, axis: .vertical)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    .xcodeStyleFrame()
                    .onSubmit {
                        Task {
                            await onSubmit()
                        }
                    }

                Button("Send") {
                    Task {
                        await onSubmit()
                    }
                }
            }
        }
        .padding()
        .frame(width: 600, height: 500)
        .onAppear {
            print("Chatting")
        }
    }

    func onSubmit() async {
        let finalText = try? await pluginEngine.onSubmit(pluginClient.textInputContent)
        let message = pluginClient.addChatMessage(message: .init(role: .sender, message: .init(finalText)))
        pluginClient.updateTextInput(text: "")
        _ = try? await pluginEngine.afterSubmit(message.message)
        pluginClient.saveMessages()
    }
}

extension View {
    func xcodeStyleFrame() -> some View {
        clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.black.opacity(0.3), style: .init(lineWidth: 1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(Color.white.opacity(0.2), style: .init(lineWidth: 1))
                    .padding(1)
            )
    }
}

struct ChattingPage_Previews: PreviewProvider {
    static var previews: some View {
        ChattingPage()
    }
}
