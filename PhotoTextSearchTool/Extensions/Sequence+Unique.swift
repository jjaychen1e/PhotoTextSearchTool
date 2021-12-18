//
//  Sequence+Unique.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
