//
//  utilities.view.swift
//  command buttons
//
//  Created by Luuk Meier on 04/12/2021.
//

import Foundation
import SwiftUI

struct CenterBox<Content: View>: View {
    @ViewBuilder var content: Content;
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .center){
                content;
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxHeight: .infinity)
        
    }
}

struct LabeledField<Label: View, Content: View>: View {
    @ViewBuilder var label: Label;
    @ViewBuilder var content: Content;

    init(label: Label, content: @escaping () -> Content) {
        self.label = label;
        self.content = content();
    }

    var body: some View {
        HStack(alignment: .top) {
            label
                .frame(
                minWidth: 100,
                maxWidth: 200,
                alignment: .trailing
            )
            .multilineTextAlignment(.trailing)
            content
        }
    }
}
