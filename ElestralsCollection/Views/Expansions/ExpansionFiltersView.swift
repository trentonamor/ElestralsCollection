import SwiftUI

struct ExpansionFiltersView: View {
    @Binding var filters: Set<ExpansionFilterType>
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sort Order") {
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.Ascending) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.Ascending)
                                self.filters.remove(.Descending) // Turn off the other toggle
                            } else {
                                self.filters.remove(.Ascending)
                            }
                        }
                    ), label: {
                        Text("Ascending")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.Descending) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.Descending)
                                self.filters.remove(.Ascending) // Turn off the other toggle
                            } else {
                                self.filters.remove(.Descending)
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
                leading: Button("Reset") {
                    resetFilters()
                },
                trailing: Button("Done") {
                    print(self.filters)
                    self.presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func resetFilters() {
        self.filters = Set([.Descending])
    }
}

struct ExpansionFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ExpansionFiltersView(filters: .constant(Set([.Ascending])))
    }
}
