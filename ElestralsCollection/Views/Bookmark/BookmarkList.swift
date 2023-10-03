//
//  BookmarkList.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/19/23.
//

import SwiftUI

struct BookmarkList: View {
    var cardId: String?
    var filteredBookmarks: [BookmarkModel]
    var isViewOnly: Bool
    var onDeleteBookmark: (BookmarkModel) -> Void
    var onEditBookmark: (BookmarkModel) -> Void
    
    var delegate: BookmarkCellDelegate?
    
    var deckBookmarks: [BookmarkModel] {
        return filteredBookmarks.filter { $0.type == .deck }
    }

    var otherBookmarks: [BookmarkModel] {
        return filteredBookmarks.filter { $0.type != .deck }
    }

    var body: some View {
        ScrollView {
            // Section for .deck bookmarks
            Section(content: {
                ForEach(deckBookmarks) { bookmark in
                    bookmarkCell(for: bookmark)
                }
            }, header: {
                HStack(alignment: .center, content: {
                    Text("Decks")
                        .foregroundStyle(Color(.dynamicGrey60))
                })
            })

            // Section for other bookmarks
            Section(content: {
                ForEach(otherBookmarks) { bookmark in
                    bookmarkCell(for: bookmark)
                }
            }, header: {
                HStack(alignment: .center, content: {
                    Text("Bookmarks")
                        .foregroundStyle(Color(.dynamicGrey60))
                })
            })
        }
    }

    @ViewBuilder
    func bookmarkCell(for bookmark: BookmarkModel) -> some View {
        if isViewOnly {
            BookmarkCellView(model: bookmark, isViewOnly: isViewOnly, didSelectCell: self.doSelectCell(bookmark: bookmark), delegate: delegate)
                .padding(.horizontal)
                .contextMenu(menuItems: {
                    Button {
                        onEditBookmark(bookmark)
                    } label: {
                        Label("Edit", systemImage: "slider.horizontal.3")
                    }
                    Button {
                        onDeleteBookmark(bookmark)
                    } label: {
                        Label("Delete", systemImage: "multiply")
                    }
                })
        } else {
            NavigationLink(destination: {
                if bookmark.type == .standard {
                    CollectionView(subset: bookmark.cards,
                                   viewTitle: bookmark.name,
                                   noResultsText: bookmark.cards.count == 0 ? "Looks like you haven't added a single card to this bookmark yet!" : "We couldn't find any cards based on your search and current filters.",
                                   showOwnedIndicator: bookmark.showOwnedIndicator,
                                   showNumberOwned: true)
                } else {
                    DeckView(bookmark: bookmark, showOwnedIndicator: bookmark.showOwnedIndicator, showNumberOwned: true)
                }
            }, label: {
                BookmarkCellView(model: bookmark, isViewOnly: isViewOnly, didSelectCell: false, delegate: delegate)
                    .padding(.horizontal)
                    .contextMenu(menuItems: {
                        Button {
                            onEditBookmark(bookmark)
                        } label: {
                            Label("Edit", systemImage: "slider.horizontal.3")
                        }
                        Button {
                            onDeleteBookmark(bookmark)
                        } label: {
                            Label("Delete", systemImage: "multiply")
                        }
                    })
            })
        }
    }
}



