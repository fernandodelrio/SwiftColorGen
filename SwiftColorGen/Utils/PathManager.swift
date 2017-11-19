//
//  PathManager.swift
//  SwiftColorGen
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 19/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

struct PathManager {
    static func isValidStoryboard(path: String) -> Bool {
        guard path.hasSuffix(".storyboard") else {
            return false
        }
        guard !path.contains("Packages/") else {
            return false
        }
        guard !path.contains(".build/") else {
            return false
        }
        guard !path.contains("Pods/") else {
            return false
        }
        guard !path.contains("Carthage/") else {
            return false
        }
        return true
    }
    
    static func isAbsolute(path: String) -> Bool {
        return path.hasPrefix("/")
    }
}
