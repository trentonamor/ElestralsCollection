//
//  BookmarkViewExtensions.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/16/23.
//

import Foundation
import CoreData

extension BookmarkView {
    func loadBookmarks() {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        
        do {
            let bookmarkEntities = try managedObjectContext.fetch(fetchRequest)
            self.bookmarkModels = bookmarkEntities.map { BookmarkModel(from: $0, cardStore: self.cardStore) }
        } catch {
            print("Failed to fetch bookmarks: \(error)")
        }
    }
}

import SwiftUI
extension BookmarkView: EditBookmarkViewDelegate {
    func saveBookmark(_ bookmark: BookmarkModel) {
        // Check if the bookmark already exists
        let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)

        let matches = try? managedObjectContext.fetch(request) as? [Bookmark]
        let bookmarkEntity: Bookmark
        if let match = matches?.first {
            // Existing bookmark
            bookmarkEntity = match
        } else {
            // New bookmark
            bookmarkEntity = Bookmark(context: managedObjectContext)
            self.bookmarkModels.append(bookmark)
        }

        // Map properties from BookmarkModel to Bookmark
        bookmarkEntity.id = bookmark.id
        bookmarkEntity.name = bookmark.name
        let cardIDs = Set(bookmark.cards.map { $0.id })
        bookmarkEntity.cards = cardIDs as NSSet
        bookmarkEntity.type = bookmark.type.rawValue
        bookmarkEntity.showOwnedIndicator = bookmark.showOwnedIndicator
        bookmarkEntity.showProgress = bookmark.showProgres
        bookmarkEntity.icon = bookmark.icon
        bookmarkEntity.color = bookmark.color.hexString ?? "FFFFFF"

        do {
            try managedObjectContext.save()
            if let index = self.bookmarkModels.firstIndex(where: { $0.id == bookmark.id }) {
                self.bookmarkModels[index] = bookmark
                self.refreshID = UUID()
            }
        } catch {
            print("Failed to save bookmark: \(error)")
        }
    }
    
    func deleteBookmark(_ bookmark: BookmarkModel) {
        withAnimation(.easeIn(duration: 0.3)) {
            let request: NSFetchRequest<NSFetchRequestResult> = Bookmark.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", bookmark.id as CVarArg)
            
            if let matches = try? managedObjectContext.fetch(request) as? [Bookmark], let match = matches.first {
                managedObjectContext.delete(match)
                
                // Remove the bookmark from the array
                if let index = self.bookmarkModels.firstIndex(where: { $0.id == bookmark.id }) {
                    self.bookmarkModels.remove(at: index)
                    self.refreshID = UUID()
                }
                
                try? managedObjectContext.save()
            }
        }

    }
}
