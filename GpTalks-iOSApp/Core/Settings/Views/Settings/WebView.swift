//
//  WebView.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 18/9/23.
//

import SwiftUI
import WebKit

struct WebView: View {
    let urlString: String
    let title: String

    var body: some View {
        WebViewContainer(urlString: urlString)
            .navigationBarTitle(title, displayMode: .inline)
    }
}

struct WebViewContainer: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
