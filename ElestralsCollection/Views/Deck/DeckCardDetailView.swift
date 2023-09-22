//
//  DeckCardDetailView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/21/23.
//

import SwiftUI

struct DeckCardDetailView: View {
    @ObservedObject var card: ElestralCard
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showingBookmarkView: Bool = false
    let bookmarkId: UUID
    
    var addToDeckDisabled: Bool { card.cardType.lowercased() != "spirit" ? card.getCount(forBookmark: bookmarkId) == 3 : card.getCount(forBookmark: bookmarkId) == 20
    }
    var substrackFromDeckDisabled: Bool {
        card.getCount(forBookmark: bookmarkId) == 0
    }
    var subtrackTotalOwnedDisabled: Bool {
        card.numberOwned == 0
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
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
                    
                    Group {
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
                            .disabled(subtrackTotalOwnedDisabled)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .opacity(subtrackTotalOwnedDisabled ? 0.75 : 1.0)
                            
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
                    }
                    Group {
                        HStack {
                            Button(action: {
                                card.updateCardCount(inBookmark: bookmarkId, byCount: -1)
                                if card.getCount(forBookmark: bookmarkId) == 0 {
                                    self.addOrRemoveBookmarks()
                                }
                                cardStore.cardUpdated(card)
                            }) {
                                VStack(alignment: .center) {
                                    Text("-")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                            }
                            .disabled(substrackFromDeckDisabled)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .opacity(substrackFromDeckDisabled ? 0.75 : 1.0)
                            
                            HStack {
                                Spacer()
                                
                                Text("\(card.getCount(forBookmark: self.bookmarkId)) in Deck")
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
                                if card.getCount(forBookmark: bookmarkId) == 0 {
                                    self.addOrRemoveBookmarks()
                                } else {
                                    card.updateCardCount(inBookmark: bookmarkId, byCount: 1)
                                }
                                cardStore.cardUpdated(card)
                            }) {
                                VStack(alignment: .center) {
                                    Text("+")
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                            }
                            
                            .disabled(addToDeckDisabled)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .opacity(addToDeckDisabled ? 0.75 : 1.0)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Button(action: {
                        self.showingBookmarkView.toggle()
                    }, label: {
                        HStack {
                            Spacer()
                            Group {
                                if card.bookmarks.isEmpty {
                                    Image(systemName: "bookmark")
                                        .foregroundColor(.black)
                                } else {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor(.black)
                                }
                            }
                            
                            let bookmarkModel = card.bookmarks.first(where: { $0.id == self.bookmarkId })
                            Text(bookmarkModel?.name ?? "Removed From Deck")
                                .foregroundColor(.black)
                                .font(.body)
                                .bold()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                            
                            Spacer()
                        }
                        .background(Color(.white))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top, 0)
                        .opacity(0.75)
                    })
                    .disabled(true)
                    
                    LineSeparator()
                        .padding(.vertical, 16)
                    
                    LabelView(topText: "Card Type", mainText: card.cardType)
                    
                    Group {
                        if let runeType = card.runeType, !runeType.isEmpty {
                            LabelView(topText: "Rune Type", mainText: runeType.capitalized)
                        }
                    }
                    
                    Group {
                        LabelView(topText: "Artist", mainText: card.artist)
                        LabelView(topText: "Card Number", mainText: card.cardNumber)
                    }
                }
            }
            .background(Color("backgroundBase"))
        }
        .sheet(isPresented: $showingBookmarkView) {
            BookmarkView(isViewOnly: true, cardToAdd: self.card)
        }
    }
}

