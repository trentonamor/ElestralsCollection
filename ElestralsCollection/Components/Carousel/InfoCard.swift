//
//  InfoCard.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import SwiftUI

struct InfoCard: View {
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("My Collection")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    Text("Did you know you can select this, or any other stats card, to open \"My collection\"? Use it to see every single card you own and filter or sort it as you desire.")
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .padding(.top, 4)
                }
                VStack(alignment: .center, content: {
                    Button {
                        print("Hello World")
                    } label: {
                        Text("Open My Collection")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                    }
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .controlSize(.regular)
                    .cornerRadius(30)
                    .padding(.horizontal)
                })
            }
        }
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard()
//        Carousel()
    }
}
