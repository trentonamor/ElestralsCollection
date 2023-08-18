//
//  CollectionView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/9/23.
//

import SwiftUI
import UIKit

struct CollectionView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    @EnvironmentObject var data: CardStore
    
    @State var searchText = ""
    @State var presentFilters = false
    
    @ObservedObject var filtersViewModel: CollectionFiltersViewModel = CollectionFiltersViewModel()
    
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
                LazyVGrid(columns: layout, spacing: 8) {
                    ForEach(data.cards, id: \.self) { card in
                        Text(card.name)
                            .font(.headline)
                            .foregroundColor(.blue) // Set the desired color for the text
                            .padding()
                    }
                }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search by Name, Artist, or Id")
            .navigationTitle("My Collection")
            .navigationBarTitleDisplayMode(.automatic)
            .padding([.top, .horizontal])
            .background(Color("backgroundBase"))
            .sheet(isPresented: $presentFilters, content: {
                CollectionFiltersView(filters: $filtersViewModel.filters)
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
                    .tint(Color.blue)
                })
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
