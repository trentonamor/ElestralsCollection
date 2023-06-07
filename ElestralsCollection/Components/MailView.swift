//
//  MailView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/18/23.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShowingMailView: Bool
    weak var delegate: MFMailComposeViewControllerDelegate?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = delegate
        viewController.setSubject("Feedback")
        viewController.setToRecipients(["support@example.com"])
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Empty function
    }
    
    // Check if the device can send email
    static func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}

