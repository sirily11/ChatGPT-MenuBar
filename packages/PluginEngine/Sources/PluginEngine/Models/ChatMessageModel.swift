//
//  File.swift
//
//
//  Created by Qiwei Li on 4/10/23.
//

import Foundation
import MenuBarSDK

private func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

enum ChatMessageModel {
    static func save(with data: [ChatMessage]) {
        let filename = getDocumentsDirectory().appendingPathComponent("messages.json")

        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }

    static func load() -> [ChatMessage] {
        let filename = getDocumentsDirectory().appendingPathComponent("messages.json")

        do {
            let data = try Data(contentsOf: filename)
            let messages = try JSONDecoder().decode([ChatMessage].self, from: data)
            return messages
        } catch {
            return []
        }
    }

    static func clear() {
        let filename = getDocumentsDirectory().appendingPathComponent("messages.json")
        do {
            try FileManager.default.removeItem(at: filename)
        } catch {
            print("Unable to delete data.")
        }
    }
}
