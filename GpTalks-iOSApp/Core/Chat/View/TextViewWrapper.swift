//
//  TextViewWrapper.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 26/7/23.
//
// TextViewWrapper.swift

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    @Binding var placeholder: String
    @Binding var isPlaceholder: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 15)
        textView.delegate = context.coordinator
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.LabelColor.label03.color.cgColor
        textView.layer.cornerRadius = 14
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != "" {
            uiView.text = text
            uiView.textColor = .white
        } else {
            uiView.text = ""
            uiView.textColor = .white
        }
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper
        
        init(parent1: TextViewWrapper) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.placeholder == "Message" {
                parent.isPlaceholder = false
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if  parent.placeholder == "Message" && parent.text.isEmpty {
                parent.isPlaceholder = true
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
}
