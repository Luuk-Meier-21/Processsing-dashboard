//
//  InputField.swift
//
//  Created by Luuk Meier on 23/09/2021.
//

import Foundation
import SwiftUI
import Combine

struct NumberField: View {
    @Binding var float: CGFloat;
    @State private var floatString: String  = "";
    var onValueChange: ((CGFloat) -> Void)?;
    
    var body: some View {
        TextField("", text: $floatString)
            .onReceive(Just(floatString)) { value in
                if let f = Float(value) {
                    let newValue = CGFloat(f)
                    if newValue != float {
                        if onValueChange != nil {
                            onValueChange!(float)
                        }
                    }
                    float = newValue;
                }
                else { floatString = "\(Int(float))" }
            }
            .onAppear(perform: {
                floatString = "\(Int(float))"
            })
    }
    
    
}

extension GeometryProxy {
    func safeWidthValue(min: CGFloat = 100,  _ calc: (_ width: CGFloat) -> CGFloat) -> CGFloat {
        let maxValue = calc(self.size.width);
        let minValue = min;
        let range = minValue...self.size.width;
        if range.contains(maxValue) {
            print(maxValue)
            return maxValue;
        } else {
            print(minValue)
            return minValue;
        }
    }
}

