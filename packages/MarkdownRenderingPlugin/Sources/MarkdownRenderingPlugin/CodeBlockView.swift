//
//  CodeBlockView.swift
//  ChatGPT-MenuBar
//
//  Created by Qiwei Li on 5/12/23.
//

import MarkdownUI
import SwiftUI

struct CodeBlockView: View {
    @State var copied: Bool = false

    let configuration: CodeBlockConfiguration

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    Task {
                        await onCopied()
                    }
                }, label: {
                    if copied {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "doc.on.doc.fill")
                    }
                })
                .padding([.top, .trailing], 5.0)
            }
            ScrollView(.horizontal) {
                configuration.label
                    .relativeLineSpacing(.em(0.225))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                    }
                    .padding(16)
            }
        }
        .background(Color.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .markdownMargin(top: 0, bottom: 16)
    }

    func onCopied() async {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(configuration.content, forType: .string)
        copied = true
        // Wait 1.5 secs
        try? await Task.sleep(for: .seconds(1.5))
        withAnimation {
            copied = false
        }
    }
}
