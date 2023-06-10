//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/8.
//

import Foundation
import CoreData
import ComposableArchitecture
import dBrainFeature

public extension NSManagedObjectContext{
    var dataAgent : dBrainDataAgent{
        return .init(schemaEntityFeatureDataAgent: .init(createInstance: createInstance, createRelation: createRelation)
                     , schemaRelationPairElementFeatureDataAgent: .init(createRelatedInstance:  createRelatedInstance )
                     , schemaEntitySelectToPairFeatureDataAgent : .init(createRelation: createRelation)
        )
    }
    func createRelatedInstance(of pairElement: SchemaRelationPairElement, in pair: SchemaRelationPair, from instance: InstanceEntity){
        let instance : CoreDataInstanceEntity = self.getFetchResultByUUID(uuid: instance.id)
        let schemaRelationPairElement : CoreDataSchemaRelationPairElement = self.getFetchResultByUUID(uuid: pairElement.id)
        let schemaRelationPair: CoreDataSchemaRelationPair = self.getFetchResultByUUID(uuid: pair.id)
        assert(schemaRelationPairElement.pair! == schemaRelationPair)
        instance.createRelatedInstance(schemaRelationPairElement: schemaRelationPairElement
                                       , viewContext: self)
    }
    func createInstance(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let coreDataSchemaEntity : CoreDataSchemaEntity = self.getFetchResultByUUID(uuid: schema.id)
        CoreDataInstanceEntity.createInstance(of: coreDataSchemaEntity, viewContext: self)
    }
    func createRelation(of schema: SchemaEntity, to schemas: Set<SchemaEntity>){
        let coreDataSchemaEntity : CoreDataSchemaEntity = self.getFetchResultByUUID(uuid: schema.id)
        for selectedSchema in schemas{
            let pairCoreDataSchemaEntity : CoreDataSchemaEntity = self.getFetchResultByUUID(uuid: selectedSchema.id)
            coreDataSchemaEntity.createPairedSchema(pair: pairCoreDataSchemaEntity,viewContext: self)
        }
    }
    func createRelation(of schema: SchemaEntity){
        //dataSource.instanceEntities.append(.init(id: UUID(), schemaID: schema.id))
        let coreDataSchemaEntity : CoreDataSchemaEntity = self.getFetchResultByUUID(uuid: schema.id)
        coreDataSchemaEntity.createPairedSchema(viewContext: self)
    }
}
public extension DependencyValues {
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
