//
//  BookmarkViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/16/23.
//

import Foundation
import CoreData

extension BookmarkView {
    func loadBookmarks() {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        
        do {
            let bookmarkEntities = try managedObjectContext.fetch(fetchRequest)
            self.bookmarkModels = bookmarkEntities.map { BookmarkModel(from: $0, cardStore: self.cardStore) }
        } catch {
            print("Failed to fetch bookmarks: \(error)")
        }
    }
    
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

    
    func addOrRemoveCardFromBookmarks() {
        guard let card = cardToAdd else {
            print("No card to add.")
            return
        }
        
        let cardEntity = ensureCardExistsInCoreData(card: card)

        // 1. Add the card to the selected bookmarks
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", selectedBookmarkIDs)
        
        do {
            let matchingBookmarks = try managedObjectContext.fetch(request) as! [Bookmark]
            for bookmarkEntity in matchingBookmarks {
                var cards = bookmarkEntity.cards as? Set<Card> ?? Set()
                cards.insert(cardEntity)
                bookmarkEntity.cards = cards as NSSet
                if let bookmark = self.bookmarkModels.first(where: {$0.id.uuidString == bookmarkEntity.id?.uuidString}) {
                    card.bookmarks.append(bookmark)
                    if bookmark.type == .deck {
                        card.cardsInDeck[bookmark.id] = 1
                    }
                }
            }
            
            // 2. Remove the card from the bookmarks it has been deselected from
            let requestForDeselected: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
            requestForDeselected.predicate = NSPredicate(format: "NOT (id IN %@)", selectedBookmarkIDs)
            let deselectedBookmarks = try managedObjectContext.fetch(requestForDeselected) as! [Bookmark]
            
            for bookmarkEntity in deselectedBookmarks {
                var cards = bookmarkEntity.cards as? Set<Card> ?? Set()
                cards.remove(cardEntity)
                bookmarkEntity.cards = cards as NSSet
                if let index = card.bookmarks.firstIndex(where: { $0.id.uuidString == bookmarkEntity.id?.uuidString }),
                   let bookmark = self.bookmarkModels.first(where: {$0.id.uuidString == bookmarkEntity.id?.uuidString}) {
                    card.bookmarks.remove(at: index)
                    if bookmark.type == .deck {
                        card.cardsInDeck.removeValue(forKey: bookmark.id)
                    }
                }
            }
            
            // 3. If the card is no longer in any bookmarks, delete the card entity from CoreData
            if card.bookmarks.isEmpty {
                managedObjectContext.delete(cardEntity)
            }
            
            try managedObjectContext.save()
            self.cardStore.lastUpdatedCard = card
            self.refreshID = UUID()
            
        } catch {
            print("Failed to update card and bookmarks relationship: \(error)")
        }
        NotificationCenter.default.post(name: .bookmarkDataDidChange, object: nil)
    }


}

import SwiftUI
extension BookmarkView: EditBookmarkViewDelegate {
    func saveBookmark(_ bookmark: BookmarkModel) {
        // Check if the bookmark already exists
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)

        let matches = try? managedObjectContext.fetch(request) as? [Bookmark]
        let bookmarkEntity: Bookmark
        if let match = matches?.first {
            // Existing bookmark
            bookmarkEntity = match
        } else {
            // New bookmark
            bookmarkEntity = Bookmark(context: managedObjectContext)
            self.bookmarkModels.append(bookmark)
        }

        // Map properties from BookmarkModel to Bookmark
        bookmarkEntity.id = bookmark.id
        bookmarkEntity.name = bookmark.name
        let cardIDs = Set(bookmark.cards.map { $0.id })
        bookmarkEntity.cards = cardIDs as NSSet
        bookmarkEntity.type = bookmark.type.rawValue
        bookmarkEntity.showOwnedIndicator = bookmark.showOwnedIndicator
        bookmarkEntity.showProgress = bookmark.showProgres
        bookmarkEntity.icon = bookmark.icon
        bookmarkEntity.color = bookmark.color.hexString ?? "FFFFFF"

        do {
            try managedObjectContext.save()
            if let index = self.bookmarkModels.firstIndex(where: { $0.id == bookmark.id }) {
                self.bookmarkModels[index] = bookmark
                self.refreshID = UUID()
            }
        } catch {
            print("Failed to save bookmark: \(error)")
        }
        NotificationCenter.default.post(name: .bookmarkDataDidChange, object: nil)
    }
    
    func deleteBookmark(_ bookmark: BookmarkModel) {
        withAnimation(.easeIn(duration: 0.3)) {
            let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)
            
            if let matches = try? managedObjectContext.fetch(request) as? [Bookmark], let match = matches.first {
                managedObjectContext.delete(match)
                
                // Remove the bookmark from the array
                if let index = self.bookmarkModels.firstIndex(where: { $0.id == bookmark.id }) {
                    self.bookmarkModels.remove(at: index)
                    self.refreshID = UUID()
                }
                
                try? managedObjectContext.save()
            }
        }
        NotificationCenter.default.post(name: .bookmarkDataDidChange, object: nil)
    }
}

extension BookmarkView: BookmarkCellDelegate {
    func selectBookmark(_ bookmark: BookmarkModel) {
        if self.selectedBookmarkIDs.contains(bookmark.id) {
            self.selectedBookmarkIDs.remove(bookmark.id)
        } else {
            self.selectedBookmarkIDs.insert(bookmark.id)
        }
    }
}

extension Notification.Name {
    static let bookmarkDataDidChange = Notification.Name("BookmarkDataDidChange")
}
