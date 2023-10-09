//
//  SupportEmailModel.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 15/9/23.
//

import Foundation
import UIKit

struct SupportEmailModel {
    let toAddress: String
    let subject: String
    var messageHeader: String
    var data: UIImage?
    var body: String {"""
        Application Name: GPTalks
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.modelName)
        Appp Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
    --------------------------------------
        \(messageHeader)
    """
    }
}
