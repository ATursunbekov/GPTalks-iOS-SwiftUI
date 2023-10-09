//
//  HistoryView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 8/8/23.
//

import EasySkeleton
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @Binding var isLoading: Bool
    @State private var showDeleteButton: [String: Bool] = [:]
    @State private var didCancelDelete = false
    @State private var searchText = ""
    @State private var showAlert = true
    @State private var offsets: [String: CGFloat] = [:]
    
    private var searchResult: [ChatMessage] {
        if searchText.isEmpty {
            return chatViewModel.chats
        } else {
            return chatViewModel.chats.filter{
                if var topic = $0.topic {
                    topic = topic.lowercased()
                    return topic.contains(searchText.lowercased())
                } else {
                    return false
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(Colors.SystemBackgrounds.background01.color)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                CustomSearchBar(isLoading: $isLoading, searchText: $searchText)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(searchResult) { chat in
                            NavigationLink(destination: (ChatView(preview: true, startChat: false, userMessage: chat.topic, gptMessage: chat.content, isHistory: true, chatID: chat.id))) {
                                HStack(spacing: 0) {
                                    
                                    ListView(userMessage: chat.topic ?? "", gptMessage: chat.content, size: CGSize(width: getDynamicWidth(width: 358), height: 83), showChatIcon: false, searchText: $searchText, chatId: chat.id, showDeleteButton: $showDeleteButton, showAlert: $showAlert)
                                        .gesture(
                                            DragGesture()
                                                 .onChanged { gesture in
                                                    let offset = gesture.translation.width
                                                    withAnimation(.easeInOut) {
                                                        if offset < -83 {
                                                            self.showDeleteButton[chat.id] = true
                                                        } else {
                                                            self.showDeleteButton[chat.id] = false
                                                        }
                                                    }
                                                }
                                                .onEnded { gesture in
                                                    withAnimation(.easeInOut) {
                                                        let offset = gesture.translation.width
                                                        if offset < -83 {
                                                            self.showDeleteButton[chat.id] = true
                                                            showAlert.toggle()
                                                        }
                                                    }
                                                }
                                        )
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .skeletonable()
                        .skeletonCornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 15)
        }
        .setSkeleton($isLoading, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(isLoading: .constant(false))
            .environmentObject(ChatViewModel())
    }
}
