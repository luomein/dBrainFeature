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
            let instanceEntities : IdentifiedArrayOf<InstanceEntity> = .init(uniqueElements: item.coreDataInstanceEntities?.map({.init(id:$0.id!, schemaID: $0.schemaID)}) ?? [])
            SchemaEntityFeatureView(store: .init(initialState: SchemaEntityFeature.State(schemaEntity: .init(id:item.id!, name: item.name!)
                                                                                         , instanceEntities: instanceEntities
                                                                                         , schemaRelationPairs: [], instanceRelationPairs: [])
                                                 , reducer: SchemaEntityFeature(dataAgent: .init(createInstance: createInstance))))
        }
    }
    func createInstance(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let coreDataSchemaEntity : CoreDataSchemaEntity = viewContext.getFetchResultByUUID(uuid: schema.id)
        CoreDataInstanceEntity.createInstance(of: coreDataSchemaEntity, viewContext: viewContext)
    }
}

struct CoreDataSchemaEntityWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataSchemaEntityWrapperView(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!)
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleSchemaEntity).container.viewContext)
    }
}
