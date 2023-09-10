//
//  DistributionCard.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import SwiftUI
import DGCharts

struct GraphItem: Identifiable {
    var id = UUID()
    var xValue: String
    var yValue: Float
    var color: Color
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }
}

struct DistributionCard: UIViewRepresentable {
    let title: String = "Distribution by kind"
    let entries: [PieChartDataEntry]
    let pieView = PieChartView()
    func makeUIView(context: Context) -> DGCharts.PieChartView {
        return pieView
    }
    
    func updateUIView(_ uiView: DGCharts.PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.label = ""
        uiView.noDataText = "No Data Available"
        uiView.data = PieChartData(dataSet: dataSet)
        uiView.centerText = title
        uiView.legend.enabled = false
        
        formatDataSet(dataSet: dataSet)
    }
    
    func formatDataSet(dataSet: PieChartDataSet) {
        dataSet.colors = ChartColorTemplates.material()
        dataSet.sliceSpace = 4
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    class coordinator: NSObject, ChartViewDelegate {
        
    }
}

struct DistributionCard_Previews: PreviewProvider {
    static var previews: some View {
        DistributionCard(entries: [
            PieChartDataEntry(value: 7, label: "Earth"),
            PieChartDataEntry(value: 8, label: "Fire"),
            PieChartDataEntry(value: 3, label: "Wind"),
            PieChartDataEntry(value: 2, label: "Thunder"),
            PieChartDataEntry(value: 10, label: "Water"),
            PieChartDataEntry(value: 11, label: "Foot"),
        ])
    }
}
