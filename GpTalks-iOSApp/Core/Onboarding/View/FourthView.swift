//
//  FouthView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct FourthView: View {
    @State var slider1: CGFloat = 0
    @State var slider2: CGFloat = 0
    @State var slider3: CGFloat = 0
    @State var slider4: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image(AssetsImage.OnboardingImages.fourthBackgroundOnboarding.name)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Rate your emotions \nabout these activities:")
                    .foregroundColor(.white)
                    .font(.custom(FontFamily.Poppins.bold, size: 28))
                    .padding(.bottom, 48)
                
                VStack(spacing: 44) {
                    CustomSlider(progress: $slider1, imageName: AssetsImage.OnboardingImages.bag.name, text: "Preparing report on your work")
                    
                    CustomSlider(progress: $slider2, imageName: AssetsImage.OnboardingImages.pizza.name, text: "Cooking your favorite food")
                    
                    CustomSlider(progress: $slider3, imageName: AssetsImage.OnboardingImages.onboardingHeart.name, text: "Daily 30-min workout")
                    
                    CustomSlider(progress: $slider4, imageName: AssetsImage.OnboardingImages.date.name, text: "Planning activities for weekend")
                }
            }
            .padding(.horizontal, getDynamicWidth(width: 24))
        }
        .onAppear {
            AmplitudeManager.shared.fourthOnBoarding()
        }
    }
}

struct FourthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView()
    }
}
