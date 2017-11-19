//
//  AEXMLElement.swift
//  SwiftColorGen
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 19/11/17.
//  Copyright © 2017 Fernando del Rio. All rights reserved.
//

import Foundation

extension AEXMLElement {
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
