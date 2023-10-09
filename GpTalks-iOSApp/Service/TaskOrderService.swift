//
//  TaskOrderService.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 22/9/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskOrderService {
    static let shared = TaskOrderService()
    private let db = Firestore.firestore()
    
    func savePersonalScenario(scenario: String, email: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "scenario": scenario,
            "email": email
        ]
        
        let collectionReference = db.collection("personalScenario")
        
        collectionReference.addDocument(data: data) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
