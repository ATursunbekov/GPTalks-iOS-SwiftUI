//
//  TopicView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/6/23

import SwiftUI
import EasySkeleton

struct CategoryView: View {
    //For scene detection
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var selectedCategory = "All"
    @State var refreshTabView = 0
    @Binding var showLoaderCategory: Bool
    
    var columns: [GridItem] {
        return [
            GridItem(.flexible(), spacing: 12, alignment: .trailing),
            GridItem(.flexible(), alignment: .leading),
        ]
    }
    
    var tempArr = ["All", "Education", "For Fun", "Work", "Lifestyle"]
    
    var body: some View {
        ZStack {
            Color(asset: Colors.SystemBackgrounds.background01)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(tempArr, id: \.self) { category in
                                Text(category)
                                    .foregroundColor(category == selectedCategory ? .black : .gray)
                                    .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                                    .background(
                                        Capsule(style: .continuous)
                                            .cornerRadius(16)
                                            .foregroundColor(Color(asset: category == selectedCategory ? categoryViewModel.getCategoryButColor(categoty: category) : Colors.SystemBackgrounds.background01))
                                    )
                                    .onTapGesture {
                                        selectedCategory = category
                                        refreshTabView += 1
                                    }
                            }
                        }
                        .skeletonable()
                        .skeletonCornerRadius(14)
                    }
                    .onChange(of: selectedCategory) { newValue in
                        value.scrollTo(newValue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                if !showLoaderCategory {
                    TabView(selection: $selectedCategory) {
                        ForEach(tempArr, id: \.self) { category in
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(categoryViewModel.getAllTopics[category] ?? [], id: \.id) { topic in
                                        ZStack(alignment: .bottomTrailing) {
                                            
                                            NavigationLink(destination: LazyView(ChatView(topic: topic.title, preview: false ,startChat: false, prePromptMessage: topic.preprompt))) {
                                            CardView(title: topic.title, description: topic.subtitle, size: 108, topicID: topic.id, selectedCategory: topic.category, isFavorite: topic.favorite,task: topic , refreshTabs: $refreshTabView)
                                                .multilineTextAlignment(.leading)
                                        }
                                            Button {
                                                categoryViewModel.toggleFavoriteFor(topicID: topic.id, isFavorite: !topic.favorite, inCategory: topic.category)
                                                categoryViewModel.updateFavoriteStatus(topicID: topic.id, favorite: !topic.favorite, task: topic)
                                                    refreshTabView += 1
                                            }
                                            label: {
                                                Image(topic.favorite ?  AssetsImage.Icons.heartFill.name : AssetsImage.Icons.heart.name)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .tag(category)
                            }
                        }
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
            .setSkeleton($showLoaderCategory, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
        }
        .onAppear {
            selectedCategory = "All"
            refreshTabView += 1
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                categoryViewModel.rewriteFavoriteTopics()
            }
        }
        .onDisappear {
            categoryViewModel.rewriteFavoriteTopics()
        }
        .environmentObject(categoryViewModel)
    }
}


struct FourthVideww_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(showLoaderCategory: .constant(true))
            .environmentObject(CategoryViewModel())
    }
}

struct SkeletonView: View {
    var columns: [GridItem] {
        return [
            GridItem(.flexible(), spacing: 12, alignment: .trailing),
            GridItem(.flexible(), alignment: .leading),
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<10) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 108)
                        .skeletonable()
                        .skeletonCornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}


public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
