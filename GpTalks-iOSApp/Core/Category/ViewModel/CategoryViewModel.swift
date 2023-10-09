//
//  TopicViewModel.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/6/23.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var showLoaderCategory = true
    @Published var showLoaderHome = false
    @Published var getAllTopics: [String: [TopicAllCategory]] = [:]
    @Published var favoriteTopics: [TopicAllCategory] = []
    // For skeleton
    @Published var homeTopics: [String : [TopicAllCategory]] = [
        "mostPopular": [TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: ""),
                        TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: ""),
                        TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: "")],
        "tryNew": [TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: ""),
                   TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: ""),
                   TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: "")],
        "fun": [TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: ""),
                TopicAllCategory(id: "", title: "", subtitle: "", preprompt: "", favorite: false, category: "")]
    ]
    @Published var getCategoryAllSize: Int = 0
    var tasksToRemove: [TopicAllCategory] = []
    var tasksToAdd: [TopicAllCategory] = []
    
    init() {
        showLoaderCategory = true
        showLoaderHome = true
        fetchHomeTopics()
        fetchCategories()
    }
    
    func fetchCategories() {
        CategoryService.shared.fetchCategories { [weak self] categories in
            withAnimation(.linear(duration: 0.01)) {
                self?.categories = categories
                self?.fetchAllTopics()
            }
        }
    }
    
    func fetchAllTopics() {
        showLoaderCategory = true
        var tempAllTopics: [TopicAllCategory] = []
        
        let dispatchGroup = DispatchGroup()
        
        for name in categories {
            dispatchGroup.enter()
            
            let category = mapCategoryToFirestoreName(name)
            CategoryService.shared.fetchAllTopics(category: category) { [weak self] topic in
                DispatchQueue.main.async {
                    self?.getAllTopics[name] = topic
                    tempAllTopics.append(contentsOf: topic)
                    self?.fetchFavoritesForUser()
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.getAllTopics["All"] = tempAllTopics
            self.showLoaderCategory = false
            self.showLoaderHome = false
            self.getCategoryAllSize = self.getAllTopics["All"]?.count ?? 0
        }
    }

    func fetchHomeTopics() {
        let homeCategories = ["fun", "mostPopular", "tryNew"]
        var tempAllTopics: [String: [TopicAllCategory]] = [:]
        
        let dispatchGroup = DispatchGroup()
        
        for name in homeCategories {
            self.showLoaderHome = true
            dispatchGroup.enter()
            
            CategoryService.shared.fetchHomeTopics(category: name) {  topic in
                DispatchQueue.main.async {
                    tempAllTopics[name] = topic.sorted { $0.id > $1.id }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.fetchFavoritesForUser()
            self.homeTopics = tempAllTopics
        }
    }
    
    func fetchFavoritesForUser() {
        let homeCategories = ["fun", "mostPopular", "tryNew"]
        
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            Firestore.firestore().collection("favorites").document(uid).collection("tasks").getDocuments { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var tasks: [TopicAllCategory] = []
                    for document in querySnapshot!.documents {
                        do {
                            let task = try Firestore.Decoder().decode(TopicAllCategory.self, from: document.data())
                            tasks.append(task)
                        } catch let error {
                            print("Error decoding task: \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self?.favoriteTopics = tasks
                        for task in tasks {
                            if homeCategories.contains(task.category) {
                                self?.replace(item: task, category: task.category, isCategory: false)
                            } else {
                                self?.replace(item: task, category: task.category == "forFun" ? "For Fun" : task.category.capitalized)
                                self?.replace(item: task, category: "All")
                            }
                        }
                        self?.showLoaderHome = false
                    }
                }
            }
        } else {
            print("No UID available.")
        }
    }
    
    func replace(item: TopicAllCategory, category: String, isCategory: Bool = true) {
        if isCategory {
            if let index = getAllTopics[category]?.firstIndex(where: { $0.id == item.id }) {
                getAllTopics[category]?[index] = item
            }
        } else {
            if let index = homeTopics[category]?.firstIndex(where: { $0.id == item.id }) {
                    self.homeTopics[category]?[index] = item
            }
        }
    }
    
    func updateFavoriteStatus(topicID: String, favorite: Bool, task: TopicAllCategory) {
        
        if favoriteTopics.isEmpty {
            favoriteTopics = []
        }
        
        if favorite {
            if UserDefaults.standard.string(forKey: "uid") != nil {
                var tempTask = task
                tempTask.favorite = true
                self.favoriteTopics.append(tempTask)
                tasksToAdd.append(task)
            } else {
                print("No UID available.")
            }
        } else {
            favoriteTopics.removeAll{ $0.id == task.id }
            tasksToRemove.append(task)
        }
    }
    
    func toggleFavoriteFor(topicID: String, isFavorite: Bool, inCategory category: String) {
        
        var selectedCategory = category
        let homeCategories = ["fun", "mostPopular", "tryNew"]
        
        if selectedCategory == "forFun" {
            selectedCategory = "For Fun"
        }
        if !homeCategories.contains(category) {
            if let index = getAllTopics[selectedCategory.capitalized]?.firstIndex(where: { $0.id == topicID }) {
                getAllTopics[selectedCategory.capitalized]?[index].favorite = isFavorite
            } else {
                print("Not found in \(selectedCategory)!")
            }
            if let index = getAllTopics["All"]?.firstIndex(where: { $0.id == topicID }) {
                getAllTopics["All"]?[index].favorite = isFavorite
            }
        } else {
            //For Home
            if let index = homeTopics[category]?.firstIndex(where: { $0.id == topicID }) {
                homeTopics[category]?[index].favorite = isFavorite
            } else {
                print("not found in home array")
            }
        }
    }

    func mapCategoryToFirestoreName(_ category: String) -> String {
        let components = category.components(separatedBy: " ")
        let firstWord = components.first ?? ""
        let remainingWords = components.dropFirst().joined(separator: " ")
        let lowercaseFirstWord = firstWord.lowercased()
        let firestoreCategory = lowercaseFirstWord + remainingWords
        
        return firestoreCategory
    }
    
    func getCategoryButColor(categoty: String) -> ColorAsset {
        switch categoty {
        case "All":
            return Colors.AccessibleColors.accessibleGreen
        case "Social":
            return Colors.AccessibleColors.accessiblePink
        case "Work":
            return Colors.AccessibleColors.accessibleYellow
        case "Education":
            return Colors.AccessibleColors.accessibleTeal
        case "For Fun":
            return Colors.AccessibleColors.accessibleBlue
        default:
            return Colors.AccessibleColors.accessiblePurple
        }
    }
    
    func getRightOrLeftString(selectedString: String, direction: String) -> String? {
        guard let selectedIndex = categories.firstIndex(of: selectedString) else {
            print("Selected string not found in the array.")
            return nil
        }
        
        if direction == "right" {
            if selectedIndex == categories.count - 1 {
                print("Selected index is the last element, can't return right string.")
                return nil
            } else {
                return categories[selectedIndex + 1]
            }
        }
        
        else if direction == "left" {
            if selectedIndex == 0 {
                print("Selected index is the first element, can't return left string.")
                return nil
            } else {
                return categories[selectedIndex - 1]
            }
        } else {
            print("Invalid direction. Please use 'right' or 'left'.")
            return nil
        }
    }
    
    func getTag(name: String) -> Int {
        return categories.firstIndex(of: name) ?? categories.count + 1
    }
    
    func rewriteFavoriteTopics() {
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            
            for task in tasksToRemove {
                Firestore.firestore().collection("favorites").document(uid).collection("tasks").document(task.id).delete() { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    }
                }
            }
            for task in tasksToAdd {
                let topicAllCategory = TopicAllCategory(id: task.id, title: task.title, subtitle: task.subtitle, preprompt: task.preprompt, favorite: true, category: task.category)
                guard let encodedCategory = try? Firestore.Encoder().encode(topicAllCategory) else { return }
                Firestore.firestore().collection("favorites").document(uid).collection("tasks").document(task.id).setData(encodedCategory) {error in
                    if error != nil {
                        print(error?.localizedDescription ?? "Error")
                    }
                }
            }
        } else {
            print("No UID available.")
        }
        tasksToRemove = []
        tasksToAdd = []
    }
    
    func refreshData() {
        showLoaderCategory = true
        showLoaderHome = true
        fetchHomeTopics()
        fetchCategories()
    }
}
