//
//  TopicModel.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/6/23.
//

import Foundation

struct Category: Identifiable {
    let id: String
    let name: String
}

struct Topic: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let preprompt: String
    let favorite: Bool
}

struct TopicAllCategory: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let preprompt: String
    var favorite: Bool
    var category: String
}

extension TopicAllCategory {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
