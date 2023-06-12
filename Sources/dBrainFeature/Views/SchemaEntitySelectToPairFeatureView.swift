//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/11.
//

import SwiftUI
import ComposableArchitecture

public struct SchemaEntitySelectToPairFeatureView: View {
    @Environment(\.dbrainDataAgent) var dataAgent
    @State var selectedSchemaEntities : Set<SchemaEntity> = []
    var store : StoreOf<SchemaEntitySelectToPairFeature>
    public init(store: StoreOf<SchemaEntitySelectToPairFeature>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(viewStore.allSchemaEntities,id: \.self
                 ,selection: $selectedSchemaEntities //viewStore.binding(get: \.selectedSchemaEntities, send: SchemaEntitySelectToPairFeature.Action.selectSchemas)
            ){schemaOption in
                Text(schemaOption.name)
            }
            .onDisappear{
                //viewStore.send(.createRelation)
                if selectedSchemaEntities.count > 0{
                    dataAgent.schemaEntitySelectToPairFeatureDataAgent.createRelation(viewStore.schemaEntity,selectedSchemaEntities)
                }
            }
        }
    }
}

//struct SchemaEntitySelectToPairFeatureView_Previews: PreviewProvider {
//    static var previews: some View {
//        SchemaEntitySelectToPairFeatureView()
//    }
//}
