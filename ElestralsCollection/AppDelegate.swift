//
//  AppDelegate.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 9/15/23.
//

import Foundation
import CoreData
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Core Data Stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ElestralsCoreData") // Name of your Data Model
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

