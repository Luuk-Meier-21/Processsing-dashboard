//
//  ContentView.swift
//  command buttons
//
//  Created by Luuk Meier on 03/11/2021.
//

import SwiftUI

struct ContentView: View {
  
    let bash = Bash();
    
    var body: some View {
        VStack {
            ProcessingDataView();
        }.frame(
            minWidth: 600,
            minHeight: 200,
            maxHeight: .infinity
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
