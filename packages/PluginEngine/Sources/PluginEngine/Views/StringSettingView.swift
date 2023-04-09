//
//  SwiftUIView.swift
//
//
//  Created by Qiwei Li on 4/9/23.
//

import MenuBarSDK
import SwiftUI

struct StringSettingView: View {
    let setting: MenuBarSDK.Settings
    let onUpdateValue: OnUpdateValue

    @State var text: String

    init(setting: MenuBarSDK.Settings, onUpdateValue: @escaping OnUpdateValue) {
        self.setting = setting
        self.onUpdateValue = onUpdateValue
        let value = setting.value

        if let value = value?.value as? String {
            _text = .init(initialValue: value)
        } else {
            _text = .init(initialValue: "")
        }
    }

    var body: some View {
        TextField(setting.title, text: $text)
            .onChange(of: text) { newValue in
                self.onUpdateValue(setting.name, newValue)
            }
    }
}
