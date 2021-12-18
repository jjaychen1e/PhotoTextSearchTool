//
//  Sidebar.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/17.
//

import SwiftUI

struct Sidebar: View {
    @State private var isDefaultItemActive = true

    var body: some View {
        List {
            Text("Photos")
                .font(.caption)
                .foregroundColor(.secondary)
            NavigationLink(destination: PhotoGridView(isFavorite: false), isActive: $isDefaultItemActive) {
                Label("All", systemImage: "photo")
            }
            NavigationLink(destination: PhotoGridView(isFavorite: true)) {
                Label("Favorite", systemImage: "star.fill")
            }
        }.listStyle(SidebarListStyle())
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
