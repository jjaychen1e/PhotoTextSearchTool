//
//  GridPhotoDetailView.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import Foundation
import SwiftUI
import Vision

struct GridPhotoDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.queryKeywords) var queryKeywords
    @Environment(\.isRegexMode) var isRegexMode
    @Environment(\.isMulticonditionMode) var isMulticonditionMode
    @Environment(\.multiconditionMode) var multiconditionMode
    
    @State var photo: Photo
    @State private var displayResults: [DisplayResult] = []
    
    private struct DisplayResult: Identifiable {
        let id = UUID()
        
        var topLeft: CGPoint
        var topRight: CGPoint
        var bottomLeft: CGPoint
        var bottomRight: CGPoint
        var result: String
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: photo.url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            GeometryReader { geo in
                                ForEach(displayResults) { result in
                                    let filterHelper = FilterHelper(isRegexMode: isRegexMode.wrappedValue, isMulticonditionMode: isMulticonditionMode.wrappedValue, multiconditionMode: multiconditionMode.wrappedValue)
                                    let valid =  filterHelper.match(source: result.result, condition: queryKeywords)
                                    
                                    Path { path in
                                        path.move(to: CGPoint(x: result.topLeft.x * geo.size.width, y: geo.size.height - result.topLeft.y * geo.size.height))
                                        path.addLine(to: CGPoint(x: result.topRight.x * geo.size.width, y: geo.size.height - result.topRight.y * geo.size.height))
                                        path.addLine(to: CGPoint(x: result.bottomRight.x * geo.size.width, y: geo.size.height - result.bottomRight.y * geo.size.height))
                                        path.addLine(to: CGPoint(x: result.bottomLeft.x * geo.size.width, y: geo.size.height - result.bottomLeft.y * geo.size.height))
                                        path.addLine(to: CGPoint(x: result.topLeft.x * geo.size.width, y: geo.size.height - result.topLeft.y * geo.size.height))
                                    }
                                    .stroke(valid ? Color.red : Color.accentColor, lineWidth: valid ? 2.0 : 1.0)
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.global().async {
                                do {
                                    if let nsImage = NSImage(contentsOf: photo.url!),
                                       let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                                        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
                                        let textRecofnitionRequest = VNRecognizeTextRequest(completionHandler: { request, error in
                                            if let results = request.results as? [VNRecognizedTextObservation] {
                                                for observation in results {
                                                    let candidate = observation.topCandidates(1)[0]
                                                    if candidate.confidence >= recognitionConfidenceThreshold {
                                                        displayResults.append(.init(topLeft: observation.topLeft,
                                                                                    topRight: observation.topRight,
                                                                                    bottomLeft: observation.bottomLeft,
                                                                                    bottomRight: observation.bottomRight,
                                                                                    result: candidate.string))
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
                } placeholder: {
                    ProgressView()
                }
                
                if let texts = photo.texts {
                    TagView(models: texts.split(separator: splitMagicCharacter).sorted { $0 > $1 }.unique()) { text in
                        let filterHelper = FilterHelper(isRegexMode: isRegexMode.wrappedValue, isMulticonditionMode: isMulticonditionMode.wrappedValue, multiconditionMode: multiconditionMode.wrappedValue)
                        let valid =  filterHelper.match(source: String(text), condition: queryKeywords)
                        
                        Text(text)
                            .lineLimit(1)
                            .padding(.all, 4)
                            .border(valid ? Color.red : Color.accentColor, width: valid ? 2.0 : 1.0)
                    }
                } else {
                    Text("No text found.")
                }
            }
            .padding(.vertical)
        }
    }
}
