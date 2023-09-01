//
//  CardImageLoader.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 8/25/23.
//

import Foundation
import Combine
import FirebaseStorage

import Foundation
import Combine
import FirebaseStorage

class CardImageLoader: ObservableObject {
    @Published var imageUrls: [String: URL] = [:]
    private let imageLoadedSubject = PassthroughSubject<String, Never>()

    var imageLoaded: AnyPublisher<String, Never> {
        return imageLoadedSubject.eraseToAnyPublisher()
    }

    func downloadCardImages(cards: [ElestralCard]) {
        let storage = Storage.storage()
        let group = DispatchGroup()

        for card in cards {
            group.enter()
            let imagePath = "cards/\(card.cardType)/\(card.id).jpg"
            let imageRef = storage.reference().child(imagePath)

            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error downloading image URL for card \(card.id): \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.imageUrls[card.id] = url
                        self.imageLoadedSubject.send(card.id) // Notify that image is loaded
                    }
                }
                group.leave()
            }
        }
    }
}
