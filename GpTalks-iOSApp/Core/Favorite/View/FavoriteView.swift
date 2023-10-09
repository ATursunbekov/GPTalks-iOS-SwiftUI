//
//  FavoriteView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 7/8/23.

import SwiftUI
import EasySkeleton

struct FavoriteView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var categoryViewModel: CategoryViewModel
    @State private var chatMessages: [ChatMessage] = []
    @State private var selectedCategory = "Tasks"
    @Binding var showLoaderFavorite: Bool
    @State private var refreshTabView = 0
    var categories = ["Tasks", "Chats"]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(Colors.SystemBackgrounds.background01.color)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0) {
                //MARK: Category switcher
                HStack(spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .foregroundColor(category == selectedCategory ? .black : .gray)
                            .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule(style: .continuous)
                                    .cornerRadius(16)
                                    .foregroundColor(Color(asset: category == selectedCategory ? Colors.AccessibleColors.accessibleGreen : Colors.SystemBackgrounds.background01))
                            )
                            .onTapGesture {
                                selectedCategory = category
                                refreshTabView += 1
                            }
                    }
                }
                .skeletonable()
                .skeletonCornerRadius(8)
                .padding(.bottom, 20)
                .padding(.horizontal, 16)
                
                if !showLoaderFavorite {
                    TabView(selection: $selectedCategory) {
                        //MARK: Tasks screen
                        TasksView(refreshTabView: $refreshTabView)
                            .tag("Tasks")
                        //MARK: Chats screen
                        ChatsView()
                            .tag("Chats")
                    }
                    .id(refreshTabView)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .animation(.default, value: selectedCategory)
                } else {
                    SkeletonView()
                }
            }
            .padding(.top, 15)
            .setSkeleton($showLoaderFavorite, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                categoryViewModel.rewriteFavoriteTopics()
            }
        }
        .onDisappear {
            categoryViewModel.rewriteFavoriteTopics()
        }
    }
}
