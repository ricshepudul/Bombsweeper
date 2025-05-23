//
//  Square.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/14/25.
//

class Square {
    let row: Int
    let column: Int
    
    var isBomb = false
    var isClicked = false
    var isFlagged = false
    var adjacentBombs = 0
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    //swift = more girlypop 
}
