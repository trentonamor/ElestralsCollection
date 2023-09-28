//
//  PasswordStrengthViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/9/23.
//

import Foundation

class PasswordStrengthViewModel {
    static func calculateStrength(password: String) -> PasswordStrength {
        let length = password.count
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecialCharacters = password.rangeOfCharacter(from: .punctuationCharacters) != nil
        let hasUpperCase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowerCase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        
        switch (length, hasNumbers, hasSpecialCharacters, hasUpperCase, hasLowerCase) {
        case (10..., true, true, true, true):
            return .veryStrong
        case (9..., true, _, true, _),
            (9..., true, _, _, true),
            (9..., _, true, true, _),
            (9..., _, true, _, true):
            return .good
        case (8..., false, false, false, true),
            (8..., false, false, true, false):
            return .fair
        case (0..<8, _, _, _, _):
            return .weak
        default:
            return .weak
        }
    }
}
