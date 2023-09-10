//
//  CardDetailView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/22/23.
//

import SwiftUI

struct CardDetailView: View {
    @ObservedObject var card: ElestralCard
    @EnvironmentObject var cardStore: CardStore
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    CardView(card: card)
                        .padding(.horizontal)
                        .padding(.top)
                    Text(card.name)
                        .font(.title2)
                        .bold()
                        .italic()
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                    Text(card.getCardSet())
                        .foregroundColor(.gray)
                        .padding(.vertical, 0)
                        .padding(.horizontal, 8)
                    
                    LabelView(topText: "Rarity", mainText: card.getCardRarity())
                    
                    HStack {
                            Button(action: {
                                if card.numberOwned > 0 {
                                    card.numberOwned -= 1
                                    cardStore.cardUpdated(card)
                                }
                            }) {
                                VStack(alignment: .center) {
                                    Text("-")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                            }
                            .disabled(card.numberOwned == 0) 
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            HStack {
                                Spacer()
                                
                                Text(card.getNumberOwned())
                                    .font(.body)
                                    .bold()
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                            }
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal, 4)

                            Button(action: {
                                card.numberOwned += 1
                                cardStore.cardUpdated(card)
                            }) {
                                VStack(alignment: .center) {
                                    Text("+")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 16)
                    
                    LineSeparator()
                        .padding(.vertical, 16)
                    
                    LabelView(topText: "Card Type", mainText: card.cardType)
                    
                    Group {
                        if let runeType = card.runeType, !runeType.isEmpty {
                            LabelView(topText: "Rune Type", mainText: runeType.capitalized)
                        }
                    }
                    
                    LabelView(topText: "Artist", mainText: card.artist)
                    LabelView(topText: "Card Number", mainText: card.cardNumber)

                }
            }
            .background(Color("backgroundBase"))
        }
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(card: ElestralCard(id: "1", name: "Cool Name", effect: "This is a really cool effect you wouldn't even believe how awesome this effect is.", elements: ["water", "rainbow"], subclasses: ["ursa", "insectoid"], attack: 1, defense: 1, artist: "Trenton Parrotte", cardSet: .baseSet, cardNumber: "TP-2452", rarity: "stellar-rare", cardType: "Elestral", runeType: nil, date: Date.now))
    }
}