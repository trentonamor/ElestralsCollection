import SwiftUI

struct ElestralsView: View {
    
    @EnvironmentObject var data: ElestralData
    @Environment(\.presentationMode) var presentation
    
    @State var searchText = ""
    @State var presentFilters = false
    @State var currentIndex: Int = 0
    @StateObject var viewModel = CarouselViewModel()
    
    @ObservedObject var filtersViewModel: FiltersViewModel = FiltersViewModel()
    
    public let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale = CGFloat(1)
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x)
        if diff < 100 {
            scale = 1 + (100 - diff) / 500
        }
        
        return scale
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    VStack(spacing: 8) {
//                        SnapCarousel()
//                            .environmentObject(viewModel.stateModel)
//                            .padding(.top)
                        GenericCardView(cardType: .progress)
                            .background(.white)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    
                    // MARK: - Earth
                    GridSection(searchText: $searchText, layout: layout, element: .earth, filters: self.filtersViewModel.filters)
                    
                    // MARK: - Fire
                    GridSection(searchText: $searchText, layout: layout, element: .fire, filters: self.filtersViewModel.filters)
                    
                    // MARK: - Water
                    GridSection(searchText: $searchText, layout: layout, element: .water, filters: self.filtersViewModel.filters)
                    
                    // MARK: - Thunder
                    GridSection(searchText: $searchText, layout: layout, element: .thunder, filters: self.filtersViewModel.filters)
                    
                    // MARK: - Wind
                    GridSection(searchText: $searchText, layout: layout, element: .wind, filters: self.filtersViewModel.filters)
                }
            }
            .padding([.top, .horizontal])
            .searchable(text: $searchText, placement: .automatic, prompt: "Search by Elestral Name")
            .navigationTitle("Elestrals")
            .navigationBarTitleDisplayMode(.automatic)
            .background(Color("backgroundBase"))
            .sheet(isPresented: $presentFilters, content: {
                FiltersView(filters: $filtersViewModel.filters, ownedToggleOn: getState(for: .owned), unownedToggleOn: getState(for: .unowned), bothToggleOn: getState(for: .none), earthToggleOn: getState(for: .earth), fireToggleOn: getState(for: .fire), thunderToggleOn: getState(for: .thunder), waterToggleOn: getState(for: .water), windToggleOn: getState(for: .wind))
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        presentFilters.toggle()
                    }, label: {
                        if filtersViewModel.isDefault() {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .frame(height: 96, alignment: .trailing)
                        } else {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .frame(height: 96, alignment: .trailing)
                        }
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
