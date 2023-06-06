//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/6.
//

import SwiftUI

public struct SchemaEntityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectItem: SelectItem
    
    public init(selectItem: Binding<SelectItem>) {
        self._selectItem = selectItem
    }
    public var body: some View {
        if let item = selectItem.coreDataSchemaEntity{
            Group{
                DisclosureGroup{
                    Button {
                        CoreDataInstanceEntity.createInstance(of: item, viewContext: viewContext)
                    } label: {
                        Text("create")
                    }

                    if let instances = item.coreDataInstanceEntities{
                        ForEach(instances) { instance in
                            CoreDataIDWrapperView<InstanceEntityView, CoreDataInstanceEntity>(uuid: instance.id!, componentView: InstanceEntityView.init, selectItem: $selectItem)
                        }
                    }
                } label: {
                    HStack{
                        TextField("name", text: .init(get: {
                            return item.name ?? ""
                        }, set: {
                            item.name = $0
                            try! viewContext.save()
                        }))
                    }
                }
            }
        }
    }
}
