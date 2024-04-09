//
//  DataBase.swift
//  Hella.
//
//  Created by mac on 4/14/18.
//  Copyright © 2018 technoBrix. All rights reserved.
//

import UIKit
import CoreData

class DataBase  {
    var entity_name:String! = nil
    var appDelegate:AppDelegate! = nil
    var managedContext:NSManagedObjectContext! = nil
    var entity:NSEntityDescription! = nil
    var myList:[NSManagedObject]!  = nil
    
required init(entity:String)
 {
        self.entity_name = entity
        appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        self.managedContext =
            appDelegate.persistentContainer.viewContext
        self.entity =
            NSEntityDescription.entity(forEntityName: self.entity_name,
                                       in: managedContext)!
 }
    func selectMultiple()
    {
        getAllRecord();
    }
    func selectedRecord(id:AnyObject,entityType:String)
    {
        getAllRecordByID(pollId:id,entityType:entityType)
    }

func deleteAllRecord()
 {
     let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity_name)
     let request = NSBatchDeleteRequest(fetchRequest: fetch)
     do {
            try managedContext.execute(request)
            try managedContext.save()
        } catch {
  }
 }
    func deleteAllSelectedRecord(pollId:AnyObject,entityType:String)
    {
        switch entityType {
        case "PollData":
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity_name)
            fetch.predicate = NSPredicate(format: "pollID = %@", pollId as! String)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedContext.execute(request)
                try managedContext.save()
            } catch {
                //  print ("There was an error")
            }
        default:
            print ("There was an error")
        }
       
    }
    
    
    func getAllRecordByID(pollId:AnyObject,entityType:String)
    {
        switch entityType {
        case "PollData" :
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
            fetchRequest.predicate = NSPredicate(format: "pollID = %@", pollId as! String)
            do {
                let bulkRecord  = try managedContext.fetch(fetchRequest)
                self.myList = bulkRecord as! [NSManagedObject]
            }
            catch _ as NSError
            {
                //print("Could not fetch. \(error), \(error.userInfo)")
            }
        default:
            print ("There was an error")
        }
        
    }

    func insertRecord(pollId:AnyObject, pollSelected:AnyObject, entityType:String)
    {
        switch entityType {
        case "PollData":
            let record = NSManagedObject(entity: entity, insertInto: managedContext)
            
            record.setValue(validateValue(data: pollId), forKeyPath: "pollID")
            record.setValue(validateValueInt(data: pollSelected), forKeyPath: "pollSelected")

            saveData()
        default:
            print ("There was an error")
        }
        

    }
    
    func updateRecord(pollId:AnyObject, pollSelected:AnyObject){
       
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
        fetchRequest.predicate = NSPredicate(format: "pollID = %@", pollId as! String)
            do{
                let test = try managedContext.fetch(fetchRequest)
                if test.count == 1
                {
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue(validateValue(data: pollId), forKeyPath: "pollID")
                    objectUpdate.setValue(validateValueInt(data: pollSelected), forKeyPath: "pollSelected")
                    saveData()
                }
            }
            catch{
            print(error)
        }
    }
    func validateValue(data:AnyObject) -> String {
        if data is String
        {
            return data as! String
        }else{
            return ""
        }
    }

    func validateValueInt(data:AnyObject) -> Int16 {
        if data is Int16
        {
            return data as! Int16
        }else{
            return 0
        }
    }
    //////////////////////////////////////DataBase Method///////////////////////////////////////////////////////////

    func getAllRecord()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name)
        
        do {
            let bulkRecord  = try managedContext.fetch(fetchRequest)
            self.myList = bulkRecord as! [NSManagedObject]
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func saveData()  {
        do {
            try self.managedContext.save()
        } catch  _ as NSError {
            // print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
