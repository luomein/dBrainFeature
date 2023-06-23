//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/23.
//

import SwiftUI
import ComposableArchitecture

struct InstanceEntitySelectToPairFeatureView: View {
    @Environment(\.dbrainDataAgent) var dataAgent
        @State var selectedInstanceEntities : Set<InstanceEntity> = []
        var store : StoreOf<InstanceEntitySelectToPairFeature>
        public init(store: StoreOf<InstanceEntitySelectToPairFeature>) {
            self.store = store
        }
        public var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List(viewStore.allInstanceEntities,id: \.self
                     ,selection: $selectedInstanceEntities //viewStore.binding(get: \.selectedSchemaEntities, send: SchemaEntitySelectToPairFeature.Action.selectSchemas)
                ){instanceOption in
                    Text(instanceOption.id.uuidString)
                }
                .onDisappear{
                    //viewStore.send(.createRelation)
                    if selectedInstanceEntities.count > 0{
                        dataAgent.instanceEntitySelectToPairFeatureDataAgent.createRelation(viewStore.instanceEntity,selectedInstanceEntities,viewStore.schemaRelationPair,viewStore.schemaRelationPairElement)
                    }
                }
            }
        }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
