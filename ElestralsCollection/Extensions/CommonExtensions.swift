//
//  HelperFunctions.swift
//
//
//  Created by Trenton Parrotte on 11/29/22.
//

import Foundation
import UIKit

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension String {
    func toDate(format: String = "MM/dd/yyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}

