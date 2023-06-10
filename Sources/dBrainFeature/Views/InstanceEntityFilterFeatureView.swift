//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/9.
//

import SwiftUI
import ComposableArchitecture

struct InstanceEntityFilterCriteriaFeatureView : View{
    let store: StoreOf<InstanceEntityFilterCriteriaFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            NavigationLink {
                if viewStore.selectedInstances.count == 0{
                    List(viewStore.allInstances
                         ,selection: viewStore.binding(get: {
                        Set( $0.selectedInstances )
                    }, send: {
                        //viewStore.selectedInstances = Array($0)
                        //viewStore.send(.selectInstances($0))
                        InstanceEntityFilterCriteriaFeature.Action.selectInstances($0)
                    })
                    ) {item in
                        EmptyView()
                    }
                }
            } label: {
                Text(viewStore.state.schema.name)
            }

        }
    }
}
struct InstanceEntityFilterFeatureView: View {
    let store: StoreOf<InstanceEntityFilterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form{
                
                DisclosureGroup {

                    ForEachStore(store.scope(state: \.criterion
                                             , action: InstanceEntityFilterFeature.Action.joinActionCriteriaFeature)) { subStore in
                        InstanceEntityFilterCriteriaFeatureView(store: subStore)
                    }
                } label: {
                    Text("4324")
                }
                List(viewStore.state.filteredInstances){ instance in
                    Text(instance.id.uuidString)
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
