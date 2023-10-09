//
//  CustomSlider.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 21/8/23.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var progress: CGFloat
    let imageName: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(text)
                .foregroundColor(.white)
                .font(.custom(FontFamily.Poppins.semiBold, size: 20))
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                Capsule()
                    .fill(Colors.FillColor.fill01.swiftUIColor)
                    .frame(height: getDynamicHeight(height: 8))
                
                Capsule()
                    .fill(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                    .frame(width: (progress +  getDynamicWidth(width: 18)) > 0 ? progress +  getDynamicWidth(width: 18) : 0,height: getDynamicHeight(height: 8))
                
                ZStack {
                    Circle()
                        .frame(width: getDynamicWidth(width: 36), height: getDynamicHeight(height: 36))
                        .foregroundColor(Colors.AccessibleColors.accessibleIndigo.swiftUIColor)
                    
                    Image(imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .offset(x: progress)
                .gesture(DragGesture().onChanged({ val in
                    if val.location.x >= getDynamicWidth(width: 9) && val.location.x <= UIScreen.main.bounds.width - getDynamicWidth(width: 54) {
                        progress = val.location.x - 18
                    }
                }))
            }
        }
    }
}
struct Fou1rthView_Previews: PreviewProvider {
    static var previews: some View {
        FourthView()
    }
}
