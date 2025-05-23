//
//  Board.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/15/25.
//
class Board {
    let size: Int
    var squares: [[Square]] = []
    
    init(size: Int) {
        self.size = size
        for row in 0..<size {
            var squareRow: [Square] = []
            for column in 0..<size {
                let square = Square(row: row, column: column)
                squareRow.append(square)
            }
            squares.append(squareRow)
        }
    }
    
    func resetBoard() {
        for row in 0..<size {
            for column in 0..<size {
                squares[row][column].isBomb = false
                squares[row][column].isClicked = false
                squares[row][column].isFlagged = false
                placeBomb(in: squares[row][column]);
            }
        }
        
        for row in 0..<size {
            for column in 0..<size {
                countBombs(square: squares[row][column])
            }
        }
        
    }
    
    func placeBomb(in square: Square) {
        square.isBomb = Int.random(in: 0..<10) < 1
    }
    
    func countBombs(square: Square) {
        let neighbors = getNeighbors(square: square)
        var bombs = 0
        for neighbor in neighbors {
            if neighbor.isBomb {
                bombs += 1
            }
        }
        square.adjacentBombs = bombs
    }
    
    func getNeighbors(square: Square) -> [Square] {
        var neighbors: [Square] = []
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        
        for (rowOffset, columnOffset) in offsets {
            let row = square.row + rowOffset
            let column = square.column + columnOffset
            
            if row >= 0 && row < size && column >= 0 && column < size {
                neighbors.append(squares[row][column])
            }
        }
        return neighbors
    }
    
    func printBoard() {
        for row in 0..<size {
            for column in 0..<size {
                if (squares[row][column].isBomb) {
                    print("💣", terminator: " ")
                } else {
                    print("\(squares[row][column].adjacentBombs)", terminator: " ")
                }
            }
            print("")
        }
    }
}
