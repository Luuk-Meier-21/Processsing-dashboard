//
//  dispatch.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation

class Queue {
    enum QueueError: Error {
        case DispatchWorkItem
    }
    
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
