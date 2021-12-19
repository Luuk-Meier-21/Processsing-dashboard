//
//  processingSize.swift
//  command buttons
//
//  Created by Luuk Meier on 23/11/2021.
//

import Foundation
import SwiftUI

struct ProcessingSizeView: View {
    @Binding var sketchSize: Size;
    @EnvironmentObject var processingCore: JSONStorage<ProcessingData>;
//    @StateObject var size: Size = Size(600, 400);
    var maxSize: Size = Size(200, 200);

    var body: some View {
        GroupBox {
            HStack {
                aspectBox(size: sketchSize, windowSize: maxSize) {
                    VStack {
                        Text("Sketch Window").foregroundColor(Color(NSColor.placeholderTextColor))
                        Text("\(Int(sketchSize.w)) ") + Text(Image(systemName: "multiply")) + Text(" \(Int(sketchSize.h))")
                    }
                }.frame(width: maxSize.w, height: maxSize.h)
                Spacer();
                VStack {
                    LabeledField(label: Text("Width")) {
                        NumberField(float: $sketchSize.w) { value in
                            processingCore.save(object: processingCore.data)
                        };
                    }
                    LabeledField(label: Text("Height")) {
                        NumberField(float: $sketchSize.h) { value in
                            processingCore.save(object: processingCore.data)
                        };
                    }
                }
                Spacer();

            }
            
        }
        
        .groupBoxStyle(BorderedGroupStyle())
    }
    
    @ViewBuilder func aspectBox<Content: View>(size: Size, windowSize: Size, content: () -> Content) -> some View {
        let ratio = CGSize(
            width: size.w,
            height: size.h
        )
        
        VStack {
            Group {
                CenterBox {
                    content()
                }.frame(minWidth: 50)
            }
            .aspectRatio(ratio, contentMode: .fit)
            .background(Color(NSColor.separatorColor))
            .cornerRadius(5)
            .padding(5)
        }
        .frame(width: maxSize.w, height: maxSize.h)
    }
}
