//
//  PurchaseViewModel.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 5/9/23.
//

import SwiftUI
import StoreKit
import Adapty
import CloudKit
import FirebaseAuth
import FirebaseFirestore
import AppsFlyerLib

class PurchaseViewModel: ObservableObject {
    @Published var showPurchaseLoader = false
    @Published var isShowAlert = false
    @Published var hasPremium: Bool = false
    @Published var products: [Product] = []

    func loadSubscriptionData() {
        Task {
            do {
                if let accessLevels = try await Adapty.getProfile()?.accessLevels {
                    for accessLevel in accessLevels where accessLevel.key == "premium" {
                        DispatchQueue.main.async {
                            self.hasPremium = accessLevel.value.isActive
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func purchaseProduct(at index: Int, products: [AdaptyPaywallProduct], showReg: Bool, completion: @escaping(Bool) -> Void) async {
        guard index >= 0 && index < products.count else {
            return
        }
        
        let product = products[index]
        
        var purchaseType = ""
        if index == 1 {
            purchaseType = "Monthly"
        } else if index == 2 {
            purchaseType = "Annual"
        }
        
        DispatchQueue.main.async {
            self.showPurchaseLoader = true
        }
        Adapty.makePurchase(product: product) { [self] result in
            switch result {
            case let .success(info):
                print("Purchase result: \(info.profile.subscriptions)")
                if info.profile.accessLevels["premium"]?.isActive ?? false {
                    print("Purchase successful.")
                    showPurchaseLoader = false
                    
                    AppsFlyerLib.shared().logEvent("Purchase", withValues: ["Type": purchaseType])
                    
                    if !showReg {
                        CKContainer(identifier: "iCloud.com.deveem.gptalks-ios-app").fetchUserRecordID(completionHandler: { (recordId, error) in
                            if let name = recordId?.recordName {
                                print("iCloud ID: " + name)
                                Task {
                                    self.signUp(email: "\(name)@gmail.com", password: name)
                                }
                            }
                            else if let error = error {
                                print(error.localizedDescription)
                            }
                        })
                    }
                    completion(true)
                } else {
                    print("Purchase successful, but access level not active.")
                    showPurchaseLoader = false
                }
            case let .failure(error):
                print("Purchase error: \(error)")
                self.showPurchaseLoader = false
                completion(false)
            }
        }
    }
    
    func fetchProductPersonalScenario() {
        Task {
            do {
                let products = try await Product.products(for: ["app.gptalks.personalScenario"])
                DispatchQueue.main.async {
                    self.products = products
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func purchasePersonalScenario(completion: @escaping (Bool) -> Void) {
        Task {
            guard let product = products.first else { return }
            DispatchQueue.main.async {
                self.showPurchaseLoader = true
            }
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        print(transaction.productID)
                        DispatchQueue.main.async {
                            self.showPurchaseLoader = false
                            completion(true)
                        }
                    case .unverified(_, _):
                        completion(false)
                    }
                case .userCancelled:
                    DispatchQueue.main.async {
                        self.showPurchaseLoader = false
                    }
                    completion(false)
                case .pending:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
            catch {
                print(error)
                completion(false)
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            if let user = authResult?.user {
                let userID = user.uid
                
                // Step 2: Generate a custom UUID string
                if let uid = UserDefaults.standard.string(forKey: "uid") {
                    
                    // Step 3: Save both Firebase UID and custom UUID to Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(userID).setData([
                        "customUUID": uid,
                        "email": email
                    ]) { error in
                        if let error = error {
                            print("Error saving to Firestore: \(error.localizedDescription)")
                        } else {
                            UserDefaults.standard.set(true, forKey: "showRegistration")
                            print("User and custom UUID saved.")
                        }
                    }
                }
            }
        }
    }
}

