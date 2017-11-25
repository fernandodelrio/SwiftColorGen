//
//  PathManager.swift
//  SwiftColorGen
//
//  Created by Fernando Del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

struct PathManager {
    static func isValidColorset(path: String) -> Bool {
        return path.hasSuffix(".colorset")
    }
    
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
    
    static func isValidAssetsFolder(path: String) -> Bool {
        guard path.hasSuffix(".xcassets") || path.hasSuffix(".xcassets/")  else {
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
    
    static func getAssetsFolder() -> String? {
        let cwd = FileManager.default.currentDirectoryPath
        let enumerator = FileManager.default.enumerator(atPath: cwd)
        while let path = enumerator?.nextObject() as? String {
            if PathManager.isValidAssetsFolder(path: path) {
                return path
            }
        }
        return nil
    }
    
    static func convertToAbsolutePath(_ path: String) -> String {
        if isAbsolute(path: path) {
            return path
        }
        let path = path.hasSuffix("/") ? String(path.prefix(path.count-1)) : path
        let cwd = FileManager.default.currentDirectoryPath
        return "\(cwd)/\(path)"
    }
    
    static func replaceCurrentPath(_ path: String) -> String {
        return path.replacingCharacters(in: path.startIndex...path.startIndex,
                                        with: FileManager.default.currentDirectoryPath)
    }
    
    static func isAbsolute(path: String) -> Bool {
        return path.hasPrefix("/") || path.hasPrefix(".")
    }
}
