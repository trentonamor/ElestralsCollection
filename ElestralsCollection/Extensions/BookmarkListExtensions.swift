//
//  BookmarkListExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/21/23.
//

import Foundation

extension BookmarkList {
    func doSelectCell(bookmark: BookmarkModel) -> Bool {
        let doesContain = bookmark.cards.contains(where: { $0.id == cardId})
        if doesContain {
            delegate?.selectBookmark(bookmark)
        }
        return doesContain
    }
}
