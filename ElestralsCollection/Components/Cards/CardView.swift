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
    var showNumberOwned: Bool = false
    var showOwnedIndicator: Bool = false
    
    init(card: ElestralCard, showOwnedIndicator: Bool = false, showNumberOwned: Bool = false) {
        self.card = card
        self.imageUrl = cardImageLoader.imageUrls[card.id]
        self.showNumberOwned = showNumberOwned
        self.showOwnedIndicator = showOwnedIndicator
    }
    
    var body: some View {
        ZStack {
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
            
            if card.numberOwned >= 1 && self.showOwnedIndicator {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .shadow(color: Color.black, radius: 16, x: 0, y: 2)
                        .overlay {
                            Image(systemName: "checkmark")
                        }
                        .transition(.opacity)
                        .animation(Animation.easeIn(duration: 0.8), value: 1)
                    
                    
                }
                
                // Position circle in the top right-hand corner
            if card.numberOwned >= 1 && self.showNumberOwned {
                    VStack {
                        HStack {
                            Spacer()
                            Circle()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                                .shadow(color: Color.black, radius: 4, x: 0, y: 2)
                                .padding([.horizontal, .top], 8)
                                .overlay {
                                    Text(card.numberOwned.description)
                                        .font(.system(size: 10))
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(1)
                                        .padding([.horizontal, .top], 8)
                                }
                                .transition(.opacity)
                                .animation(Animation.easeIn, value: 0.5)
                            
                        }
                        Spacer()
                    }
                }
            
        }
    }


}
