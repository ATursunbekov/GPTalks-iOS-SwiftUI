//
//  HomeView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/7/23.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            Color(Colors.SystemBackgrounds.background01.color)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                //header
                HeaderView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        //MARK: Most Popular
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.white)
                            
                            Text("Most popular")
                                .font(.custom(FontFamily.Poppins.bold, size: 20))
                                .foregroundColor(.white)
                        }
                        .frame(width: 358, alignment: .leading)
                        
                        HStack(alignment: .top, spacing: 12) {
                            CardView(title: "Create a social media post",
                                     description: "Cover any event or topic on social media",
                                     size: CGSize(width: 220, height: 108),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                            
                            CardView(title: "Engage in text role play",
                                     description: "Talk to AI as if it’s someone else",
                                     size: CGSize(width: 126, height: 108),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                        }
                        
                        CardView(title: "Long text about working process",
                                 description: "Description of the working process",
                                 size: CGSize(width: 358, height: 108),
                                 likeButtonImageName: AssetsImage.Icons.heart.name)
                        
                        //MARK: Try New
                        HStack {
                            Image(AssetsImage.Icons.education.name)
                                .frame(width: 16, height: 16)
                            
                            Text("Try new")
                                .font(.custom(FontFamily.Poppins.bold, size: 20))
                                .foregroundColor(.white)
                        }
                        .frame(width: 358, alignment: .leading)
                        
                        HStack(alignment: .top, spacing: 12) {
                            CardView(title: "Long text about working process",
                                     description: "Description of the working process",
                                     size: CGSize(width: 111, height: 122),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                            
                            CardView(title: "Engage in text role play",
                                     description: "Cover any event or topic on social media",
                                     size: CGSize(width: 111, height: 122),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                            
                            CardView(title: "Long text about working process",
                                     description: "Description of the working process",
                                     size: CGSize(width: 111, height: 122),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                        }
                        
                        //MARK: For Fun
                        HStack {
                            Image(AssetsImage.Icons.stars.name)
                                .frame(width: 16, height: 16)
                            
                            Text("For fun")
                                .font(.custom(FontFamily.Poppins.bold, size: 20))
                                .foregroundColor(.white)
                        }
                        .frame(width: 358, alignment: .leading)
                        
                        HStack(alignment: .top, spacing: 12) {
                            CardView(title: "Create a social media post",
                                     description: "Cover any event or topic on social media",
                                     size: CGSize(width: 173, height: 126),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                            
                            CardView(title: "Engage in text role play",
                                     description: "Cover any event or topic on social media",
                                     size: CGSize(width: 173, height: 126),
                                     likeButtonImageName: AssetsImage.Icons.heart.name)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
