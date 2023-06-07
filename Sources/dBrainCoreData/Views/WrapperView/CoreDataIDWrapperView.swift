//
//  SwiftUIView.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import SwiftUI
import CoreData

public struct CoreDataIDWrapperView<ComponentView:View, T:NSManagedObject>: View where T:CoreDataProperty {
    @Environment(\.managedObjectContext) private var viewContext
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    var componentView : (Binding<SelectItem>)->ComponentView
    @Binding var selectItem : SelectItem
    
    public init(uuid: UUID , componentView : @escaping (Binding<SelectItem>)->ComponentView
         , selectItem : Binding<SelectItem>  ){

        let fetchRequest :NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        //NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        self.requestItems = .init(fetchRequest: fetchRequest)
        self.componentView = componentView
        //self._selectItem = State(initialValue: selectItem)
        self._selectItem = selectItem
    }
    public var body: some View {
        if let item = items.first
           {
            componentView(.constant( SelectItem.setValue(setSelectItemByType: item.setSelectItemByType
                                              , selectItem: selectItem)) )
        }
    }
}
public protocol ViewOption: RawRepresentable, Equatable, Hashable{
    
}
//public protocol ComponentViewProtocol: View{
//    associatedtype VO
//    var viewOption : VO {get}
//}
//public struct CoreDataIDWrapperViewOptionView2<ComponentView:ComponentViewProtocol, T:NSManagedObject>: View where T:CoreDataProperty {
//    @Environment(\.managedObjectContext) private var viewContext
//    var requestItems : FetchRequest<T>
//    private var items: FetchedResults<T>{requestItems.wrappedValue}
//    var componentView : (Binding<SelectItem>, VO)->ComponentView
//    @Binding var selectItem : SelectItem
//    let viewOption : ComponentViewProtocol.VO
//    //typealias VO = ComponentViewProtocol.VO
//
//    public init(uuid: UUID , componentView : @escaping (Binding<SelectItem>, VO)->ComponentView
//                , selectItem : Binding<SelectItem>, viewOption: VO ){
//
//        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
//        self.requestItems = .init(fetchRequest: fetchRequest)
//        self.componentView = componentView
//        //self._selectItem = State(initialValue: selectItem)
//        self._selectItem = selectItem
//        self.viewOption = viewOption
//    }
//    public var body: some View {
//        if let item = items.first
//           {
//            componentView(.constant( SelectItem.setValue(setSelectItemByType: item.setSelectItemByType
//                                                         , selectItem: selectItem)), viewOption )
//        }
//    }
//}
public struct CoreDataIDWrapperViewOptionView<ComponentView:View, T:NSManagedObject, VO:ViewOption>: View where T:CoreDataProperty {
    @Environment(\.managedObjectContext) private var viewContext
    var requestItems : FetchRequest<T>
    private var items: FetchedResults<T>{requestItems.wrappedValue}
    var componentView : (Binding<SelectItem>, VO)->ComponentView
    @Binding var selectItem : SelectItem
    let viewOption : VO
    
    public init(uuid: UUID , componentView : @escaping (Binding<SelectItem>, VO)->ComponentView
                , selectItem : Binding<SelectItem>, viewOption: VO ){

        let fetchRequest :NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
//        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        self.requestItems = .init(fetchRequest: fetchRequest)
        self.componentView = componentView
        //self._selectItem = State(initialValue: selectItem)
        self._selectItem = selectItem
        self.viewOption = viewOption
    }
    public var body: some View {
        if let item = items.first
           {
            componentView(.constant( SelectItem.setValue(setSelectItemByType: item.setSelectItemByType
                                                         , selectItem: selectItem)), viewOption )
        }
    }
}

struct CoreDataIDWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            CoreDataIDWrapperView<InstanceEntityView,CoreDataInstanceEntity>(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000" )!
                                                                             , componentView: InstanceEntityView.init, selectItem: .constant(.init()))
        }
        .environment(\.managedObjectContext, PersistenceController.previewByOption(option: .singleInstanceEntity).container.viewContext)
    }
}
