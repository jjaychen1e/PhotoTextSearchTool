//
//  MulticonditionMode.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import Foundation

enum MulticonditionMode: String, CaseIterable, Identifiable {
    case and
    case or
    
    var id: String { self.rawValue }
}
