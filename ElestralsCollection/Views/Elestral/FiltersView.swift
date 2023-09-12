//
//  FiltersView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 11/30/22.
//

import SwiftUI

struct FiltersView: View {
    @Binding var filters: Set<FilterType>
    
    @State var ownedToggleOn: Bool
    @State var unownedToggleOn: Bool
    @State var bothToggleOn: Bool
    
    @State var earthToggleOn: Bool
    @State var fireToggleOn: Bool
    @State var thunderToggleOn: Bool
    @State var waterToggleOn: Bool
    @State var windToggleOn: Bool
    
    @State var selectAllButtonTitle: String = "Deselect All"
    
    @Environment(\.presentationMode) var presentation

    var body: some View {
        NavigationStack {
            Form {
                Section("State") {
                    Toggle(isOn: $bothToggleOn, label: {
                        Text("Owned and Unowned")
                    })
                    .onChange(of: bothToggleOn, perform: {
                        newValue in
                        if newValue {
                            self.ownedToggleOn = false
                            self.unownedToggleOn = false
                        }
                        
                        if newValue {
                            self.filters.insert(.none)
                        } else {
                            self.filters.remove(.none)
                        }
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: $ownedToggleOn, label: {
                        Text("Owned Only")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: ownedToggleOn, perform: { newValue in
                        if newValue {
                            self.unownedToggleOn = false
                            self.bothToggleOn = false
                        } else if !newValue && !unownedToggleOn {
                            self.bothToggleOn = true
                        }
                        
                        if newValue {
                            self.filters.insert(.owned)
                        } else {
                            self.filters.remove(.owned)
                        }
                    })
                    
                    Toggle(isOn: $unownedToggleOn, label: {
                        Text("Unowned Only")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: unownedToggleOn, perform: { newValue in
                        if newValue {
                            self.ownedToggleOn = false
                            self.bothToggleOn = false
                        } else if !newValue && !ownedToggleOn {
                            self.bothToggleOn = true
                        }
                        
                        if newValue {
                            self.filters.insert(.unowned)
                        } else {
                            self.filters.remove(.unowned)
                        }
                    })
                }
                
                Section(content: {
                    Toggle(isOn: $earthToggleOn, label: {
                        Text("Earth")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: earthToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.earth)
                            } else {
                                self.filters.remove(.earth)
                            }
                    })

                    Toggle(isOn: $fireToggleOn, label: {
                        Text("Fire")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: fireToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.fire)
                            } else {
                                self.filters.remove(.fire)
                            }
                    })
                   
                    Toggle(isOn: $thunderToggleOn, label: {
                        Text("Thunder")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: thunderToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.thunder)
                            } else {
                                self.filters.remove(.thunder)
                            }
                    })
                    
                    Toggle(isOn: $waterToggleOn, label: {
                        Text("Water")
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: waterToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.water)
                            } else {
                                self.filters.remove(.water)
                            }
                    })
                    
                    Toggle(isOn: $windToggleOn, label: {
                        Text("Wind")
                            .foregroundColor(.black)
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: windToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.wind)
                            } else {
                                self.filters.remove(.wind)
                            }
                    })
                }, header: {
                    HStack {
                        Text("Element")
                        Spacer()
                        Button(action: {
                            if selectAllButtonTitle == "Select All" {
                                self.selectAllButtonTitle = "Deselect All"
                                self.toggleElements(ofValue: true)
                            } else {
                                self.selectAllButtonTitle = "Select All"
                                self.toggleElements(ofValue: false)
                            }
                        }, label: {
                            Text(selectAllButtonTitle)
                                .font(.caption)
                        })
                    }
                })
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button("Reset", action: {
                        resetFilters()
                    })
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Done", action: {
                        self.presentation.wrappedValue.dismiss()
                    })
                })
            }
        }
    }
    
    func resetFilters() {
        ownedToggleOn = false
        unownedToggleOn = false
        bothToggleOn = true
        
        self.toggleElements(ofValue: true)
        
        self.filters = Set([.none, .fire, .wind, .water, .thunder, .earth])
    }
    
    func toggleElements(ofValue: Bool) {
        earthToggleOn = ofValue
        fireToggleOn = ofValue
        thunderToggleOn = ofValue
        waterToggleOn = ofValue
        windToggleOn = ofValue
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(filters: .constant(Set([.none])), ownedToggleOn: false, unownedToggleOn: false, bothToggleOn: true, earthToggleOn: false, fireToggleOn: false, thunderToggleOn: false, waterToggleOn: false, windToggleOn: false)
    }
}
