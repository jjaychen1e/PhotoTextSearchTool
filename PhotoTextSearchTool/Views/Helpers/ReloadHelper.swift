//
//  ReloadHelper.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import SwiftUI

class ReloadHelper: ObservableObject {
    func reloadView() {
        objectWillChange.send()
    }
}

