//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//
import Foundation
import dBrainFeature
import CoreData

public extension CoreDataInstanceEntity{
    struct Converter{
        public var instanceEntity : InstanceEntity{
            return .init(id: item.id!, schemaID: item.schemaID, isSelected: item.isSelected)
        }
        
        public typealias T = CoreDataInstanceEntity
        var item : T
        public init(item: T) {
            self.item = item
        }
        
        
    }
    var converter: Converter{
        return .init(item: self)
    }
    struct CytoscapeConverter{
        public var instanceNode : InstanceNode{
            if item.isSelected{
                return .init(data: .init(id: item.id!.uuidString), classes: "\(item.schema!.name!) selected" )
            }
            else{
                return .init(data: .init(id: item.id!.uuidString), classes: item.schema!.name!)
            }
        }
        public var cytoscape: Cytoscape{
            return .init(instanceNode: instanceNode)
        }
        
        public typealias T = CoreDataInstanceEntity
        var item : T
        public init(item: T) {
            self.item = item
        }
        
        public static func getConnected(selectedNodes:[T],relationFilterType: CoreDataSchemaEntity.RelationFilterType = .union)->[T]{
            var result : Set<CoreDataInstanceEntity>? = nil
            for n in selectedNodes{
                if var subResult = n.getRelatedInstance(){
                    //print("subResult",n.id!.uuidString, subResult.count)
                    subResult.append(n)
                    switch relationFilterType{
                    case .union:
                        result = result?.union(subResult) ?? .init(subResult)
                    case .intersection:
                        //result = result.intersection(subResult)
                        result = result?.intersection(subResult) ?? .init(subResult)
                    }
                    //print(relationFilterType, result?.count)
                }
            }
            return result?.map({$0}) ?? []
        }
    }
    var cytoscapeConverter: CytoscapeConverter{
        return .init(item: self)
    }
}
