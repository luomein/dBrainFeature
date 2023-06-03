//
//  dBrainCoreDataTests.swift
//  
//
//  Created by MEI YIN LO on 2023/6/2.
//

import XCTest
@testable import dBrainCoreData

final class dBrainCoreDataTests: XCTestCase {

    func test(){
        let persistenceController = PersistenceController.preview
        let viewContext = persistenceController.container.viewContext
        
        let schema = CoreDataSchemaEntity(context: viewContext)
        schema.id = UUID()
        schema.name = "schema"
        let schema2 = CoreDataSchemaEntity(context: viewContext)
        schema2.id = UUID()
        schema2.name = "schema2"
        
        let instance = CoreDataInstanceEntity(context: viewContext)
        instance.id = UUID()
        instance.schema = schema
        
        let pairSchema = CoreDataSchemaRelationPair(context: viewContext)
        pairSchema.id = UUID()
        
        let pairSchemaElement = CoreDataSchemaRelationPairElement(context: viewContext)
        pairSchemaElement.id = UUID()
        pairSchemaElement.schema = schema
        pairSchemaElement.pair = pairSchema
        let pairSchemaElement2 = CoreDataSchemaRelationPairElement(context: viewContext)
        pairSchemaElement2.id = UUID()
        pairSchemaElement2.schema = schema
        pairSchemaElement2.pair = pairSchema
        
        //print(instance.schema!.relationPairElements?.count)
        
        instance.createRelatedInstance(schemaRelationPairElement: pairSchemaElement, viewContext: viewContext)
        
        
        if let instancePairElements = pairSchemaElement2.instances?.allObjects.map({($0 as! CoreDataInstanceRelationPairElement)})
                                        .filter({
                                            $0.instance! == instance
                                        })

        {
            let instances = instancePairElements.map({$0.getPairedElement().instance!})
            print(instances.first!.id!.uuidString)
            //print(instancePairElements.count)
        }
        else{
            print(0)
        }
//        if let pairElements = item.schema?.relationPairElements?.allObjects.map({($0 as! CoreDataSchemaRelationPairElement).pair!}).flatMap({
//            item.getRelationPairElement(schemaRelationPair:$0){
//
//            }
//        if let schemaRelationPairElement = pairSchema.elements?.allObjects.map({$0 as! CoreDataSchemaRelationPairElement}).first(where: {
//            print($0.instances?.count)
//            return true
//        }){
//            print("a") // schemaRelationPairElement.name ?? schemaRelationPairElement.schema!.name!
//        }
        
    }

}
