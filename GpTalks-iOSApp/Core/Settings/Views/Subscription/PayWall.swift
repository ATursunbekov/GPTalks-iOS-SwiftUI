//
//  payWall.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 21/8/23.
//

import SwiftUI
import Adapty
import CloudKit
import FirebaseAuth
import FirebaseFirestore

struct PayWall: View {
    @EnvironmentObject var discountTimer: DiscountTimer
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @AppStorage("showRegistration") private var  showReg = false
    @Binding var showPayWall: Bool
    @State private var products: [AdaptyPaywallProduct] = []
    @State private var showPurchaseLoader = false
    @State var monthPrice = ""
    @State var yearPrice = ""
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.payWallBack.name)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button {
                        showPayWall = false
                    } label: {
                        Image(AssetsImage.Icons.close.name)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Colors.AccessibleColors.accessibleGray01.swiftUIColor)
                            .padding(4)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 45)
                .padding(.bottom, 13)
                .padding(.horizontal, 12)
                
                HStack(spacing: -8) {
                    Text("Try")
                    Image(AssetsImage.OnboardingImages.proImage.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 104, height: 52)
                    Text("for free")
                }
                .foregroundColor(.white)
                .font(.custom(FontFamily.Poppins.bold, size: 36))
                .padding(.bottom, getDynamicHeight(height: 7))
                .padding(.trailing, 16)
                
                Text("Our scenarios give 4x more relevant answers from ChatGPT")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.Poppins.semiBold, size: getDynamicHeight(height: 17)))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: getDynamicHeight(height: 334))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.bottom, getDynamicHeight(height: 60))
                    .padding(.trailing, 16)
                
                providedService(name: AssetsImage.Icons.stars.name, title: "20+ life scenarios", text: "Work, health & fit, home routines, funny games, and more to come")
                    .padding(.bottom, getDynamicHeight(height: 40))
                
                providedService(name: AssetsImage.OnboardingImages.fire.name, title: "ChatGPT4 and GPT3.5 under the hood", text: "Be on the cutting edge of AI technologies, get newest technologies now and further")
                
                Spacer()
                    .frame(minHeight: 20)
                
                ZStack(alignment: .topLeading) {
                    Button {
                        Task {
                            if discountTimer.currentDiscountPercentage == 40 {
                                await purchaseViewModel.purchaseProduct(at: 3, products: products, showReg: showReg) { result in
                                    if result {
                                        showPayWall = false
                                    }
                                }
                            } else if discountTimer.currentDiscountPercentage == 60 {
                                await purchaseViewModel.purchaseProduct(at: 4, products: products, showReg: showReg) { result in
                                    if result {
                                        showPayWall = false
                                    }
                                }
                            } else {
                                await purchaseViewModel.purchaseProduct(at: 2, products: products, showReg: showReg) { result in
                                    if result {
                                        showPayWall = false
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Colors.DefaultColors.indigo.swiftUIColor)
                                .frame(height: getDynamicHeight(height: 80))
                            VStack {
                                Text("Start 3-day trial")
                                    .font(.custom(FontFamily.Poppins.semiBold, size: 20))
                                Text("then 1 year - \(yearPrice.replacingOccurrences(of: "US", with: ""))")
                                    .font(.custom(FontFamily.Poppins.regular, size: 17))
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .disabled(showPurchaseLoader)
                }
                .padding(.trailing, 16)
                .padding(.bottom, getDynamicHeight(height: 12))
                
                Button {
                    Task {
                        await purchaseViewModel.purchaseProduct(at: 1, products: products, showReg: showReg, completion: { result in
                            if result {
                                showPayWall = false
                            }
                        })
                    }
                } label: {
                    Text("Monthly plan \(monthPrice.replacingOccurrences(of: "US", with: ""))")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, getDynamicHeight(height: 20))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Colors.DefaultColors.gray06.swiftUIColor)
                        )
                }
                .disabled(showPurchaseLoader)
                .padding(.trailing, 16)
                .padding(.bottom, 12)
                
                Group {
                    VStack {
                        Text("By starting a 3-day free trial, you agree to the GPTalk")
                            .font(.custom(FontFamily.Poppins.regular, size: 11))
                        HStack(spacing: 1) {
                            Button{
                                
                            } label: {
                                Text("Terms of use")
                                    .font(.custom(FontFamily.Poppins.regular, size: 11))
                                    .underline()
                            }
                            Text(" and acknowledge the ")
                                .font(.custom(FontFamily.Poppins.regular, size: 11))
                            Button {
                                
                            } label: {
                                Text("Privacy Policy")
                                    .font(.custom(FontFamily.Poppins.regular, size: 11))
                                    .underline()
                            }
                        }
                    }
                    .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, getDynamicHeight(height: 54))
                }
            }
            .padding(.leading, getDynamicWidth(width: 16))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            ReusableLoaderView(isLoading: $purchaseViewModel.showPurchaseLoader)
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
                
                monthPrice = products[1].localizedPrice ?? "no price"
                
                if discountTimer.currentDiscountPercentage == 40 {
                    yearPrice = products[3].localizedPrice ?? "no price"
                } else if discountTimer.currentDiscountPercentage == 60 {
                    yearPrice = products[4].localizedPrice ?? "no price"
                } else {
                    yearPrice = products[2].localizedPrice ?? "no price"
                }
                
            } catch {
                print (error)
            }
        }
        .onAppear {
            NotificationManager.shared.daysNotifications()
        }
        .onDisappear {
            purchaseViewModel.loadSubscriptionData()
            print("purchaseViewModel.loadSubscriptionData()")
        }
    }
    
    func providedService(name: String,title: String, text: String) -> some View {
        return VStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(name)
                    .resizable()
                    .frame(width: 22, height: 27)
                
                Text(title)
                    .font(.custom(FontFamily.Poppins.semiBold, size: getDynamicHeight(height: 20)))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.leading, 16)
            
            HStack(spacing: 0) {
                Text(text)
                    .font(.custom(FontFamily.Poppins.regular, size: getDynamicHeight(height: 15)))
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.leading, getDynamicWidth(width: 46))
        }
    }
}

