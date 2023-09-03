//
//  ExpansionCellModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/16/23.
//

import Foundation

class ExpansionCellModel: ObservableObject, Identifiable {
    @Published var imageName: String = ""
    @Published var cellText: String = ""
    var expansionId: ExpansionId
    let creationDate: Date
    let id = UUID()
    
    init(imageName: String, cellText: String, expansionId: ExpansionId, creationDate: Date) {
        self.imageName = imageName
        self.cellText = cellText
        self.expansionId = expansionId
        self.creationDate = creationDate
    }
    
}

enum ExpansionId: Int {
    case unknown
    case baseSet
    case centaurborStarterDeck
    case trifernalStarterDeck
    case majeseaStarterDeck
    case ohmperialStarterDeck
    case penterrorStarterDeck
    case artistCollection
    case baseSetPromoCards
    case prototypePromoCards
}
