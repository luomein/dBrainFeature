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
}
