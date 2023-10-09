//
//  ExtensionShare.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 6/9/23.
//

import Foundation
import SwiftUI

class ShareHelper{
    func share() {
        let textToShare = """
        Hey,
        I'm using GPTalk application.
        If you want to use to - please use this link https://apple.com/2345345 !
        Install the app and have fun!
        """
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
