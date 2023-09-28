//
//  PasswordStrengthViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/9/23.
//

import Foundation

class PasswordStrengthViewModel {

    static func calculateStrength(password: String) -> PasswordStrength {
        let len = password.count
        var score = 0
        
        // Additions
        score += len * 4
        score += (len - password.filter { $0.isUppercase }.count) * 2
        score += (len - password.filter { $0.isLowercase }.count) * 2
        score += password.filter { $0.isNumber }.count * 4
        score += password.filter { $0.isSymbol }.count * 6
        let middleChars = Array(password.dropFirst().dropLast())
        score += middleChars.filter { $0.isNumber || $0.isSymbol }.count * 2
        score = Int(Double(score) * shannonEntropy(password: password))
        
        // Deductions
        if password.allSatisfy({ $0.isLetter }) {
            score -= len
        }
        if password.allSatisfy({ $0.isNumber }) {
            score -= len * 16
        }
        score -= repeatChars(password: password)
        score -= consecutivePattern(password: password, pattern: { $0.isUppercase }) * 2
        score -= consecutivePattern(password: password, pattern: { $0.isLowercase }) * 2
        score -= consecutivePattern(password: password, pattern: { $0.isNumber }) * 2
        score -= sequentialPattern(password: password, patternSet: "abcdefghijklmnopqrstuvwxyz") * 3
        score -= sequentialPattern(password: password, patternSet: "0123456789") * 3
        score -= sequentialPattern(password: password, patternSet: "!@#$%^&*()_+") * 3
        score -= repeatedWords(password: password)
        
        // Special deductions
        if password.first?.isUppercase == true && password.dropFirst().allSatisfy({ !$0.isUppercase }) {
            score -= len
        }
        if let lastChar = password.last, !lastChar.isSymbol, password.dropLast().allSatisfy({ !$0.isNumber }) {
            score -= len
        }
        if let lastChar = password.last, lastChar.isSymbol, password.dropLast().allSatisfy({ !$0.isSymbol }) {
            score -= len
        }
        
        // Determine final strength
        if score < 100 {
            return .weak
        } else if score < 200 {
            return .fair
        } else if score < 300 {
            return .good
        } else {
            return .veryStrong
        }
    }

    // Helper functions
    static func shannonEntropy(password: String) -> Double {
        var entropy: Double = 0
        let passwordLength = Double(password.count)
        for char in Set(password) {
            let px = Double(password.filter { $0 == char }.count) / passwordLength
            if px > 0 {
                entropy += -px * log2(px)
            }
        }
        return entropy
    }

    static func repeatChars(password: String) -> Int {
        var count = 0
        let lowered = password.lowercased()
        for char in Set(lowered) {
            let repeats = lowered.filter { $0 == char }.count
            if repeats > 1 {
                count += repeats
            }
        }
        return count
    }

    static func consecutivePattern(password: String, pattern: (Character) -> Bool) -> Int {
        var count = 0
        var consecutive = 0
        for char in password {
            if pattern(char) {
                consecutive += 1
            } else {
                consecutive = 0
            }
            if consecutive > 1 {
                count += 1
            }
        }
        return count
    }

    static func sequentialPattern(password: String, patternSet: String) -> Int {
        var count = 0
        let lowered = password.lowercased()
        for i in 0..<(patternSet.count - 2) {
            let start = patternSet.index(patternSet.startIndex, offsetBy: i)
            let end = patternSet.index(patternSet.startIndex, offsetBy: i + 2)
            let pattern = patternSet[start...end]
            
            if lowered.contains(pattern) {
                count += 1
            }
        }
        return count
    }

    static func repeatedWords(password: String) -> Int {
        var count = 0
        let words = Set(password.lowercased().split(separator: " "))
        for word in words {
            if password.lowercased().components(separatedBy: word).count > 2 {
                count += 1
            }
        }
        return count
    }

}
