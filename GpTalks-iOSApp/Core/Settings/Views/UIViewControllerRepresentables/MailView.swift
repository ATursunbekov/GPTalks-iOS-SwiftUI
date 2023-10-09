//
//  File.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 15/9/23.
//

import SwiftUI
import UIKit
import MessageUI

// Credit for this struct goes to https://swiftuirecipes.com/blog/send-mail-in-swiftui

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentation
  @Binding var supportEmail: SupportEmailModel
  let callback: MailViewCallback

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentation: PresentationMode
    @Binding var data: SupportEmailModel
    let callback: MailViewCallback

    init(presentation: Binding<PresentationMode>,
         data: Binding<SupportEmailModel>,
         callback: MailViewCallback) {
      _presentation = presentation
      _data = data
      self.callback = callback
    }
      
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(presentation: presentation, data: $supportEmail, callback: callback)
  }
    
  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let mvc = MFMailComposeViewController()
    mvc.mailComposeDelegate = context.coordinator
    mvc.setSubject(supportEmail.subject)
    mvc.setToRecipients([supportEmail.toAddress])
    mvc.setMessageBody(supportEmail.body, isHTML: false)
      let fileName = Int.random(in: 0...500000).description + ".jpeg"
      if let image = supportEmail.data?.jpegData(compressionQuality: 1)! {
          mvc.addAttachmentData(image, mimeType: "image/jpg", fileName: fileName)
      }
    mvc.accessibilityElementDidLoseFocus()
    return mvc
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<MailView>) {
  }

  static var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }
}
