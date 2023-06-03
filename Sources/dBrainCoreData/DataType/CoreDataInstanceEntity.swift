//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/2.
//

import Foundation
import CoreData
import dBrainFeature

extension CoreDataInstanceRelationPairElement{
    public func getPairedElement()->CoreDataInstanceRelationPairElement{
        return self.pair!.elements!.allObjects.map({$0 as! CoreDataInstanceRelationPairElement}).first {
            $0 != self
        }!
    }
}
extension CoreDataSchemaRelationPairElement{
    public func getPairedElement()->CoreDataSchemaRelationPairElement{
        return self.pair!.elements!.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}).first {
            $0 != self
        }!
    }
}
extension CoreDataInstanceEntity{
    public var schemaID : UUID{
        return self.schema!.id!
    }
    
    public var mapped : InstanceEntity{
        return .init(id: self.id!, schemaID: self.schemaID)
    }
    
    public static func createInstance(of schema: CoreDataSchemaEntity, viewContext: NSManagedObjectContext)->CoreDataInstanceEntity{
        let newItem = Self(context: viewContext)
        newItem.id = UUID()
        newItem.schema = schema
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
    public func createRelatedInstance(schemaRelationPairElement: CoreDataSchemaRelationPairElement, viewContext: NSManagedObjectContext){
        let newItem = CoreDataInstanceEntity.createInstance(of: schemaRelationPairElement.schema!, viewContext: viewContext)
        
        let newPair = CoreDataInstanceRelationPair(context: viewContext)
        
        let newPairElement = CoreDataInstanceRelationPairElement(context: viewContext)
        newPairElement.schema = schemaRelationPairElement
        newPairElement.instance = newItem
        newPairElement.id = UUID()
        newPairElement.pair = newPair
        
        let newPairElementSelf = CoreDataInstanceRelationPairElement(context: viewContext)
        newPairElementSelf.schema = schemaRelationPairElement.getPairedElement()
        newPairElementSelf.instance = self
        newPairElementSelf.id = UUID()
        newPairElementSelf.pair = newPair
        
        
    }
    public func getRelationPairElement(schemaEntity: CoreDataSchemaEntity)->[CoreDataSchemaRelationPairElement]?{
//        if let schemaRelationPairElement = schemaEntity.relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}).first(where: {
//            if let instances = $0.instances, instances.count > 0 {
//                if let _ =  instances.allObjects.first(where: {
//                    ($0 as! CoreDataInstanceRelationPairElement).instance == self
//                }){
//                    return false
//                }
//                return true
//            }
//            return false
//        }){
//            return  [schemaRelationPairElement]
//        }
        
        if let schemaRelationPairElement = schemaEntity.relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}).first(where: {
            return $0.schema != self.schema
        }){
            return  [schemaRelationPairElement]
        }
        else{
            return (schemaEntity.relationPairElements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}))
        }
    }
    
}
