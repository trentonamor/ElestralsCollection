//
//  LineSeparator.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/1/23.
//

import SwiftUI

struct LineSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1)
            .padding(.horizontal)
    }
}

struct LineSeparator_Previews: PreviewProvider {
    static var previews: some View {
        LineSeparator()
    }
}