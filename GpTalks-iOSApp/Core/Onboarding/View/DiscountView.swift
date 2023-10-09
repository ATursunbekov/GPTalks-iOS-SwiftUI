//
//  DiscountView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 29/8/23.
//

import SwiftUI
import Adapty

struct DiscountView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @State private var isAnimating = false
    @Binding var isPresented: Bool
    @EnvironmentObject var discountTimer: DiscountTimer
    @Environment(\.presentationMode) private var presentationMode
    @State private var products: [AdaptyPaywallProduct] = []
    @State private var selectedProductIndex = 3
    @State private var localizedPrice: String = ""
    @State private var initialPrice = ""
    @AppStorage("showRegistration") var  showReg = false
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                HStack {
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Image(AssetsImage.Icons.close.name)
                            .resizable()
                            .frame(width: 17, height: 17)
                            .foregroundColor(Colors.LabelColor.label01.swiftUIColor)
                            .padding(7)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                            .clipShape(Circle())
                        
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 12)
                
                ZStack(alignment: .center) {
                    Image(AssetsImage.OnboardingImages.confetti.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 238)
                        .scaleEffect(isAnimating ? 0.8 : 1.2)
                        .onAppear {
                            print(discountTimer.currentDiscountPercentage)
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                                self.isAnimating.toggle()
                            }
                        }
                    
                    Text("\(discountTimer.currentDiscountPercentage)%")
                        .font(.custom(FontFamily.Poppins.bold, size: 100))
                        .foregroundColor(Colors.AccessibleColors.accessibleGreen.swiftUIColor)
                }
                .padding(.horizontal, 45)
                .padding(.bottom, 21)
                
                VStack(spacing: 12) {
                    Text("\(discountTimer.currentDiscountPercentage)% discount \non the annual plan")
                        .font(.custom(FontFamily.Poppins.bold, size: 28))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("""
Lorem ipsum dolor sit amet consectetur. Nulla
felis suscipit semper placerat diam ac nunc at.
Scelerisque semper mi etiam et in ac vitae.
""")
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                if discountTimer.infinityDiscount == false {
                    VStack(spacing: 8) {
                        Text("The sale will end soon")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                        
                            Text(timeUntilNextDiscountString())
                                .font(.custom(FontFamily.Poppins.bold, size: 22))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        
                        
                    }
                    .padding(.bottom, 68)
                }
                
                Button {
                    if discountTimer.currentDiscountPercentage == 40 {
                        Task {
                            await purchaseViewModel.purchaseProduct(at: 3, products: products, showReg: showReg, completion: { result in
                                if result {
                                    isPresented = false
                                } else {
                                    isPresented = true
                                }
                            })
                        }
                    } else {
                        Task {
                            await purchaseViewModel.purchaseProduct(at: 4, products: products, showReg: showReg, completion: { result in
                                if result {
                                    isPresented = false
                                } else {
                                    isPresented = true
                                }
                            })
                        }
                    }
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Spacer()
                        
                        Text("Claim my \(discountTimer.currentDiscountPercentage)%")
                            .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .frame(height: 48)
                    .background(Colors.AccessibleColors.accessibleGreen.swiftUIColor)
                    .cornerRadius(18)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 12)
                
                Text("\(localizedPrice.replacingOccurrences(of: "US", with: "")) per year")
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text("Before \(initialPrice.replacingOccurrences(of: "US", with: ""))")
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                
                Spacer()
            }
            .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
            .overlay {
                ReusableLoaderView(isLoading: $purchaseViewModel.showPurchaseLoader)
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
                print(products)

                print(products.count)
                initialPrice = products[2].localizedPrice ?? "no price"

                if discountTimer.currentDiscountPercentage == 40 {
                    localizedPrice = products[3].localizedPrice ?? "no price"
                } else {
                    localizedPrice = products[4].localizedPrice ?? "no price"
                }
            } catch {
                print(error)
            }
        }
        .onAppear {
            AmplitudeManager.shared.bannerOpened()
        }
        
    }
    
    private func timeUntilNextDiscountString() -> String {
        let hours = Int(discountTimer.timeUntilNextDiscount) / 3600
        let minutes = Int(discountTimer.timeUntilNextDiscount) / 60 % 60
        let seconds = Int(discountTimer.timeUntilNextDiscount) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ReusableLoaderView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea(edges: .all)
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            }
        }
    }
}

struct DiscoumtView: PreviewProvider {
    static var previews: some View {
        DiscountView(isPresented: .constant(true))
            .environmentObject(DiscountTimer())
    }
}
