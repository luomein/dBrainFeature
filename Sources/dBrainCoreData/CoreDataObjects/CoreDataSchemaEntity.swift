//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import Foundation
import CoreData

extension CoreDataSchemaEntity:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .coreDataSchemaEntity(self)
    }
    
    public static var entityName : String{
        return "CoreDataSchemaEntity"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return "relationPairElements"
//    }
}

public extension CoreDataSchemaEntity{
    var coreDataSchemaRelationPairElements: [CoreDataSchemaRelationPairElement]?{
        return relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement})
    }
    
    var coreDataInstanceEntities: [CoreDataInstanceEntity]?{
        return self.instances?.allObjects.map({$0 as! CoreDataInstanceEntity})
    }
    
    static func createSchema( viewContext: NSManagedObjectContext)->Self{
        let newItem = Self(context: viewContext)
        newItem.id = UUID()
        newItem.name = "\(Int.random(in: 0...1000))"
        do {
            try viewContext.save()
            return newItem
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func createPairedSchema(pair to: CoreDataSchemaEntity? = nil, viewContext: NSManagedObjectContext)->Self{
        let pairTo : Self
        if to == nil{
            let newItem = Self(context: viewContext)
            newItem.id = UUID()
            newItem.name = "new schema"
            pairTo = newItem
        }else{
            pairTo = to! as! Self
        }
        let newPair = CoreDataSchemaRelationPair(context: viewContext)
        newPair.id = UUID()
        
        let newPairElement = CoreDataSchemaRelationPairElement(context: viewContext)
        newPairElement.id = UUID()
        newPairElement.pair = newPair
        newPairElement.schema = self
        newPairElement.name = "new relation: \(self.name!) -- \(pairTo.name!)"
        
        let newPairElement2 = CoreDataSchemaRelationPairElement(context: viewContext)
        newPairElement2.id = UUID()
        newPairElement2.pair = newPair
        newPairElement2.schema = pairTo
        newPairElement2.name = "new relation: \(self.name!) -- \(pairTo.name!)"
        
        do {
            try viewContext.save()
            return pairTo
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
