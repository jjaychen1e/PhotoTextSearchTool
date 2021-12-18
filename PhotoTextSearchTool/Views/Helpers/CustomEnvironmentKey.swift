//
//  QueryKeywordsKey.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import SwiftUI

private struct QueryKeywordsKey: EnvironmentKey {
    static let defaultValue = ""
}

extension EnvironmentValues {
    var queryKeywords: String {
        get { self[QueryKeywordsKey.self] }
        set { self[QueryKeywordsKey.self] = newValue }
    }
}

private struct IsRegexModeKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isRegexMode: Binding<Bool> {
        get { self[IsRegexModeKey.self] }
        set { self[IsRegexModeKey.self] = newValue }
    }
}

private struct IsMulticonditionModeKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isMulticonditionMode: Binding<Bool> {
        get { self[IsMulticonditionModeKey.self] }
        set { self[IsMulticonditionModeKey.self] = newValue }
    }
}

private struct MulticonditionModeKey: EnvironmentKey {
    static let defaultValue: Binding<MulticonditionMode> = .constant(.and)
}

extension EnvironmentValues {
    var multiconditionMode: Binding<MulticonditionMode> {
        get { self[MulticonditionModeKey.self] }
        set { self[MulticonditionModeKey.self] = newValue }
    }
}
