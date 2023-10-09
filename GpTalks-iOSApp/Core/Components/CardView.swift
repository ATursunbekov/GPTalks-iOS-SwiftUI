//
//  CardView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 20/7/23.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var viewModel: CategoryViewModel
    let title: String
    var description: String?
    let size: CGFloat
    var topicID: String = ""
    @State var selectedCategory: String = ""
    var hideButton: Bool = false
    var isFavorite: Bool
    @State var task: TopicAllCategory?
    @Binding var refreshTabs: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .bottom, spacing: 12) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                    if description != nil && description != ""{
                        Spacer()
                        Text(description!)
                            .foregroundColor(Colors.LabelColor.label02.swiftUIColor)
                            .font(.custom(FontFamily.SFProDisplay.regular, size: 13))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .lineLimit(nil)
                    }
                    if description == "" || description == nil {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(width: 10, height: 25)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: size, alignment: .topLeading)
        .background(Colors.FillColor.fill03.swiftUIColor)
        .cornerRadius(8)
    }
}
