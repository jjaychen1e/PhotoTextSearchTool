//
//  PhotoGridView.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/17.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Vision

struct PhotoGridView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.queryKeywords) var queryKeywords
    @Environment(\.isRegexMode) var isRegexMode
    @Environment(\.isMulticonditionMode) var isMulticonditionMode
    @Environment(\.multiconditionMode) var multiconditionMode
    
    @FetchRequest var photos: FetchedResults<Photo>
    
    private let isFavorite: Bool
    
    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
        
        let request = Photo.fetchRequest()
        if isFavorite {
            request.predicate = NSPredicate(format: "isFavorite == true")
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Photo.addedAt, ascending: false)]
        
        _photos = FetchRequest(fetchRequest: request)
    }
    
    @State private var selectedPhoto: Photo? = nil
    
    var body: some View {
        let dropDelegate = PhotoFileDropDelegate(managedObjectContext: managedObjectContext, isFavorite: isFavorite)
        
        Group {
            if photos.count == 0 && queryKeywords == "" {
                GeometryReader { _ in
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Drag photos here to add")
                            Spacer()
                        }
                        Spacer()
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 250, maximum: 300))]) {
                        ForEach(photos, id: \.self) { photo in
                            if queryKeywords.contains { $0 != " "} {
                                let filterHelper = FilterHelper(isRegexMode: isRegexMode.wrappedValue, isMulticonditionMode: isMulticonditionMode.wrappedValue, multiconditionMode: multiconditionMode.wrappedValue)
                                let sources = photo.texts?.split(separator: splitMagicCharacter) ?? []
                                let valid =  filterHelper.match(source: sources.map { String($0) }, condition: queryKeywords)
                                if valid {
                                    GridPhotoItemView(photo: photo, selectedPhoto: $selectedPhoto)
                                }
                            } else {
                                GridPhotoItemView(photo: photo, selectedPhoto: $selectedPhoto)
                            }
                        }
                    }
                }
                .contextMenu {
                    Button("Delete All") {
                        photos.forEach { managedObjectContext.delete($0) }
                        try? managedObjectContext.save()
                    }
                }
                .onTapGesture {
                    selectedPhoto = nil
                }
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    managedObjectContext.delete(selectedPhoto!)
                    try? managedObjectContext.save()
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(selectedPhoto == nil)

                Button {
                    photos.forEach { managedObjectContext.delete($0) }
                    try? managedObjectContext.save()
                } label: {
                    Text("Delete All")
                }
                .disabled(photos.count == 0)
            }
            
            ToolbarItemGroup(placement: .automatic) {
                Toggle("Regex", isOn: isRegexMode)
                    .toggleStyle(.button)
                
                Toggle("Multiple Condition", isOn: isMulticonditionMode)
                    .toggleStyle(.button)
                
                Picker("", selection: multiconditionMode) {
                    ForEach(MulticonditionMode.allCases) {
                        Text($0.rawValue.capitalized)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(!isMulticonditionMode.wrappedValue)
            }
        }
        .padding(.all, 8)
        .onDrop(of: !queryKeywords.contains { $0 != " "} ? [.fileURL] : [], delegate: dropDelegate)
    }
}

struct PhotoFileDropDelegate: DropDelegate {
    @State var managedObjectContext: NSManagedObjectContext
    @State var isFavorite: Bool
    
    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.fileURL])
    }

    func performDrop(info: DropInfo) -> Bool {
        DispatchQueue.global().async {
            Task {
                for item in info.itemProviders(for: [.fileURL]) {
                    let urlData = try await item.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil)
                    if let urlData = urlData as? Data {
                        if let url = URL(dataRepresentation: urlData, relativeTo: nil, isAbsolute: true) {
                            let imageData = try Data(contentsOf: url)
                            if let nsImage = NSImage(data: imageData) {
                                let photo = Photo(context: managedObjectContext)
                                photo.addedAt = Date()
                                photo.id = UUID()
                                photo.isFavorite = isFavorite
                                
                                let fileExtension = url.pathExtension != "" ? ".\(url.pathExtension)" : ""
                                let directoryPath = FileManager.default.homeDirectoryForCurrentUser
                                    .appendingPathComponent("SavedPhotos", isDirectory: true)
                                try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                                let filePath = directoryPath
                                    .appendingPathComponent("\(photo.addedAt?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)\(fileExtension)", isDirectory: false)
                                
                                try imageData.write(to: filePath)
                                photo.url = filePath
                                
                                let managedObjectContext = managedObjectContext
                                DispatchQueue.global().async {
                                    do {
                                        if let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                                            let requestHandler = VNImageRequestHandler(cgImage: cgImage)
                                            let textRecofnitionRequest = VNRecognizeTextRequest(completionHandler: { request, error in
                                                if let results = request.results as? [VNRecognizedTextObservation] {
                                                    var texts: [String] = []
                                                    for observation in results {
                                                        let candidate = observation.topCandidates(1)[0]
                                                        if candidate.confidence >= recognitionConfidenceThreshold {
                                                            texts.append(candidate.string)
                                                        }
                                                    }
                                                    let joinedTexts = texts.joined(separator: String(splitMagicCharacter))
                                                    if joinedTexts != "" {
                                                        photo.texts = joinedTexts
                                                        DispatchQueue.main.async {
                                                            try? managedObjectContext.save()
                                                        }
                                                    }
                                                }
                                            })
                                            textRecofnitionRequest.revision = 2
                                            textRecofnitionRequest.recognitionLevel = .accurate
                                            textRecofnitionRequest.usesLanguageCorrection = true
                                            textRecofnitionRequest.usesCPUOnly = false
                                            textRecofnitionRequest.recognitionLanguages = ["zh-Hans", "en-US"]
                                            try requestHandler.perform([textRecofnitionRequest])
                                        }
                                    } catch _ {}
                                }
                            }
                        }
                    }
                }
                
                try managedObjectContext.save()
            }
        }
        
        return true
    }
}
