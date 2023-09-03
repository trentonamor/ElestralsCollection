//
//  CardDetailViewModel.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/2/23.
//

import Foundation

class CardDetailViewModel: ObservableObject {
    @Published var card: ElestralCard
    
    init(card: ElestralCard) {
        self.card = card
    }
}
