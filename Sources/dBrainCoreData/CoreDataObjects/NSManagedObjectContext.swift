//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/8.
//

import Foundation
import CoreData
import ComposableArchitecture

extension DependencyValues {
  /// The current dependency context.
  ///
  /// The current ``DependencyContext`` can be used to determine how dependencies are loaded by the
  /// current runtime.
  ///
  /// It can also be overridden, for example via ``withDependencies(_:operation:)-4uz6m``, to
  /// control how dependencies will be loaded by the runtime for the duration of the override.
  ///
  /// ```swift
  /// withDependencies {
  ///   $0.context = .preview
  /// } operation: {
  ///   // Dependencies accessed here default to their "preview" value
  /// }
  /// ```
//  public var viewContextDependencyManager: NSManagedObjectContextDependencyManager {
//    get { self[NSManagedObjectContextDependencyManager.self] }
//    set { self[NSManagedObjectContextDependencyManager.self] = newValue }
//  }
    public var viewContext: NSManagedObjectContext  {
      get { self[NSManagedObjectContext.self] }
      set { self[NSManagedObjectContext.self] = newValue }
    }
}
extension NSManagedObjectContext : DependencyKey {
    public static let liveValue : NSManagedObjectContext = PersistenceController.shared.container.viewContext
    public static let testValue : NSManagedObjectContext = PersistenceController.preview.container.viewContext
}

public extension NSManagedObjectContext{
    public static func getFetchRequestByUUID<T:CoreDataProperty>(uuid: UUID)->NSFetchRequest<T> where T:NSManagedObject{
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        
        return fetchRequest
//        let item = try! viewContext.fetch(fetchRequest).first!
//        return item
    }
    public func getFetchResultByUUID<T:CoreDataProperty>(uuid: UUID)->T where T:NSManagedObject{
//        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName )
//        fetchRequest.sortDescriptors = []
//        fetchRequest.predicate = NSPredicate(format: "id == %@",  uuid as CVarArg)
        let fetchRequest : NSFetchRequest<T> = NSManagedObjectContext.getFetchRequestByUUID(uuid: uuid)
        
        let item = try! self.fetch(fetchRequest).first!
        return item
    }
}
