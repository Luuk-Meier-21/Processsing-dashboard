//
//  dispatch.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation

class Queue {
    /// The Queue class and it method `execute()` allow for an easy way to execute functions on a separate thread.
    
    enum QueueError: Error {
        case DispatchWorkItem
    }
    
    /// `execute()` executes whatever is given to its closure `onAsync()` as long as it does not return a type.
    static func execute(onAsync: @escaping () -> Void) {
        let item = DispatchWorkItem {
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .userInteractive)
            dispatchQueue.async {
                onAsync()
            }
        }
        DispatchQueue.global().async(execute: item)
    }
}
