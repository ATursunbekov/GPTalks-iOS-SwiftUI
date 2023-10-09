//
//  ChatView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 20/7/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var showSheet = false
    @State private var height: CGFloat = 32
    @State private var keyboardHeight: CGFloat = 0
    @State private var placeholder = "Message"
    @State private var isPlaceholder = true
    @State private var isCopy = false
    @State private var isShow = false
    @State private var isDisable = false
    @State private var showAlert = false
    @State private var shareableText: String = ""
    @State private var preview: Bool
    @State private var isFirstMessageFavorite: Bool = false
    @State private var isFavoriteChatView: Bool
    @State private var isHistory: Bool
    @State private var continueChatTapped: Bool = false
    @State private var typingIndicatorScale: CGFloat = 1.0
    @State private var dotsOpacity: Double = 1.0
    @State private var activeDotIndex: Int = 0
    private var chatID: String?
    private var startChat: Bool
    private var prePromptMessage: String?
    private var topic: String?
    private var gptMessage: String?
    private var userMessage: String?
    private var selectedMessageId: String?
    private var topicSender: String?
    private var isFavorite: Bool?
    
    init(topic: String? = nil, preview: Bool, startChat: Bool, prePromptMessage: String? = nil, userMessage: String? = nil, gptMessage: String? = nil, selectedMessageId: String? = nil, isHistory: Bool = false, chatID: String? = nil, topicSender: String? = nil, isFavorite: Bool? = nil, isFavoriteChatView: Bool = false) {
        self.startChat = startChat
        self.userMessage = startChat ? nil : userMessage
        self.gptMessage = startChat ? nil : gptMessage
        _preview = State(initialValue: preview)
        self.selectedMessageId = selectedMessageId
        self.prePromptMessage = startChat ? nil : prePromptMessage
        self.chatID = chatID
        self.topicSender = topicSender
        self.topic = startChat ? nil : topic
        self.isFavorite = isFavorite
        _isFavoriteChatView = State(initialValue: isFavoriteChatView)
        _isHistory = State(initialValue: isHistory)
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            //MARK: Suggestions
            if chatViewModel.chatMessages.isEmpty && !chatViewModel.isTyping && !preview{
                VStack(alignment: .center, spacing: 24) {
                    Spacer()
                    
                    Text("""
                            Hey there!
                            
                            Ask me anything you would like
                            or choose one of our suggestions below
                            """)
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .dismissKeyboardOnDrag()
                    
                    Button {
                        AmplitudeManager.shared.suggestionPressed()
                        showSheet = true
                    } label: {
                        Text("Suggestions")
                            .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(height: 40, alignment: .center)
                            .background(Colors.AccessibleColors.accessibleTeal.swiftUIColor)
                            .cornerRadius(14)
                    }
                    .dismissKeyboardOnDrag()
                }
                .dismissKeyboardOnDrag()
            }
            //MARK: Normal chat
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    VStack {
                        if chatViewModel.isTyping {
                            HStack(spacing: -27) {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .foregroundColor(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(dotsOpacity * (1 - Double(abs(activeDotIndex - index)) * 0.4))
                                }
                                .padding(.trailing, 12)
                                .padding(.leading, 18)
                                .padding(.vertical, 12)
                            }
                            .ignoresSafeArea(.all)
                            .background(Colors.FillColor.fill03.swiftUIColor)
                            .clipShape(TypingShape())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id("typingIndicator")
                            .rotationEffect(.degrees(180))
                            .scaleEffect(typingIndicatorScale)
                            .onAppear {
                                scrollView.scrollTo("typingIndicator", anchor: .bottom)
                                withAnimation(Animation.easeInOut(duration: 0.9).repeatForever()) {
                                    typingIndicatorScale = 1.01
                                    dotsOpacity = 0.2
                                }
                            }
                            .onDisappear {
                                withAnimation {
                                    typingIndicatorScale = 1.0
                                }
                                activeDotIndex = 0
                            }
                        }
                        
                        Spacer()
                        
                        ForEach(chatViewModel.chatMessages.indices.reversed(), id: \.self) { index in
                            let message = chatViewModel.chatMessages[index]
                            let previousMessage = index > 0 ? chatViewModel.chatMessages[index - 1] : nil
                            
                            VStack {
                                HStack {
                                    if DateHelper.shouldShowDateSeparator(for: message, previousMessage: previousMessage) {
                                        Text(DateHelper.dateSeparator(date: message.dateCreated) + " " + DateHelper.formatDate(message.dateCreated).replacingOccurrences(of: "•", with: ""))
                                            .font(.custom(FontFamily.SFProDisplay.regular, size: 11))
                                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                                    }
                                }
                                messageView(message: message, isFirstMessageFavorite: $isFirstMessageFavorite, isCopy: $isCopy, isDisable: $isDisable, isShow: $isShow, showAlert: $showAlert, index: index)
                            }
                            .id(message.id)
                        }.rotationEffect(.degrees(180))
                    }
                    .onChange(of: chatViewModel.chatMessages) { _ in
                        if chatViewModel.chatMessages.last?.id == chatViewModel.chatMessages.first?.id {
                            scrollView.scrollTo("typingIndicator", anchor: .bottom)
                        } else {
                            scrollView.scrollTo(chatViewModel.chatMessages.last?.id, anchor: .bottom)
                        }
                    }
                }
                .dismissKeyboardOnDrag()
                .rotationEffect(.degrees(180))
            }
            .padding(.top)
            .overlay(backgroundView(isCopy: isCopy, isDisable: isDisable))
            Spacer()
            
            //MARK: Action buttons
            if preview {
                HStack(alignment: .bottom, spacing: 16) {
                    Button {
                        preview = false
                        isShow = true
                        continueChatTapped = true
                        guard let chatID = chatID else { return }
                        
                        if isFavoriteChatView == true {
                            chatViewModel.loadAllChatMessagesFromFirestore(chatID: chatID)
                        } else {
                            chatViewModel.loadHistoryChatMessagesFromFirestore(chatID: chatID)
                        }
                    } label: {
                        Text("Continue this chat")
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .inset(by: 0.5)
                                    .stroke(.white, lineWidth: 1)
                            )
                    }
                    
                    Button {
                        share(text: shareableText)
                    } label: {
                        Text("Share")
                            .font(.custom(FontFamily.SFProDisplay.semibold, size: 15))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
                            .background(.white)
                            .cornerRadius(14)
                    }
                }
                //MARK: Text field
            } else {
                HStack(alignment: .bottom, spacing: 12) {
                    TextViewWrapper(text: $chatViewModel.messageText, height: $height, placeholder: $placeholder, isPlaceholder: $isPlaceholder)
                        .frame(width: getDynamicWidth(width: 320),height: self.height < 112 ? self.height : 112)
                        .background(.clear)
                        .background {
                            HStack {
                                Text(placeholder)
                                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                                    .opacity(isPlaceholder ? 1 : 0)
                                Spacer()
                            }
                            .offset(x: 12)
                        }
                    
                    Button {
                        chatViewModel.sendMessageButton(chatID: chatID)
                    } label: {
                        Image(AssetsImage.Icons.sendMessage.name)
                            .frame(width: getDynamicWidth(width: 24), height: getDynamicHeight(height: 24))
                    }
                    .padding(.vertical, 3)
                    .buttonStyle(PlainButtonStyle())
                    .disabled(chatViewModel.isGeneratingResponse)
                }
                .padding(.vertical, 8)
                .frame(width: getDynamicWidth(width:390), alignment: .center)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, self.keyboardHeight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Chat")
                        .font(.custom(FontFamily.SFProDisplay.semibold, size: 17))
                        .foregroundColor(.white)
                }
            }
        }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("if you're sure that you want to delete the selected entries, click Confirm"),
                    primaryButton:  .destructive(Text("Cancel")),
                    secondaryButton: .default(Text("Confirm")) {
                        if let messageIdToDelete = selectedMessageId {
                            chatViewModel.deleteMessageWithIDFromFirestore(chatID: messageIdToDelete)
                        }
                    }
                )
            }
        
        .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
        .halfSheet(showSheet: $showSheet) {
            SuggestionView(isPresented: $showSheet)
                .environmentObject(chatViewModel) //MARK: TODO
                .environmentObject(categoryViewModel) //MARK: TODO
        } onEnd: {}
        
        .onAppear {
            print(topic ?? "AIDAR")
            print(chatViewModel.generateNewChatID)
            self.chatViewModel.resetState()
            if !preview{
                guard let topic = topic else { return }
                self.chatViewModel.getSuggestionPrompt(title: topic, prePromptMessage: prePromptMessage)
                isShow = true
            } else {
                isShow = false
            }
            if let topicSender = topicSender {
                let initialSender: MessageSender = topicSender == "user" ? .user : .assistant
                self.chatViewModel.previewMessage(userMessage: userMessage, gptMessage: gptMessage, senderID: initialSender)
            }
            guard let chatID = chatID else { return }
            if isFavoriteChatView == false {
                chatViewModel.loadHistoryChatMessagesFromFirestore(chatID: chatID)
            }
            shareableText = (userMessage ?? "") + "\n" + (gptMessage ?? "")
        }
        .onDisappear {
            chatViewModel.resetState()
            chatViewModel.generateNewChatID = UUID().uuidString
            chatViewModel.cancelAllTasks()
        }
    }
    
    func messageView(message: ChatMessage, isFirstMessageFavorite: Binding<Bool>, isCopy: Binding<Bool>, isDisable: Binding<Bool>, isShow: Binding<Bool>, showAlert: Binding<Bool>, index: Int) -> some View {
        let chatIDToUse = isFavoriteChatView || isHistory ? chatID ?? "" : chatViewModel.generateNewChatID
        
        return ChatMessageCell(isFirstMessageFavorite: isFirstMessageFavorite, isCopy: $isCopy, isShow: $isShow, isDisable: $isDisable, showAlert: $showAlert, isStartChat: startChat, message: message, topic: topic, isMessageFavorite: isFavoriteChatView ? (continueChatTapped ? message.isFavorite : isFavorite) ?? false : message.isFavorite, index: index, chatID: chatIDToUse, messageID: message.id)
    }
    
    func backgroundView(isCopy: Bool, isDisable: Bool) -> some View {
        Group {
            if isCopy {
                CopyTextView(isCopy: $isCopy, isDisable: $isDisable)
            } else {
                Color.clear
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(preview: false, startChat: false, prePromptMessage: "hello", chatID: "")
            .environmentObject(ChatViewModel())
    }
}
