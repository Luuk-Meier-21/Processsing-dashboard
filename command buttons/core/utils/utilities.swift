//
//  utilities.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation
import SwiftUI


// does not want 
class Size: Codable {
    var w: CGFloat;
    var h: CGFloat;
    var min: Size?;
    var max: Size?;
    
    init(_ w: CGFloat, _ h: CGFloat) {
        self.w = w;
        self.h = h;
    }
    
    init(size: CGSize) {
        self.w = size.width;
        self.h = size.height;
    }
    
    func encode(to encoder: Encoder) throws {
        print("encode", self.w)
        var container = encoder.container(keyedBy: CodingKeys.self);
        try container.encode(self.w, forKey: .w);
        try container.encode(self.h, forKey: .h);
    }
    
    enum CodingKeys: String, CodingKey, Codable {
        case w,
             h
    }
}

class Range {
    var min: CGFloat;
    var max: CGFloat;
    var range: ClosedRange<CGFloat>;
    
    init(min: CGFloat, max: CGFloat) {
        self.min = min;
        self.max = max > min ? max : min + 10;
        self.range = self.min...self.max;
    }
    
    func within(_ value: CGFloat) -> CGFloat {
        if range.contains(value) {
            // Within
            return value;
        } else if value < min {
            // Under
            return min;
        } else if value > max {
            // Over
            return max;
        } else {
            return max;
        }
    }
}

//class Ratio: Codable {
//    var w: CGFloat;
//    var h: CGFloat;
//    var maxW: CGFloat;
//    var maxH: CGFloat;
//    
//    init(size: Size, maxSize: Size) {
//        self.w = size.w;
//        self.h = size.h;
//        self.maxW = maxSize.maxW;
//        self.maxH = maxSize.maxH;
//    }
//}

class Selection<T: Codable>: Codable {
    var array: [T];
    
    init(_ array: [T]) {
        self.array = array;
    }
}

class ObservableContainer<T>: ObservableObject {
    @Published var data: T;
    
    init(_ data: T) {
        self.data = data;
    }
}
