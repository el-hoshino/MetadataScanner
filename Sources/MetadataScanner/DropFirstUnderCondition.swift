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
            
            var count = dropCount
            
            upstream.drop { (output) -> Bool in
                
                defer {
                    if count > 0 {
                        count -= 1
                    }
                }
                
                return count > 0 && dropCondition(output)
                
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
