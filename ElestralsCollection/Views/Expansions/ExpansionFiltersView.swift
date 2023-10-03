import SwiftUI

struct ExpansionFiltersView: View {
    @Binding var filters: Set<ExpansionFilterType>
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sort Order").foregroundStyle(Color(.dynamicGrey40))) {
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.ascending) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.ascending)
                                self.filters.remove(.descending) // Turn off the other toggle
                            } else {
                                self.filters.update(with: .ascending)
                            }
                        }
                    ), label: {
                        Text("Ascending")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.descending) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.descending)
                                self.filters.remove(.ascending) // Turn off the other toggle
                            } else {
                                self.filters.update(with: .descending)
                            }
                        }
                    ), label: {
                        Text("Descending")
                    })
                    .toggleStyle(.checklist)
                }
            }
            .navigationBarTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.resetFilters()
                    }, label: {
                        Text("Reset")
                            .foregroundStyle(Color(.dynamicUiBlue))
                    }),
                trailing: 
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .foregroundStyle(Color(.dynamicUiBlue))
                    })
            )
        }
    }
    
    func resetFilters() {
        self.filters = Set([.descending])
    }
}

struct ExpansionFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ExpansionFiltersView(filters: .constant(Set([.ascending])))
    }
}
