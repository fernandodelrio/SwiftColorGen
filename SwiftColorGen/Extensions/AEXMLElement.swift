//
//  AEXMLElement.swift
//  SwiftColorGen
//
//  Created by Fernando del Rio (fernandomdr@gmail.com) on 19/11/17.
//

import Foundation

extension AEXMLElement {
    // Get a AEXMLElement, filtering by the name
    // and optionally by attributes
    func getChild(name: String,
                  attributes: [String:String] = [:]) -> AEXMLElement? {
        for child in children {
            if child.name != name {
                continue
            }
            var match = true
            for (key, value) in attributes {
                if self.attributes[key] != value {
                    match = false
                }
            }
            if match {
                return child
            }
        }
        return nil
    }
}
