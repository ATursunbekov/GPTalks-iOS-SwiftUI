//
//  ChatService.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 19/7/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatService {
    static let shared = ChatService()
    private let db = Firestore.firestore()
    private let uid = UserDefaults.standard.string(forKey: "uid")
    
    func updateFavoriteStatusInHistory(chatID: String, messageID: String, isFavorite: Bool, topic: String) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        let chatDocumentRef = db.collection("historyChats").document(uid).collection("chats").document(chatID)
        let messageDocumentRef = chatDocumentRef.collection("messages").document(messageID)
        
        messageDocumentRef.updateData(["isFavorite": isFavorite]) { error in
            if let error = error {
                print("Error updating favorite status: \(error)")
            } else {
                print("Favorite status updated successfully!")
                self.moveMessageToFavorites(chatID: chatID, messageID: messageID, topic: topic)
                let allChatsDocumentRef = db.collection("allChats").document(uid).collection("chats").document(chatID)
                allChatsDocumentRef.collection("messages").document(messageID).updateData(["isFavorite": isFavorite]) { error in
                    if let error = error {
                        print("Error updating favorite status in allChats: \(error)")
                    } else {
                        print("Favorite status updated successfully in allChats!")
                    }
                }
            }
        }
    }
    
    func moveMessageToFavorites(chatID: String, messageID: String, topic: String) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        let db = Firestore.firestore()
        let historyChatDocumentRef = db.collection("historyChats").document(uid).collection("chats").document(chatID)
        let messageDocumentRef = historyChatDocumentRef.collection("messages").document(messageID)
        
        messageDocumentRef.getDocument { (document, error) in
            guard let document = document, document.exists else { return }
            if var document = document.data() {
                let newTopic = topic
                document["topic"] = newTopic
                db.collection("favorites").document(uid).collection("chats").document(messageID).setData(document)
            }
        }
    }

    //MARK: Save chat to the historyChats collections
    func saveHistoryChatToFirestore(message: ChatMessage, chatID: String, topic: String? = nil) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        let db = Firestore.firestore()
        let chatMessages: [String: Any] = [
            "chatID": chatID,
            "id": message.id,
            "content": message.content,
            "dateCreated": message.dateCreated,
            "senderID": message.senderID.rawValue,
            "topic": topic ?? "",
            "isFavorite": message.isFavorite
        ]
        let refAllChats = db.collection("allChats").document(uid).collection("chats").document(chatID)
        refAllChats.setData([:])
        refAllChats.collection("messages").document(message.id).setData(chatMessages)
        
        let refToChats = db.collection("historyChats").document(uid)
        refToChats.collection("chats").document(chatID).collection("messages").document(message.id).setData(chatMessages)
        
        refToChats.collection("chats").document(chatID).collection("messages").order(by: "dateCreated", descending: false).limit(to: 2).getDocuments { snapshot, _ in
            guard let documentFirst = snapshot?.documents.last else { return }
            let documentForHistory = documentFirst.data()
            
            if let content = documentForHistory["content"] as? String, let topic = documentForHistory["topic"] as? String, let isFavorite = documentForHistory["isFavorite"] as? Bool {
                let document: [String : Any] = [
                    "id": chatID,
                    "content": content,
                    "dateCreated": Date(),
                    "senderID": message.senderID.rawValue,
                    "topic": topic,
                    "isFavorite": isFavorite
                ]
                refToChats.collection("chats").document(chatID).setData(document)
            }
        }
    }
    
    //MARK: Fetch favorite chat from the favorites collections
    func loadFavoriteChatsFromFirestore(completion: @escaping([ChatMessage]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        db.collection("favorites").document(uid).collection("chats").order(by: "dateCreated", descending: true).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let favorites = documents.compactMap{ try? $0.data(as: ChatMessage.self) }
            completion(favorites)
        }
    }
    
    //MARK: Fetch chats from the historyChats collections
    func loadHistoryChatsFromFirestore(completion: @escaping ([ChatMessage]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        db.collection("historyChats").document(uid).collection("chats").order(by: "dateCreated", descending: true).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let lastMessageHistory = documents.compactMap{ try? $0.data(as: ChatMessage.self) }
            completion(lastMessageHistory)
        }
    }
    
    //MARK: Fetch chat messages from the historyChats collections
    func loadHistoryChatMessagesFromFirestore(chatID: String, completion: @escaping ([ChatMessage]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        db.collection("historyChats").document(uid).collection("chats").document(chatID).collection("messages").order(by: "dateCreated", descending: false).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let chatMessages = documents.compactMap{ try? $0.data(as: ChatMessage.self) }
            completion(chatMessages)
        }
    }
    
    //MARK: Fetch chats from the chatsForFavorite collections
    func loadAllChatMessagesFromFirestore(chatID: String, completion: @escaping ([ChatMessage]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        db.collection("allChats").document(uid).collection("chats").document(chatID).collection("messages").order(by: "dateCreated", descending: false).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let lastMessageHistory = documents.compactMap{ try? $0.data(as: ChatMessage.self) }
            completion(lastMessageHistory)
        }
    }
    
    //MARK: Fetch chat messages from the favorite collections
    func loadFavoriteMessagesFromFirestore(chatID: String ,completion: @escaping ([ChatMessage]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        db.collection("favorites").document(uid).collection("chats").document(chatID).collection("favoriteMessages").order(by: "dateCreated", descending: false).addSnapshotListener { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let chatMessages = documents.compactMap{ try? $0.data(as: ChatMessage.self) }
            completion(chatMessages)
        }
    }
    
    //MARK: Delete chat from history
    func deleteHistoryChatFromFirestore(chatID: String) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        let chatDocumentRef = db.collection("historyChats").document(uid).collection("chats").document(chatID)
        
        chatDocumentRef.collection("messages").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying chat messages: \(error)")
                return
            }
            
            guard let messageDocuments = querySnapshot?.documents else {
                print("No messages found in the chat.")
                return
            }
            
            for messageDocument in messageDocuments {
                messageDocument.reference.delete { error in
                    if let error = error {
                        print("Error deleting message: \(error)")
                    } else {
                        print("Message deleted successfully!")
                    }
                }
            }
            
            chatDocumentRef.delete { error in
                if let error = error {
                    print("Error deleting chat document: \(error)")
                } else {
                    print("Chat document deleted successfully!")
                }
            }
        }
    }

    func deleteFavoriteMessageFromFirestore(content: String, dateCreated: Date) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        
        let collectionRef = db.collection("favorites").document(uid).collection("chats")
        
        collectionRef.whereField("content", isEqualTo: content).whereField("dateCreated", isEqualTo: dateCreated).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document deleted successfully!")
                    }
                }
            }
        }
    }
    
    //MARK: Delete the message from the favorites collection.
    func deleteFavoriteMessageWithIDFromFirestore(chatID: String) {
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            print("No UID available.")
            return
        }
        let documentRef = db.collection("favorites").document(uid).collection("chats").document(chatID)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully!")
            }
        }
    }
}
