//
//  BannerView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 24/8/23.
//

import Adapty
import SwiftUI

struct BannerView: View {
    @EnvironmentObject var discountTimer: DiscountTimer
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @Binding var isBannerVisible: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(!purchaseViewModel.hasPremium ? "UPGRADE TO PRO" : "CREATE YOUR")
                        .font(.custom(FontFamily.Poppins.bold, size: 22))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        isBannerVisible.toggle()
                    } label: {
                        Image(AssetsImage.Banner.bannerClose.name)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                
                Text(!purchaseViewModel.hasPremium ? "with \(discountTimer.currentDiscountPercentage)% discount only today!" : "PERSONAL SCENARIO")
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .frame(height: 81, alignment: .leading)
        .frame(maxWidth: .infinity)
        .background(
            ZStack(alignment: .trailing) {
                Group{
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.12, green: 0.23, blue: 0.84), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.18, green: 0.14, blue: 0.47), location: 0.99),
                        ],
                        startPoint: UnitPoint(x: 0.97, y: 0.89),
                        endPoint: UnitPoint(x: 0.13, y: 0.16)
                    )
                    
                    Image(AssetsImage.Banner.maskGroup.name)
                }
            }
        )
        .cornerRadius(12)
    }
}
