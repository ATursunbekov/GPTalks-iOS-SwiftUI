//
//  CategoryService.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 24/7/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct CategoryService {
    static let shared = CategoryService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchCategories(completion: @escaping([String]) -> Void) {
        db.collection("categories").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let categories = documents.compactMap({ $0.data()["name"] as? String })
            completion(categories)
        }
    }
    
    func fetchAllTopics(category: String ,completion: @escaping([TopicAllCategory]) -> Void) {
        db.collection("categories").document(category).collection("topics").getDocuments() { snapshot, _ in
            guard let documents = snapshot?.documents else {
                return
            }
            let topics = documents.compactMap { document -> TopicAllCategory? in
                guard let id = document["id"] as? String,
                      let title = document["title"] as? String,
                      let preprompt = document["preprompt"] as? String,
                      let subtitle = document["subtitle"] as? String else {
                    return nil
                }
                let topic = TopicAllCategory(id: id, title: title, subtitle: subtitle, preprompt: preprompt, favorite: false, category: category)
                return topic
            }
            completion(topics)
        }
    }
    
    func fetchHomeTopics(category: String ,completion: @escaping([TopicAllCategory]) -> Void) {
        db.collection("topics").document(category).collection("topics").getDocuments() { snapshot, _ in
            guard let documents = snapshot?.documents else {
                return
            }
            let topics = documents.compactMap { document -> TopicAllCategory? in
                guard let id = document["id"] as? String,
                      let title = document["title"] as? String,
                      let preprompt = document["preprompt"] as? String,
                      let subtitle = document["subtitle"] as? String else {
                    return nil
                }
                let topic = TopicAllCategory(id: id, title: title, subtitle: subtitle, preprompt: preprompt, favorite: false, category: category)
                return topic
            }
            completion(topics)
        }
    }
    
    func updateFavoriteStatus(forTopic topicID: String, favorite: Bool, yourCategory category: String, completion: @escaping (Error?) -> Void) {
        db.collection("categories").document(category).collection("topics").document(topicID).updateData(["favorite": favorite]) { error in
            if let error = error {
                print("DEBUG: Error updating favorite status: \(error)")
                completion(error)
            } else {
                print("DEBUG: Favorite status updated successfully!")
                completion(nil)
            }
        }
    }
}
