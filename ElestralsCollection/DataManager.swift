//
//  DataManager.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/15/23.
//

import Foundation
import CoreData

class DataManager {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: Create
    func createBookmark(cards: [ElestralCard], name: String, type: String, showOwnedIndicator: Bool, showProgress: Bool, icon: String, color: String) -> Bookmark? {
        let newBookmark = Bookmark(context: self.context)
        newBookmark.id = UUID() // Automatically generating a new UUID
        
        let cards = cards.map { cards -> Card in
            let card = Card(context: self.context)
            card.id = cards.id
            return card
        }
        
        newBookmark.cards = NSSet(array: cards)
        
        newBookmark.name = name
        newBookmark.type = type
        newBookmark.showOwnedIndicator = showOwnedIndicator
        newBookmark.showProgress = showProgress
        newBookmark.icon = icon
        newBookmark.color = color
        
        do {
            try self.context.save()
            return newBookmark
        } catch {
            print("Error saving bookmark: \(error)")
            return nil
        }
    }
    
    func createOrUpdateBookmark(bookmark: BookmarkModel) {
        // Check if the bookmark already exists
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)

        if let matches = try? context.fetch(request) as? [Bookmark], let match = matches.first {
            // Existing bookmark, update it
            updateBookmark(
                bookmark: match,
                name: bookmark.name,
                type: bookmark.type.rawValue,
                showOwnedIndicator: bookmark.showOwnedIndicator,
                showProgress: bookmark.showProgres,
                icon: bookmark.icon,
                color: bookmark.color.hexString ?? "FFFFFF",
                elestralCards: bookmark.cards
            )
        } else {
            // New bookmark, create it
            _ = createBookmark(
                cards: bookmark.cards,
                name: bookmark.name,
                type: bookmark.type.rawValue,
                showOwnedIndicator: bookmark.showOwnedIndicator,
                showProgress: bookmark.showProgres,
                icon: bookmark.icon,
                color: bookmark.color.hexString ?? "FFFFFF"
            )
        }
    }

    
    //MARK: Read
    func fetchAllBookmarks() -> [Bookmark]? {
        let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching bookmarks: \(error)")
            return nil
        }
    }

    func fetchAllCards() -> [Card]? {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching cards: \(error)")
            return nil
        }
    }
    
    //MARK: Update
    func updateBookmark(bookmark: Bookmark, name: String, type: String, showOwnedIndicator: Bool, showProgress: Bool, icon: String, color: String, elestralCards: [ElestralCard]) {
        bookmark.name = name
        bookmark.type = type
        bookmark.showOwnedIndicator = showOwnedIndicator
        bookmark.showProgress = showProgress
        bookmark.icon = icon
        bookmark.color = color

        // Update associated Card entities
        let cards = elestralCards.map { elestralCard -> Card in
            let card = Card(context: self.context)
            card.id = elestralCard.id
            return card
        }
        bookmark.cards = NSSet(array: cards)

        do {
            try context.save()
        } catch {
            print("Error updating bookmark: \(error)")
        }
    }
    
    func updateCard(card: Card, newID: String, bookmarks: [Bookmark]) {
        card.id = newID
        card.bookmarks = NSSet(array: bookmarks)
        
        do {
            try context.save()
        } catch {
            print("Error updating card: \(error)")
        }
    }
    
    //MARK: Delete
    func deleteBookmark(bookmark: BookmarkModel) {
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)

        if let matches = try? context.fetch(request) as? [Bookmark], let match = matches.first {
            context.delete(match)
            do {
                try context.save()
            } catch {
                print("Error deleting bookmark: \(error)")
            }
        }
    }
    
    func deleteBookmark(bookmark: Bookmark) {
        context.delete(bookmark)
        do {
            try context.save()
        } catch {
            print("Error deleting bookmark: \(error)")
        }
    }

    func deleteCard(card: Card) {
        context.delete(card)
        do {
            try context.save()
        } catch {
            print("Error deleting card: \(error)")
        }
    }

    func deleteAllCardsAndBookmarks() {
        // Delete all cards
        if let allCards = fetchAllCards() {
            for card in allCards {
                context.delete(card)
            }
        }

        // Delete all bookmarks
        if let allBookmarks = fetchAllBookmarks() {
            for bookmark in allBookmarks {
                context.delete(bookmark)
            }
        }
        
        // Save changes
        do {
            try context.save()
        } catch {
            print("Error deleting all cards and bookmarks: \(error)")
        }
    }
    
    
}
