//
//  CardModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/1/22.
//

import Foundation

class CardModel: ObservableObject {
    @Published var cardType: CardType = .unknown
    @Published var cardList: [ElestralCard] = []
    
    init(cardType: CardType, cardList: [ElestralCard] = []) {
        self.cardType = cardType
        self.cardList = cardList
    }
    
    func getUniqueNumberOfElestrals() -> Int {
        let uniqueNames = Set(cardList.map { $0.name })
        return uniqueNames.count
    }
    
}

enum CardType: Codable {
    case unknown
    case progress
    case distribution
    case info
}
