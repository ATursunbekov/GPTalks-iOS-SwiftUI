//
// ListView.swift
// GpTalks-iOSApp
//
// Created by Nurzhan Ababakirov on 7/8/23.
//


import SwiftUI
struct ListView: View {
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @Binding var showAlert: Bool
    @Binding var showDeleteButton: [String: Bool]
    @Binding var searchText: String
    let userMessage: String
    let gptMessage: String
    let date: String?
    let size: CGSize
    let showChatIcon: Bool
    var chatId: String?
    init(userMessage: String, gptMessage: String, date: String? = nil, size: CGSize, showChatIcon: Bool, searchText: Binding<String>, chatId: String? = nil, showDeleteButton: Binding<[String: Bool]>, showAlert: Binding<Bool>) {
        self.userMessage = userMessage
        self.gptMessage = gptMessage
        self.date = date
        self.size = size
        self.showChatIcon = showChatIcon
        self._searchText = searchText
        self.chatId = chatId
        self._showDeleteButton = showDeleteButton
        self._showAlert = showAlert
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .bottom, spacing: 12) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let date = date {
                                Text(date)
                                    .font(.custom(FontFamily.SFProDisplay.regular, size: 11))
                                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                            }
                            HStack(spacing: 8) {
                                if showChatIcon {
                                    Image(AssetsImage.ChatIcons.chatIcon.name)
                                        .frame(width: 16, height: 16)
                                }
                                //MARK: Title
                                HighlightedText(text: userMessage, searchText: searchText)
                                    .multilineTextAlignment(.leading)
                            }
                            //MARK: Subtitle
                            Text(gptMessage.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(.custom(FontFamily.SFProDisplay.regular, size: 13))
                                .lineLimit(2)
                                .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                }
                .offset(x: showDeleteButton[chatId ?? ""] ?? false ? -50 : 0, y: showDeleteButton[chatId ?? ""] ?? false ? -3 : 0)
                
                Spacer()
                
                Image(AssetsImage.ChatIcons.arrow.name)
                    .frame(width: 16, height: 16)
                    .frame(maxHeight: .infinity, alignment: .bottomLeading)
            }
            .padding(12)
            .frame(alignment: .bottomTrailing)
            
            Group {
                if showDeleteButton[chatId ?? String()] ?? false {
                    VStack {
                        Spacer()
                        
                        Image(AssetsImage.Icons.delete.name)
                        
                        Spacer()
                    }
                    .frame(width: getDynamicWidth(width: 83))
                    .frame(maxHeight: .infinity)
                    .background(.red)
                    .frame(maxHeight: .infinity, alignment: .center)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("if you're sure that you want to delete the selected entries, click Confirm"),
                    primaryButton:  .destructive(Text("Cancel")) {
                        withAnimation(.easeInOut) {
                            showDeleteButton[chatId ?? ""] = false
                        }
                    },
                    secondaryButton: .default(Text("Confirm")) {
                        chatViewModel.deleteChatFromFirestore(chatID: chatId ?? "")
                    }
                )
            }
        }
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .background(Colors.FillColor.fill03.swiftUIColor)
        .cornerRadius(8)
    }
}
