//
//  ToastView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/27/23.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}


#Preview {
    ToastView(message: "Hello World")
}
