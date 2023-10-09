//
//  SettingsView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 14/8/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import CloudKit
import Adapty

struct SettingsView: View {
    @EnvironmentObject private var categoryViewModel: CategoryViewModel
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @State private var showAlerAfterDeletion = false
    @State private var boughtSubcription = ""
    @State private var products: [AdaptyPaywallProduct] = []
    @State private var showContactSupport = false
    @AppStorage("showRegistration") private var  showRegistration = false
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack(spacing: 24) {
            //MARK: First Section
            VStack(alignment: .leading, spacing: 2) {
                Text("ACTION")
                    .padding(.leading, 16)
                    .font(.custom(FontFamily.SFProDisplay.medium, size: 12))
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                
                ZStack {
                    VStack(spacing: 0) {
                        NavigationLink {
                            NotificationSettings()
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack(spacing: 9.7) {
                                    Text("Notifications")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("Email, Push")
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        NavigationLink {
                            SubscriptionView()
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 0)
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack(spacing: 9.7) {
                                    Text("Subscription")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(boughtSubcription)
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        Button {
                            SettingsView.requestReviewManually()
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("Rate us")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .foregroundColor(.cyan)
                }
            }
            
            //MARK: Second Section
            VStack(alignment: .leading, spacing: 2) {
                Text("HELP & FEEDBACK")
                    .padding(.leading, 16)
                    .font(.custom(FontFamily.SFProDisplay.medium, size: 12))
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                ZStack {
                    VStack(spacing: 0) {
                        NavigationLink(destination: PrivacyPolicyView()) {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack(spacing: 9.7) {
                                    Text("Privacy policy")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        NavigationLink {
                           TermsOfUseView()
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 0)
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack(spacing: 9.7) {
                                    Text("Terms of use")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        Button {
                            showContactSupport.toggle()
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("Contact support")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(AssetsImage.Icons.chevronRight.name)
                                        .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                        .frame(width: 10, height: 10)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
            if showRegistration {
                Button {
                    //deleteAllDataForCustomUUID()
                    Authantication.deleteAllDataForCustomUUID {
                        showAlerAfterDeletion = true
                        // Optional: Clear local storage (UserDefaults, etc.)
                        UserDefaults.standard.set(false, forKey: "showRegistration")
                        userSettings.refreshData()
                        chatViewModel.refreshData()
                        categoryViewModel.refreshData()
                    }
                } label: {
                    ZStack {
                        RoundedCorner(radius: 10, corners: .allCorners)
                            .frame(height: 44)
                            .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                        HStack(spacing: 9.7) {
                            Spacer()
                            
                            Text("Delete Account")
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .padding(.top, 16)
        .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Your account was deleted !" ,isPresented: $showAlerAfterDeletion) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $showContactSupport) {
            ContactSupportView()
        }
        .task {
            do {
                guard let paywall = try await Adapty.getPaywall("subscriptions") else {
                    return
                }
                
                guard let products = try await Adapty.getPaywallProducts(paywall: paywall) else {
                    return
                }
                
                self.products = products
                
                if let subs = try await Adapty.getProfile()?.subscriptions {
                    boughtSubcription = subs.first(where: { $1.isActive })?.key ?? ""
                    
                    if boughtSubcription == "app.gptalks.weekly" {
                        boughtSubcription = products[0].localizedPrice ?? ""
                    } else if boughtSubcription == "app.gptalks.monthly" {
                        boughtSubcription = products[1].localizedPrice ?? ""
                    } else if boughtSubcription == "app.gptalks.annualDis40" {
                        boughtSubcription = products[3].localizedPrice ?? ""
                    } else if boughtSubcription == "app.gptalks.annualDis60" {
                        boughtSubcription = products[4].localizedPrice ?? ""
                    } else if boughtSubcription != "" {
                        boughtSubcription = products[2].localizedPrice ?? ""
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func requestReviewManually() {
        let url = "https://apps.apple.com/app/id6453692555?action=write-review"
        guard let writeReviewURL = URL(string: url)
        else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
