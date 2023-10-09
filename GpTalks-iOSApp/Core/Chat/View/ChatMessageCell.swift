//
//  ChatMessageCell.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 24/7/23.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore

struct ChatMessageCell: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State private var isFavorite: Bool = false
    @Binding var isFirstMessageFavorite: Bool
    @Binding var isCopy: Bool
    @Binding var isShow: Bool
    @Binding var isDisable: Bool
    @Binding var showAlert: Bool
    let isStartChat: Bool
    let message: ChatMessage
    let topic: String?
    @State var isMessageFavorite: Bool
    let index: Int
    let chatID: String
    let messageID: String
    
    var isUserMessage: Bool {
        return message.senderID.rawValue == MessageSender.user.rawValue
    }
    
    var body: some View {
        //MARK: Message itself
        VStack(alignment: message.senderID == MessageSender.user ? .trailing : .leading, spacing: 8) {
            HStack(alignment: .bottom, spacing: 4) {
                VStack(alignment: message.senderID == MessageSender.user ? .trailing : .leading, spacing: 8) {
                    Text(message.content)
                        .font(.system(size: 15))
                        .foregroundColor(message.senderID == MessageSender.user ? Colors.SystemBackgrounds.background01.swiftUIColor : .white)
                        .padding(message.senderID == MessageSender.user ? .trailing : .leading, 18)
                        .padding(message.senderID == MessageSender.user ? .leading : .trailing, 12)
                        .padding(.vertical, 8)
                }
                .background(message.senderID == MessageSender.user ? Colors.AccessibleColors.accessibleTeal.swiftUIColor : Colors.FillColor.fill03.swiftUIColor)
                .clipShape(BubbleShape(message: message))
                .frame(maxWidth: .infinity, alignment: message.senderID == MessageSender.user ? .trailing : .leading)
                
                if message.senderID == MessageSender.user && !isShow {
                    Image(AssetsImage.Icons.profile.name)
                        .frame(width: 24, height: 24)
                }
                
            }
            
            //MARK: Buttons under message
            HStack(spacing: 12) {
                if message.senderID == MessageSender.user {
                    let myMessage = ChatMessage(id: UUID().uuidString, content: message.content, dateCreated: Date(), senderID: MessageSender.user, isFavorite: true)
                    Button {
                        if !isMessageFavorite && index != 0 {
                            AmplitudeManager.shared.messageSaved()
                            isFavorite.toggle()
                            if !isStartChat {
                                chatViewModel.updateFavoriteStatusInHistory(chatID: chatID, messageID: messageID, isFavorite: true, topic: (topic ?? chatViewModel.currentTopic) ?? "No topic")
                            } else {
                                chatViewModel.updateFavoriteStatusInHistory(chatID: chatID, messageID: messageID, isFavorite: true, topic: (topic ?? chatViewModel.currentTopic) ?? "No topic")
                            }
                            if index != 0 {
                                isFirstMessageFavorite = true
                            }
                        } else {
                            showAlert.toggle()
                        }
                    } label: {
                        Image(isFavorite || isMessageFavorite || (index == 0 && isFirstMessageFavorite) ? AssetsImage.Icons.heartFill.name : AssetsImage.Icons.heart.name)
                            .frame(width: 20, height: 20)
                    }
                    .disabled(isFavorite || index == 0)
                    
                    Button {
                        UIPasteboard.general.string = message.content
                        isCopy.toggle()
                        isDisable.toggle()
                    } label: {
                        Image(AssetsImage.Icons.copy.name)
                            .frame(width: 20, height: 20)
                    }
                    .disabled(isDisable)
                    
                } else {
                    Button {
                        if !isMessageFavorite && index != 0 {
                            isFavorite.toggle()
                            if !isStartChat {
                                chatViewModel.updateFavoriteStatusInHistory(chatID: chatID, messageID: messageID,isFavorite: true, topic: (topic ?? chatViewModel.currentTopic) ?? "No topic")
                            } else {
                                chatViewModel.updateFavoriteStatusInHistory(chatID: chatID, messageID: messageID,isFavorite: true, topic: (topic ?? chatViewModel.currentTopic) ?? "No topic")
                            }
                            if index != 0 {
                                isFirstMessageFavorite = true
                            }
                        } else {
                            showAlert.toggle()
                        }
                    } label: {
                        Image(isFavorite || isMessageFavorite || (index == 0 && isFirstMessageFavorite) ? AssetsImage.Icons.heartFill.name : AssetsImage.Icons.heart.name)
                            .frame(width: 20, height: 20)
                    }
                    .disabled(isFavorite || index == 0)
                    if isShow {
                        Button {
                            share(text: message.content)
                        } label: {
                            Image(AssetsImage.Icons.send.name)
                                .frame(width: 20, height: 20)
                        }
                    }
                  
                    Button {
                        UIPasteboard.general.string = message.content
                        isCopy.toggle()
                        isDisable.toggle()
                    } label: {
                        Image(AssetsImage.Icons.copy.name)
                            .frame(width: 20, height: 20)
                    }
                    .disabled(isDisable)
                }
            }
            .padding(.horizontal, message.senderID == MessageSender.user ? 8 : 8)
            .padding(.bottom, 16)
        }
        .padding(message.senderID == MessageSender.user ? .leading : .trailing, 54)
    }
}

//MARK: Typing shape
struct TypingShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 20, y: height))
        path.addLine(to: CGPoint(x: width-15, y: height))
        path.addCurve(to: CGPoint(x: width, y: height-15), controlPoint1: CGPoint(x: width-8, y: height), controlPoint2: CGPoint(x: width, y: height - 8))
        path.addLine(to: CGPoint(x: width, y: 15))
        path.addCurve(to: CGPoint(x: width-15, y: 0), controlPoint1: CGPoint(x: width, y: 8), controlPoint2: CGPoint(x: width - 8, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.addCurve(to: CGPoint(x: 5, y: 15), controlPoint1: CGPoint(x: 12, y: 0), controlPoint2: CGPoint(x: 5, y: 8))
        path.addLine(to: CGPoint(x: 5, y: height - 10))
        path.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 5, y: height-1), controlPoint2: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: -1, y: height))
        path.addCurve(to: CGPoint(x: 12, y: height - 4), controlPoint1: CGPoint(x: 4, y: height+1), controlPoint2: CGPoint(x: 8, y: height - 1))
        path.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: CGPoint(x: 15, y: height), controlPoint2: CGPoint(x: 20, y: height))
        
        return Path(path.cgPath)
    }
}

//MARK: Message shape
struct BubbleShape: Shape {
    let message: ChatMessage
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = UIBezierPath()
        
        if message.senderID == MessageSender.user {
            path.move(to: CGPoint(x: width - 20, y: height))
            path.addLine(to: CGPoint(x: 15, y: height))
            path.addCurve(to: CGPoint(x: 0, y: height - 15), controlPoint1: CGPoint(x: 8, y: height), controlPoint2: CGPoint(x: 0, y: height - 8))
            path.addLine(to: CGPoint(x: 0, y: 15))
            path.addCurve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 0, y: 8), controlPoint2: CGPoint(x: 8, y: 0))
            path.addLine(to: CGPoint(x: width - 20, y: 0))
            path.addCurve(to: CGPoint(x: width - 5, y: 15), controlPoint1: CGPoint(x: width - 12, y: 0), controlPoint2: CGPoint(x: width - 5, y: 8))
            path.addLine(to: CGPoint(x: width - 5, y: height - 10))
            path.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 5, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width + 1, y: height))
            path.addCurve(to: CGPoint(x: width - 12, y: height - 4), controlPoint1: CGPoint(x: width - 4, y: height + 1), controlPoint2: CGPoint(x: width - 8, y: height - 1))
            path.addCurve(to: CGPoint(x: width - 20, y: height), controlPoint1: CGPoint(x: width - 15, y: height), controlPoint2: CGPoint(x: width - 20, y: height))
        } else {
            path.move(to: CGPoint(x: 20, y: height))
            path.addLine(to: CGPoint(x: width-15, y: height))
            path.addCurve(to: CGPoint(x: width, y: height-15), controlPoint1: CGPoint(x: width-8, y: height), controlPoint2: CGPoint(x: width, y: height - 8))
            path.addLine(to: CGPoint(x: width, y: 15))
            path.addCurve(to: CGPoint(x: width-15, y: 0), controlPoint1: CGPoint(x: width, y: 8), controlPoint2: CGPoint(x: width - 8, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
            path.addCurve(to: CGPoint(x: 5, y: 15), controlPoint1: CGPoint(x: 12, y: 0), controlPoint2: CGPoint(x: 5, y: 8))
            path.addLine(to: CGPoint(x: 5, y: height - 10))
            path.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 5, y: height-1), controlPoint2: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: -1, y: height))
            path.addCurve(to: CGPoint(x: 12, y: height - 4), controlPoint1: CGPoint(x: 4, y: height+1), controlPoint2: CGPoint(x: 8, y: height - 1))
            path.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: CGPoint(x: 15, y: height), controlPoint2: CGPoint(x: 20, y: height))
        }
        return Path(path.cgPath)
    }
}
