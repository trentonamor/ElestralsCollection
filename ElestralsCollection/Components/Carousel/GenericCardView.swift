//
//  GenericCardView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/1/22.
//

import SwiftUI
import Charts

struct GenericCardView: View {
    @ObservedObject var data: CardStore
    
    var cardType: CardType
    var body: some View {
        switch cardType {
        case .progress:
            ProgressCard(cardViewModel: CardModel(cardType: .progress, cardList: data.getElestralsList()))
        case .distribution:
            DistributionCard(entries: [
                PieChartDataEntry(value: 7, label: "Earth"),
                PieChartDataEntry(value: 8, label: "Fire"),
                PieChartDataEntry(value: 3, label: "Wind"),
                PieChartDataEntry(value: 2, label: "Thunder"),
                PieChartDataEntry(value: 10, label: "Water"),
                PieChartDataEntry(value: 11, label: "Foot"),
            ])
        case .info:
            InfoCard()
        default:
            InfoCard()
        }
    }
}

//struct GenericCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericCardView( cardType: .distribution)
//            .environmentObject(ElestralData())
//    }
//}
