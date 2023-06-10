//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import SwiftUI
import CoreData
import dBrainFeature
import ComposableArchitecture
import IdentifiedCollections

struct CoreDataSchemaEntityWrapperView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    typealias T = CoreDataSchemaEntity
    public init(uuid: UUID)
    {
        let fetchRequest :NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        self.requestItems = .init(fetchRequest: fetchRequest)
    }
    var body: some View {
        if let item = items.first
        {
            
            
            SchemaEntityFeatureView(store: .init(initialState: SchemaEntityFeature.State(schemaEntity: item.converter.schemaEntity
                                                                                         , instanceEntities: item.converter.instanceEntities
                                                                                         , schemaRelationPairs: item.converter.schemaRelationPairs
                                                                                         , instanceRelationPairs: [])
                                                     , reducer: SchemaEntityFeature(dataAgent: .init(createInstance: createInstance, createRelation: createRelation))))
           
        }
    }
    func createInstance(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let coreDataSchemaEntity : CoreDataSchemaEntity = viewContext.getFetchResultByUUID(uuid: schema.id)
        CoreDataInstanceEntity.createInstance(of: coreDataSchemaEntity, viewContext: viewContext)
    }
    func createRelation(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let coreDataSchemaEntity : CoreDataSchemaEntity = viewContext.getFetchResultByUUID(uuid: schema.id)
        coreDataSchemaEntity.createPairedSchema(viewContext: viewContext)
    }
    //createPairedSchema
}

struct CoreDataSchemaEntityWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            CoreDataSchemaEntityWrapperView(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!)
        }
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleSchemaEntity).container.viewContext)
    }
}
