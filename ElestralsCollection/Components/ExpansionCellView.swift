//
//  ExpansionCellView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/16/23.
//

import SwiftUI

struct ExpansionCellView: View {
    let model: ExpansionCellModel
    
    var body: some View {
        HStack {
            Image(model.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            
            Text(model.cellText)
                .fontWeight(.bold)
                .font(.title2)
                .padding(16)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ExpansionCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExpansionCellView(model: ExpansionCellModel(imageName: "base-set", cellText: "Base Set", expansionId: .baseSet, creationDate: Date()))
    }
}
