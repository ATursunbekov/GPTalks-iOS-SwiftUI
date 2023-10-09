//
//  ShareSheet.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 25/7/23.
//

import Foundation
import UIKit

func share(text: String) {
    let textToShare = text
    
    let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}
