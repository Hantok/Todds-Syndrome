//
//  User+CoreDataProperties.swift
//  Todds Syndrome
//
//  Created by Roman on 9/23/16.
//  Copyright © 2016 Roman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var questions: NSSet?

}
