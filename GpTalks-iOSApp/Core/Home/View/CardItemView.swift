//
//  CardItemView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 20/9/23.
//

import SwiftUI

struct CardItemView: View {
    @State private var selectedCard: String? = nil
    @State private  var refreshNumber = 0
    @EnvironmentObject var viewModel: CategoryViewModel
    var category: String
    var size: CGFloat
    var index: Int
    @Binding var favoritePressed : Bool
    var showSub : Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if index >= 0 && index < viewModel.getAllTopics[category]?.count ?? 0 {
                if let topic = viewModel.getAllTopics[category]?[index] {
                    NavigationLink(destination: LazyView(ChatView(topic: topic.title, preview: false, startChat: false, prePromptMessage: viewModel.getAllTopics[category]?[index].preprompt)), tag: topic.id, selection: $selectedCard) {
                        CardView(title: topic.title, description: showSub ? "" : topic.subtitle, size: size, topicID: topic.id, selectedCategory: topic.category, isFavorite: topic.favorite, task: topic, refreshTabs: $refreshNumber)
                            .multilineTextAlignment(.leading)
                    }
                    .disabled(favoritePressed)
                    
                    Button {
                        favoritePressed = true
                        viewModel.toggleFavoriteFor(topicID: topic.id, isFavorite: !topic.favorite, inCategory: topic.category)
                        viewModel.updateFavoriteStatus(topicID: topic.id, favorite: !topic.favorite, task: topic)
                        refreshNumber += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            favoritePressed = false
                        }
                    } label: {
                        Image(topic.favorite ? AssetsImage.Icons.heartFill.name : AssetsImage.Icons.heart.name)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
            } else {
                if let topic = viewModel.homeTopics["fun"]?[0] {
                    NavigationLink(destination: LazyView(ChatView(topic: topic.title, preview: false, startChat: false, prePromptMessage: viewModel.homeTopics["fun"]?[0].preprompt)), tag: topic.id, selection: $selectedCard) {
                        CardView(title: topic.title, description: topic.subtitle, size: size, topicID: topic.id, selectedCategory: topic.category, isFavorite: topic.favorite, task: topic, refreshTabs: $refreshNumber)
                            .multilineTextAlignment(.leading)
                            .disabled(favoritePressed)
                    }
                    
                    Button {
                        favoritePressed = true
                        viewModel.toggleFavoriteFor(topicID: topic.id, isFavorite: !topic.favorite, inCategory: topic.category)
                        viewModel.updateFavoriteStatus(topicID: topic.id, favorite: !topic.favorite, task: topic)
                        refreshNumber += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            favoritePressed = false
                        }
                    } label: {
                        Image(topic.favorite ? AssetsImage.Icons.heartFill.name : AssetsImage.Icons.heart.name)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
            }
        }
    }
}
