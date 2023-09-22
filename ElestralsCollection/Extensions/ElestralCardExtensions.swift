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
        case .prototypePromoCards:
            return "Prototype Promo Cards"
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
    
    func getTotalOwned() -> Int {
        return self.numberOwned
    }
    
    func addToBookmarks(bookmark: BookmarkModel) {
        if self.bookmarks.contains(where: {$0.id == bookmark.id}) {
            self.bookmarks.removeAll(where: {$0.id == bookmark.id})
        }
        
        self.bookmarks.append(bookmark)
    }
    
    func getBookmarks() -> String {
        switch bookmarks.count {
        case 0:
            return "Add to Bookmarks"
        case 1:
            return "In \(truncatedName(bookmarks[0].name))"
        case 2:
            return "In \(truncatedName(bookmarks[0].name)) and \(truncatedName(bookmarks[1].name))"
        default:
            let extraCount = bookmarks.count - 2
            return "In \(truncatedName(bookmarks[0].name)), \(truncatedName(bookmarks[1].name)), +\(extraCount)"
        }
    }

    func truncatedName(_ name: String) -> String {
        let maxLength = 20  // Adjust as needed
        if name.count > maxLength {
            return String(name.prefix(maxLength)) + "..."
        } else {
            return name
        }
    }
    
    func updateCardCount(inBookmark bookmarkId: UUID, byCount: Int) {
        guard let _ = cardsInDeck[bookmarkId] else {
            cardsInDeck[bookmarkId] = 1
            return
        }
        cardsInDeck[bookmarkId]! += byCount
        
        if cardsInDeck[bookmarkId] == 0 {
            cardsInDeck.removeValue(forKey: bookmarkId)
        }
    }
    
    func getCount(forBookmark bookmarkId: UUID) -> Int {
        return cardsInDeck[bookmarkId] ?? 0
    }

}
