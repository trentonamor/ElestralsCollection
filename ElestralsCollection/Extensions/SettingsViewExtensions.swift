//
//  SettingsViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

extension SettingsView {
    func openWebpage(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

class MailComposerDelegate: NSObject, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Handle email composition result here
        controller.dismiss(animated: true)
    }
}
