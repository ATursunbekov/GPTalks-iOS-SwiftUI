//
//  TermsOfUseView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 19/9/23.
//

import SwiftUI

struct TermsOfUseView: View {
    @State private var documentText = ""

    var body: some View {
        VStack {
            Spacer()
            
            ScrollView {
                Text(documentText)
                    .font(.custom(FontFamily.SFProDisplay.regular, size: 15))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
        .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.async {
                loadDocument()
            }
        }
        .navigationTitle("Terms of Use")
    }
    
    func loadDocument() {
        if let url = URL(string: "https://docs.google.com/document/d/1ESpHzWGmksJ0fDYiXS6QFwxI4G_85pgLg_4tM_kGp7g/export?format=txt") {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error document load: \(error)")
                } else if let data = data, let documentContent = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.documentText = documentContent                    }
                }
            }
            task.resume()
        }
    }
}

struct TermsOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUseView()
    }
}
