//
//  InputView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/8/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color.black)
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .padding(.bottom, 0)
            } else {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .padding(.bottom, 0)
            }
            
            Divider()
                .padding(.top, 0)
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
