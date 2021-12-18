//
//  ContentView.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Sidebar()
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: toggleSidebar) {
                            Image(systemName: "sidebar.left")
                                .help("Toggle Sidebar")
                        }
                    }
                }
            Text("No Sidebar Selection") // You won't see this in practice (default selection)
            Text("No Photo Selection") // You won't see this in practice (default selection)
        }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
