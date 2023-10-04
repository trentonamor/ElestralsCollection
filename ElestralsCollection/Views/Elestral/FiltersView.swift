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
    @State var frostToggleOn: Bool
    
    @State var selectAllButtonTitle: String = "Deselect All"
    
    @Environment(\.presentationMode) var presentation

    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    Toggle(isOn: $bothToggleOn, label: {
                        Text("Owned and Unowned")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                            .foregroundStyle(Color(.dynamicGrey80))
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
                            .foregroundStyle(Color(.dynamicGrey80))
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
                }, header: {
                    HStack {
                        Text("State")
                            .foregroundStyle(Color(.dynamicGrey40))
                    }
                })
                .listRowBackground(Color(.backgroundElevated))
                
                Section(content: {
                    Toggle(isOn: $earthToggleOn, label: {
                        Image("Earth")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Earth")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                        Image("Fire")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Fire")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                    
                    Toggle(isOn: $frostToggleOn, label: {
                        Image("Frost")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Frost")
                            .foregroundStyle(Color(.dynamicGrey80))
                    })
                    .toggleStyle(.checklist)
                    .onChange(of: frostToggleOn, perform: {
                        newValue in
                            if newValue {
                                self.filters.insert(.frost)
                            } else {
                                self.filters.remove(.frost)
                            }
                    })
                   
                    Toggle(isOn: $thunderToggleOn, label: {
                        Image("Thunder")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Thunder")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                        Image("Water")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Water")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                        Image("Wind")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Wind")
                            .foregroundStyle(Color(.dynamicGrey80))
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
                            .foregroundStyle(Color(.dynamicGrey40))
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
                                .foregroundStyle(Color(.dynamicUiBlue))
                        })
                    }
                })
                .listRowBackground(Color(.backgroundElevated))
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        self.resetFilters()
                    }, label: {
                        Text("Reset")
                            .foregroundStyle(Color(.dynamicUiBlue))
                    })
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .foregroundStyle(Color(.dynamicUiBlue))
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
        
        self.filters = Set([.none, .fire, .wind, .water, .thunder, .earth, .frost])
    }
    
    func toggleElements(ofValue: Bool) {
        earthToggleOn = ofValue
        fireToggleOn = ofValue
        thunderToggleOn = ofValue
        waterToggleOn = ofValue
        windToggleOn = ofValue
        frostToggleOn = ofValue
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(filters: .constant(Set([.none])), ownedToggleOn: false, unownedToggleOn: false, bothToggleOn: true, earthToggleOn: false, fireToggleOn: false, thunderToggleOn: false, waterToggleOn: false, windToggleOn: false, frostToggleOn: true)
    }
}
