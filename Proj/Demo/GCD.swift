//
//  GCD.swift
//  Demo
//
//  Created by xxxAIRINxxx on 2016/08/04.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

struct GCD {
    
    private init() {}
    
    enum `Type` {
        case async(queue: GCD.Queue)
        case sync(queue: GCD.Queue)
        case after(second: Double, queue: GCD.Queue)
        case barrierAsync(queue: GCD.Queue)
        case barrierSync(queue: GCD.Queue)
        case group(taskQueue: GCD.Queue, tasks: [(() -> Void)], timeout: Double)
        case groupNotify(taskQueue: GCD.Queue, tasks: [(() -> Void)], completionQueue: GCD.Queue, completion: (() -> Void))
    }
    
    enum Queue {
        case main
        case background
        case userInteractive
        case userInitiated
        case utility
        case `default`
        case cosutom(queue: DispatchQueue)
        
        var raw : DispatchQueue {
            switch self {
            case .main:
                return DispatchQueue.main
            case .background:
                return DispatchQueue.global(qos: .background)
            case .userInteractive:
                return DispatchQueue.global(qos: .userInitiated)
            case .userInitiated:
                return DispatchQueue.global(qos: .userInitiated)
            case .utility:
                return DispatchQueue.global(qos: .utility)
            case .default:
                return DispatchQueue.global(qos: .default)
            case .cosutom(let queue):
                return queue
            }
        }
    }
    
    static func dispatch(type :Type, _ block: @escaping () -> Void) {
        switch type {
        case .async(let queue):
            queue.raw.async { block() }
        case .sync(let queue):
            queue.raw.sync { block() }
        case .after(let second, let queue):
            queue.raw.asyncAfter(deadline: self.afterTime(second: second)) {
                block()
            }
        case .barrierAsync(let queue):
            queue.raw.async(flags: .barrier) { block() }
        case .barrierSync(let queue):
            queue.raw.sync(flags: .barrier) { block() }
        case .group(let taskQueue, let tasks, let timeout):
            let group = DispatchGroup()
            
            tasks.forEach() { task in
                group.enter()
                taskQueue.raw.async {
                    task()
                    group.leave()
                }
            }
            
            _ = group.wait(timeout: self.afterTime(second: timeout))
        case .groupNotify(let taskQueue, let tasks, let completionQueue, let completion):
            let group = DispatchGroup()
            
            tasks.forEach() { task in
                group.enter()
                taskQueue.raw.async {
                    task()
                    group.leave()
                }
            }
            
            group.notify(queue: completionQueue.raw) { completion() }
        }
    }
    
    private static func afterTime(second: Double) -> DispatchTime {
        return DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}
