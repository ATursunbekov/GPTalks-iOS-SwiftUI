//
//  CustomSearchBar.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 14/8/23.
//

import SwiftUI
import EasySkeleton

struct CustomSearchBar: View {
    @Binding var isLoading: Bool
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 0) {
            if searchText == "" {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                    .padding(.leading, 12)
                    .padding(.vertical, 8)
            }

            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                        Text("Search")
                        .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                }
                .autocapitalization(.none)
                .accentColor(Colors.DefaultColors.teal.swiftUIColor)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.leading, searchText == "" ? 8 : 12)

            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(AssetsImage.Icons.close.name)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 8)
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Colors.FillColor.fill03.swiftUIColor))
        .skeletonable()
        .skeletonCornerRadius(8)
        .padding(.horizontal, 16)
        .setSkeleton($isLoading, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
    }
}

struct HistoryVieww_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(isLoading: .constant(true))
            .environmentObject(ChatViewModel())
    }
}
