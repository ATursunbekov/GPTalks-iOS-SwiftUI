//
//  TaskOrderView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 22/9/23.
//

import SwiftUI
import StoreKit
import AppsFlyerLib

struct TaskOrderView: View {
    @StateObject var purchaseViewModel = PurchaseViewModel()
    @State private var textMessage = ""
    @State private var height: CGFloat = 142
    @State private var isPlaceholder = true
    @State private var email = ""
    @State private var showAlert = false
    @State private var sentAlert = false
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("We are so excited to create \nscenario personally for you!")
                            .font(.custom(FontFamily.Poppins.medium, size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        if #available(iOS 16.0, *) {
                            TextEditor(text: $textMessage)
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    VStack {
                                        HStack {
                                            if textMessage.isEmpty {
                                                Text("Please describe what problem you want to solve using GPTalk and how you see the result of scenario.")
                                                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                                                    .padding(.vertical, 11)
                                                    .padding(.horizontal, 16)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                    }
                                )
                                .frame(height: 142)
                                .background(Colors.FillColor.fill03.swiftUIColor)
                                .scrollContentBackground(.hidden)
                                .cornerRadius(12)
                        } else {
                            TextEditor(text: $textMessage)
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    VStack {
                                        HStack {
                                            if textMessage.isEmpty {
                                                Text("Please describe what problem you want to solve using GPTalk and how you see the result of scenario.")
                                                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                                                    .padding(.vertical, 11)
                                                    .padding(.horizontal, 16)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                    }
                                )
                                .frame(height: 142)
                                .background(Colors.FillColor.fill03.swiftUIColor)
                                .cornerRadius(12)

                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("We may need your help to clarity the request. Please give us E-mail ")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(.white)
                        
                        TextField("eeeee@ddddd.com", text: $email.animation(nil))
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .padding(.vertical, 11)
                            .padding(.horizontal, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                            .cornerRadius(12)
                            .onChange(of: email) { newValue in
                                email = newValue.lowercased()
                            }
                            .keyboardType(.emailAddress)
                    }
                    
                    Text("""
Please be aware that Al technology has its limitations, and there may be certain scenarios where cannot generate the desired output. If we encounter such a situation, rest assured that a refund will be promptly issued. Your satisfaction is our priority, and we strive to
provide the best assistance we can.
""")
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 11))
                    .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    
                    Spacer()
                    
                    if let product = purchaseViewModel.products.first {
                        Button {
                            if email.isEmpty || textMessage.isEmpty {
                                showAlert = true
                            } else {
                                purchaseViewModel.purchasePersonalScenario { success in
                                    if success {
                                        TaskOrderService.shared.savePersonalScenario(scenario: textMessage, email: email) { error in
                                            if let error = error {
                                                print("Saving error: \(error.localizedDescription)")
                                            } else {
                                                AmplitudeManager.shared.boughtScenario()
                                                AppsFlyerLib.shared().logEvent("Purchase", withValues: ["Type": "Scenario"])
                                                print("Saved to Firestore")
                                                sentAlert = true
                                            }
                                        }
                                    } else {
                                        print("Покупка не была успешной.")
                                    }
                                }
                            }
                        } label: {
                            Text("Get your personal scenario - $\(product.displayPrice.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "USD", with: ""))")
                                .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                                .foregroundColor(.white)
                                .padding(.horizontal, 70)
                                .padding(.vertical, 14)
                                .background((email.isEmpty || textMessage.isEmpty) ? .gray : Colors.DefaultColors.indigo.swiftUIColor)

                                .cornerRadius(12)
                        }
                        .disabled((email.isEmpty || textMessage.isEmpty) ? true : false)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Please fill in all fields"),
                message: Text("You must complete all fields before continuing."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            purchaseViewModel.fetchProductPersonalScenario()
        }
        .padding(.horizontal, 16)
        .background(Colors.SystemBackgrounds.background01.swiftUIColor)
        .dismissKeyboardOnDrag()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Task order")
                        .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            isPresented = false
        }) {
            HStack(spacing: 4) {
                Image(AssetsImage.Icons.backIcon.name)
                
                Text("Back")
            }.foregroundColor(.white)
        })
        .overlay {
            ReusableLoaderView(isLoading: $purchaseViewModel.showPurchaseLoader)
        }
        .alert(isPresented: $sentAlert) {
            Alert(
                title: Text("Personal scenario"),
                message: Text("You successfully ordered your personal scenario!"),
                dismissButton: .default(Text("OK")) {
                    isPresented = false
                }
            )
        }
    }
}
