//
//  processingStyle.swift
//  command buttons
//
//  Created by Luuk Meier on 09/11/2021.
//

import Foundation
import SwiftUI

protocol RGB {
    var r: Int { get };
    var g: Int { get };
    var b: Int { get };
}

class RGBColor: RGB {
    var r: Int = 0;
    var g: Int = 0;
    var b: Int = 0;
    
    init(_ r: Int, _ g: Int, _ b: Int) {
        self.r = withinRange(r);
        self.g = withinRange(g);
        self.b = withinRange(b);
    }
    
    func withinRange(_ val: Int) -> Int {
        do {
            if (val <= 0 && val >= 255) {
                return val;
            } else {
                throw RangeError.valueOutOfRange(val);
            }
        } catch {
            print(error);
            return 0;
        }
    }
    
    enum RangeError: Error {
        case valueOutOfRange(_ val: Int);
    }
 }

struct BorderedGroupStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding(5)
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  alignment: .topLeading
                )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 1)
            )
            .background(Color(NSColor.black).opacity(0.1))
            
    }
}

