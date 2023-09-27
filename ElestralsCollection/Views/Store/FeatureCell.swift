//
//  FeatureCell.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import SwiftUI

struct FeatureCell: View {
    var imageName: String
    var imageColor: Color
    var featureTitle: String
    var featureDescription: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFill()
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8.0).fill(imageColor))
            
            VStack(alignment: .leading) {
                Text(featureTitle)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(featureDescription)
                    .font(.subheadline)
                    .foregroundStyle(Color(.dynamicGrey20))
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                
        }

    }
}

#Preview {
    FeatureCell(imageName: "atom", imageColor: Color(.dynamicRed), featureTitle: "Experimental Features", featureDescription: "B")
        .background(Color(.dynamicNavy))
        .edgesIgnoringSafeArea(.all)
}
