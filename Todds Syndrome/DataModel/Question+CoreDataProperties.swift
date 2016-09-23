//
//  Question+CoreDataProperties.swift
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

extension Question {

    @NSManaged var isPositive: NSNumber?
    @NSManaged var title: String?
    @NSManaged var user: User?

}
