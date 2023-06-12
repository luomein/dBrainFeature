//
//  File.swift
//  
//
//  Created by MEI YIN LO on 2023/6/11.
//

import Foundation
import CoreData

public extension CoreDataInstanceEntity{

    
    
    func getRelatedInstance(
                             checkedPath : [CoreDataInstanceRelationPairElement]=[]
    )->[CoreDataInstanceEntity]?{
        guard self.isSelected else {return nil}
        if checkedPath.map({$0.instance!}).contains(self){
            return nil
        }
        var checkedPath = checkedPath
        var result : Set<CoreDataInstanceEntity> = []
        if let elements = self.coreDataInstanceRelationPairElement{
            //print(elements.count)
            for element in elements {
                let pairedInstance = element.getPairedElement().instance!
                //print(pairedInstance.schema?.name!)
                assert(pairedInstance != self)
                if checkedPath.map({$0.instance!}).contains(pairedInstance){
                    continue
                }
                else if result.contains(pairedInstance){
                    continue
                }
                result.insert(pairedInstance)
                checkedPath.append(element)
                if pairedInstance.schema!.isBreaker{
                    continue
                }
                else if let subResult = pairedInstance.getRelatedInstance(checkedPath: checkedPath){
                    result = result.union(subResult)
                }
            }
        }
        return (result.count == 0) ? nil : result.map({$0})
    }
//    func getRelatedInstance(of schema: CoreDataSchemaEntity
//                            ,checkedPath : [CoreDataInstanceRelationPairElement]=[]
//                            ,excludedPathInstance: [CoreDataInstanceEntity] = [] )->[CoreDataInstanceEntity]?{
//        if checkedPath.map({$0.instance!}).contains(self){
//            return nil
//        }
//        var checkedPath = checkedPath
//        var result : Set<CoreDataInstanceEntity> = []
//        if let elements = self.coreDataInstanceRelationPairElement{
//            //print(elements.count)
//            for element in elements {
//                let pairedInstance = element.getPairedElement().instance!
//                //print(pairedInstance.schema?.name!)
//                assert(pairedInstance != self)
//                if checkedPath.map({$0.instance!}).contains(pairedInstance){
//                    continue
//                }
//                else if result.contains(pairedInstance){
//                    continue
//                }
//                else if pairedInstance.schema! == schema{
//                    //result.append(pairedInstance)
//                    //print(result.count)
//                    result.insert(pairedInstance)
//                    //print(result.count)
//                }
//                checkedPath.append(element)
//                if excludedPathInstance.contains(where: {$0 == pairedInstance}){
//                    continue
//                }
//                else if let subResult = pairedInstance.getRelatedInstance(of: schema, checkedPath: checkedPath,excludedPathInstance:excludedPathInstance){
//                    //result.append(contentsOf: subResult)
//                    result = result.union(subResult)
//                }
//            }
//        }
//        return (result.count == 0) ? nil : result.map({$0})
//    }
}
