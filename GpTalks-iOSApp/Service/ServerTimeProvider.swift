//
//  ServerTimeProvider.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 8/9/23.
//

import Foundation

class ServerTimeProvider {
    static let shared = ServerTimeProvider()
    private let apiKey = "ZQZ0FMT0VFGJ" // Замените на свой API-ключ
    
    private init() { }
    
    func fetchServerTime(completion: @escaping (Date?) -> Void) {
        let urlString = "https://api.timezonedb.com/v2.1/get-time-zone?key=\(apiKey)&format=json&by=zone&zone=UTC"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let timestamp = json["timestamp"] as? Int {
                // Преобразуем метку времени в объект Date
                let serverTime = Date(timeIntervalSince1970: TimeInterval(timestamp))
                print(serverTime)
                completion(serverTime)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
