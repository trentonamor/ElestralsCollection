//
//  CardsOwnedCard.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import SwiftUI

struct ProgressCard: View {
    
    var cardViewModel: CardModel
    @State var progressValue: Float = 0.0
    
    var foundText: String {
        return "\(self.getNumberCollected(for: nil)) of \(cardViewModel.cardList.count)"
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 8 ,content: {
                    Text("Elestrals Found")
                        .font(.title2)
                        .bold()
                    Text(foundText)
                        .font(.body)
                        .padding(.bottom)
                        .onChange(of: self.foundText) { _ in
                            self.progressValue = self.getPercentage()
                        }
                    
                    
                    Text("Cards Owned")
                        .font(.title2)
                        .bold()
                    Text("\(self.getNumberCardsOwned(for: nil))")
                        .font(.body)
                })
                .padding(.trailing)
                
                ProgressCircle(progressValue: $progressValue)
                    .frame(width: 150, height: 150)
            }
            .padding()
        }
    }
}

struct CardsOwnedCard_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCard(cardViewModel: CardModel(cardType: .progress))
    }
}
