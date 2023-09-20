//
//  BookmarkList.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/19/23.
//

import SwiftUI

struct BookmarkList: View {
    var filteredBookmarks: [BookmarkModel]
    var isViewOnly: Bool
    var onDeleteBookmark: (BookmarkModel) -> Void
    var onEditBookmark: (BookmarkModel) -> Void

    @State private var selectedBookmarks: Set<UUID> = []

    var body: some View {
        ScrollView {
            ForEach(filteredBookmarks) { bookmark in
                if isViewOnly {
                    BookmarkCellView(model: bookmark, isViewOnly: isViewOnly, didSelectCell: false)
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
                                .foregroundColor(Color.red)
                        }
                    })
                } else {
                    NavigationLink(destination: {
                        CollectionView(subset: bookmark.cards,
                                       viewTitle: bookmark.name,
                                       noResultsText: bookmark.cards.count == 0 ? "Looks like you haven't added a single card to this bookmark yet!" : "We couldn't find any cards based on your search and current filters.",
                                       showOwnedIndicator: bookmark.showOwnedIndicator,
                                       showNumberOwned: true)
                    }, label: {
                        BookmarkCellView(model: bookmark, isViewOnly: isViewOnly, didSelectCell: false)
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
                                        .foregroundColor(Color.red)
                                }
                            })
                    })
                }
            }
        }
    }
}


