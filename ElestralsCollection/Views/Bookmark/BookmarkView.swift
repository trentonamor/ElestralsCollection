import SwiftUI

protocol EditBookmarkViewDelegate {
    func saveBookmark(_ bookmark: BookmarkModel)
    func deleteBookmark(_ bookmark: BookmarkModel)
}

struct BookmarkView: View {
    var navigationTitle: String = "Bookmarks"
    @State var presentNewBookmark: Bool = false
    @State var searchText: String = ""
    @State var refreshID = UUID()
    
    @State private var temporaryBookmark: BookmarkModel = BookmarkModel()
    
    @EnvironmentObject var cardStore: CardStore
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var bookmarkModels: [BookmarkModel] = []
    var filteredBookmarks: [BookmarkModel] {
        if searchText.isEmpty {
            return bookmarkModels
        } else {
            return bookmarkModels.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    @State var editMode: EditMode = .new
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                if filteredBookmarks.count > 0 {
                    ForEach(filteredBookmarks) { bookmark in
                        NavigationLink(destination: {
                            CollectionView(subset: bookmark.cards,
                                           viewTitle: bookmark.name,
                                           noResultsText: bookmark.cards.count == 0 ? "Looks like you haven't added a single card to this bookmark yet!" : "We couldn't find any cards based on your search and current filters.",
                                           showOwnedIndicator: bookmark.showOwnedIndicator,
                                           showNumberOwned: true)
                        }, label: {
                            BookmarkCellView(model: bookmark)
                                .padding(.horizontal)
                                .contextMenu(menuItems: {
                                    Button {
                                        self.temporaryBookmark = bookmark
                                        self.editMode = .edit
                                        self.presentNewBookmark.toggle()
                                    } label: {
                                        Label("Edit", systemImage: "slider.horizontal.3")
                                    }
                                    Button {
                                        self.bookmarkModels.removeAll(where: {
                                            $0.id == bookmark.id
                                        })
                                    } label: {
                                        Label("Delete", systemImage: "multiply")
                                            .foregroundColor(Color.red)
                                    }
                                })
                        })
                    }
                    .id(refreshID)
                    Spacer()
                } else {
                    VStack(alignment: .center, spacing: 16) {
                        Spacer()
                        Text("You don't have any bookmarks!")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(.horizontal)
                        Text("Here are a few ideas for your bookmarks: \"Cards you would like to have\", \"My Powerful Deck\", or \"Stellars\"")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .searchable(text: $searchText, placement: .automatic, prompt: "Search by Name")
            .navigationTitle(navigationTitle)
            .background(Color("backgroundBase"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.temporaryBookmark = BookmarkModel()
                        self.editMode = .new
                        self.presentNewBookmark.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                    
                })
            }
            .sheet(isPresented: $presentNewBookmark, content: {
                EditBookmarkView(model: self.$temporaryBookmark, mode: editMode, delegate: self)
            })
        }
        
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView(bookmarkModels: [
            BookmarkModel(cards: [ElestralCard(id: "123", name: "Trenton", effect: "Trenton is cool", elements: ["water"], subclasses: ["human"], attack: 24, defense: 52, artist: "Trenton Parrotte", cardSet: .baseSet, cardNumber: "Tp-24", rarity: "full-art", cardType: "elestral", runeType: nil, date: Date.now), ], name: "Cool Bookmark", type: .standard, showOwnedIndicator: false, showProgres: true, icon: "heart.fill", color: .green),
            BookmarkModel(cards: [ElestralCard(id: "456", name: "Trenton", effect: "Trenton is cool", elements: ["water"], subclasses: ["human"], attack: 24, defense: 52, artist: "Trenton Parrotte", cardSet: .baseSet, cardNumber: "Tp-24", rarity: "full-art", cardType: "elestral", runeType: nil, date: Date.now)], name: "Cool Bookmark 2", type: .standard, showOwnedIndicator: false, showProgres: false, icon: "heart.fill", color: .red)
        ])
    }
}

