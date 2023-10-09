//
//  SubscriptionView.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 23/8/23.
//

import SwiftUI
import StoreKit
import Adapty
import CloudKit
import FirebaseAuth
import FirebaseFirestore

struct SubscriptionView: View {
    @AppStorage("showRegistration") var  showReg = false
    @EnvironmentObject var discountTimer: DiscountTimer
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @State private var products: [AdaptyPaywallProduct] = []
    @State var weekPrice = ""
    @State var monthPrice = ""
    @State var yearPrice = ""
    @State var boughtSub = ""
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 26) {
                //MARK: First Section
                ZStack {
                    VStack(spacing: 0) {
                        
                        Button {
                            Task {
                                await purchaseViewModel.purchaseProduct(at: 0, products: products, showReg: showReg, completion: {_ in 
                                    Task {
                                        if let subs = try await Adapty.getProfile()?.subscriptions {
                                            boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                                            print(boughtSub)
                                        }
                                    }
                                })
                            }
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("1 week")
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                                        .foregroundColor(boughtSub == "app.gptalks.weekly" ? .blue : .white)
                                    
                                    Spacer()
                                    
                                    Text(weekPrice.replacingOccurrences(of: "US", with: ""))
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                        .foregroundColor(boughtSub == "app.gptalks.weekly" ? .blue : Colors.LabelColor.label02.swiftUIColor)
                                    
                                    if (boughtSub == "app.gptalks.weekly") {
                                        Image(AssetsImage.Icons.baseCheck.name)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .disabled(purchaseViewModel.showPurchaseLoader || purchaseViewModel.isShowAlert || boughtSub == "app.gptalks.weekly")
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        Button {
                            Task {
                                await purchaseViewModel.purchaseProduct(at: 1, products: products, showReg: showReg, completion: {_ in 
                                    Task {
                                        if let subs = try await Adapty.getProfile()?.subscriptions {
                                            boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                                            print(boughtSub)
                                        }
                                    }
                                })
                            }
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("1 month")
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                                        .foregroundColor(boughtSub == "app.gptalks.monthly" ? .blue : .white)
                                    
                                    Spacer()
                                    
                                    Text(monthPrice.replacingOccurrences(of: "US", with: ""))
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                        .foregroundColor(boughtSub == "app.gptalks.monthly" ? .blue : Colors.LabelColor.label02.swiftUIColor)
                                    
                                    if (boughtSub == "app.gptalks.monthly") {
                                        Image(AssetsImage.Icons.baseCheck.name)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .disabled(purchaseViewModel.showPurchaseLoader || purchaseViewModel.isShowAlert || boughtSub == "app.gptalks.monthly")
                        
                        Divider()
                            .overlay{
                                Colors.DefaultColors.gray03.swiftUIColor
                            }
                            .padding(.leading, 16)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                        
                        Button {
                            Task {
                                if discountTimer.currentDiscountPercentage == 40 {
                                    await purchaseViewModel.purchaseProduct(at: 3, products: products, showReg: showReg, completion: {_ in
                                        Task {
                                            if let subs = try await Adapty.getProfile()?.subscriptions {
                                                boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                                                print(boughtSub)
                                            }
                                        }
                                    })
                                }
                                else if discountTimer.currentDiscountPercentage == 60 {
                                    await purchaseViewModel.purchaseProduct(at: 4, products: products, showReg: showReg, completion: {_ in 
                                        Task {
                                            if let subs = try await Adapty.getProfile()?.subscriptions {
                                                boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                                                print(boughtSub)
                                            }
                                        }
                                    })
                                } else {
                                    await purchaseViewModel.purchaseProduct(at: 2, products: products, showReg: showReg, completion: {_ in 
                                        Task {
                                            if let subs = try await Adapty.getProfile()?.subscriptions {
                                                boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                                                print(boughtSub)
                                            }
                                        }
                                    })
                                }
                            }
                            
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("1-year (3-days Free Trial)")
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                                        .foregroundColor((boughtSub == "app.gptalks.annual" || boughtSub == "app.gptalks.annualDis40" || boughtSub == "app.gptalks.annualDis60") ? .blue : .white)
                                    
                                    Spacer()
                                    
                                    Text(yearPrice.replacingOccurrences(of: "US", with: ""))
                                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                        .foregroundColor((boughtSub == "app.gptalks.annual" || boughtSub == "app.gptalks.annualDis40" || boughtSub == "app.gptalks.annualDis60") ? .blue :  Colors.LabelColor.label02.swiftUIColor)
                                    
                                    if (boughtSub == "app.gptalks.annual" || boughtSub == "app.gptalks.annualDis40" || boughtSub == "app.gptalks.annualDis60") {
                                        Image(AssetsImage.Icons.baseCheck.name)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .disabled(purchaseViewModel.showPurchaseLoader || purchaseViewModel.isShowAlert || (boughtSub == "app.gptalks.annual" || boughtSub == "app.gptalks.annualDis40" || boughtSub == "app.gptalks.annualDis60"))
                    }
                }
                
                //MARK: Second Section
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                        .frame(height: 104)
                    VStack(spacing: 16) {
                        Text("If you’ve already GPTalk subscription, you can restore \nthat purchase.")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 13))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Button {
                            _ = Task<Void, Never> {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                                .foregroundColor(.blue)
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            
                        }
                    }
                    .padding(16)
                }
                
                //MARK: Thirt section
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                            .frame(height: 44)
                        VStack(spacing: 16) {
                            Text("Cancel Subscription")
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 17))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                Spacer()
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
                } catch {
                    print (error)
                }
            }
            .onAppear {
                Adapty.getProfile { result in
                    if let profile = try? result.get() {
                        for (key, value) in profile.accessLevels {
                            if value.isActive {
                                print("Subscription \(key) is active")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity)
            .padding(.top, 16)
            .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            
            ReusableLoaderView(isLoading: $purchaseViewModel.showPurchaseLoader)
            
            if purchaseViewModel.isShowAlert {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
            }
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
                
                weekPrice = products[0].localizedPrice ?? "no price"
                monthPrice = products[1].localizedPrice ?? "no price"
                
                if discountTimer.currentDiscountPercentage == 40 {
                    yearPrice = products[3].localizedPrice ?? "no price"
                } else if discountTimer.currentDiscountPercentage == 60 {
                    yearPrice = products[4].localizedPrice ?? "no price"
                } else {
                    yearPrice = products[2].localizedPrice ?? "no price"
                }
                
                if let subs = try await Adapty.getProfile()?.subscriptions {
                    boughtSub = subs.first(where: { $1.isActive })?.key ?? "?"
                    print(subs)
                }
            } catch {
                print(error)
            }
        }
        .onDisappear {
            purchaseViewModel.loadSubscriptionData()
            print("purchaseViewModel.loadSubscriptionData()")
        }
    }
}

struct Purchases_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
