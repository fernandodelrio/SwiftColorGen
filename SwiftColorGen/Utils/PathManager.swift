//
//  PathManager.swift
//  SwiftColorGen
//
//  Created by Fernando Del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

struct PathManager {
    // Filter storyboard files, avoid messing with code
    //   inside Cocoa Pods, Carthage and Swift PM
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
