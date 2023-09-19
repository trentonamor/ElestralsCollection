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
    
    @State var temporaryBookmark: BookmarkModel?
    
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
    
    var body: some View {
       NavigationStack {
                VStack(alignment: .leading, spacing: 8) {
                    if filteredBookmarks.count > 0 {
                        ScrollView {
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
                                            } label: {
                                                Label("Edit", systemImage: "slider.horizontal.3")
                                            }
                                            Button {
                                                let index = self.bookmarkModels.firstIndex(where: { $0.id == bookmark.id })
                                                let model = self.bookmarkModels[index ?? 0]
                                                self.deleteBookmark(model)
                                            } label: {
                                                Label("Delete", systemImage: "multiply")
                                                    .foregroundColor(Color.red)
                                            }
                                        })
                                })
                            }
                            .id(refreshID)
                        }
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
                        self.presentNewBookmark.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                    
                })
            }
            .sheet(item: self.$temporaryBookmark, onDismiss: { self.temporaryBookmark = nil}, content: { item in
                EditBookmarkView(model: item, delegate: self)
            })
        }
        .onAppear {
            loadBookmarks()
        }
        
    }
}
