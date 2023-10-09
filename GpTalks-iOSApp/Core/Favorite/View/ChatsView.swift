
// ChatsView.swift
// GpTalks-iOSApp
//
// Created by Alikhan Tursunbekov on 9/8/23.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @State private var searchText = ""
    private var selectedMessageId: String? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(Colors.SystemBackgrounds.background01.color)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(chatViewModel.favoriteChats, id: \.id) { favoriteChats in
                        NavigationLink(destination: LazyView(ChatView(preview: true, startChat: false, userMessage: favoriteChats.topic, gptMessage: favoriteChats.content, selectedMessageId: favoriteChats.id, chatID: favoriteChats.chatID, topicSender: favoriteChats.senderID.rawValue, isFavorite: favoriteChats.isFavorite, isFavoriteChatView: true))) {
                            ListView(userMessage: favoriteChats.topic ?? "", gptMessage: favoriteChats.content, date: DateHelper.formatDate(favoriteChats.dateCreated), size: CGSize(width: getDynamicWidth(width: 358), height: 104), showChatIcon: true, searchText: $searchText, showDeleteButton: .constant([String() : false]), showAlert: .constant(false))
                        }
                    }
                    .padding(.trailing, 16)
                }
            }
        }
        .onAppear {
            chatViewModel.loadFavoriteChatsFromFirestore()
        }
    }
}
