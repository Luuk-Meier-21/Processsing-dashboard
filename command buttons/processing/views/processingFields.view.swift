//
//  processingFields.swift
//  command buttons
//
//  Created by Luuk Meier on 22/11/2021.
//

import Foundation
import SwiftUI

struct ProcessingFieldView: View {
    @EnvironmentObject var settings: JSONStorage<SketchSettings>;
    @EnvironmentObject var sketchData: JSONStorage<ProcessingData>;
//    @Binding var data: ProcessingData;

    var body: some View {
        ScrollView {
            Form {
                Section(header: Text("Sketch data")) {
                    LabeledField(label: Text("test")) {
                        Text("testa")
                    }
                    loopFields(sketchData.data.fields);
                }
                Divider();
                Section(header: Text("Settings")) {
                    LabeledField(label: Text("Preferred IDE")) {
                        SelectAppView(value: $settings.data.preferredProgram, selectPanel: .selectProgram)
                    }
                    LabeledField(label: Text("Source code")) {
                        ProcessingSourceView();
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder func loopFields(_ fields: [ProcessingDataField]) -> some View {
        ForEach(Array(sketchData.data.fields.enumerated()), id: \.element.id) { index, field in
            buildField(field: field, binding: $sketchData.data.fields[index]);
        }.padding(.bottom, 2)
    }
    
    @ViewBuilder func buildField(field: ProcessingDataField, binding: Binding<ProcessingDataField>) -> some View {
        switch field.value.raw {
            case .string(_):
                nilSafeBinding(binding.value.string) { binding in
                    LabeledField(label: Text(field.label)) {
                        TextField("placeholder", text: binding)
                    }
                }
//            case .int(_):
//                nilSafeBinding(binding.value.int) { int in
//                    LabeledField(label: Text(field.label)) {
//                        NumberField(float: int)
//                    }
//                    
//                }
            case .size(_):
                nilSafeBinding(binding.value.size) { size in
                    LabeledField(label: Text(field.label)) {
                        ProcessingSizeView(sketchSize: size)
                    }
                    
//                    Button(action: {
//                        size.w.wrappedValue = 50;
//                        print(size.w.wrappedValue)
//                    }) {
//                        Text("\(size.w.wrappedValue)")
//                    }
                }
            case .stringSelection(_):
                Text("dfa")
//                ProcessingSizeView();
        default:
            EmptyView();
        }
    }
    
    @ViewBuilder func nilSafeBinding<T, VT: View>(_ binding: Binding<T?>, onValid: (_ binding: Binding<T>) -> VT) -> some View {
        if let optionalBinding = Binding(binding) {
            onValid(optionalBinding)
        } else {
            ErrorView(message: "Binding: \(binding) is nil")
        }
    }
    
    struct ErrorView: View {
        @State var isVisible = true;
        var message: String;
        
        var body: some View {
            Text("Error")
//            ScrollView {
//                HStack {
//                    Text("Error: \(message)")
//                        .fontWeight(.light)
//                    Button(action: {
//
//                    }) {
//                        Image(systemName: "x.circle")
//                            .foregroundColor(Color(NSColor.systemRed))
//                    }
//                        .background(Color.clear)
//                        .mask(Circle())
//                        .frame(maxWidth: 15)
//                }
//                    .foregroundColor(Color(NSColor.systemRed))
//                    .padding(.horizontal)
//                    .padding(.vertical, 1)
//                    .border(Color(NSColor.systemRed), width: 1)
//                    .cornerRadius(2)
//                    .background(Color(NSColor.systemRed).opacity(0.25))
//            }
//            .padding(.top, 1)
        }
        
        func test() {
            
        }
    }
}
