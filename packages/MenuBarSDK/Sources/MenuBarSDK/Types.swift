//
//  File.swift
//
//
//  Created by Qiwei Li on 4/6/23.
//

import AnyCodable
import Foundation

public enum ExecutionResult {
    case skip
    case stop
    case continueExecution
}

public enum Role: String, Codable {
    case sender = "Sender"
    case receiver = "Receiver"
}

public enum UIType {
    case int
    case string
    case boolean
}

public struct ChatMessage: Identifiable, Hashable, Codable {
    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }

    public var id = UUID()
    public var role: Role
    public var message: AnyCodable?

    public init(role: Role, message: AnyCodable) {
        self.role = role
        self.message = message
    }
}

public struct AddMessageResponse {
    public let id: String
    public let message: ChatMessage

    public init(id: String, message: ChatMessage) {
        self.id = id
        self.message = message
    }
}

public struct UpdateMessageResponse {
    public let id: String
    public let message: ChatMessage

    public init(id: String, message: ChatMessage) {
        self.id = id
        self.message = message
    }
}

public struct Settings {
    public let name: String
    public let title: String
    public let type: UIType
    public var value: AnyCodable? {
        get {
            switch type {
                case .int:
                    let value = UserDefaults.standard.integer(forKey: name)
                    return .init(value)
                case .string:
                    let value = UserDefaults.standard.string(forKey: name)
                    return .init(value)
                case .boolean:
                    let value = UserDefaults.standard.bool(forKey: name)
                    return .init(value)
            }
        }

        set {
            UserDefaults.standard.set(newValue, forKey: name)
        }
    }

    public let selections: [String]?

    public init(name: String, title: String, type: UIType) {
        self.name = name
        self.title = title
        self.type = type
        self.selections = nil
    }

    public init(name: String, title: String, type: UIType, selections: [String]) {
        self.name = name
        self.title = title
        self.type = type
        self.selections = selections
    }
}
