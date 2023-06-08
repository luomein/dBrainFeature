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
        let schema3 = CoreDataSchemaEntity(context: viewContext)
        schema3.id = UUID()
        schema3.name = "schema3"
        
        let instance = CoreDataInstanceEntity(context: viewContext)
        instance.id = UUID()
        instance.schema = schema
        
        let pairSchema = CoreDataSchemaRelationPair(context: viewContext)
        pairSchema.id = UUID()
        
        let pairSchemaElement = CoreDataSchemaRelationPairElement(context: viewContext)
        pairSchemaElement.id = UUID()
        pairSchemaElement.schema = schema
        pairSchemaElement.name = "pairSchemaElement"
        pairSchemaElement.pair = pairSchema
        let pairSchemaElement2 = CoreDataSchemaRelationPairElement(context: viewContext)
        pairSchemaElement2.id = UUID()
        pairSchemaElement2.schema = schema
        pairSchemaElement2.pair = pairSchema
        pairSchemaElement2.name = "pairSchemaElement2"
        //print(instance.schema!.relationPairElements?.count)
        
        let newItem1 = instance.createRelatedInstance(schemaRelationPairElement: pairSchemaElement2, viewContext: viewContext)
        let newItem2 = instance.createRelatedInstance(schemaRelationPairElement: pairSchemaElement2, viewContext: viewContext)
        let newItem1_1 = newItem1.createRelatedInstance(schemaRelationPairElement: pairSchemaElement2, viewContext: viewContext)
        
        
        print(instance.getRelatedInstance(of: schema))
        //XCTAssertFalse(schema.hasRelationWithSchema(schema: schema3, includeSelfRelation: true))
//        XCTAssertTrue(schema.hasRelationWithSchema(schema: schema2, includeSelfRelation: true))
    }

}
