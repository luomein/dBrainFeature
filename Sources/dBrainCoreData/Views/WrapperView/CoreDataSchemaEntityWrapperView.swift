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

public struct CoreDataSchemaEntityWrapperView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dbrainDataAgent) var dataAgent
    @State var navPath = [SchemaEntityFeatureView.StackNavPath]()
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    typealias T = CoreDataSchemaEntity
    public init(uuid: UUID)
    {
        let fetchRequest :NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        self.requestItems = .init(fetchRequest: fetchRequest)
    }
    public var body: some View {
        if let item = items.first
        {
            NavigationStack(path: $navPath) {
                SchemaEntityFeatureView(store: .init(initialState: SchemaEntityFeature.State(schemaEntity: item.converter.schemaEntity
                                                                                             , instanceEntities: item.converter.instanceEntities
                                                                                             , schemaRelationPairs: item.converter.schemaRelationPairs
                                                                                             , instanceRelationPairs: item.converter.instanceRelationPairs)
                                                     , reducer: SchemaEntityFeature(dataAgent: dataAgent.schemaEntityFeatureDataAgent
                                                                //.init(createInstance: createInstance, createRelation: createRelation)
                                                                                       )))
                .navigationDestination(for: SchemaEntityFeatureView.StackNavPath.self) { destination in
                    switch destination{
                    case .SchemaEntitySelectToPairFeatureView(let uuid):
                        CoreDataSchemaEntitySelectToPairWrapperView(uuid: uuid)
                    }
                }
            }
            
            
           
        }
    }
    
    //createPairedSchema
}

struct CoreDataSchemaEntityWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            CoreDataSchemaEntityWrapperView(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!)
        }
        .environment(\.dbrainDataAgent, PersistenceController.previewByOption(option: .singleSchemaEntity).container.viewContext.dataAgent)
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleSchemaEntity).container.viewContext)
    }
}
