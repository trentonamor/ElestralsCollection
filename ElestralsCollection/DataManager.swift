//
//  DataManager.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/15/23.
//

import Foundation
import CoreData
import FirebaseFirestore
import SwiftUI

@MainActor
class DataManager {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: Create
    func createBookmark(cards: [ElestralCard], name: String, type: String, showOwnedIndicator: Bool, showProgress: Bool, icon: String, color: String, id: UUID) -> Bookmark? {
        let newBookmark = Bookmark(context: self.context)
        newBookmark.id = id
        
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
                color: bookmark.color.name ?? "dynamicLime",
                elestralCards: bookmark.cards
            )
            
            // Ensure the cards exist in CoreData and add them to the bookmark
            var cardEntities: Set<Card> = []
            for card in bookmark.cards {
                let cardEntity = ensureCardExistsInCoreData(card: card)
                cardEntities.insert(cardEntity)
            }
            match.cards = cardEntities as NSSet
            
        } else {
            // New bookmark, create it
            let newBookmark = createBookmark(
                cards: [], // Intentionally empty as we will add cards next
                name: bookmark.name,
                type: bookmark.type.rawValue,
                showOwnedIndicator: bookmark.showOwnedIndicator,
                showProgress: bookmark.showProgres,
                icon: bookmark.icon,
                color: bookmark.color.name ?? "dynamicLime",
                id: bookmark.id
            )
            
            // Ensure the cards exist in CoreData and add them to the new bookmark
            var cardEntities: Set<Card> = []
            for card in bookmark.cards {
                let cardEntity = ensureCardExistsInCoreData(card: card)
                cardEntities.insert(cardEntity)
            }
            newBookmark?.cards = cardEntities as NSSet
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save bookmark: \(error)")
        }
    }

    private func ensureCardExistsInCoreData(card: ElestralCard) -> Card {
        // Check if the card already exists
        let cardFetchRequest: NSFetchRequest<NSFetchRequestResult> = Card.fetchRequest()
        cardFetchRequest.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)
        
        let matches = try? self.context.fetch(cardFetchRequest) as? [Card]
        if let existingCard = matches?.first {
            return existingCard
        } else {
            let newCardEntity = Card(context: self.context)
            newCardEntity.id = card.id

            return newCardEntity
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
    
    //MARK: Firebase Functions
    func saveCardStoreToFirebase(cardStore: CardStore, for userId: String) async throws {
        // Save all cards to Firebase
        try await save(elestralCards: cardStore.cards.filter({ $0.numberOwned > 0 || !$0.bookmarks.isEmpty}), for: userId)
        
        // Extract unique bookmarks from all cards
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        var uniqueBookmarks: [BookmarkModel] = []
        
        do {
            let bookmarkEntities = try context.fetch(fetchRequest)
            uniqueBookmarks = bookmarkEntities.map { BookmarkModel(from: $0, cardStore: cardStore) }
        } catch {
            print("Failed to fetch bookmarks: \(error)")
        }
        
        // Delete bookmarks from Firebase that aren't in the local copy
        try await deleteFirebaseBookmarksNotIn(uniqueBookmarks, for: userId)
        
        // Save all unique bookmarks to Firebase
        try await save(bookmarks: uniqueBookmarks, for: userId)
    }

    func save(elestralCards: [ElestralCard], for userId: String) async throws {
        let db = Firestore.firestore()
        for card in elestralCards {
            let documentRef = db.collection("users").document(userId).collection("cards").document(card.id)
            
            // Convert UUID keys to strings for Firestore compatibility
            let cardsInDeckStringKeys = card.cardsInDeck.mapKeys { $0.uuidString }
            
            try await documentRef.setData([
                "id": card.id,
                "name": card.name,
                "effect": card.effect,
                "elements": card.elements,
                "subclasses": card.subclasses,
                "attack": card.attack ?? NSNull(),
                "defense": card.defense ?? NSNull(),
                "artist": card.artist,
                "cardSet": self.getSetId(set: card.cardSet),
                "cardNumber": card.cardNumber,
                "rarity": card.rarity,
                "cardType": card.cardType,
                "runeType": card.runeType ?? NSNull(),
                "publishedDate": card.publishedDate,
                "cardsInDeck": cardsInDeckStringKeys, // Store the cardsInDeck dictionary
                "numberOwned": card.numberOwned
            ])
        }
    }
    
    func save(bookmarks: [BookmarkModel], for userId: String) async throws {
        let db = Firestore.firestore()
        for bookmark in bookmarks {
            let bookmarkRef = db.collection("users").document(userId).collection("bookmarks").document(bookmark.id.uuidString)
            try await bookmarkRef.setData([
                "id": bookmark.id.uuidString,
                "name": bookmark.name,
                "type": bookmark.type.rawValue,
                "showOwnedIndicator": bookmark.showOwnedIndicator,
                "showProgres": bookmark.showProgres,
                "icon": bookmark.icon,
                "color": bookmark.color.name,
                "cards": bookmark.cards.map { $0.id }
            ])
        }
    }
    
    func deleteFirebaseBookmarksNotIn(_ localBookmarks: [BookmarkModel], for userId: String) async throws {
        let db = Firestore.firestore()
        let bookmarksRef = db.collection("users").document(userId).collection("bookmarks")
        
        // Fetch all bookmarks from Firebase
        let snapshot = try await bookmarksRef.getDocuments()
        
        let firebaseBookmarksIDs = snapshot.documents.map { $0.documentID }
        let localBookmarksIDs = localBookmarks.map { $0.id.uuidString }
        
        let bookmarksToDelete = firebaseBookmarksIDs.filter { !localBookmarksIDs.contains($0) }
        
        for bookmarkID in bookmarksToDelete {
            let bookmarkRef = bookmarksRef.document(bookmarkID)
            try await bookmarkRef.delete()
        }
    }
    
    func fetchBookmarks(for userId: String) async throws -> [BookmarkModel] {
        do {
            let db = Firestore.firestore()
            let bookmarksQuerySnapshot = try await db.collection("users").document(userId).collection("bookmarks").getDocuments()
            var bookmarks: [BookmarkModel] = []
            
            for document in bookmarksQuerySnapshot.documents {
                let data = document.data()
                let cards = try await fetchElestralCards(forBookmarkId: document.documentID, userId: userId)
                let uuid: UUID = UUID(uuidString: (data["id"] as? String)!)!
                let bookmark = BookmarkModel(
                    cardIds: data["cards"] as? [String] ?? [],
                    name: data["name"] as? String ?? "",
                    type: BookmarkType(rawValue: data["type"] as? String ?? "") ?? .standard,
                    showOwnedIndicator: data["showOwnedIndicator"] as? Bool ?? false,
                    showProgres: data["showProgres"] as? Bool ?? false,
                    icon: data["icon"] as? String ?? "",
                    color: Color(data["color"] as? String ?? "dynamicGreen"),
                    id: uuid
                )
                
                bookmarks.append(bookmark)
                
            }
            return bookmarks
        } catch {
            return []
        }
    }
    
    func fetchCards(for userId: String) async throws -> [ElestralCard] {
        let db = Firestore.firestore()

        // 1. Fetch all bookmarks for the user
        let bookmarks = try await fetchBookmarks(for: userId)

        let cardsQuerySnapshot = try await db.collection("users").document(userId).collection("cards").getDocuments()
        
        var elestralCards: [ElestralCard] = []
        for document in cardsQuerySnapshot.documents {
            let data = document.data()
            
            // Convert string keys back to UUID for in-app use
            let cardsInDeckUUIDKeys = (data["cardsInDeck"] as? [String: Int])?.mapKeys { UUID(uuidString: $0)! } ?? [:]
            
            // 2. Use the cardsInDeck dictionary to determine which bookmarks the card belongs to
            let associatedBookmarks = bookmarks.filter { bookmark in
                if let id = UUID(uuidString: bookmark.id.uuidString) {
                    return cardsInDeckUUIDKeys.keys.contains(id)
                }
                return false
            }
            
            var card = ElestralCard(
                id: data["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                effect: data["effect"] as? String ?? "",
                elements: data["elements"] as? [String] ?? [],
                subclasses: data["subclasses"] as? [String] ?? [],
                attack: data["attack"] as? Int,
                defense: data["defense"] as? Int,
                artist: data["artist"] as? String ?? "",
                cardSet: getSetId(set: data["cardSet"] as? String ?? ""),
                cardNumber: data["cardNumber"] as? String ?? "",
                rarity: data["rarity"] as? String ?? "",
                cardType: data["cardType"] as? String ?? "",
                runeType: data["runeType"] as? String,
                date: (data["publishedDate"] as? Timestamp)?.dateValue() ?? Date(),
                bookmarks: associatedBookmarks
            )
            card.cardsInDeck = cardsInDeckUUIDKeys
            card.numberOwned = data["numberOwned"] as? Int ?? -1
            
            elestralCards.append(card)
        }
        
        return elestralCards
    }


    func fetchElestralCards(forBookmarkId bookmarkId: String, userId: String) async throws -> [ElestralCard] {
        let db = Firestore.firestore()
        let cardsQuerySnapshot = try await db.collection("users").document(userId).collection("cards").whereField("cardsInDeck.\(bookmarkId)", isGreaterThan: 0).getDocuments()
        
        var elestralCards: [ElestralCard] = []
        for document in cardsQuerySnapshot.documents {
            let data = document.data()
            
            // Convert string keys back to UUID for in-app use
            let cardsInDeckUUIDKeys = (data["cardsInDeck"] as? [String: Int])?.mapKeys { UUID(uuidString: $0)! } ?? [:]
            
            var card = ElestralCard(
                id: data["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                effect: data["effect"] as? String ?? "",
                elements: data["elements"] as? [String] ?? [],
                subclasses: data["subclasses"] as? [String] ?? [],
                attack: data["attack"] as? Int,
                defense: data["defense"] as? Int,
                artist: data["artist"] as? String ?? "",
                cardSet: getSetId(set: data["cardSet"] as? String ?? ""),
                cardNumber: data["cardNumber"] as? String ?? "",
                rarity: data["rarity"] as? String ?? "",
                cardType: data["cardType"] as? String ?? "",
                runeType: data["runeType"] as? String,
                date: (data["publishedDate"] as? Timestamp)?.dateValue() ?? Date(),
                bookmarks: []
            )
            card.cardsInDeck = cardsInDeckUUIDKeys
            
            elestralCards.append(card)
        }
        
        return elestralCards
    }

    private func getSetId(set: String) -> ExpansionId {
        switch set.lowercased(){
        case "artist collection":
            return .artistCollection
        case "base set":
            return .baseSet
        case "base set promo cards":
            return .baseSetPromoCards
        case "centaurbor starter deck":
            return .centaurborStarterDeck
        case "trifernal starter deck":
            return .trifernalStarterDeck
        case "majesea starter deck":
            return .majeseaStarterDeck
        case "ohmperial starter deck":
            return .ohmperialStarterDeck
        case "penterror starter deck":
            return .penterrorStarterDeck
        case "prototype promo cards":
            return .prototypePromoCards
        default:
            print("Error in finding set for \(set)")
            return .unknown
        }
    }
    
    private func getSetId(set: ExpansionId) -> String {
        switch set {
        case .artistCollection:
            return "artist collection"
        case .unknown:
            return ""
        case .baseSet:
            return "base set"
        case .centaurborStarterDeck:
            return "centaurbor starter deck"
        case .trifernalStarterDeck:
            return "trifernal starter deck"
        case .majeseaStarterDeck:
            return "majesea starter deck"
        case .ohmperialStarterDeck:
            return "ohmperial starter deck"
        case .penterrorStarterDeck:
            return "penterror starter deck"
        case .baseSetPromoCards:
            return "base set promo cards"
        case .prototypePromoCards:
            return "prototype promo cards"
        }
    }
}
