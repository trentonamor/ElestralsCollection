//
//  BookmarkCellView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/13/23.
//

import SwiftUI

struct BookmarkCellView: View {
    var model: BookmarkModel
    let framsize: CGFloat = 64
    var isViewOnly: Bool
    @State var didSelectCell: Bool = false
    
    var delegate: BookmarkCellDelegate?
    
    var body: some View {
            let content = HStack {
                ZStack {
                    Image(systemName: model.icon)
                        .foregroundColor(model.color)
                }
                .frame(width: framsize, height: framsize)
                .background(model.color.opacity(0.2))
                .cornerRadius(6)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(model.name)
                            .font(.body)
                            .bold()
                            .lineLimit(2)
                            .foregroundColor(Color(.dynamicGrey80))
                        
                        let totalOwned = model.cards.filter { $0.numberOwned >= 1 }.count
                        let cardCount = model.cards.count
                        
                        if totalOwned == 0 || !model.showProgres {
                            
                            let cardString = cardCount == 1 ? "Card" : "Cards"
                            Text("\(cardCount) \(cardString)")
                                .font(.subheadline)
                                .foregroundColor(Color(.dynamicGrey40))
                        } else {
                            let percentage: Double = Double(totalOwned) / Double(cardCount)
                            HStack {
                                if percentage != 1 {
                                    Text("\(totalOwned) of \(cardCount)")
                                        .foregroundColor(Color(.dynamicGrey40))
                                } else {
                                    Text("\(totalOwned) of \(cardCount)")
                                        .foregroundColor(Color(.dynamicUiBlue))
                                }
                                ProgressView(value: percentage)
                                if percentage == 1 {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(.dynamicGreen))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if self.isViewOnly && self.didSelectCell {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.dynamicUiBlue))
                    }
                }
                
                Spacer()
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color(.backgroundElevated))
            .cornerRadius(12)
        
        // Conditionally add the tap gesture based on isViewOnly
        if isViewOnly {
            return AnyView(content
                .onTapGesture {
                    self.didSelectCell.toggle()
                    self.delegate?.selectBookmark(self.model, doSelect: self.didSelectCell)
                })
        } else {
            return AnyView(content)
        }
    }
    
}


//struct BookmarkCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookmarkCellView(model: BookmarkModel(cards: [ElestralCard(id: "123", name: "Trenton", effect: "Trenton is cool", elements: ["water"], subclasses: ["human"], attack: 24, defense: 52, artist: "Trenton Parrotte", cardSet: .baseSet, cardNumber: "Tp-24", rarity: "full-art", cardType: "elestral", runeType: nil, date: Date.now)], name: "Cool Bookmark with a really long name that is so incredibly long my guy", type: .standard, showOwnedIndicator: false, showProgres: true, icon: "heart.fill", color: .green), isViewOnly: true, didSelectCell: true)
//    }
//}
