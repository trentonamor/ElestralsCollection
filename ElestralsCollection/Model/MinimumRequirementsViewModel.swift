//
//  MinimumRequirementsViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/9/23.
//

import Foundation

class MinimumRequirementsViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var containsNumber = false
    @Published var containsSymbol = false
    @Published var containsLetter = false
    @Published var containsMinimumCharacters = false
    
    let symbols = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|:\";<>,.?/~`-=")
    
    func updateRequirements() {
        containsNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        containsSymbol = password.rangeOfCharacter(from: symbols) != nil
        containsLetter = password.rangeOfCharacter(from: .letters) != nil
        containsMinimumCharacters = password.count >= 10
    }
}
