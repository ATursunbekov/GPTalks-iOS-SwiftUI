//
//  SuggestionVIew.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 22/7/23.
//

import SwiftUI

struct SuggestionView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var selectedCategory = "All"
    @Binding var isSuggestionsPresented: Bool
    @State private var refreshNumber = 0
    
    init(isPresented: Binding<Bool>) {
        _isSuggestionsPresented = isPresented
//        categoryViewModel.fetchCategories()
    }
    
    var body: some View {
        ZStack {
            Color(asset: Colors.SystemBackgrounds.background01)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Capsule()
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                    .frame(width: 36, height: 4)
                    .padding(.top, 5)
                
                ZStack {
                    Text("Suggestion")
                        .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            isSuggestionsPresented = false
                        } label: {
                            Image(AssetsImage.Icons.close.name)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Colors.AccessibleColors.accessibleGray01.swiftUIColor)
                                .padding(4)
                                .background(Colors.FillColor.fill03.swiftUIColor)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 16)
                    }
                }
                .padding(.vertical, 16)
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(categoryViewModel.categories, id: \.self) { category in
                                Text(category)
                                    .foregroundColor(category == selectedCategory ? .black : .gray)
                                    .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                                    .background(
                                        Capsule(style: .continuous)
                                            .cornerRadius(16)
                                            .foregroundColor(Color(asset:category == selectedCategory ? Colors.AccessibleColors.accessibleYellow : Colors.SystemBackgrounds.background01))
                                    )
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                            }
                            
                        }
                    }
                    .padding(.bottom, 20)
                    .onChange(of: selectedCategory) { newValue in
                        value.scrollTo(newValue)
                    }
                }
                .padding(.horizontal, 16)
                
                TabView(selection: $selectedCategory) {
                    ForEach(categoryViewModel.categories, id: \.self) { category in
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(categoryViewModel.getAllTopics[category] ?? []) { topic in
                                    CardView(title: topic.title, description: topic.subtitle, size: 108, topicID: topic.id, selectedCategory: topic.category, hideButton: true, isFavorite: topic.favorite, refreshTabs: $refreshNumber)
                                        .multilineTextAlignment(.leading)
                                        .onTapGesture {
                                            print("OK")
                                            isSuggestionsPresented = false
                                            chatViewModel.getSuggestionPrompt(title: topic.title, prePromptMessage: topic.preprompt)
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .tag(categoryViewModel.getTag(name: category))
                    }
                }
                .id(refreshNumber)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .environmentObject(categoryViewModel)
    }
}
