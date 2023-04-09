//
//  SwiftUIView.swift
//
//
//  Created by Qiwei Li on 4/9/23.
//

import MenuBarSDK
import SwiftUI

struct IntSettingView: View {
    let setting: MenuBarSDK.Settings
    let onUpdateValue: OnUpdateValue

    @State var text: String

    init(setting: MenuBarSDK.Settings, onUpdateValue: @escaping OnUpdateValue) {
        self.setting = setting
        self.onUpdateValue = onUpdateValue

        if let value = setting.value?.value as? Int {
            _text = .init(initialValue: String(value))
        } else {
            _text = .init(initialValue: "")
        }
    }

    var body: some View {
        TextField(setting.title, text: $text)
            .onChange(of: text) { newValue in
                let intValue = Int(newValue) ?? 0
                self.onUpdateValue(setting.name, intValue)
                self.text = String(intValue)
            }
    }
}
