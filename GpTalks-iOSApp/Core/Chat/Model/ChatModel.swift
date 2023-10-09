//
//  ChatModel.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 20/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct OpenAICompletionsBody: Encodable {
    let model: String
    let messages: [[String: String]]
    let temperature: Float?
    let maxTokens: Int
    
    private enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case maxTokens = "max_tokens"
    }
}

struct OpenAICompletionsResponse: Decodable {
    let id: String?
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let message: OpenAICompletionsMessage
}

struct OpenAICompletionsMessage: Decodable {
    let role: String
    let content: String
}

struct ChatMessage: Codable, Identifiable {
    var id: String
    var topic: String? = nil
    var chatID: String? = nil
    let content: String
    let dateCreated: Date
    var senderID: MessageSender
    var isFavorite: Bool
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: dateCreated)
    }
}

extension ChatMessage: Equatable {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}

enum MessageSender: String, Codable {
    case user
    case assistant
}
