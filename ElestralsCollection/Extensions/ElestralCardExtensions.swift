//
//  ElestralCardExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation

extension ElestralCard: CustomStringConvertible {
    var description: String {
        var output = "ElestralCard: \(id)\n"
        output += "Name: \(name)\n"
        output += "Effect: \(effect)\n"
        output += "Elements: \(elements)\n"
        output += "Subclasses: \(subclasses)\n"
        output += "Attack: \(String(describing: attack))\n"
        output += "Defense: \(String(describing: defense))\n"
        output += "Artist: \(artist)\n"
        output += "Card Set: \(cardSet)\n"
        output += "Card Number: \(cardNumber)\n"
        output += "Rarity: \(rarity)\n"
        output += "Card Type: \(cardType)\n"
        output += "Rune Type: \(String(describing: runeType))\n"
        output += "Number Owned: \(numberOwned)\n"
        return output
    }
    
    func getCardSet() -> String {
        switch self.cardSet {
        case .artistCollection:
            return "Artist Collection"
        case .baseSet:
            return "Base Set"
        case .baseSetPromoCards:
            return "Base Set Promo Cards"
        case .centaurborStarterDeck:
            return "Centaurbor Starter Deck"
        case .majeseaStarterDeck:
            return "Majesea Starter Deck"
        case .ohmperialStarterDeck:
            return "Ohmperial Starter Deck"
        case .penterrorStarterDeck:
            return "Penterror Starter Deck"
        case .trifernalStarterDeck:
            return "Trifernal Starter Deck"
        default:
            return ""
        }
    }
    
    func getCardRarity() -> String {
        let words = self.rarity.components(separatedBy: "-")
        let capitalizedWords = words.map { $0.capitalized }
        return capitalizedWords.joined(separator: " ")
    }
    
    func getNumberOwned() -> String {
        if self.numberOwned == 0 {
            return "Not Owned"
        } else if self.numberOwned == 1 {
            return "Owned"
        }
        
        return "\(self.numberOwned) Owned"
    }
}
