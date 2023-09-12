//
//  CardView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/22/23.
//

import SwiftUI
import Foundation

struct CardView: View {
    @State var imageUrl: URL?
    
    let card: ElestralCard
    let cardImageLoader: CardImageLoader = CardImageLoader()
    
    let cornerRadius: CGFloat = 12
    
    init(card: ElestralCard) {
        self.card = card
        self.imageUrl = cardImageLoader.imageUrls[card.id]
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: self.imageUrl) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Image("MainCardBackground")
                            .resizable()
                        Text(card.name)
                            .foregroundColor(.white)
                    }
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    ZStack {
                        Image("MainCardBackground")
                            .resizable()
                        Text(card.name)
                            .foregroundColor(.white)
                    }
                @unknown default:
                    ZStack {
                        Image("MainCardBackground")
                            .resizable()
                        Text(card.name)
                            .foregroundColor(.white)
                    }
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onAppear {
            cardImageLoader.downloadCardImages(cards: [card])
        }
        .onReceive(cardImageLoader.imageLoaded) { loadedCardID in
            if loadedCardID == card.id {
                imageUrl = cardImageLoader.imageUrls[loadedCardID]
            }
        }
    }
}
