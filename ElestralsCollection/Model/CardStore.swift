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
    
    init() {
        self.isLoading = true
        
        fetchAllCards { (documents, error) in
            defer { self.isLoading = false }
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            if let documents = documents {
                // Process the fetched documents
                for document in documents {
                    let data = document.data()
                    let card = ElestralCard(id: data["id"] as? String ?? "",
                                            name: data["cardName"] as? String ?? "",
                                            effect: data["cardEffect"] as? String ?? "",
                                            elements: data["elements"] as? [String] ?? [],
                                            subclasses: data["subclasses"] as? [String] ?? [],
                                            attack: data["attack"] as? Int,
                                            defense: data["defense"] as? Int,
                                            artist: data["artistName"] as? String ?? "",
                                            cardSet: self.getSetId(set: data["setName"] as? String ?? ""),
                                            cardNumber: data["setNumber"] as? String ?? "",
                                            rarity: data["rarity"] as? String ?? "",
                                            cardType: data["cardType"] as? String ?? "",
                                            runeType: data["runeType"] as? String,
                                            date: (data["publishedDate"] as? String ?? "").toDateFromPOSIX() ?? Date.distantPast)
                    self.cards.append(card)
                }
            } else {
                print("No documents found.")
            }
        }
    }

    private func fetchAllCards(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        let cardTypesCollectionRef = db.collection("Cards").document("CardTypes")
        
        var allDocuments: [QueryDocumentSnapshot] = []
        
        let subcollectionNames = ["Elestral", "Rune", "Spirit"]
        
        let dispatchGroup = DispatchGroup()
        
        for subcollectionName in subcollectionNames {
            dispatchGroup.enter()
            
            cardTypesCollectionRef.collection(subcollectionName).getDocuments { (querySnapshot, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let documents = querySnapshot?.documents {
                    allDocuments.append(contentsOf: documents)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if allDocuments.isEmpty {
                completion(nil, nil) // No documents found
            } else {
                completion(allDocuments, nil)
            }
        }
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


