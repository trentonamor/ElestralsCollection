//
//  ProgressCircle.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/1/22.
//

import SwiftUI

struct ProgressCircle: View {
    @Binding var progressValue: Float

    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .percent
        return formatter
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color(.dynamicUiBlue))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progressValue, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(.dynamicUiBlue))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear)
            

            Text(formatter.string(for: min(self.progressValue, 1.0)) ?? "0%")
                .foregroundStyle(Color(.dynamicGrey80))
        }
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCard(cardViewModel: CardModel(cardType: .progress))
    }
}
