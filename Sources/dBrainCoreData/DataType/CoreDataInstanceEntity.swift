//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/2.
//

import Foundation
import CoreData
import dBrainFeature




extension CoreDataInstanceEntity:CoreDataProperty{
    public var setSelectItemByType: SelectItem.SetSelectItemByType {
        return .coreDataInstanceEntity(self)
    }
    
    public static var entityName : String{
        return "CoreDataInstanceEntity"
        //why Self.entity().name possibliy be nil
    }
//    public static var mutableSetValueKey: String{
//        return "relationPairElements"
//    }
}
public extension NSManagedObjectContext{
    public static func getFetchRequestByUUID<T:CoreDataProperty>(uuid: UUID)->NSFetchRequest<T> where T:NSManagedObject{
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        
        return fetchRequest
//        let item = try! viewContext.fetch(fetchRequest).first!
//        return item
    }
    public func getFetchResultByUUID<T:CoreDataProperty>(uuid: UUID)->T where T:NSManagedObject{
//        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        let fetchRequest : NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        
        let item = try! self.fetch(fetchRequest).first!
        return item
    }
}
public extension CoreDataInstanceEntity{
    var schemaID : UUID{
        return self.schema!.id!
    }
    
    var mapped : InstanceEntity{
        return .init(id: self.id!, schemaID: self.schemaID)
    }
    static func updatePin(uuid: UUID, isPinned: Bool, viewContext: NSManagedObjectContext){
        let item : Self = viewContext.getFetchResultByUUID(uuid: uuid)
        if item.isPinned != isPinned{
            item.isPinned = isPinned
            item.timestamp = Date()
        }
    }
    static func updateTimestamp(uuid: UUID, viewContext: NSManagedObjectContext){
        let item : Self = viewContext.getFetchResultByUUID(uuid: uuid)
        item.timestamp = Date()
    }
    public static func createInstance(of schema: CoreDataSchemaEntity, viewContext: NSManagedObjectContext)->CoreDataInstanceEntity{
        let newItem = Self(context: viewContext)
        newItem.id = UUID()
        newItem.schema = schema
        newItem.timestamp = Date()
        newItem.isPinned = false
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
        let newItem = Self.createInstance(of: schemaRelationPairElement.schema!, viewContext: viewContext)
        
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
}
