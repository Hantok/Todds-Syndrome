//
//  User.swift
//  Todds Syndrome
//
//  Created by Roman on 9/23/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import CoreData


class User: NSManagedObject {
    
    convenience init () {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        self.init(entity: entity!, insertIntoManagedObjectContext: nil)
    }
    
    func getPercent() -> Int {
        let questionsList = CoreService.fetchQuestions(self)
        
        var score = 0
        for question in questionsList {
            if let positive = question.isPositive?.boolValue {
                score += positive == true ? 1 : 0
            }
        }
        return (100/questionsList.count)*score
    }

}
