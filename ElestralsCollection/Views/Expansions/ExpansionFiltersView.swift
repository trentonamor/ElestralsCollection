import SwiftUI

struct ExpansionFiltersView: View {
    @Binding var filters: Set<ExpansionFilterType>
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sort Order") {
                    
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
                leading: Button("Reset") {
                    resetFilters()
                },
                trailing: Button("Done") {
                    self.presentation.wrappedValue.dismiss()
                }
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
