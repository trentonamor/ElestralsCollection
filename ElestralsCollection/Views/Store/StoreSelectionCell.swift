//
//  StoreSelectionCell.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import SwiftUI

struct StoreSelectionCell: View {
    var cellTitle: String
    var cost: Double
    var color: Color {
        return isSelected ? Color(.dynamicUiBlue) : Color(.dynamicNavy)
    }
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(cellTitle)
                .foregroundStyle(Color(.dynamicGrey0))
            Spacer()
            Text("$\(cost.formatted(.currency(code: "en_US")))")
                .foregroundStyle(Color(.dynamicGrey0))
        }
        .padding(16)
        .background(color)
        .cornerRadius(12)
        .shadow(color: Color(.dynamicGrey0), radius: 5)
    }
}

#Preview {
    StoreSelectionCell(cellTitle: "Monthly Plan", cost: 3.99, isSelected: true)
}
