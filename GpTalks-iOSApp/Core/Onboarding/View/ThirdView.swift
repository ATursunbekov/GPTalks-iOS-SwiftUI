//
//  ThirdView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct ThirdView: View {
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.thirdBackgroundOnboarding.name)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Image(AssetsImage.OnboardingImages.imageForThirdOnboarding.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: getDynamicWidth(width: 264), height: getDynamicHeight(height: 264))
                
                Text("… and help with your \ndaily routines")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.Poppins.bold, size: 28))
                    .multilineTextAlignment(.trailing)
                    .padding(.top, 68)
                    .padding(.bottom, 26)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 40)
                VStack(alignment: .leading ,spacing: 24) {
                    HStack(alignment: .top) {
                        Image(AssetsImage.Icons.file.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        Text("Summarize articles \nand meetings")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                    HStack(alignment: .top) {
                        Image(AssetsImage.Icons.email.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        Text("Send perfectly written \ne-mails")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
            }
        }
        .onAppear {
            AmplitudeManager.shared.thirdOnBoarding()
        }
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView()
    }
}
