//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import SwiftUI


struct SimpleInstanceEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item : CoreDataInstanceEntity
    var body: some View {
        Text(item.mutableSetValue(forKey: "relationPairElements").count.description)
    }
}
public struct InstanceEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectItem: SelectItem
    
    public init(selectItem: Binding<SelectItem>) {
        self._selectItem = selectItem
    }
    public var body: some View {
        if let item = selectItem.coreDataInstanceEntity{
            Group{
                DisclosureGroup {
                    Button {
                        item.schema!.createPairedSchema(viewContext: viewContext)
                    } label: {
                        Text("create")
                    }

                    
                    if let pairElements = item.schema!.coreDataSchemaRelationPairElements?.map({
                        $0.getPairedElement()
                    }){
                        //Text("\(pairElements.count)")
                        ForEach(pairElements, id: \.self) { pairElement in
                            CoreDataIDWrapperView<SchemaRelationPairElementView,CoreDataSchemaRelationPairElement>(uuid: pairElement.id!
                                                                                                                   , componentView: SchemaRelationPairElementView.init,selectItem: $selectItem
                            )
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
