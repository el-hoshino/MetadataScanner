//
//  DropFirstUnderCondition.swift
//
//
//  Created by 史 翔新 on 2021/03/20.
//

import Foundation
import Combine

extension Publishers {
    
    struct DropFirstUnderCondition<Upstream: Publisher>: Publisher {
        
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        let upstream: Upstream
        var dropCondition: (Output) -> Bool
        var dropCount: Int
        
        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            
            var remained = dropCount
            
            upstream.drop { (output) -> Bool in
                
                defer {
                    if remained > 0 {
                        remained -= 1
                    }
                }
                
                return remained > 0 && dropCondition(output)
                
            }
            .subscribe(subscriber)
            
        }
        
    }
    
}

extension Publisher {
    
    func dropFirst(_ n: Int = 1, if shouldDrop: @escaping (Output) -> Bool) -> Publishers.DropFirstUnderCondition<Self> {
        
        return .init(upstream: self, dropCondition: shouldDrop, dropCount: n)
        
    }
    
}
