//
//  SwiftUIView.swift
//
//
//  Created by Qiwei Li on 4/9/23.
//

import MenuBarSDK
import SwiftUI

typealias OnUpdateValue = (String, Any) -> Void
typealias GetSettingNames = () -> [(String, String)]
typealias GetSettingsByName = (String) -> [MenuBarSDK.Settings]?
typealias GetSettingsViewByName = (String) -> AnyView?
typealias Refresh = (String) async -> Void

struct SettingsView: View {
    let getSettingNames: GetSettingNames
    let getSettingsByName: GetSettingsByName
    let getSettingsViewByName: GetSettingsViewByName
    let refresh: Refresh
    @State var names: [(String, String)] = []

    var body: some View {
        VStack {
            TabView {
                ForEach(names, id: \.0) { name, icon in
                    VStack {
                        if let settings = getSettingsByName(name) {
                            SettingsList(settings: settings)
                        }
                        if let settingsView = getSettingsViewByName(name) {
                            settingsView
                        }
                        
                        HStack {
                            Button("Reload") {
                                Task {
                                    await refresh(name)
                                }
                            }
                        }
                    }
                    .tabItem {
                        Label(name, systemImage: icon)
                    }
                }
            }
        }
        .onAppear {
            self.names = self.getSettingNames()
        }
    }
}

struct SettingsList: View {
    let settings: [MenuBarSDK.Settings]

    var body: some View {
        Form {
            ForEach(self.settings, id: \.name) { setting in
                switch setting.type {
                    case .string:
                        StringSettingView(setting: setting, onUpdateValue: self.onUpdateValue)
                    case .int:
                        IntSettingView(setting: setting, onUpdateValue: self.onUpdateValue)
                    default:
                        EmptyView()
                }
            }
        }
        .padding()
    }

    func onUpdateValue(_ key: String, _ value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsList(settings: [])
    }
}
