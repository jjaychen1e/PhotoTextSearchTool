//
//  PhotoTextSearchToolApp.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/16.
//

import SwiftUI

@main
struct PhotoTextSearchToolApp: App {
    let persistenceController = PersistenceController()
    
    @State private var queryKeywords = ""
    @State private var isRegexMode = false
    @State private var isMulticonditionMode = false
    @State private var multiconditionMode: MulticonditionMode = .and

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .searchable(text: $queryKeywords, prompt: "Search")
                .environment(\.queryKeywords, queryKeywords)
                .environment(\.isRegexMode, $isRegexMode)
                .environment(\.isMulticonditionMode, $isMulticonditionMode)
                .environment(\.multiconditionMode, $multiconditionMode)
        }
    }
}
