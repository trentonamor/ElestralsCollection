//
//  CollectionTabView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/12/23.
//

import SwiftUI

struct CollectionTabView: View {
    @State private var selectedSegment: CollectionSegment = .normal
    @EnvironmentObject var cardStore: CardStore

    var body: some View {
        VStack {
            // Switch views based on the selected segment
            switch selectedSegment {
            case .normal:
                CollectionView(subset: self.cardStore.getCards(for: true), showOwnedIndicator: false, showNumberOwned: true)
            case .bookmarks:
                BookmarkView(isViewOnly: false)
            }
            
            Picker("Collection Segment", selection: $selectedSegment) {
                ForEach(CollectionSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                        .foregroundStyle(Color(.backgroundTabBar))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .background(Color(.backgroundCard))
        .onAppear(perform: {
            UISegmentedControl.appearance().backgroundColor = UIColor(Color(.backgroundRecessed))
        })
    }
}

struct CollectionTabView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionTabView()
    }
}
