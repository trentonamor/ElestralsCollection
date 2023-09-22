//
//  DeckViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/22/23.
//

import Foundation
import CoreData

extension DeckView {
    func getTotalInBookmark(cards: [ElestralCard], bookmarkId: UUID) -> Int {
        var total = 0
        for card in cards {
            total += card.getCount(forBookmark: bookmarkId)
        }
        return total
    }
}

extension DeckCardDetailView {
    private func ensureCardExistsInCoreData(card: ElestralCard) -> Card {
        // Check if the card already exists
        let cardFetchRequest: NSFetchRequest<NSFetchRequestResult> = Card.fetchRequest()
        cardFetchRequest.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)
        
        let matches = try? managedObjectContext.fetch(cardFetchRequest) as? [Card]
        if let existingCard = matches?.first {
            return existingCard
        } else {
            // If the card doesn't exist, create a new Card entity
            let newCardEntity = Card(context: managedObjectContext)
            newCardEntity.id = card.id
            // Add any other properties of the card that need to be saved
            return newCardEntity
        }
    }

    
    func addOrRemoveBookmarks() {
        // Fetch the card from CoreData or ensure it exists.
        let cardEntity = ensureCardExistsInCoreData(card: card)
        
        // 1. Check if the card is already in the bookmark with given ID.
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmarkId as CVarArg)
        
        do {
            if let bookmarkEntity = try managedObjectContext.fetch(request).first as? Bookmark {
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
                    let newBookmarkModel = BookmarkModel(from: bookmarkEntity, cardStore: self.cardStore)
                    card.addToBookmarks(bookmark: newBookmarkModel)
                    if newBookmarkModel.type == .deck {
                        card.cardsInDeck[newBookmarkModel.id] = 1
                    }
                }
                
                // 3. If the card is no longer in any bookmarks, delete the card entity from CoreData
                if card.bookmarks.isEmpty {
                    managedObjectContext.delete(cardEntity)
                }
                
                try managedObjectContext.save()
                cardStore.cardUpdated(card)
                
            }
        } catch {
            print("Failed to update card and bookmarks relationship: \(error)")
        }
        NotificationCenter.default.post(name: .bookmarkDataDidChange, object: nil)
    }



}
