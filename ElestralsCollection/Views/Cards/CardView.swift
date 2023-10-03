import SwiftUI
import Foundation

struct CardView: View {
    @State var imageUrl: URL?
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let card: ElestralCard
    let cardImageLoader: CardImageLoader = CardImageLoader()
    
    let cornerRadius: CGFloat = 12
    var showNumberOwned: Bool = false
    var showOwnedIndicator: Bool = false
    var bookmark: BookmarkModel? = nil
    
    init(card: ElestralCard, showOwnedIndicator: Bool = false, showNumberOwned: Bool = false, bookmark: BookmarkModel? = nil) {
        self.card = card
        self.imageUrl = cardImageLoader.imageUrls[card.id]
        self.showNumberOwned = showNumberOwned
        self.showOwnedIndicator = showOwnedIndicator
        self.bookmark = bookmark
    }
    
    var contentView: some View {
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
                        image.resizable()
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
            
            if (card.numberOwned >= 1 && self.showOwnedIndicator && self.bookmark == nil) || (self.bookmark != nil && self.card.bookmarks.contains(where: { $0.id.uuidString == self.bookmark?.id.uuidString })) {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 16, x: 0, y: 2)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.black)
                    }
                    .transition(.opacity)
                    .animation(Animation.easeIn(duration: 0.8), value: 1)
            }
            
            if card.numberOwned >= 1 && self.showNumberOwned {
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 4, x: 0, y: 2)
                            .padding([.horizontal, .top], 8)
                            .overlay {
                                Text(card.numberOwned.description)
                                    .font(.system(size: 10))
                                    .minimumScaleFactor(0.01)
                                    .foregroundStyle(.black)
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

    var body: some View {
        if let _ = bookmark {
            return AnyView(contentView.onTapGesture {
                if card.bookmarks.contains(where: { $0.id.uuidString == bookmark?.id.uuidString }) {
                    // Remove bookmark
                    card.bookmarks.removeAll(where: { $0.id.uuidString == bookmark?.id.uuidString })
                } else {
                    // Append bookmark
                    card.bookmarks.append(bookmark!)
                }
                
                cardStore.cardUpdated(card)
                addOrRemoveBookmarks(bookmarkId: bookmark?.id, card: card)
            })
        } else {
            return AnyView(contentView)
        }
    }
}
