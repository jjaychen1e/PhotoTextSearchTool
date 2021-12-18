//
//  SwiftUIView.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var selection = MulticonditionMode.and
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(MulticonditionMode.allCases) {
                    Text($0.rawValue.capitalized)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            
            Text("Selected color: \(selection.rawValue)")
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
