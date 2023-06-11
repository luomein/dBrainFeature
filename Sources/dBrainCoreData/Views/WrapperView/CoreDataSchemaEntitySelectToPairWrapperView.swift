//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/11.
//

import SwiftUI
import CoreData
import dBrainFeature
import ComposableArchitecture
import IdentifiedCollections

public struct CoreDataSchemaEntitySelectToPairWrapperView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dbrainDataAgent) var dataAgent
    
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    
    @FetchRequest
    var allItems :  FetchedResults<T>
    
    typealias T = CoreDataSchemaEntity
    public init(uuid: UUID)
    {
        let fetchRequest :NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        self.requestItems = .init(fetchRequest: fetchRequest)
        
        _allItems = FetchRequest<T>(sortDescriptors: [])
    }

    public var body: some View {
        if let item = items.first
        {
            SchemaEntitySelectToPairFeatureView(store: .init(initialState: .init(schemaEntity: item.converter.schemaEntity, allSchemaEntities: .init(uniqueElements: allItems.map({$0.converter.schemaEntity}))
                                                                                ), reducer: SchemaEntitySelectToPairFeature(dataAgent: dataAgent.schemaEntitySelectToPairFeatureDataAgent)))
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
