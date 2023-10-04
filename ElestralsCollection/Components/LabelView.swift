//
//  LabelView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import SwiftUI

struct LabelView: View {
    let topText: String?
    let mainText: String
    let backgroundColor: Color = Color(.backgroundElevated)
    let alignment: HorizontalAlignment = .leading
    
    var body: some View {
        HStack {
            VStack(alignment: alignment, spacing: 4) {
                if let topText = topText {
                    Text(topText)
                        .font(.subheadline)
                        .foregroundColor(Color(.dynamicGrey40))
                }
                Text(mainText)
                    .font(.body)
                    .foregroundStyle(Color(.dynamicGrey80))
                    .bold()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            Spacer()
        }
        .background(backgroundColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}


