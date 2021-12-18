//
//  FilterHelper.swift
//  PhotoTextSearchTool
//
//  Created by 陈俊杰 on 2021/12/18.
//

import Foundation


struct FilterHelper {
    
    let isRegexMode: Bool
    let isMulticonditionMode: Bool
    let multiconditoinMode: MulticonditionMode
    
    init(isRegexMode: Bool, isMulticonditionMode: Bool, multiconditionMode: MulticonditionMode) {
        self.isRegexMode = isRegexMode
        self.isMulticonditionMode = isMulticonditionMode
        self.multiconditoinMode = multiconditionMode
    }
    
    func match(source: [String], condition: String) -> Bool {
        if condition == "" {
            return true
        }
        
        let source = source.map { $0.localizedLowercase }
        let condition = condition.localizedLowercase
        
        if isMulticonditionMode {
            let conditions = condition.split(separator: " ")
            
            if isRegexMode {
                var result = false
                for condition in conditions {
                    result = source.contains { str in
                        str.range(of: condition, options: .regularExpression) != nil
                    }
                    
                    if multiconditoinMode == .and {
                        if result == false {
                            return false
                        }
                    } else {
                        if result == true {
                            return true
                        }
                    }
                }
                
                if multiconditoinMode == .and {
                    return true
                } else {
                    return false
                }
            } else {
                var result = false
                for condition in conditions {
                    result = source.contains { str in
                        str.contains(condition)
                    }
                    if multiconditoinMode == .and {
                        if result == false {
                            return false
                        }
                    } else {
                        if result == true {
                            return true
                        }
                    }
                }
                
                if multiconditoinMode == .and {
                    return true
                } else {
                    return false
                }
            }
        } else {
            if isRegexMode {
                return source.contains { str in
                    str.range(of: condition, options: .regularExpression) != nil
                }
            } else {
                return source.contains { str in
                    str.contains(condition)
                }
            }
        }
    }
    
    func match(source: String, condition: String) -> Bool {
        if condition == "" {
            return false
        }
        
        let source = source.localizedLowercase
        let condition = condition.localizedLowercase
        
        if isMulticonditionMode {
            let conditions = condition.split(separator: " ")
            
            if isRegexMode {
                for condition in conditions {
                    if source.range(of: condition, options: .regularExpression) != nil {
                        return true
                    }
                }
                
                return false
            } else {
                for condition in conditions {
                    if source.contains(condition) == true {
                        return true
                    }
                }
                
                return false
            }
        } else {
            if isRegexMode {
                return source.range(of: condition, options: .regularExpression) != nil
            } else {
                return source.contains(condition)
            }
        }
    }
}
