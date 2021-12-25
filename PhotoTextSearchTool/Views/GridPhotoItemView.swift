//
//  GridPhotoItemView.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import SwiftUI

struct GridPhotoItemView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var photo: Photo
    @Binding var selectedPhoto: Photo?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var body: some View {
        NavigationLink(tag: photo, selection: $selectedPhoto) {
            GridPhotoDetailView(photo: photo)
        } label: {
            VStack {
                AsyncImage(url: photo.url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 15))
                        .foregroundColor(Color.yellow)
                        .opacity(photo.isFavorite ? 1.0 : 0.0)
                        .padding(.all, 4)
                }
                
                Text(photo.addedAt == nil ? "Unknown" : dateFormatter.string(from: photo.addedAt!))
                    .font(.system(size: 12).weight(.medium))
            }
            .background(.black.opacity(0.001))
            .padding(.vertical, 2)
            .border(Color.accentColor, width: photo == selectedPhoto ? 2.0 : 0.0)
            .contextMenu {
                Button(photo.isFavorite ? "Remove from Favorite" : "Add to Favorite") {
                    photo.isFavorite.toggle()
                    try? managedObjectContext.save()
                }
                
                Button("Delete photo") {
                    managedObjectContext.delete(photo)
                }
            }
            .onTapGesture {
                selectedPhoto = nil
                // One frame later..
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 / 60.0) {
                    selectedPhoto = photo // I don't know why, SwiftUI sucks.
                }
            }
        }
        .buttonStyle(.plain)
    }
}
