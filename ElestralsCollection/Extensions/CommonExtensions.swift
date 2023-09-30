//
//  HelperFunctions.swift
//
//
//  Created by Trenton Parrotte on 11/29/22.
//

import Foundation
import UIKit
import SwiftUI


extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension Character {
    var isSymbol: Bool {
        return "!@#$%^&*()_+-=[]{}|;:,.<>?/\\~".contains(self)
    }
}

extension String {
    func toDateFromMMDDYYY(format: String = "MM/dd/yyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func toDateFromPOSIX(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}

extension Color {
    var name: String? {
        let pattern = "NamedColor\\(name: \"([^\"]+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let string = self.description
        let range = NSRange(string.startIndex..., in: string)
        
        if let match = regex.firstMatch(in: string, options: [], range: range) {
            if let range = Range(match.range(at: 1), in: string) {
                return String(string[range])
            }
        }
        
        return nil
    }
}

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
        var dictionary: [T: Value] = [:]
        for (key, value) in self {
            dictionary[try transform(key)] = value
        }
        return dictionary
    }
}

enum AuthError: Error {
    case verifyEmail
    case emailAlreadyInUse
    case other(Error)
    case none
}


