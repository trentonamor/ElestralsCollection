//
//  MinimumRequirementsView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/9/23.
//

import SwiftUI

struct MinimumRequirementsView: View {
    @EnvironmentObject var viewModel: MinimumRequirementsViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Minimum Requirements")
                    .font(.headline)
                    .padding(.bottom, 4)
                RequirementRowView(requirement: "Must contain at least 1 number.", isMet: viewModel.containsNumber)
                RequirementRowView(requirement: "Must contain at least 1 symbol.", isMet: viewModel.containsSymbol)
                RequirementRowView(requirement: "Must contain at least 1 letter.", isMet: viewModel.containsLetter)
                RequirementRowView(requirement: "Must contain at least 10 characters.", isMet: viewModel.containsMinimumCharacters)
            }
            .onReceive(viewModel.$password) { _ in
                viewModel.updateRequirements()
            }
            Spacer()
        }
    }
}

struct RequirementRowView: View {
    let requirement: String
    let isMet: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "x.circle.fill")
                .foregroundColor(isMet ? .green : .red)
            Text(requirement)
        }
    }
}


struct MinimumRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        MinimumRequirementsView()
    }
}
