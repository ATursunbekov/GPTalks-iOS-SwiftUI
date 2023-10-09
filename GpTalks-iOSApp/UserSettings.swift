//
//  UserSettings.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 17/8/23.
//

import Foundation

//MARK: Get UID
class UserSettings: ObservableObject {
    @Published var uid: String? {
        didSet {
            UserDefaults.standard.set(uid, forKey: "uid")
        }
    }
    
    init() {
        self.uid = UserDefaults.standard.string(forKey: "uid")
    }
    
    func refreshData() {
        self.uid = UserDefaults.standard.string(forKey: "uid")
    }
    
    func generateUID() -> String {
        return UUID().uuidString
    }
}
