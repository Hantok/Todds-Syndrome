//
//  CoreService.swift
//  Todds Syndrome
//
//  Created by Roman on 9/23/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import CoreData

class CoreService: NSObject {
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    static func saveUser(name: String, questions: [Question]) {
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            if (results.count == 0) {
                let entity =  NSEntityDescription.entityForName("User",
                                                                        inManagedObjectContext:managedObjectContext)
                
                let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedObjectContext)
                
                person.setValue(name, forKey: "name")
                person.setValue(NSSet(array: questions), forKey: "questions")
                
                do {
                    try managedObjectContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            } else {
                let user = results[0] as! User
                user.questions = NSSet(array: questions)
                try managedObjectContext.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    static func fetchUsers() -> [User] {
        managedObjectContext.rollback()
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            return results as! [User]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchQuestions(user: User?) -> [Question] {
        let fetchRequest = NSFetchRequest(entityName: "Question")
        if let user = user {
            fetchRequest.predicate = NSPredicate(format: "user.name ==%@", user.name!)
            do {
                let results = try managedObjectContext.executeFetchRequest(fetchRequest)
                return results as! [Question]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                return []
            }
        } else {
            return getQuestions(managedObjectContext)
        }
    }
    
    private static func getQuestions(managedContext: NSManagedObjectContext) -> [Question] {
        
        //can be replased for call API
        let entity =  NSEntityDescription.entityForName("Question", inManagedObjectContext:managedContext)
        
        let question1 = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext) as! Question
        let question2 = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext) as! Question
        let question3 = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext) as! Question
        let question4 = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext) as! Question
        
        question1.title = "Do you have migraines?"
        question2.title = "Are you younger than 15?"
        question3.title = "Are you man?"
        question4.title = "Did you have any hallucinogenic drugs?"
        
        return [question1, question2, question3, question4]

    }
}
