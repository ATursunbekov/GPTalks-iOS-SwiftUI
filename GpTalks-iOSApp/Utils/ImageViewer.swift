//
//  ImageViewer.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 4/9/23.
//

import SwiftUI

struct ImageViewer: View {
    var image: UIImage
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.isPresented = false
                    }) {
                        Image(AssetsImage.Banner.bannerClose.name)
                            .padding(.trailing, 16)
                    }
                }
                .padding()
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
            }
        }
    }
}
