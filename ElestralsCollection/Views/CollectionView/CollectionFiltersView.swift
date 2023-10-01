//
//  CollectionFiltersView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 6/10/23.
//

import SwiftUI

struct CollectionFiltersView: View {
    @Binding var filters: Set<CollectionFilterType>
    
    @Environment(\.presentationMode) var presentation
    
    var isSortOrderSectionValid: Bool {
        return filters.contains(.ascending) || filters.contains(.descending)
    }
    
    var body: some View {
        NavigationStack {
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
                        Image(systemName: "arrow.up")
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
                        Image(systemName: "arrow.down")
                        Text("Descending")
                    })
                    .toggleStyle(.checklist)
                    
                }
                
                Section("SORT BY") {
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.releaseDate) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.releaseDate)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.name)
                                self.filters.remove(.artist)
                            } else {
                                self.filters.update(with: .releaseDate)
                            }
                        }
                    ), label: {
                        Image(systemName: "calendar")
                        Text("Release Date")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.name) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.name)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.releaseDate)
                                self.filters.remove(.artist)
                            } else {
                                self.filters.update(with: .name)
                            }
                        }
                    ), label: {
                        Image(systemName: "textformat")
                        Text("Name")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.artist) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.artist)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.releaseDate)
                                self.filters.remove(.name)
                            } else {
                                self.filters.update(with: .artist)
                            }
                        }
                    ), label: {
                        Image(systemName: "pencil.and.outline")
                        Text("Artist")
                    })
                    .toggleStyle(.checklist)
                }
                
                Section("CARD STATE") {
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.both) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.both)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.ownedOnly)
                                self.filters.remove(.moreThan1OwnedOnly)
                                self.filters.remove(.unowned)
                            } else {
                                self.filters.update(with: .both)
                            }
                        }
                    ), label: {
                        Image(systemName: "checkmark.circle")
                        Text("Owned & Not Owned")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.ownedOnly) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.ownedOnly)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.both)
                                self.filters.remove(.moreThan1OwnedOnly)
                                self.filters.remove(.unowned)
                            } else {
                                self.filters.update(with: .ownedOnly)
                            }
                        }
                    ), label: {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Owned Only")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.moreThan1OwnedOnly) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.moreThan1OwnedOnly)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.ownedOnly)
                                self.filters.remove(.both)
                                self.filters.remove(.unowned)
                            } else {
                                self.filters.update(with: .moreThan1OwnedOnly)
                            }
                        }
                    ), label: {
                        Image(systemName: "circlebadge.2.fill")
                        Text("More Than 1 Owned Only")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.unowned) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.unowned)
                                
                                //Remove the other sort by categories
                                self.filters.remove(.ownedOnly)
                                self.filters.remove(.moreThan1OwnedOnly)
                                self.filters.remove(.both)
                            } else {
                                self.filters.update(with: .unowned)
                            }
                        }
                    ), label: {
                        Image(systemName: "x.circle")
                        Text("Not Owned Only")
                    })
                    .toggleStyle(.checklist)
                }
                
                Section(header:
                    HStack {
                        Text("CARD TYPE")
                        Spacer()
                        Button(action: {
                            let allSelected = Set([.elestral, .spirit, .rune]).isSubset(of: filters)
                            if allSelected {
                                filters.subtract(Set([.elestral, .spirit, .rune]))
                            } else {
                                filters.formUnion(Set([.elestral, .spirit, .rune]))
                            }
                        }, label: {
                            Text(Set([.elestral, .spirit, .rune]).isSubset(of: filters) ? "Deselect All" : "Select All")
                                .font(.caption)
                        })
                        .foregroundColor(.blue)
                    }
                ) {
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.elestral) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.elestral)
                            } else {
                                self.filters.remove(.elestral)
                            }
                        }
                    ), label: {
                        Image(systemName: "pawprint.fill")
                        Text("Elestral")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.spirit) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.spirit)
                            } else {
                                self.filters.remove(.spirit)
                            }
                        }
                    ), label: {
                        Image(systemName: "leaf")
                        Text("Spirit")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.rune) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.rune)
                            } else {
                                self.filters.remove(.rune)
                            }
                        }
                    ), label: {
                        Image(systemName: "wand.and.stars.inverse")
                        Text("Rune")
                    })
                    .toggleStyle(.checklist)
                }
                
                if filters.contains(.elestral) || filters.contains(.spirit) {
                    Section(header:
                        HStack {
                            Text("Elestral Element")
                            Spacer()
                            Button(action: {
                                let allSelected = Set([.earth, .fire, .thunder, .water, .wind, .frost, .rainbow]).isSubset(of: filters)
                                if allSelected {
                                    filters.subtract(Set([.earth, .fire, .thunder, .water, .wind, .frost, .rainbow]))
                                } else {
                                    filters.formUnion(Set([.earth, .fire, .thunder, .water, .wind, .frost, .rainbow]))
                                }
                            }, label: {
                                Text(Set([.earth, .fire, .thunder, .water, .wind, .frost, .rainbow]).isSubset(of: filters) ? "Deselect All" : "Select All")
                                    .font(.caption)
                            })
                            .foregroundColor(.blue)
                        }
                    ) {
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.earth) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.earth)
                                } else {
                                    self.filters.remove(.earth)
                                }
                            }
                        ), label: {
                            Image("Earth")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Earth")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.fire) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.fire)
                                } else {
                                    self.filters.remove(.fire)
                                }
                            }
                        ), label: {
                            Image("Fire")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Fire")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.frost) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.frost)
                                } else {
                                    self.filters.remove(.frost)
                                }
                            }
                        ), label: {
                            Image("Frost")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Frost")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.thunder) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.thunder)
                                } else {
                                    self.filters.remove(.thunder)
                                }
                            }
                        ), label: {
                            Image("Thunder")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Thunder")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.water) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.water)
                                } else {
                                    self.filters.remove(.water)
                                }
                            }
                        ), label: {
                            Image("Water")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Water")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.wind) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.wind)
                                } else {
                                    self.filters.remove(.wind)
                                }
                            }
                        ), label: {
                            Image("Wind")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Wind")
                        })
                        .toggleStyle(.checklist)
                        
                        Toggle(isOn: Binding(
                            get: { self.filters.contains(.rainbow) },
                            set: { isOn in
                                if isOn {
                                    self.filters.insert(.rainbow)
                                } else {
                                    self.filters.remove(.rainbow)
                                }
                            }
                        ), label: {
                            Image("Rainbow")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Rainbow")
                        })
                        .toggleStyle(.checklist)
                    }
                }
                
                Section(header:
                    HStack {
                        Text("Rarity")
                        Spacer()
                        Button(action: {
                            let allSelected = Set([.common, .uncommon, .rare, .holoRare, .stellarRare, .alternativeArt, .fullArt]).isSubset(of: filters)
                            if allSelected {
                                filters.subtract(Set([.common, .uncommon, .rare, .holoRare, .stellarRare, .alternativeArt, .fullArt]))
                            } else {
                                filters.formUnion(Set([.common, .uncommon, .rare, .holoRare, .stellarRare, .alternativeArt, .fullArt]))
                            }
                        }, label: {
                            Text(Set([.common, .uncommon, .rare, .holoRare, .stellarRare, .fullArt]).isSubset(of: filters) ? "Deselect All" : "Select All")
                                .font(.caption)
                        })
                        .foregroundColor(.blue)
                    }
                ) {
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.common) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.common)
                            } else {
                                self.filters.remove(.common)
                            }
                        }
                    ), label: {
                        Image(systemName: "circle.fill")
                        Text("Common")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.uncommon) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.uncommon)
                            } else {
                                self.filters.remove(.uncommon)
                            }
                        }
                    ), label: {
                        Image(systemName: "diamond.fill")
                        Text("Uncommon")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.rare) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.rare)
                            } else {
                                self.filters.remove(.rare)
                            }
                        }
                    ), label: {
                        Image(systemName: "star.fill")
                        Text("Rare")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.holoRare) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.holoRare)
                            } else {
                                self.filters.remove(.holoRare)
                            }
                        }
                    ), label: {
                        Image(systemName: "star")
                        Text("Holo Rare")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.stellarRare) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.stellarRare)
                            } else {
                                self.filters.remove(.stellarRare)
                            }
                        }
                    ), label: {
                        Image(systemName: "sparkles")
                        Text("Stellar Rare")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.alternativeArt) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.alternativeArt)
                            } else {
                                self.filters.remove(.alternativeArt)
                            }
                        }
                    ), label: {
                        Image(systemName: "seal")
                        Text("Alternative Art")
                    })
                    .toggleStyle(.checklist)
                    
                    Toggle(isOn: Binding(
                        get: { self.filters.contains(.fullArt) },
                        set: { isOn in
                            if isOn {
                                self.filters.insert(.fullArt)
                            } else {
                                self.filters.remove(.fullArt)
                            }
                        }
                    ), label: {
                        Image(systemName: "seal.fill")
                        Text("Full Art")
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
        self.filters = CollectionFiltersViewModel().defaultsFilters
    }
}

struct CollectionFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionFiltersView(filters: .constant(Set([.ascending, .elestral])))
    }
}

