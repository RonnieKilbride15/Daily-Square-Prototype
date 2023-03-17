//
//  Square.swift
//  Daily-Square-Prototype
//
//  Created by Ronnie Kilbride on 3/16/23.
//

import Foundation
import SpriteKit

//different colors for the squares
enum ColorType: Int {
    case red=1, blue=2, green=3, yellow=4, orange=5, teal=6, purple=7, gray=8
    
}


class Square: Equatable{
    
    //function fot squares to be compared
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.color == rhs.color && lhs.column == rhs.column && lhs.row == rhs.row

    }
    
    
    var column: Int
    var row: Int
    var color: ColorType
    var sprite: SKSpriteNode!

    init(column: Int, row: Int, color: ColorType) {
        self.column = column
        self.row = row
        self.color = color
    }
    
}

