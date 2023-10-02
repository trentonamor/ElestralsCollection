//
//  CardStore.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/24/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData

class CardStore: ObservableObject {
    @Published var cards: [ElestralCard] = []
    @Published var isLoading: Bool = false
    @Published var lastUpdatedCard: ElestralCard?
    @Published var errorOccurred: Bool = false
    
    init() {
        self.isLoading = true
    }
    
    @MainActor func setup(userId: String, context: NSManagedObjectContext) async {
        Task {
            var cards: [ElestralCard] = []
            self.isLoading = true
            
            do {
                let documents = try await fetchAllCards()
                let dataManager = DataManager(context: context)
                dataManager.deleteAllCardsAndBookmarks()
                let bookmarks = try await dataManager.fetchBookmarks(for: userId)
                
                // Process the fetched documents
                for document in documents {
                    let data = document.data()
                    let card = ElestralCard(id: data["id"] as? String ?? "",
                                            name: data["cardName"] as? String ?? "",
                                            effect: self.cleanAndFormatEffect(effect: data["cardEffect"] as? String ?? ""),
                                            elements: data["elements"] as? [String] ?? [],
                                            subclasses: data["subclasses"] as? [String] ?? [],
                                            attack: Int(data["attack"] as? String ?? "-1"),
                                            defense: Int(data["defense"] as? String ?? "-1"),
                                            artist: data["artistName"] as? String ?? "",
                                            cardSet: self.getSetId(set: data["setName"] as? String ?? ""),
                                            cardNumber: data["setNumber"] as? String ?? "",
                                            rarity: data["rarity"] as? String ?? "",
                                            cardType: data["cardType"] as? String ?? "",
                                            runeType: data["runeType"] as? String,
                                            date: (data["publishedDate"] as? String ?? "").toDateFromPOSIX() ?? Date.distantPast)
                    
                    for bookmark in bookmarks {
                        if bookmark.cardIds.contains(card.id) {
                            bookmark.cards.append(card)
                        }
                    }
                    // Link the card with all bookmarks that have its ID
                    card.bookmarks = bookmarks.filter { $0.cardIds.contains(card.id) }
                    
                    cards.append(card)
                }
                
                // Fetch user cards
                let fetchedCards = try await dataManager.fetchCards(for: userId)
                cards = self.mergeElestralCards(firstArray: cards, secondArray: fetchedCards)
                self.isLoading = false
                
                for bookmark in bookmarks {
                    dataManager.createOrUpdateBookmark(bookmark: bookmark)
                }
                
            } catch {
                print("Error fetching documents: \(error)")
                self.errorOccurred = true
                self.isLoading = false
            }
            self.cards = cards
        }
    }
    
    
    private func fetchAllCards() async throws -> [QueryDocumentSnapshot] {
        let db = Firestore.firestore()
        
        let cardTypesCollectionRef = db.collection("Cards").document("CardTypes")
        
        var allDocuments: [QueryDocumentSnapshot] = []
        
        let subcollectionNames = ["Elestral", "Rune", "Spirit"]
        
        // Use the new `Task` to gather all documents concurrently
        try await withThrowingTaskGroup(of: [QueryDocumentSnapshot].self) { group in
            for subcollectionName in subcollectionNames {
                group.addTask {
                    try await cardTypesCollectionRef.collection(subcollectionName).getDocuments().documents
                }
            }
            
            // Gather all documents from each task into the allDocuments array
            for try await documents in group {
                allDocuments += documents
            }
        }
        
        return allDocuments
    }
    
    private func mergeElestralCards(firstArray: [ElestralCard], secondArray: [ElestralCard]) -> [ElestralCard] {
        // Convert second array to a dictionary for fast lookup by ID
        var secondArrayDict = Dictionary(uniqueKeysWithValues: secondArray.map { ($0.id, $0) })

        // Incorporate bookmarks from the first array into the corresponding card in the second array
        for card in firstArray {
            if let existingCard = secondArrayDict[card.id] {
                existingCard.bookmarks.append(contentsOf: card.bookmarks)
                existingCard.bookmarks = Array(Set(existingCard.bookmarks)) // remove potential duplicates
            } else {
                secondArrayDict[card.id] = card
            }
        }

        return Array(secondArrayDict.values)
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
}


