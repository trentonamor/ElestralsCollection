//
//  GridSection.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import SwiftUI

struct GridSection: View {
    
    @EnvironmentObject var data: ElestralData
    @Binding var searchText: String
    
    private var elestralsStringList: [String] {
        self.getElementalElestrals(for: element)
    }
    
    public var layout: [GridItem]
    public var element: Element
    public var filters: Set<FilterType>
    
    init(searchText: Binding<String>, layout: [GridItem], element: Element, filters: Set<FilterType>) {
        _searchText = searchText
        self.layout = layout
        self.element = element
        self.filters = filters
    }
    
    var body: some View {
        // MARK: - Earth
        if !self.elestralsStringList.isEmpty {
            HStack {
                Text(self.getTitle(for: element))
                    .font(.headline)
                let owned: Int = self.getNumberOwned(for: element)
                Text("| \(owned) of \(self.elestralsStringList.count)")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding()
        }
        LazyVGrid(columns: layout, spacing: 8) {
            ForEach(elestralsStringList, id: \.self) { elestralName in
                if let elestral = data.elestralsList.first(where: { $0.name.lowercased() == elestralName}) {
                    ElestralsGridItem(elestral: elestral)
                }
            }
        }
    }
}
