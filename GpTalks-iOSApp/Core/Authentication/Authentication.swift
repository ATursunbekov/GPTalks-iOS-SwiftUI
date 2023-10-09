//
//  Authentication.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 22/9/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CloudKit

class Authantication {
    
    static func signIn(email: String, password: String, completion: @escaping () -> Void) {
        // Step 1: Log-In User with Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            
            if let user = authResult?.user {
                let uid = user.uid
                
                // Step 2: Fetch custom UUID from Firestore using Firebase UID
                let db = Firestore.firestore()
                db.collection("users").document(uid).getDocument { document, error in
                    if let error = error {
                        print("Error fetching document: \(error)")
                    } else {
                        if let document = document {
                            if let data = document.data(),
                               let userID = data["customUUID"] as? String {
                                print("Fetched custom UUID: \(userID)")
                                UserDefaults.standard.set(userID, forKey: "uid")
//                                userSettings.refreshData()
//                                chatViewModel.refreshData()
//                                categoryViewModel.refreshData()
                                completion()
                                UserDefaults.standard.set(true, forKey: "showRegistration")
                            } else {
                                print("Custom UUID not found.")
                            }
                        } else {
                            print("Document does not exist.")
                        }
                    }
                }
            }
        }
    }
    
    static func deleteAllDataForCustomUUID(completion: @escaping () -> Void) {
        // Get the uid from UserDefaults
        
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }
        
        let uid = user.uid
        
        guard let customUUID = UserDefaults.standard.string(forKey: "uid") else {
            print("No custom UUID found.")
            return
        }
        
        // Initialize Firestore
        let db = Firestore.firestore()
        
        // Delete all tasks under /favorites/customUUID/tasks
        db.collection("favorites").document(customUUID).collection("tasks").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting tasks: \(error)")
                return
            }
            
            for document in snapshot!.documents {
                document.reference.delete()
            }
        }
        
        //MARK: Deleting all chats
        db.collection("allChats").document(customUUID).collection("chats").getDocuments { (snapshot, error) in
            print("first stage: \(customUUID)")
            if let error = error {
                print("Error getting chats: \(error)")
                return
            }
            print("snapshot: \(snapshot?.count ?? -100)")
            // Loop through each chat document
            for chatDocument in snapshot!.documents {
                print("inside chats")
                // Fetch all message documents under each chat
                chatDocument.reference.collection("messages").getDocuments { (messageSnapshot, messageError) in
                    if let messageError = messageError {
                        print("Error getting messages: \(messageError)")
                        return
                    }
                    
                    // Delete each message document
                    for messageDocument in messageSnapshot!.documents {
                        print("inside messages")
                        messageDocument.reference.delete { err in
                            if let err = err {
                                print("Error deleting message: \(err)")
                            } else {
                                print("Message successfully deleted!")
                            }
                        }
                    }
                    
                    // Delete the chat document itself
                    chatDocument.reference.delete { err in
                        if let err = err {
                            print("Error deleting chat: \(err)")
                        } else {
                            print("Chat successfully deleted!")
                        }
                    }
                }
            }
        }
        
        //MARK: Delete history of chats
        db.collection("historyChats").document(customUUID).collection("chats").getDocuments { (snapshot, error) in
            print("first stage")
            if let error = error {
                print("Error getting chats: \(error)")
                return
            }
            
            // Loop through each chat document
            for chatDocument in snapshot!.documents {
                print("inside chats")
                // Fetch all message documents under each chat
                chatDocument.reference.collection("messages").getDocuments { (messageSnapshot, messageError) in
                    if let messageError = messageError {
                        print("Error getting messages: \(messageError)")
                        return
                    }
                    
                    // Delete each message document
                    for messageDocument in messageSnapshot!.documents {
                        print("inside messages")
                        messageDocument.reference.delete { err in
                            if let err = err {
                                print("Error deleting message: \(err)")
                            } else {
                                print("Message successfully deleted!")
                            }
                        }
                    }
                    
                    // Delete the chat document itself
                    chatDocument.reference.delete { err in
                        if let err = err {
                            print("Error deleting chat: \(err)")
                        } else {
                            print("Chat successfully deleted!")
                        }
                    }
                }
            }
        }
        
        //MARK: Delete whole account
        db.collection("users").document(uid).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("User document successfully removed!")
                
                // Step 2: Delete user from Firebase Authentication
                CKContainer(identifier: "iCloud.com.deveem.gptalks-ios-app").fetchUserRecordID(completionHandler: { (recordId, error) in
                    if let name = recordId?.recordName {
                        let credential = EmailAuthProvider.credential(withEmail: "\(name)@gmail.com", password: name)
                        user.reauthenticate(with: credential, completion: { (result, error) in
                            if let error = error {
                                // An error happened during re-authentication.
                                print("Error re-authenticating: \(error)")
                                return
                            } else {
                                user.delete { error in
                                    if let error = error {
                                        print("Error deleting user: \(error)")
                                    } else {
                                        print("User account deleted.")
//                                        showAlerAfterDeletion = true
//                                        // Optional: Clear local storage (UserDefaults, etc.)
//                                        UserDefaults.standard.set(false, forKey: "showRegistration")
//                                        userSettings.refreshData()
//                                        chatViewModel.refreshData()
//                                        categoryViewModel.refreshData()
                                        completion()
                                        
                                        // Optional: Sign out any other sessions the user might have
                                        do {
                                            try Auth.auth().signOut()
                                        } catch let signOutError as NSError {
                                            print("Error signing out: %@", signOutError)
                                        }
                                    }
                                }
                            }
                        })
                    }
                    else if let error = error {
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
}
