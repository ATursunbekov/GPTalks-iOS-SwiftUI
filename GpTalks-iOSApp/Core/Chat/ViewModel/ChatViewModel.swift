//
//  ChatViewModel.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 20/7/23.
//

import Foundation
import Alamofire
import Combine
import FirebaseFirestore
import Firebase

class ChatViewModel: ObservableObject {
    @Published var chatMessages: [ChatMessage] = []
    @Published var chats: [ChatMessage] = []
    @Published var favoriteChats: [ChatMessage] = []
    @Published var favoriteChatMessages: [ChatMessage] = []
    
    @Published var isTyping: Bool = false
    @Published var messageText: String = ""
    @Published var isGeneratingResponse: Bool = false
    @Published var isSubscribed: Bool = false
    @Published var currentTopic: String?
    
    var generateNewChatID: String = ""
    private let firestore = Firestore.firestore()
    private let maxQuestionsPerDay = 240
    private let isChatEmpty: Bool = false
    private var scrollToBottom: Bool = false
    private var isMessageSent: Bool = false
    private let isFieldEmpty: Bool = false
    private var prePromptMessage: String?
    private var title: String?
    private let uid = UserDefaults.standard.string(forKey: "uid")
     var userMessage: String?
     var gptMessage: String?
    public var cancellables: Set<AnyCancellable> = []
    
    //MARK: User message
    private func createUserMessage(content: String) -> ChatMessage {
        return ChatMessage(id: UUID().uuidString, content: content.trimmingCharacters(in: .whitespacesAndNewlines), dateCreated: Date(), senderID: MessageSender.user, isFavorite: false)
    }
    
    //MARK: Assistant message
    private func createAssistantMessage(content: String) -> ChatMessage {
        return ChatMessage(id: UUID().uuidString, content: content.trimmingCharacters(in: .whitespacesAndNewlines), dateCreated: Date(), senderID: MessageSender.assistant, isFavorite: false)
    }
    
    private func appendUserAndAssistantMessages(userContent: String?, assistantContent: String?) {
        if let userContent = userContent {
            let userMessage = createUserMessage(content: userContent)
            chatMessages.append(userMessage)
        }
        
        if let assistantContent = assistantContent {
            let assistantMessage = createAssistantMessage(content: assistantContent)
            chatMessages.append(assistantMessage)
        }
    }
    
    init(prePromptMessage: String? = nil, title: String? = nil) {
        self.prePromptMessage = prePromptMessage
        self.title = title
        self.generateNewChatID = UUID().uuidString
        
        loadChatsFromFirestore()
        
        if let topicTitle = title {
            let topicMessage = createUserMessage(content: topicTitle)
            chatMessages.append(topicMessage)
        }
        
        if let prePrompt = prePromptMessage {
            sendMessage(message: prePrompt)
                .sink { completion in
                } receiveValue: { response in
                    guard let textResponse = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
                    let assistantMessage = self.createAssistantMessage(content: textResponse)
                    self.chatMessages.append(assistantMessage)
                }
                .store(in: &cancellables)
        }
    }
    
    //MARK: Send message button
    func sendMessageButton(chatID: String? = nil) {
        isTyping = true
        scrollToBottom = true
        isGeneratingResponse = true
        
        let userDefaults = UserDefaults.standard
        let questionCount = userDefaults.integer(forKey: "questionCount")
        
        if !isFieldEmpty{
            isMessageSent = false
            isTyping = false
            isGeneratingResponse = false
        }
        
        if !isSubscribed && questionCount >= maxQuestionsPerDay {
            isMessageSent = false
            return
        }
        
        if isSubscribed || questionCount < maxQuestionsPerDay {
            guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            
            let userMessage = self.createUserMessage(content: messageText)
            
            if chatMessages.contains(where: { $0.id == userMessage.id }) {
                return
            }
            chatMessages.append(userMessage)
            
            if currentTopic == nil {
                currentTopic = userMessage.content.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            sendMessage(message: messageText.trimmingCharacters(in: .whitespacesAndNewlines))
                .sink { completion in
                    self.isTyping = false
                    self.isGeneratingResponse = false
                } receiveValue: { response in
                    guard let textResponse = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
                    let assistanMessage = self.createAssistantMessage(content: textResponse)
                    self.chatMessages.append(assistanMessage)
                    if let chatID = chatID {
                        self.saveChatToFirestore(message: userMessage, chatID: chatID)
                        self.saveChatToFirestore(message: assistanMessage, topic: userMessage.content, chatID: chatID)
                    } else {
                        self.saveChatToFirestore(message: userMessage)
                        self.saveChatToFirestore(message: assistanMessage, topic: userMessage.content)
                    }
                    self.isGeneratingResponse = false
                }
                .store(in: &cancellables)
            
            messageText = ""
        } else {
            isMessageSent = false
        }
    }
    
    //MARK: Send message API
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        isGeneratingResponse = true
        isTyping = true
        
        var chatMessages: [[String: String]] = []
        
        for chatMessage in self.chatMessages {
            let role = chatMessage.senderID == .user ? "user" : "assistant"
            let content = chatMessage.content
            let message = ["role": role, "content": content]
            chatMessages.append(message)
        }
        chatMessages.append(["role": "user", "content": message])
        
        let parameters = OpenAICompletionsBody(
            model: "gpt-4-0314",
            messages: chatMessages,
            temperature: nil,
            maxTokens: 256
        )
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request("https://api.openai.com/v1/chat/completions", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: OpenAICompletionsResponse.self) { response in
                    self.isGeneratingResponse = false
                    self.isTyping = false
                    
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                            print("Error message: \(errorMessage)")
                        }
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func cancelAllTasks() {
        AF.session.getAllTasks { (tasks) in
            tasks.forEach {$0.cancel() }
        }
    }
    
    //MARK: Preview chat
    func previewMessage(userMessage: String?, gptMessage: String?, senderID: MessageSender) {
        self.userMessage = userMessage
        self.gptMessage = gptMessage
        
        if let titleMessage = userMessage {
            let title = createUserMessage(content: titleMessage)
            self.chatMessages.append(title)
        }
        
        if let savedMessage = gptMessage {
            let message: ChatMessage

            if senderID == .user {
                message = createUserMessage(content: savedMessage)
            } else {
                message = createAssistantMessage(content: savedMessage)
            }

            self.chatMessages.append(message)
        }
    }
    
    func getSuggestionPrompt(title: String, prePromptMessage: String?) {
        self.title = title
        
        let topicMessage = ChatMessage(id: UUID().uuidString, content: title, dateCreated: Date(), senderID: MessageSender.user, isFavorite: false)
        if currentTopic == nil {
            currentTopic = topicMessage.content.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        self.chatMessages.append(topicMessage)
        
        self.prePromptMessage = prePromptMessage
        if let prePrompt = prePromptMessage {
            sendMessage(message: prePrompt)
                .sink { completion in
                } receiveValue: { response in
                    guard let textResponse = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
                    let assistantMessage = self.createAssistantMessage(content: textResponse)
                    self.chatMessages.append(assistantMessage)
                    self.saveChatToFirestore(message: assistantMessage, topic: title)
                    self.saveChatToFirestore(message: topicMessage)
                }
                .store(in: &cancellables)
        }
    }
    
    func updateFavoriteStatusInHistory(chatID: String, messageID: String, isFavorite: Bool, topic: String) {
        ChatService.shared.updateFavoriteStatusInHistory(chatID: chatID, messageID: messageID, isFavorite: isFavorite, topic: topic)
    }
    
    func saveChatToFirestore(message: ChatMessage, topic: String? = nil, chatID: String? = nil) {
        ChatService.shared.saveHistoryChatToFirestore(message: message, chatID: chatID ?? generateNewChatID, topic: topic)
    }
    
    func loadChatsFromFirestore() {
        ChatService.shared.loadHistoryChatsFromFirestore { chats  in
            self.chats = chats
        }
    }
    
    
    func loadHistoryChatMessagesFromFirestore(chatID: String) {
        ChatService.shared.loadHistoryChatMessagesFromFirestore(chatID: chatID) { message in
            self.chatMessages = message
        }
    }
    
    func loadFavoriteChatMessagesFromFirestore(chatID: String) {
        ChatService.shared.loadFavoriteMessagesFromFirestore(chatID: chatID) { favoriteMessage in
            self.favoriteChatMessages = favoriteMessage
        }
    }
    
    func loadAllChatMessagesFromFirestore(chatID: String) {
        ChatService.shared.loadAllChatMessagesFromFirestore(chatID: chatID) { message in
            self.chatMessages = message
        }
    }
    
    func loadFavoriteChatsFromFirestore() {
        ChatService.shared.loadFavoriteChatsFromFirestore() { favoriteChats in
            self.favoriteChats = favoriteChats
        }
    }
    
    func deleteMessageWithIDFromFirestore(chatID: String) {
        ChatService.shared.deleteFavoriteMessageWithIDFromFirestore(chatID: chatID)
    }
    
    func deleteChatFromFirestore(chatID: String){
        ChatService.shared.deleteHistoryChatFromFirestore(chatID: chatID)
    }

    
    func resetState() {
        messageText = ""
        chatMessages = []
        isTyping = false
        currentTopic = nil
    }
    
    func refreshData() {
        loadChatsFromFirestore()
        loadFavoriteChatsFromFirestore()
    }
}
