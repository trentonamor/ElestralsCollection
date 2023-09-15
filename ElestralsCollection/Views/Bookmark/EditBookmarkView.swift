import SwiftUI

struct EditBookmarkView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var navigationTitle: String {
        return (mode == .new) ? "New Bookmark" : "Edit Bookmark"
    }
    
    var actionButtonString: String {
        return (mode == .new) ? "Add Bookmark" : "Edit Bookmark"
    }

    
    @State var name = ""
    @Binding var model: BookmarkModel
    var mode: EditMode = .new
    
    @State var type: BookmarkType
    
    @State var icon: String
    @State var color: Color
    var showDeleteButton: Bool {
        return mode == .edit
    }
    
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
    
    
    init(model: Binding<BookmarkModel>, mode: EditMode) {
        self._model = model
        self.mode = mode
        
        if mode == .edit {
            _name = State(initialValue: model.wrappedValue.name)
            _type = State(initialValue: model.wrappedValue.type)
            _icon = State(initialValue: model.wrappedValue.icon)
            _color = State(initialValue: model.wrappedValue.color)
        } else {
            _name = State(initialValue: "")
            _type = State(initialValue: .standard)
            _icon = State(initialValue: "heart.fill")
            _color = State(initialValue: .blue)
        }
    }

    
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
                            Toggle("", isOn: self.$model.showOwnedIndicator)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: self.color))
                        }
                        .padding(12)
                        .background(.white)
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Show Progress in List")
                            Spacer()
                            Toggle("", isOn: self.$model.showOwnedIndicator)
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
                        dismiss()
                    }, label: {
                        Text(actionButtonString)
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .disabled(name.isEmpty)
                    
                    if self.showDeleteButton {
                        Button(action: {
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
    
    enum EditMode {
        case new
        case edit
    }
