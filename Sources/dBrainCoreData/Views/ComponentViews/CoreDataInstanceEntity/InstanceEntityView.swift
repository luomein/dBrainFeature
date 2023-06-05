//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import SwiftUI

struct SchemaEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectItem: SelectItem
    
    var body: some View {
        if let item = selectItem.coreDataSchemaEntity{
            Group{
                //Text(item.mutableSetValue(forKey: "relationPairElements").count.description)
                Text(item.name!)
                if let instances = item.coreDataInstanceEntities{
                    ForEach(instances) { instance in
                        CoreDataIDWrapperView<InstanceEntityView, CoreDataInstanceEntity>(uuid: instance.id!, componentView: InstanceEntityView.init, selectItem: $selectItem)
                    }
                }
            }
        }
    }
}
struct SimpleInstanceEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item : CoreDataInstanceEntity
    var body: some View {
        Text(item.mutableSetValue(forKey: "relationPairElements").count.description)
    }
}
struct InstanceEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectItem: SelectItem
    
    var body: some View {
        if let item = selectItem.coreDataInstanceEntity{
            Group{
                DisclosureGroup {
                    //Text(item.mutableSetValue(forKey: "relationPairElements").count.description)
                    
                    if let pairElements = item.schema!.coreDataSchemaRelationPairElements?.map({
                        $0.getPairedElement()
                    }){
                        //Text("\(pairElements.count)")
                        ForEach(pairElements, id: \.self) { pairElement in
                            CoreDataIDWrapperView<SchemaRelationPairElementView,CoreDataSchemaRelationPairElement>(uuid: pairElement.id!
                                                                                                                   , componentView: SchemaRelationPairElementView.init,selectItem: $selectItem
                            )
                            EmptyView()
                        }
                    }
                } label: {
                HStack{
                    Text(item.id?.uuidString ?? "")
                }
            }
            }
        }
    }
}

//struct InstanceEntityView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstanceEntityView()
//    }
//}
