//
//  EditBookmarkView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/13/23.
//

import SwiftUI

struct EditBookmarkView: View {
    @Environment(\.dismiss) var dismiss
    
    let navigationTitle = "New Bookmark Folder"
    @State var name = ""
    @Binding var model: BookmarkModel
    
    @State var type: BookmarkType = .standard
    @State var showOwnedIndicator: Bool = true
    @State var showProgres: Bool = true
    
    @State var icon: String = "heart.fill"
    @State var color: Color = .blue
    let showDeleteButton = false
    
    let icons: [String] = [
            "heart.fill", "star.fill", "sparkles", "hand.thumbsup.fill", "face.smiling.inverse", "tag.fill", "trash.fill",
            "folder.fill", "archivebox.fill", "shippingbox.fill", "book.closed.fill", "leaf.fill", "flame.fill",
            "drop.fill", "bolt.fill", "wind", "snowflake", "checkmark.seal.fill", "target",
            "suit.club.fill", "suit.spade.fill", "suit.diamond.fill", "diamond.fill", "triangle.fill", "circle.fill", "signature",
            "cart.fill", "gift.fill", "square.stack.3d.up.fill", "dollarsign.circle.fill", "person.fill"
        ]
    
    let colors: [Color] = [
        .red, .pink, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .brown, .black, .gray
        ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .bold()
                        TextField("Name", text: $name, prompt: Text("ex) Whishlist, Burn Deck, Stellar Rares"))
                            .padding(.all, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.white, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            )

                    }
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Settings")
                            .bold()
                        HStack {
                            Text("Type")
                            Spacer()
                            Menu(content: {
                                Button(action: {
                                    self.type = .standard
                                    self.model.type = .standard
                                }, label: {
                                    Text("Standard")
                                })
                                Button(action: {
                                    self.type = .smart
                                    self.model.type = .smart
                                }, label: {
                                    Text("Smart")
                                })
                                Button(action: {
                                    self.type = .deck
                                    self.model.type = .deck
                                }, label: {
                                    Text("Deck")
                                })
                            }, label: {
                                Text(self.type.rawValue)
                                    .bold()
                                    .foregroundColor(self.color)
                            })
                            .menuStyle(.automatic)
                        }
                        .padding(12)
                        .background(.white)
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Show Owned Indicator")
                            Spacer()
                            Toggle("", isOn: self.$showOwnedIndicator)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: self.color))
                        }
                        .padding(12)
                        .background(.white)
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Show Progress in List")
                            Spacer()
                            Toggle("", isOn: self.$showProgres)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: self.color))
                        }
                        .padding(12)
                        .background(.white)
                        .cornerRadius(10)
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Icon")
                            .bold()
                        let columns = Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 70), spacing: 8), count: 1)


                               ScrollView {
                                   LazyVGrid(columns: columns, spacing: 8) {
                                       ForEach(icons, id: \.self) { icon in
                                           Image(systemName: icon)
                                               .resizable()
                                               .scaledToFit()
                                               .frame(minWidth: 24, idealWidth: 24, minHeight: 24, idealHeight: 24)
                                               .padding()
                                               .foregroundColor(self.icon == icon ? self.color : Color.gray)
                                               .background(self.icon == icon ? self.color.opacity(0.2) : Color.white)
                                               .cornerRadius(8)
                                               .onTapGesture {
                                                   self.icon = icon
                                                   self.model.icon = icon
                                               }
                                       }
                                   }
                               }
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                            Text("Color")
                                .bold()
                            
                            let columns = Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 70), spacing: 8), count: 1)
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 8) {
                                            ForEach(colors, id: \.self) { currentColor in
                                                ZStack {
                                                    Color.white
                                                        .cornerRadius(8)
                                                    Circle()
                                                        .fill(currentColor)
                                                        .frame(width: 24, height: 24)
                                                }
                                                .padding()
                                                .background(self.color == currentColor ? self.color.opacity(0.2) : Color.white)
                                                .cornerRadius(8)
                                                .onTapGesture {
                                                    self.color = currentColor
                                                    self.model.color = currentColor
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8).stroke(self.color == currentColor ? self.color : Color.clear, lineWidth: 2)
                                                )
                                            }
                                        }
                            }
                        })
                }
                .padding()
                
            }
            .navigationTitle(navigationTitle)
            .background(Color("backgroundBase"))
            VStack {
                    
                    VStack {
                        Button(action: {
                            model.name = name
                            model.isSaved = true
                            dismiss()
                        }, label: {
                            Text("Add Bookmark")
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .disabled(name.isEmpty)
                        
                        if self.showDeleteButton {
                            Button(action: {
                                model.isSaved = false
                                dismiss()
                            }, label: {
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color.red)
                            })
                            .padding(.horizontal)
                        }
                    }
                }
            .padding(.vertical, 8)

        }
    }
}

struct EditBookmarkView_Previews: PreviewProvider {
    @State static var mockModel = BookmarkModel(cards: [], name: "", type: .standard, showOwnedIndicator: true, showProgres: true, icon: "heart.fill", color: .blue)

    static var previews: some View {
        EditBookmarkView(model: $mockModel)
    }
}

