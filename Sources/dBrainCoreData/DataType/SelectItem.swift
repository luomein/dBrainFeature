//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/4.
//

import Foundation

public struct SelectItem{
    public var coreDataSchemaEntity : CoreDataSchemaEntity?
    public var coreDataInstanceEntity : CoreDataInstanceEntity?
    public var coreDataSchemaRelationPairElement : CoreDataSchemaRelationPairElement?
    public var coreDataInstanceRelationPairElement: CoreDataInstanceRelationPairElement?
    
    public enum  SetSelectItemByType{
        case coreDataSchemaEntity(CoreDataSchemaEntity)
        case coreDataInstanceEntity(CoreDataInstanceEntity)
        case coreDataSchemaRelationPairElement(CoreDataSchemaRelationPairElement)
        case coreDataInstanceRelationPairElement(CoreDataInstanceRelationPairElement)
    }
    
    public static func setValue(setSelectItemByType: SetSelectItemByType, selectItem: SelectItem)->SelectItem{
        var selectItem = selectItem
        switch setSelectItemByType{
        case .coreDataInstanceEntity(let value):
            selectItem.coreDataInstanceEntity = value
        case .coreDataSchemaRelationPairElement(let value):
            selectItem.coreDataSchemaRelationPairElement = value
        case .coreDataInstanceRelationPairElement(let value):
            selectItem.coreDataInstanceRelationPairElement = value
        case .coreDataSchemaEntity(let value):
            selectItem.coreDataSchemaEntity = value
        }
        return selectItem
    }
}
