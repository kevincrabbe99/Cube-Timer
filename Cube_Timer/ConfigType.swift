//
//  ConfigType.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation

enum ConfigType {
    case a2x2x2, a3x3x3, a4x4x4, a5x5x5, a6x6x6
    
    func getType() -> String {
        if self == .a2x2x2 {
            return "2x2x2"
        } else if self == .a3x3x3 {
            return "3x3x3"
        } else if self == .a4x4x4 {
            return "4x4x4"
        } else if self == .a5x5x5 {
            return "5x5x5"
        } else if self == .a6x6x6 {
            return "6x6x6"
        }
        return ""
    }
}


enum ConfigBrand {
    case rubiks;
    
    func getType() -> String {
        if self == .rubiks {
            return "Original Rubiks Brand"
        }
        return ""
    }
}

