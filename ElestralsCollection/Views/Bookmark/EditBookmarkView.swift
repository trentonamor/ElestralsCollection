import SwiftUI

struct EditBookmarkView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var navigationTitle: String {
        return (mode == .new) ? "New Bookmark" : "Edit Bookmark"
    }
    
    var actionButtonString: String {
        return (mode == .new) ? "Add Bookmark" : "Edit Bookmark"
    }
    
    var delegate: EditBookmarkViewDelegate?

    
    @State var name = ""
    var model: BookmarkModel
    var mode: EditMode = .new
    
    @State var type: BookmarkType
    @State var showOwnedIndicator: Bool = true
    @State var showProgressIndicator: Bool = true
    
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
        Color(.dynamicRed), Color(.dynamicPink), Color(.dynamicOrange), Color(.dynamicYellow), Color(.dynamicLime), Color(.dynamicGreen), Color(.dynamicGreenBlue), Color(.dynamicGreenCyan), Color(.dynamicCyanBlue), Color(.dynamicBlue), Color(.dynamicNavy), Color(.dynamicPurple), Color(.dynamicGrey100), Color(.dynamicGrey40)
    ]
    
    
    init(model: BookmarkModel, delegate: EditBookmarkViewDelegate) {
        self.model = model
        self.delegate = delegate
        self.mode = self.model.name.isEmpty ? .new : .edit
        
        if mode == .edit {
            _name = State(initialValue: model.name)
            _type = State(initialValue: model.type)
            _icon = State(initialValue: model.icon)
            _color = State(initialValue: model.color)
            _showOwnedIndicator =  State(initialValue: model.showOwnedIndicator)
            _showProgressIndicator =  State(initialValue: model.showProgres)
        } else {
            _name = State(initialValue: "")
            _type = State(initialValue: .standard)
            _icon = State(initialValue: "heart.fill")
            _color = State(initialValue: Color(.dynamicBlue))
        }
    }
    
    func onSaveButtonPressed() {
        delegate?.saveBookmark(self.model)
    }

    func onDeleteButtonPressed() {
        delegate?.deleteBookmark(self.model)
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .foregroundStyle(Color(.dynamicGrey80))
                            .bold()
                        TextField("Name", text: $name, prompt: Text("ex) Whishlist, Burn Deck, Stellar Rares").foregroundColor(Color(.dynamicGrey40)))
                            .foregroundStyle(Color(.dynamicGrey80))
                            .padding(.all, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color(.backgroundElevated), lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.backgroundElevated)))
                            )
                        
                    }
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Settings")
                            .foregroundStyle(Color(.dynamicGrey80))
                            .bold()
                        HStack {
                            Text("Type")
                                .foregroundStyle(Color(.dynamicGrey80))
                            Spacer()
                            Menu(content: {
                                
                                Button(action: {
                                    self.type = .standard
                                    self.model.type = .standard
                                }, label: {
                                    Text("Standard")
                                })
                                /*
                                Button(action: {
                                    self.type = .smart
                                    self.model.type = .smart
                                }, label: {
                                    Text("Smart")
                                })
                                 */
                                 
                                Button(action: {
                                    self.type = .deck
                                    self.model.type = .deck
                                    self.showOwnedIndicator = false
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
                        .background(Color(.backgroundElevated))
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Show Owned Indicator")
                                .foregroundStyle(Color(.dynamicGrey80))
                            Spacer()
                            Toggle("", isOn: self.$showOwnedIndicator)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: self.color))
                                .disabled(self.type == .deck)
                        }
                        .padding(12)
                        .background(Color(.backgroundElevated))
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Show Progress in List")
                                .foregroundStyle(Color(.dynamicGrey80))
                            Spacer()
                            Toggle("", isOn: self.$showProgressIndicator)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: self.color))
                        }
                        .padding(12)
                        .background(Color(.backgroundElevated))
                        .cornerRadius(10)
                    })
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("Icon")
                            .bold()
                            .foregroundStyle(Color(.dynamicGrey80))
                        let columns = Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 70), spacing: 8), count: 1)
                        
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 24, idealWidth: 24, minHeight: 24, idealHeight: 24)
                                        .padding()
                                        .foregroundColor(self.icon == icon ? self.color : Color(.dynamicGrey60))
                                        .background(self.icon == icon ? self.color.opacity(0.2) : Color(.backgroundElevated))
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
                            .foregroundStyle(Color(.dynamicGrey80))
                            .bold()
                        
                        let columns = Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 70), spacing: 8), count: 1)
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(colors, id: \.self) { currentColor in
                                    ZStack {
                                        Circle()
                                            .fill(currentColor)
                                            .frame(width: 24, height: 24)
                                    }
                                    .padding()
                                    .background(self.color == currentColor ? self.color.opacity(0.2) : Color(.backgroundElevated))
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
            .background(Color(.backgroundBase))
            VStack {
                
                VStack {
                    Button(action: {
                        model.name = name
                        model.showProgres = self.showProgressIndicator
                        model.showOwnedIndicator = self.showOwnedIndicator
                        self.delegate?.saveBookmark(model)
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
                            self.delegate?.deleteBookmark(model)
                            dismiss()
                        }, label: {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(.dynamicRed))
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
