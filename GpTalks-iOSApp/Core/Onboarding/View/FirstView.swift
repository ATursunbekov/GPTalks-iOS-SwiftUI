//
//  FirstView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.firstBackgroundOnboarding.name)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Image(AssetsImage.OnboardingImages.imageForFirstOnboarding.name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: getDynamicWidth(width: 264), height: getDynamicHeight(height: 264))
                Text("Feel the power \nof AI and ChatGPT")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.Poppins.bold, size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.top, 68)
                    .padding(.bottom, 26)
                VStack(alignment: .leading ,spacing: 24) {
                    HStack(alignment: .top, spacing: 20.2) {
                        Image(AssetsImage.OnboardingImages.fire.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        Text("Instant answers,\nanytime, anywhere")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                    HStack(alignment: .top, spacing: 20.2) {
                        Image(AssetsImage.Icons.stars.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        Text("Learn, grow, and expand\nyour knowledge")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
            }
        }.onAppear{
            AmplitudeManager.shared.firstOnboarding()
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnBoarding: .constant(true))
    }
}
