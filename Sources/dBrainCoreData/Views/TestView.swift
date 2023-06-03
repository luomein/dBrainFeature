//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/3.
//

import SwiftUI
import CoreData


@available(macOS 11.0, *)
struct SwiftUIView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<CoreDataInstanceEntity>

    @State var selectItem : Item? = nil
    
    @ViewBuilder
    func getRelatedInstance(pairElement: CoreDataSchemaRelationPairElement
                            ,item: CoreDataInstanceEntity
    )-> some View{
        if let instancePairElements = pairElement.instances?.allObjects.map({($0 as! CoreDataInstanceRelationPairElement)})
                                        .filter({
                                            $0.instance! == item
                                        })

        {
            let instances = instancePairElements.map({
                $0.getPairedElement().instance!
            })
            //Text(instances.first?.id?.uuidString ?? "")
            ForEach(instances ) { instance in
                Text(instance.id?.uuidString ?? "")
            }
        }
        
    }
    
    var body: some View {
        //List(items, id: \.self, selection: $selectItem) {item in
        //if let item = items.first{
        Form{
            ForEach(items, id: \.self) { item in
                Text(item.id?.uuidString ?? "")
                if let pairElements = item.getRelationPairElement(schemaEntity: item.schema!)
                 {
                    ForEach(pairElements, id: \.self) { pairElement in
                        DisclosureGroup {
                            //Text(pairElement.pair!.id?.uuidString ?? "")
                            getRelatedInstance(pairElement: pairElement, item: item)
                        } label: {
                            HStack{
                                Text(pairElement.name ?? pairElement.schema!.name! )
                                Button {
                                    item.createRelatedInstance(schemaRelationPairElement: pairElement, viewContext: viewContext)
                                } label: {
                                    Text("create")
                                }

                            }
                        }

                    }
                    
                }
            }
        }
    }
}

@available(macOS 11.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext)
    }
}
