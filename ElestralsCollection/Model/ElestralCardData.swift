//
//  ElestralCardData.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 5/20/23.
//

import Foundation
import SwiftUI

class ElestralCard : ObservableObject {
    @Published var name: String
    @Published var effect: String
    @Published var elements: [Element]
    @Published var subclasses: [Subclass]
    @Published var attack: Int?
    @Published var defense: Int?
    @Published var artist: String
    @Published var cardSet: ExpansionId
    @Published var cardNumber: String
    @Published var editions: [Edition]
    @Published var rarity: Rarity
    var art: String {
        guard UIImage(named: cardNumber) != nil else { return "" }
        return cardNumber
    }
    
    var numberOwned: Int {
        return 0
    }
    
    init(name: String, effect: String, elements: [Element], subclasses: [Subclass], attack: Int?, defense: Int?, artist: String, cardSet: ExpansionId, cardNumber: String, editions: [Edition], rarity: Rarity) {
        self.name = name
        self.effect = effect
        self.elements = elements
        self.subclasses = subclasses
        self.attack = attack
        self.defense = defense
        self.artist = artist
        self.cardSet = cardSet
        self.cardNumber = cardNumber
        self.editions = editions
        self.rarity = rarity
    }
}

enum Rarity : Int {
    case fullArt = 0
    case common = 1
    case rare = 2
    case uncommon = 3
    case holoRare = 4
    case stellarRare = 5
}

enum Subclass: Int {
    case dragon = 0
    case eldritch = 1
    case insectoid = 2
    case golem = 3
    case oceanic = 4
    case ethereal = 5
    case archaic = 6
    case brute = 7
    case dryad = 8
    case behemoth = 9
    case aquatic = 10
    case ursa = 11
}

enum Edition : Int {
    case prototype = 0
    case founders = 1
}
                                                                

class ElestralCardData: ObservableObject {
    @Published var cardList: [ElestralCard] = [
        ElestralCard(name: "Penterror", effect: "When this Penterror is destroyed by an opponent's card effect you can Special Cast any number of Hydrake and Twindra from your hand or deck in Attack Position", elements: [.wind, .wind, .wind], subclasses: [.dragon, .eldritch], attack: 15, defense: 8, artist: "Diego Monster", cardSet: .baseSet, cardNumber: "BS1-000", editions: [.prototype, .founders], rarity: .fullArt),
        ElestralCard(name: "Teratlas", effect: "Earth Spirit", elements: [.earth], subclasses: [.insectoid, .golem], attack: nil, defense: nil, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-001", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Vipyro", effect: "Fire Spirit", elements: [.fire], subclasses: [.dragon, .eldritch], attack: nil, defense: nil, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-002", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Leviaphin", effect: "Water Spirit", elements: [.water], subclasses: [.oceanic, .ethereal], attack: nil, defense: nil, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-003", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Zaptor", effect: "Thunder Spirit", elements: [.thunder], subclasses: [.archaic, .dragon], attack: nil, defense: nil, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-004", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Lycarus", effect: "Wind Spirit", elements: [.wind], subclasses: [.brute, .ethereal], attack: nil, defense: nil, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-005", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Drataya", effect: "When a player Casts Ambrosia you can draw 2 cards.", elements: [.earth], subclasses: [.dryad, .dragon], attack: 2, defense: 4, artist: "Zeta Strokes", cardSet: .baseSet, cardNumber: "BS1-006", editions: [.prototype,.founders], rarity: .common),
        ElestralCard(name: "Ladogon", effect: "When a player Casts Ambrosia or Golden Apple of Discord you can target and destroy a card.", elements: [.earth, .earth], subclasses: [.dryad, .dragon], attack: 7, defense: 8, artist: "Zeta Strokes", cardSet: .baseSet, cardNumber: "BS1-007", editions: [.prototype, .founders], rarity: .rare),
        ElestralCard(name: "Rummagem", effect: "When you Normal Cast this Rummagem you can Search your deck for an Elestral with Enchantment Cost (earth) and add it to your hand.", elements: [.earth], subclasses: [.golem, .brute], attack: 2, defense: 3, artist: "Giovanni Aguilar", cardSet: .baseSet, cardNumber: "BS1-008", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Scavagem", effect: "When you Ascend into the Scavagem you can Expend (earth) in order to Search your deck for up to 2 cards with Enchantment Cost (earth) or (two earth) and add them to your hand.", elements: [.earth, .earth], subclasses: [.golem, .behemoth], attack: 4, defense: 6, artist: "Giovanni Aguilar", cardSet: .baseSet, cardNumber: "BS1-009", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Spinymph", effect: "When this Spinymph is destroyed in battle you can Cast it as an Artifact Empowering the Elestral that destroyed it with the effect \"The Empowered Elestral has 0 base (attack)\"", elements: [.earth], subclasses: [.insectoid], attack: 1, defense: 5, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-010", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Spinosect", effect: "This Spinosect can attack in Defense Position. If it does, use its (defense) for calculations", elements: [.earth, .wind], subclasses: [.insectoid, .eldritch], attack: 1, defense: 9, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-011", editions: [.prototype, .founders], rarity: .holoRare),
        ElestralCard(name: "Clovie", effect: "When this Clovie recieves 1 or more (earth) you can draw a card.", elements: [.earth], subclasses: [.archaic, .dryad], attack: 1, defense: 4, artist: "Phoebe Sumner-Twisk", cardSet: .baseSet, cardNumber: "BS1-012", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Sakurasaur", effect: "You can Expend (earth) in order to draw 2 cards.", elements: [.earth, .earth], subclasses: [.archaic, .dryad], attack: 6, defense: 8, artist: "Phoebe Sumner-Twisk", cardSet: .baseSet, cardNumber: "BS1-013", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Tectaurus", effect: "This Tectaurus gets +1 for each Enchanting (earth) on the field", elements: [.earth], subclasses: [.golem, .behemoth], attack: 3, defense: 2, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-014", editions: [.prototype, .founders], rarity: .rare),
        ElestralCard(name: "Barabog", effect: "When an opponent Casts an Elestral or Rune without (earth) or (water) they must Expend (spirit)", elements: [.earth, .water], subclasses: [.aquatic, .dryad], attack: 3, defense: 7, artist: "Daniel Reyes", cardSet: .baseSet, cardNumber: "BS1-015", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Titanostalk", effect: "You can Expend (earth) in order to force an opponent to reveal their hand until the End Phase", elements: [.earth], subclasses: [.archaic, .dryad], attack: 1, defense: 4, artist: "Victor Rosales", cardSet: .baseSet, cardNumber: "BS1-016", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Equilynx", effect: "You can Nexus up to (two earth). When you do, you can target and destroy a Rune.", elements: [.earth], subclasses: [.dryad], attack: 4, defense: 3, artist: "Amalry", cardSet: .baseSet, cardNumber: "BS1-017", editions: [.prototype, .founders], rarity: .rare),
        ElestralCard(name: "Vysceris", effect: "This Vysceris gains +1 (attack) for each Vysceris on the field. When the Vysceris destroys and Elestral in battle you can Special Cast a Vysceris from your hand or deck in Defense Position.", elements: [.earth], subclasses: [.insectoid], attack: 4, defense: 2, artist: "Marcel Romo", cardSet: .baseSet, cardNumber: "BS1-018", editions: [.prototype, .founders], rarity: .holoRare),
        ElestralCard(name: "Pandicine", effect: "You can Disenchant (earth) from this Pandicine in order to return an Invoke Rune from your Underworld to your hand.", elements: [.earth], subclasses: [.brute], attack: 1, defense: 4, artist: "Giovanni Aguilar", cardSet: .baseSet, cardNumber: "BS1-019", editions: [.prototype, .founders], rarity: .holoRare),
        ElestralCard(name: "Necruff", effect: "When this Necruff destroys an opponent's Elestral in battle that opponent must Expand (spirit).", elements: [.fire], subclasses: [.eldritch, .brute], attack: 5, defense: 1, artist: "Jonny De Oliviera", cardSet: .baseSet, cardNumber: "BS1-020", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Blazerus", effect: "This Blazerus can attack twice during your Battle Phase. When this Blazerus destroys 2 Elestrals in the same Battle Phase you can Special Ascend this Blazerus to Trifernal from your hand or deck.", elements: [.fire, .fire], subclasses: [.eldritch, .behemoth], attack: 7, defense: 2, artist: "Jonny De Oliviera", cardSet: .baseSet, cardNumber: "BS1-021", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Trifernal", effect: "When an opponent Casts an Elestral you can Expend (fire) in order to give it -3 (defense) until your next End Phase. If that Elestral's (defense) is reduced to 0 by this effect, it is destroyed.", elements: [.fire, .fire, .fire], subclasses: [.eldritch, .behemoth], attack: 14, defense: 3, artist: "Jonny De Oliviera", cardSet: .baseSet, cardNumber: "BS1-022", editions: [.prototype, .founders], rarity: .rare),
        ElestralCard(name: "Urscout", effect: "When this Urscout is destroyed in battle you can Special Cast an (ursa) that costs 1 Spirit from your hand or deck.", elements: [.fire], subclasses: [.ursa], attack: 1, defense: 3, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-023", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Ursmog", effect: "You can Expend (fire) in order to Special Cast an (ursa) Elestral that costs 1 Spirit from your hand.", elements: [.fire], subclasses: [.ursa], attack: 2, defense: 3, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-024", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Ursear", effect: "When this Ursear destroys an Elestral in battle you can Special Cast an (ursa) Elestral that costs 1 Spirit from your hand or deck.", elements: [.fire], subclasses: [.ursa], attack: 3, defense: 1, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-025", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Majursa", effect: "This Majursa gets +2 (attack) for each other (ursa) Elestral on your field. Your (ursa) Elestrals that cost 1 Spirit cannot be attacked and cannot be targeted by an opponent's card effect.", elements: [.fire, .fire, .fire], subclasses: [.ursa], attack: 12, defense: 12, artist: "Daniel Mosby", cardSet: .baseSet, cardNumber: "BS1-026", editions: [.prototype, .founders], rarity: .rare),
        ElestralCard(name: "Ignectar", effect: "When you Normal Cast this Ignetar you can Special Cast up to 2 Ignectar from your hand or deck in Attack Position with (fire). If you do you must skip your next Battle Phase.", elements: [.fire], subclasses: [.insectoid], attack: 1, defense: 2, artist: "Dragonith", cardSet: .baseSet, cardNumber: "BS1-027", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Waspyre", effect: "You can Disenchant (fire) from an Ignectar or Waspyre to force an opponent to Expend (two spirits). This Waspyre's effect can be activated any number of times on your turn.", elements: [.fire, .fire], subclasses: [.insectoid, .eldritch], attack: 5, defense: 1, artist: "Dragonith", cardSet: .baseSet, cardNumber: "BS1-028", editions: [.prototype, .founders], rarity: .uncommon),
        ElestralCard(name: "Warmite", effect: "You can target an opponet's Elestral and give it -4 (attack) until the End Phase", elements: [.fire], subclasses: [.insectoid], attack: 3, defense: 1, artist: "Giovanni Aguilar", cardSet: .baseSet, cardNumber: "BS1-029", editions: [.prototype, .founders], rarity: .common),
        ElestralCard(name: "Flarachne", effect: "As long as this Flarachne is Enchanted Elestrals cannot attack the turn they are cast unless they are (fire)-Enchanted", elements: [.fire, .fire], subclasses: [.insectoid], attack: 4, defense: 8, artist: "Giovanni Aguilar", cardSet: .baseSet, cardNumber: "BS1-030", editions: [.prototype, .founders], rarity: .rare)
        
    ] { didSet {
        subscribeToChanges()
    }}
    
    private var c: Any?
    
    init() {
        subscribeToChanges()
    }
    
    private func subscribeToChanges() {
        c = cardList
            .publisher
            .flatMap { elestral in elestral.objectWillChange }
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
    }

}

/*@Published var records: [Record] = (1 ... 5).map(Record.init) {
 didSet {
 subscribeToChanges()    ///<<< HERE
 }
 }
 
 private var c: AnyCancellable?
 init() {
 subscribeToChanges()
 }
 
 func subscribeToChanges() {
 c = records
 .publisher
 .flatMap { record in record.objectWillChange }
 .sink { [weak self] in
 self?.objectWillChange.send()
 }
 }
 */
