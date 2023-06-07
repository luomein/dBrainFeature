//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/5.
//

import SwiftUI

public struct SchemaRelationPairElementView : View{
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectItem: SelectItem
    public init(selectItem: Binding<SelectItem>) {
        self._selectItem = selectItem
    }
    public var body: some View {
        if let item = selectItem.coreDataInstanceEntity,
           let pairElement = selectItem.coreDataSchemaRelationPairElement{
            Group{
                DisclosureGroup {
                    //Text(pairElement.id!.uuidString)
                    //Text(pairElement.coreDataInstanceRelationPairElements?.count.description ?? "nil")
                    if let instances = pairElement.coreDataInstanceRelationPairElements?.filter({
                        $0.instance! != item && $0.getPairedElement().instance! == item
                    })
                        .map({$0.instance!}){
                        ForEach(instances ) { instance in
                            NavigationLink {
                                Text(instance.id?.uuidString ?? "")
                            } label: {
                                Text(instance.id?.uuidString ?? "")
                            }

                            
                        }
                    }
                } label: {
                    HStack{
                        //Text(pairElement.name ?? pairElement.schema!.name! )
                        TextField("name", text: .init(get: {
                            return pairElement.name ?? pairElement.schema!.name!
                        }, set: {
                            pairElement.name = $0
                            try! viewContext.save()
                        }))
                        Button {
                            item.createRelatedInstance(schemaRelationPairElement: pairElement, viewContext: viewContext)
                        } label: {
                            Text("create")
                        }

                    }
                }
            }
        }
//        else{
//            if selectItem.coreDataSchemaRelationPairElement == nil {Text("pairElement nil")}
//            if selectItem.coreDataInstanceEntity == nil {Text("item nil")}
//            
//        }
    }
}
