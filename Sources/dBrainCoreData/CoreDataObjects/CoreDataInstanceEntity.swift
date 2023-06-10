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
    func createRelatedInstance(schemaRelationPairElement: CoreDataSchemaRelationPairElement, viewContext: NSManagedObjectContext)->CoreDataInstanceEntity{
        assert(schemaRelationPairElement.getPairedElement().schema! == self.schema!)
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
        
        return newItem
    }
    var coreDataInstanceRelationPairElement : [CoreDataInstanceRelationPairElement]?{
        return relationPairElements?.allObjects.map({$0 as! CoreDataInstanceRelationPairElement})
    }
    func getRelatedInstance(of schema: CoreDataSchemaEntity,checkedPath : [CoreDataInstanceRelationPairElement]=[] )->[CoreDataInstanceEntity]?{
        if checkedPath.map({$0.instance!}).contains(self){
            return nil
        }
        var checkedPath = checkedPath
        var result : Set<CoreDataInstanceEntity> = []
        if let elements = self.coreDataInstanceRelationPairElement{
            //print(elements.count)
            for element in elements {
                let pairedInstance = element.getPairedElement().instance!
                //print(pairedInstance.schema?.name!)
                assert(pairedInstance != self)
                if checkedPath.map({$0.instance!}).contains(pairedInstance){
                    continue
                }
                else if result.contains(pairedInstance){
                    continue
                }
                else if pairedInstance.schema! == schema{
                    //result.append(pairedInstance)
                    //print(result.count)
                    result.insert(pairedInstance)
                    //print(result.count)
                }
                checkedPath.append(element)
                if let subResult = pairedInstance.getRelatedInstance(of: schema, checkedPath: checkedPath){
                    //result.append(contentsOf: subResult)
                    result = result.union(subResult)
                }
            }
        }
        return (result.count == 0) ? nil : result.map({$0})
    }
}
