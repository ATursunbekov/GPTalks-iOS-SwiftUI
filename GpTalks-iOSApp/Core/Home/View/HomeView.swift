//
//  HomeView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/7/23.
import SwiftUI
import EasySkeleton
import Adapty

struct HomeView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @State private var showAlert = false
    @State public var startChat = false
    @State private var refreshNumber = 0
    @State private var isBannerVisible = true
    @EnvironmentObject var viewModel: CategoryViewModel
    @Binding var showLoaderHome: Bool
    @State private var isDiscountViewPresented = false
    @State private var isTaskOrderViewPresented = false
    @EnvironmentObject var discountTimer: DiscountTimer
    @State private var selectedCard: String? = nil
    @State private var favoritePressed = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(Colors.SystemBackgrounds.background01.color)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 12) {
                            //MARK: Banner
                            if isBannerVisible {
                                
                                BannerView(isBannerVisible: $isBannerVisible)
                                    .skeletonable()
                                    .skeletonCornerRadius(12)
                                    .onTapGesture {
                                        if !purchaseViewModel.hasPremium {
                                            isDiscountViewPresented.toggle()
                                        } else {
                                            isTaskOrderViewPresented.toggle()
                                        }
                                        
                                    }
                                    .environmentObject(discountTimer)
                            }
                            
                            //MARK: Most Popular
                            HStack {
                                Image(AssetsImage.Icons.like.name)
                                    .foregroundColor(.white)
                                
                                Text("Most popular")
                                    .font(.custom(FontFamily.Poppins.bold, size: 20))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .skeletonable()
                            .skeletonCornerRadius(8)
                            
                            HStack(alignment: .top, spacing: 12) {
                                CardItemView(category: "All", size: 108, index: viewModel.getCategoryAllSize - 1, favoritePressed: $favoritePressed, showSub: false)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                                
                                CardItemView(category: "All", size: 108, index: viewModel.getCategoryAllSize - 2, favoritePressed: $favoritePressed, showSub: false)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                            }
                            CardItemView(category: "All", size: 108, index: viewModel.getCategoryAllSize - 3, favoritePressed: $favoritePressed, showSub: false)
                                .skeletonable()
                                .skeletonCornerRadius(8)
                            
                            //MARK: Try New
                            HStack {
                                Image(AssetsImage.Icons.education.name)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.white)
                                
                                Text("Try new")
                                    .font(.custom(FontFamily.Poppins.bold, size: 20))
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .skeletonable()
                            .skeletonCornerRadius(8)
                            
                            HStack(alignment: .top, spacing: 12) {
                                CardItemView(category: "All", size: 122, index: 0, favoritePressed: $favoritePressed, showSub: true)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                                
                                CardItemView(category: "All", size: 122, index: 1, favoritePressed: $favoritePressed, showSub: true)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                                
                                CardItemView(category: "All", size: 122, index: 2, favoritePressed: $favoritePressed, showSub: true)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                            }
                            //MARK: For Fun
                            HStack {
                                Image(AssetsImage.Icons.stars.name)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.white)
                                Text("For fun")
                                    .font(.custom(FontFamily.Poppins.bold, size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .skeletonable()
                            .skeletonCornerRadius(8)
                            
                            HStack(alignment: .top, spacing: 12) {
                                CardItemView(category: "For Fun", size: 126, index: 0, favoritePressed: $favoritePressed, showSub: false)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                                
                                CardItemView(category: "For Fun", size: 126, index: 1, favoritePressed: $favoritePressed, showSub: false)
                                    .skeletonable()
                                    .skeletonCornerRadius(8)
                            }
                            .padding(.bottom, 60)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
            }
            
            NavigationLink(destination: LazyView(ChatView(preview: false, startChat: true))) {
                Text("Start chat")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                    .foregroundColor(.black)
                    .background(Colors.AccessibleColors.accessibleGreen.swiftUIColor)
                    .cornerRadius(14, corners: [.topRight, .bottomLeft, .topLeft])
            }
            .skeletonable()
            .skeletonCornerRadius(14)
            .padding(.leading, 230)
            .padding(.bottom, 16)
            .padding(.trailing, 16)
        }
        .fullScreenCover(isPresented: $isDiscountViewPresented) {
            DiscountView(isPresented: $isDiscountViewPresented)
        }
        .fullScreenCover(isPresented: $isTaskOrderViewPresented) {
            NavigationView {
                TaskOrderView(isPresented: $isTaskOrderViewPresented)
            }
        }
        .onDisappear {
            viewModel.rewriteFavoriteTopics()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No premium"), message: Text("You do not have premium access"), dismissButton: .cancel())
        }
        
        .setSkeleton($showLoaderHome, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
    }
}
