import SwiftUI

protocol EditBookmarkViewDelegate {
    func saveBookmark(_ bookmark: BookmarkModel)
    func deleteBookmark(_ bookmark: BookmarkModel)
}

protocol BookmarkCellDelegate {
    func saveBookmark(_ bookmark: BookmarkModel)
    func selectBookmark(_ bookmark: BookmarkModel, doSelect: Bool)
}

struct BookmarkView: View {
    var navigationTitle: String = "Bookmarks"
    @State var searchText: String = ""
    @State var refreshID = UUID()
    @State private var showUpsell = false
    
    @State var temporaryBookmark: BookmarkModel?
    
    @EnvironmentObject var cardStore: CardStore
    @EnvironmentObject var entitilementManager: EntitlementsManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State var bookmarkModels: [BookmarkModel] = []
    @State var isViewOnly: Bool
    
    @State var selectedBookmarkIDs: Set<UUID> = []
    var cardToAdd: ElestralCard?
    
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
                    BookmarkList(cardId: self.cardToAdd?.id, filteredBookmarks: filteredBookmarks, isViewOnly: isViewOnly, onDeleteBookmark: deleteBookmark, onEditBookmark: { bookmark in
                        self.temporaryBookmark = bookmark
                    }, delegate: self)
                    .id(refreshID)
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
                        if self.entitilementManager.hasEntitlements || self.bookmarkModels.count < 2 {
                            self.temporaryBookmark = BookmarkModel()
                        } else {
                            self.showUpsell = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                    
                })
                
                if self.isViewOnly {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Done")
                                .foregroundColor(.accentColor)
                        })
                    })
                }
            }
            .sheet(item: self.$temporaryBookmark, onDismiss: { self.temporaryBookmark = nil}, content: { item in
                EditBookmarkView(model: item, delegate: self)
            })
            .sheet(isPresented: self.$showUpsell, content: {
                UpsellView()
            })
        }
        .onAppear {
            loadBookmarks()
            NotificationCenter.default.addObserver(
                forName: .bookmarkDataDidChange,
                object: nil,
                queue: nil) { [self] _ in
                    // Handle the notification by updating the view's data
                    self.loadBookmarks() // Or perform any necessary updates
                    
                }
        }
        .onDisappear {
            self.addOrRemoveCardFromBookmarks()
        }
        
    }
}
