//
//  TasksView.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 9/8/23.

import SwiftUI

struct TasksView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @Binding var refreshTabView: Int
    
    var columns: [GridItem] {
        return [
            GridItem(.flexible(), spacing: 12, alignment: .trailing),
            GridItem(.flexible(), alignment: .leading),
        ]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categoryViewModel.favoriteTopics, id: \.id) { topic in
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
            }
            .padding(.horizontal, 16)
        }
    }
