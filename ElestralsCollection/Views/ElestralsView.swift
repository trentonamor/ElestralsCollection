import SwiftUI

struct ElestralsView: View {

    @EnvironmentObject var data: ElestralData
    @Environment(\.presentationMode) var presentation
    
    @State var searchText = ""
    @State var filters: [String] = []
    @State var presentFilters = false
    
    @ObservedObject var filtersViewModel: FiltersViewModel = FiltersViewModel()
    
    var earthElestrals: [String] {
        let earth = data.elestralsList.filter {
            $0.element == .earth
        }
        let lcElestrals = earth.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    var fireElestrals: [String] {
        let fire = data.elestralsList.filter {
            $0.element == .fire
        }
        let lcElestrals = fire.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    var thunderElestrals: [String] {
        let thunder = data.elestralsList.filter {
            $0.element == .thunder
        }
        let lcElestrals = thunder.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    var waterElestrals: [String] {
        let water = data.elestralsList.filter {
            $0.element == .water
        }
        let lcElestrals = water.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    var windElestrals: [String] {
        let wind = data.elestralsList.filter {
            $0.element == .wind
        }
        let lcElestrals = wind.map {
            $0.name.lowercased()
        }.sorted()
        return searchText == "" ? lcElestrals :
        lcElestrals.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
                ScrollView {
                    // MARK: - Earth
                    if !self.earthElestrals.isEmpty {
                        HStack {
                            Text("Earth")
                                .font(.headline)
                            let owned: Int = self.getNumberOwned(for: .earth)
                            Text("| \(owned) of \(self.earthElestrals.count)")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    }
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(earthElestrals, id: \.self) { elestralName in
                            if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                                ElestralsGridItem(elestral: elestral)
                            }
                        }
                    }
                    
                    // MARK: - Fire
                    if !self.fireElestrals.isEmpty {
                        HStack {
                            Text("Fire")
                                .font(.headline)
                            let owned: Int = self.getNumberOwned(for: .fire)
                            Text("| \(owned) of \(self.fireElestrals.count)")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    }
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(fireElestrals, id: \.self) { elestralName in
                            if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                                ElestralsGridItem(elestral: elestral)
                            }
                        }
                    }
                    
                    // MARK: - Water
                    if !self.waterElestrals.isEmpty {
                        HStack {
                            Text("Water")
                                .font(.headline)
                            let owned: Int = self.getNumberOwned(for: .water)
                            Text("| \(owned) of \(self.waterElestrals.count)")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    }
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(waterElestrals, id: \.self) { elestralName in
                            if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                                ElestralsGridItem(elestral: elestral)
                            }
                        }
                    }
                    
                    // MARK: - Thunder
                    if !self.thunderElestrals.isEmpty {
                        HStack {
                            Text("Thunder")
                                .font(.headline)
                            let owned: Int = self.getNumberOwned(for: .thunder)
                            Text("| \(owned) of \(self.thunderElestrals.count)")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    }
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(thunderElestrals, id: \.self) { elestralName in
                            if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                                ElestralsGridItem(elestral: elestral)
                            }
                        }
                    }
                    
                    // MARK: - Wind
                    if !self.windElestrals.isEmpty {
                        HStack {
                            Text("Wind")
                                .font(.headline)
                            let owned: Int = self.getNumberOwned(for: .wind)
                            Text("| \(owned) of \(self.windElestrals.count)")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    }
                    LazyVGrid(columns: layout, spacing: 8) {
                        ForEach(windElestrals, id: \.self) { elestralName in
                            if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                                ElestralsGridItem(elestral: elestral)
                            }
                        }
                    }
                }
                .padding([.top, .horizontal])
                .searchable(text: $searchText, placement: .automatic, prompt: "Search by Elestral Name")
                .navigationTitle("Elestrals")
                .background(Color("backgroundBase"))
                .sheet(isPresented: $presentFilters, content: {
                    FiltersView(filters: $filtersViewModel.filters, ownedToggleOn: getState(for: .owned), unownedToggleOn: getState(for: .unowned), bothToggleOn: getState(for: .none), earthToggleOn: getState(for: .earth), fireToggleOn: getState(for: .fire), thunderToggleOn: getState(for: .thunder), waterToggleOn: getState(for: .water), windToggleOn: getState(for: .wind))
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            presentFilters.toggle()
                        }, label: {
                            if filters.isEmpty {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .frame(height: 96, alignment: .trailing)
                            } else {
                                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                    .frame(height: 96, alignment: .trailing)
                            }
                        })
                    })
                    
                    ToolbarItem(content: {
                        Button(action: {
                            print(self.filtersViewModel.filters)
                        }, label: {
                            Text("Check Filters")
                                .frame(height: 96, alignment: .trailing)
                        })
                    })
                }
        }
    }
}

struct ElestralsViewPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ElestralData())
    }
}
