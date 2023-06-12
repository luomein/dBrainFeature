//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/10.
//

import Foundation
import dBrainFeature
import CoreData
import IdentifiedCollections

public extension CoreDataInstanceRelationPair{
    struct Converter{
        
        public var instanceRelationPairElements : IdentifiedArrayOf< InstanceRelationPairElement >{
            return .init(uniqueElements:  item.coreDataInstanceRelationPairElements!.map({$0.converter.instanceRelationPairElement}) )
        }
        public var instanceRelationPair : InstanceRelationPair{
            return .init(id: item.id!, elements: instanceRelationPairElements, schemaID: item.schema!.id!)
        }
        
        public typealias T = CoreDataInstanceRelationPair
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var converter: Converter{
        return .init(item: self)
    }
    struct CytoscapeConverter{
        public var instanceRelationPairEdge : InstanceRelationPairEdge{
            return .init(data: .init(id: item.id!.uuidString, source: item.coreDataInstanceRelationPairElements![0].instance!.id!.uuidString
                                     , target: item.coreDataInstanceRelationPairElements![1].instance!.id!.uuidString))
        }
        public var cytoscape: Cytoscape{
            return .init(instanceRelationPairEdge: instanceRelationPairEdge)
        }
        public typealias T = CoreDataInstanceRelationPair
        var item : T
        public init(item: T) {
            self.item = item
        }
    }
    var cytoscapeConverter: CytoscapeConverter{
        return .init(item: self)
    }
}
