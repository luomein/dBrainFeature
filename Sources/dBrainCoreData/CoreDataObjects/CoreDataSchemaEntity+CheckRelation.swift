//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/11.
//

import Foundation
import CoreData
import IdentifiedCollections

public extension CoreDataSchemaEntity{
    var isBreaker: Bool{
        if let hasSelectedInstance = self.coreDataInstanceEntities?.first(where: {$0.isSelected}){
            return true
        }
        return false
    }
    public enum RelationFilterType{
        case union
        case intersection
    }
    func listRelatedInstance(criteria: IdentifiedArrayOf<CoreDataInstanceEntity>, includingSelfFilterCriteria: Bool, relationFilterType: RelationFilterType = .union, includeCriteriaNodes : Bool = true)->[CoreDataInstanceEntity]{
        var result : Set<CoreDataInstanceEntity>? = nil
        let filteredCriteria = criteria.filter {
            if !includingSelfFilterCriteria && $0.schema! == self{return false}
            else{return true}
        }
        
        for c in filteredCriteria{
            if var relatedInstance = c.getRelatedInstance()?.filter({$0.schema! == self}){
                if includeCriteriaNodes && (c.schema! == self){
                    relatedInstance.append(c)
                }
                switch relationFilterType{
                case .union:
                    result = result?.union(relatedInstance) ?? .init(relatedInstance)
                case .intersection:
                    result = result?.intersection(relatedInstance) ?? .init(relatedInstance)
                }
            }
        }
        return result?.map({$0}) ?? []
    }
    func hasRelationWithSchema(schema: CoreDataSchemaEntity, checkedPath : [CoreDataSchemaRelationPairElement] = [], includeSelfRelation: Bool)->Bool{
        //print("checkedPath", checkedPath)
        //print(self, self.coreDataSchemaRelationPairElements?.count)
        if !includeSelfRelation && schema==self{
            return false
        }
        if checkedPath.map({$0.schema!}).contains(self){
            //print("duplicated")
            return false
        }
        var checkedPath = checkedPath
        if let elements = self.coreDataSchemaRelationPairElements{
            for element in elements{
                let pairedSchema = element.getPairedElement().schema!
                if checkedPath.map({$0.schema!}).contains(pairedSchema){
                    //print("duplicated")
                    continue
                }
                else if pairedSchema == schema{
                    if schema==self{
                        if includeSelfRelation{
                            return true
                        }
                        else{fatalError()}
                    }
                    else{
                        return true
                    }
                }
                else{
                    checkedPath.append(element)
                    if pairedSchema.hasRelationWithSchema(schema: schema, checkedPath: checkedPath, includeSelfRelation: false){return true}
                }
            }
        }
        return false
    }
    
}
