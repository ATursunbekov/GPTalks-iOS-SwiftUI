//
//  SecondView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct SecondView: View {
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.secondBackgroundOnboarding.name)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Find solutions \nto your challenges...")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 40)
                    .font(.custom(FontFamily.Poppins.bold, size: 28))
                    .padding(.bottom, 26)
                VStack(alignment: .leading ,spacing: 24) {
                    HStack(spacing: 17) {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        
                        Text("Plan your awesome vacation")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                    
                    HStack(spacing: 17) {
                        Image(AssetsImage.Icons.education.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        
                        Text("Grow your expertise")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                    
                    HStack(alignment: .top ,spacing: 17) {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                        
                        Text("Brainstorm and get creative ideas")
                            .foregroundColor(.white)
                            .font(.custom(FontFamily.Poppins.medium, size: 18))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .padding(.bottom, 68)
                
                Image(AssetsImage.OnboardingImages.imageForSecondOnboarding.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: getDynamicWidth(width: 264), height: getDynamicHeight(height: 264))
            }
        }
        .onAppear {
            AmplitudeManager.shared.secondOnBoarding()
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
