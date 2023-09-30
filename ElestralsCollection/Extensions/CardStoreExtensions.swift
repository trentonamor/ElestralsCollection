//
//  CardStoreExtension.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/17/23.
//

import Foundation
import CoreData

extension CardStore {
    func getExpansionList() -> [ExpansionId] {
        let uniqueSets =  Set(self.cards.map { $0.cardSet })
        return Array(uniqueSets)
    }
    
    func getCards(for cardName: String) -> [ElestralCard] {
        return self.cards.filter { $0.name == cardName }
    }
    
    func getCards(for expansion: ExpansionId) -> [ElestralCard] {
        return self.cards.filter { $0.cardSet == expansion }
    }
    
    func getCards(for isOwned: Bool) -> [ElestralCard] {
        if isOwned {
            return self.cards.filter { $0.numberOwned > 0 }
        } else {
            return self.cards.filter { $0.numberOwned == 0 }
        }
    }
    
    func getCards(for cardIds: [String]) -> [ElestralCard] {
        return self.cards.filter { cardIds.contains($0.id) }
    }
    
    func getTotalOwned(for cardName: String) -> Int {
        let cards = self.cards.filter {$0.name == cardName}
        let cardTotal = cards.reduce(0) { (result, card) in
            return result + card.numberOwned
        }
        return cardTotal
    }
    
    func getUniqueElestralsOwned(for element: String) -> Int {
        let cards = self.cards.filter { $0.elements.contains(element.lowercased()) && $0.cardType.lowercased() == "elestral"}
        var totalOwned = 0
        var cardsAdded: Set<String> = Set()
        for card in cards {
            if !cardsAdded.contains(card.name) && card.numberOwned > 0 {
                totalOwned += 1
                cardsAdded.insert(card.name)
            }
        }
        return totalOwned
    }
    
    func getAverageReleaseDate(for expansion: ExpansionId) -> Date{
        let cards = self.getCards(for: expansion)
        
        let totalTimeInterval = cards.reduce(0) { (result, card) in
            return result + card.publishedDate.timeIntervalSince1970
        }
        
        let averageTimeInterval = totalTimeInterval / Double(cards.count)
        return Date(timeIntervalSince1970: averageTimeInterval)
    }
    
    func getElestralsList() -> [ElestralCard] {
        return self.cards.filter { $0.cardType == "Elestral" }
    }
    
    func cardUpdated(_ card: ElestralCard) {
        self.lastUpdatedCard = card
    }
    
    func fetchBookmarksForCard(cardID: String, context: NSManagedObjectContext) -> [BookmarkModel] {
        let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "ANY cards.id == %@", cardID)
        
        do {
            let matchingBookmarks = try context.fetch(request)
            return matchingBookmarks.map { BookmarkModel(from: $0, cardStore: self) }
        } catch {
            print("Failed to fetch bookmarks for card \(cardID): \(error)")
            return []
        }
    }
    
    func setBookmarks(context: NSManagedObjectContext) {
        for card in self.cards {
            card.bookmarks = self.fetchBookmarksForCard(cardID: card.id, context: context)
        }
    }
    
    func cleanAndFormatEffect(effect: String) -> String {
        let replacements: [String: String] = [
            "A": "(Air Symbol)",
            "E": "(Earth Symbol)",
            "F": "(Fire Symbol)",
            "I": "(Ice Symbol)",
            "J": "(Attach Symbol)",
            "O": "(Defense Symbol)",
            "S": "(Stellar Symbol)",
            "T": "(Thunder Symbol)",
            "W": "(Water Symbol)",
            "X": "(Any Element Symbol)"
        ]
        
        var cleanedEffect = effect
        for (key, value) in replacements {
            cleanedEffect = cleanedEffect.replacingOccurrences(of: "<span class=\"elestrals-font\">\(key)</span>", with: value, options: .caseInsensitive)
            cleanedEffect = cleanedEffect.replacingOccurrences(of: "<span class=\"elestrals-font\">\(key.lowercased())</span>", with: value, options: .caseInsensitive)
        }
        
        cleanedEffect = cleanedEffect.replacingOccurrences(of: "``` embed", with: "")
        cleanedEffect = cleanedEffect.replacingOccurrences(of: "\n```", with: "")
        cleanedEffect = cleanedEffect.replacingOccurrences(of: "\n", with: " ")
        return cleanedEffect
    }
    
    private func ensureCardExistsInCoreData(card: ElestralCard, context: NSManagedObjectContext) -> Card {
        // Check if the card already exists
        let cardFetchRequest: NSFetchRequest<NSFetchRequestResult> = Card.fetchRequest()
        cardFetchRequest.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)
        
        let matches = try? context.fetch(cardFetchRequest) as? [Card]
        if let existingCard = matches?.first {
            return existingCard
        } else {
            // If the card doesn't exist, create a new Card entity
            let newCardEntity = Card(context: context)
            newCardEntity.id = card.id
            // Add any other properties of the card that need to be saved
            return newCardEntity
        }
    }

    
    func addOrRemoveBookmarks(bookmarkId: UUID?, card: ElestralCard, context: NSManagedObjectContext) {
        guard let bookmarkId = bookmarkId else {
            return
        }
        // Fetch the card from CoreData or ensure it exists.
        let cardEntity = ensureCardExistsInCoreData(card: card, context: context)
        
        // 1. Check if the card is already in the bookmark with given ID.
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmarkId as CVarArg)
        
        do {
            if let bookmarkEntity = try context.fetch(request).first as? Bookmark {
                var cards = bookmarkEntity.cards as? Set<Card> ?? Set()
                
                if cards.contains(cardEntity) {
                    // Card already exists in the bookmark, remove it.
                    cards.remove(cardEntity)
                    bookmarkEntity.cards = cards as NSSet
                    
                    if let index = card.bookmarks.firstIndex(where: { $0.id.uuidString == bookmarkEntity.id?.uuidString }),
                       let bookmark = card.bookmarks.first(where: { $0.id.uuidString == bookmarkEntity.id?.uuidString }) {
                        card.bookmarks.remove(at: index)
                        if bookmark.type == .deck {
                            card.cardsInDeck.removeValue(forKey: bookmark.id)
                        }
                    }
                } else {
                    // Card is not in the bookmark, add it.
                    cards.insert(cardEntity)
                    bookmarkEntity.cards = cards as NSSet

                    // Create the bookmark model and add to the card's bookmarks.
                    let newBookmarkModel = BookmarkModel(from: bookmarkEntity, cardStore: self)
                    card.addToBookmarks(bookmark: newBookmarkModel)
                    if newBookmarkModel.type == .deck {
                        card.cardsInDeck[newBookmarkModel.id] = 1
                    }
                }
                
                // 3. If the card is no longer in any bookmarks, delete the card entity from CoreData
                if card.bookmarks.isEmpty {
                    context.delete(cardEntity)
                }
                
                try context.save()
                
            }
        } catch {
            print("Failed to update card and bookmarks relationship: \(error)")
        }
        NotificationCenter.default.post(name: .bookmarkDataDidChange, object: nil)
    }
}
