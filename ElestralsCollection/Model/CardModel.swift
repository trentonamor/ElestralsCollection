//
//  CardModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/1/22.
//

import Foundation

class CardModel: ObservableObject {
    @Published var cardType: CardType = .unknown
    @Published var cardList: [Elestral] = []
    
    init(cardType: CardType, cardList: [Elestral] = []) {
        self.cardType = cardType
        self.cardList = cardList
    }
    
}

enum CardType: Codable {
    case unknown
    case progress
    case distribution
    case info
}
