//
//  FifthView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct FifthView: View {
    @Binding var showOnBoarding: Bool
    @State private var assistantAnswer: String = "Typing..."
    @State private var changeColorBackground: [Bool] = Array(repeating: false, count: 4)
    @State private var hiddenButtons: [Int] = []
    @State private var labels: [String] = []
    private let buttonLabels = ["Your friends", "Your health", "Your family", "Your work"]
    private let buttonResultLabels = ["My friends", "My health", "My family", "My work"]
    
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.fifthBackgroundOnboarding.name)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                HStack(alignment: .bottom, spacing: 2) {
                    Image(AssetsImage.OnboardingImages.chatBotIcon.name)
                    
                    ZStack {
                        Image(AssetsImage.OnboardingImages.assistantMessage.name)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 241, height: 84)
                        
                        Text("What excites you at \nmost? ")
                            .font(.custom(FontFamily.Poppins.semiBold, size: 20))
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                }
                
                VStack(spacing: 80) {
                    ZStack {
                        if hiddenButtons.count > 0 {
                            VStack(spacing: 15) {
                                
                                ForEach(0..<hiddenButtons.count, id: \.self) { index in
                                     ZStack {
                                         Text(labels[index])
                                             .font(.custom(FontFamily.Poppins.semiBold, size: 20))
                                             .foregroundColor(.white)
                                             .padding(.vertical, 12)
                                             .padding(.leading, 15)
                                             .padding(.trailing, 19)
                                             .background(Image(AssetsImage.OnboardingImages.usersAnswer.name).resizable())
                                     }
                                 }
                            }
                            
                        } else {
                            Image(AssetsImage.OnboardingImages.assistantTyping.name)
                            
                            Text("Typing...")
                                .font(.custom(FontFamily.Poppins.semiBold, size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    VStack {
                            Text("Сhoose:")
                                .foregroundColor(.white)
                                .font(.custom(FontFamily.Poppins.medium, size: 20))
                                .isHidden(hiddenButtons.count == 4, remove: true)
                                .opacity(hiddenButtons.count == 4 ? 0 : 1)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 24), count: 2)) {
                            ForEach(0..<4) { index in
                                if !hiddenButtons.contains(index) {
                                    Button {
                                        labels.append(buttonResultLabels[index])
                                        hiddenButtons.append(index)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(changeColorBackground[index] ? Colors.AccessibleColors.accessibleGreen.swiftUIColor : Colors.FillColor.fill02.swiftUIColor)
                                                .frame(height: 48)
                                            
                                            Text(buttonLabels[index])
                                                .foregroundColor(.white)
                                                .font(.custom(FontFamily.Poppins.regular, size: 18))
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 24)
                        }
                        if hiddenButtons.count > 0 {
                            Button {
                                    showOnBoarding = false
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill( Colors.AccessibleColors.accessibleGreen.swiftUIColor)
                                        .frame(height: 48)
                                    Text("Get started")
                                        .foregroundColor(.black)
                                        .font(.custom(FontFamily.Poppins.semiBold, size: 17))
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .onAppear {
            AmplitudeManager.shared.fifthOnBoarding()
        }
    }
}

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
struct FourthVidew_Previews: PreviewProvider {
    static var previews: some View {
        FifthView(showOnBoarding: .constant(true))
    }
}
