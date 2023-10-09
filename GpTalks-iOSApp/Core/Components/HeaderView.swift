//
//  HeaderView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/7/23.
//

import Adapty
import SwiftUI
import EasySkeleton

struct HeaderView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @Binding var isLoading: Bool
    @State private var isShareSheetPresented = false
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                Text("GPTalk")
                    .font(.custom(FontFamily.Poppins.bold, size: 28))
                    .foregroundColor(.white)
                    .skeletonable()
                    .skeletonCornerRadius(8)
                
                if purchaseViewModel.hasPremium {
                    Image(AssetsImage.HeaderIcons.pro.name)
                        .frame(width: 36, height: 18)
                        .skeletonable()
                        .skeletonCornerRadius(8)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    ShareHelper().share()
                } label: {
                    Image(AssetsImage.Icons.share.name)
                }
                .frame(width: 24, height: 24)
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(AssetsImage.Icons.settings.name)
                }
                .frame(width: 24, height: 24)
                
                if !purchaseViewModel.hasPremium {
                    Button {
                        UserDefaults.standard.set(true, forKey: "showPayWall")
                    } label:  {
                        Image(AssetsImage.HeaderIcons.proIcon.name)
                    }
                    .frame(width: 65, height: 31)
                }
            }
            .skeletonable()
            .skeletonCornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .center)
        .setSkeleton($isLoading, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.6), transition: .none)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(isLoading: .constant(true))
            .environmentObject(PurchaseViewModel())
    }
}
