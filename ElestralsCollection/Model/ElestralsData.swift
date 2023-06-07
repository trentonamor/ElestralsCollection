import Foundation
import SwiftUI

class Elestral : ObservableObject {
    @Published var name: String
    @Published var isOwned: Bool
    @Published var element: Element
    var sprite: String {
        guard UIImage(named: name) != nil else {
            switch element {
                case .earth:
                    return "Earth"
                case .fire:
                    return "Fire"
                case .thunder:
                    return "Thunder"
                case .water:
                    return "Water"
                case .wind:
                    return "Wind"
                default:
                    return "StoneSquare"
            }
        }
        return name
    }
    var backgroundColor: Color {
        if !isOwned {
            return .white
        }
        switch element {
            case .earth:
                return Color("EarthGreen")
            case .fire:
                return Color("FireRed")
            case .thunder:
                return Color("ThunderYellow")
            case .water:
                return Color("WaterBlue")
            case .wind:
                return Color("AirWhite")
            default:
                return .white
        }
    }
    
    init(name: String, element: Element, isOwned: Bool) {
        self.name = name
        self.isOwned = isOwned
        self.element = element
    }
}

enum Element : Int {
    case earth = 0
    case fire = 1
    case thunder = 2
    case water = 3
    case wind = 4
}

class ElestralData: ObservableObject {
    @Published var elestralsList: [Elestral] = [
    Elestral(name: "Penterror", element: .wind, isOwned: false),
    Elestral(name: "Teratlas", element: .earth, isOwned: false),
    Elestral(name: "Vipyro", element: .fire, isOwned: false),
    Elestral(name: "Leviaphin", element: .water, isOwned: false),
    Elestral(name: "Zaptor", element: .thunder, isOwned: false),
    Elestral(name: "Lycarus", element: .wind, isOwned: false),
    Elestral(name: "Drataya", element: .earth, isOwned: false),
    Elestral(name: "Ladogon", element: .earth, isOwned: false),
    Elestral(name: "Rummagem", element: .earth, isOwned: false),
    Elestral(name: "Scavagem", element: .earth, isOwned: false),
    Elestral(name: "Spinymph", element: .earth, isOwned: false),
    Elestral(name: "Spinosect", element: .earth, isOwned: false),
    Elestral(name: "Clovie", element: .earth, isOwned: false),
    Elestral(name: "Sakurasaur", element: .earth, isOwned: false),
    Elestral(name: "Tectaurus", element: .earth, isOwned: false),
    Elestral(name: "Barabog", element: .earth, isOwned: false),
    Elestral(name: "Titanostalk", element: .earth, isOwned: false),
    Elestral(name: "Equilynx", element: .earth, isOwned: false),
    Elestral(name: "Vysceris", element: .earth, isOwned: false),
    Elestral(name: "Pandicine", element: .earth, isOwned: false),
    Elestral(name: "Necruff", element: .fire, isOwned: false),
    Elestral(name: "Blazerus", element: .fire, isOwned: false),
    Elestral(name: "Trifernal", element: .fire, isOwned: false),
    Elestral(name: "Urscout", element: .fire, isOwned: false),
    Elestral(name: "Ursmog", element: .fire, isOwned: false),
    Elestral(name: "Ursear", element: .fire, isOwned: false),
    Elestral(name: "Majursa", element: .fire, isOwned: false),
    Elestral(name: "Ignectar", element: .fire, isOwned: false),
    Elestral(name: "Waspyre", element: .fire, isOwned: false),
    Elestral(name: "Warmite", element: .fire, isOwned: false),
    Elestral(name: "Flarachne", element: .fire, isOwned: false),
    Elestral(name: "Kindleo", element: .fire, isOwned: false),
    Elestral(name: "Leonite", element: .fire, isOwned: false),
    Elestral(name: "Sinder", element: .fire, isOwned: false),
    Elestral(name: "Emphyrix", element: .fire, isOwned: false),
    Elestral(name: "Volcaries", element: .fire, isOwned: false),
    Elestral(name: "Krakkid", element: .water, isOwned: false),
    Elestral(name: "Krakking", element: .water, isOwned: false),
    Elestral(name: "Sluggle", element: .water, isOwned: false),
    Elestral(name: "Glauby", element: .water, isOwned: false),
    Elestral(name: "Majesea", element: .water, isOwned: false),
    Elestral(name: "Foamee", element: .water, isOwned: false),
    Elestral(name: "Capregal", element: .water, isOwned: false),
    Elestral(name: "Typhlant", element: .water, isOwned: false),
    Elestral(name: "Eyevory", element: .water, isOwned: false),
    Elestral(name: "Smoltuga", element: .water, isOwned: false),
    Elestral(name: "Krakatuga", element: .water, isOwned: false),
    Elestral(name: "Verutaqua", element: .water, isOwned: false),
    Elestral(name: "Javelantis", element: .water, isOwned: false),
    Elestral(name: "Tadpuff", element: .water, isOwned: false),
    Elestral(name: "Zephrog", element: .water, isOwned: false),
    Elestral(name: "Moustacean", element: .water, isOwned: false),
    Elestral(name: "Galaxea", element: .water, isOwned: false),
    Elestral(name: "Apheros", element: .water, isOwned: false),
    Elestral(name: "Boombatt", element: .thunder, isOwned: false),
    Elestral(name: "Sonicore", element: .thunder, isOwned: false),
    Elestral(name: "Ampup", element: .thunder, isOwned: false),
    Elestral(name: "Lycavolt", element: .thunder, isOwned: false),
    Elestral(name: "Elechik", element: .thunder, isOwned: false),
    Elestral(name: "Griffuse", element: .thunder, isOwned: false),
    Elestral(name: "Voltempest", element: .thunder, isOwned: false),
    Elestral(name: "Sparkitt", element: .thunder, isOwned: false),
    Elestral(name: "Gatobolt", element: .thunder, isOwned: false),
    Elestral(name: "Quackle", element: .thunder, isOwned: false),
    Elestral(name: "Cygnetrik", element: .thunder, isOwned: false),
    Elestral(name: "Ohmperial", element: .thunder, isOwned: false),
    Elestral(name: "Jolten", element: .thunder, isOwned: false),
    Elestral(name: "Raiceros", element: .thunder, isOwned: false),
    Elestral(name: "Astrabbit", element: .thunder, isOwned: false),
    Elestral(name: "Aeromare", element: .wind, isOwned: false),
    Elestral(name: "Glydesdale", element: .wind, isOwned: false),
    Elestral(name: "Nimbug", element: .wind, isOwned: false),
    Elestral(name: "Cirrucoon", element: .wind, isOwned: false),
    Elestral(name: "Stratomoth", element: .wind, isOwned: false),
    Elestral(name: "Peagust", element: .wind, isOwned: false),
    Elestral(name: "Fowlicane", element: .wind, isOwned: false),
    Elestral(name: "Soarlet", element: .wind, isOwned: false),
    Elestral(name: "Chrysoar", element: .wind, isOwned: false),
    Elestral(name: "Carryon", element: .wind, isOwned: false),
    Elestral(name: "Peliquarius", element: .wind, isOwned: false),
    Elestral(name: "Exaltair", element: .wind, isOwned: false),
    Elestral(name: "Centaurbor", element: .earth, isOwned: false),
    Elestral(name: "Hydrake", element: .wind, isOwned: false),
    Elestral(name: "Twindra", element: .wind, isOwned: false),
    Elestral(name: "Sproutyr", element: .earth, isOwned: false),
    Elestral(name: "Satymber", element: .earth, isOwned: false),
    Elestral(name: "Girafflora", element: .earth, isOwned: false),
    Elestral(name: "Oystress", element: .water, isOwned: false),
    Elestral(name: "Hummbust", element: .fire, isOwned: false),
    Elestral(name: "Toxion", element: .thunder, isOwned: false),
    Elestral(name: "Galvenom", element: .thunder, isOwned: false)
    ] { didSet {
        subscribeToChanges()
    }}
    
    private var c: Any?
    
    init() {
        subscribeToChanges()
    }
    
    private func subscribeToChanges() {
        c = elestralsList
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
