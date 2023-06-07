import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView {
            ElestralsView()
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Elestrals")
                }
            ExpansionsView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Expansions")
                }
//            BookmarkView()
//                .tabItem {
//                    Image(systemName: "bookmark")
//                    Text("Bookmarks")
//                }
//            SearchView()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Search")
//                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                        .environment(\.symbolVariants, .none)
                    Text("Settings")
                }
        }
    }
}

struct ContentViewPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ElestralData())
    }
}
