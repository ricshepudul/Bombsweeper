//
//  Button.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/16/25.
//

import UIKit

class Button: UIButton {

    let size: CGFloat
    let margin: CGFloat
    var square: Square
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGFloat, margin: CGFloat, square: Square) {
        self.size = size
        self.margin = margin
        self.square = square
        let x = CGFloat(square.column) * (size + margin)
        let y = CGFloat(square.row) * (size + margin)
        let buttonFrame = CGRect(x: x, y: y, width: size, height: size)
        super.init(frame: buttonFrame)
    }
    
    func getLabel(_ winner: Bool) -> String {
        if square.isBomb {
            if winner {
                return "💣"
            } else {
                return "💥"
            }
        } else {
            if square.adjacentBombs == 0 {
                return ""
            }
            return "\(square.adjacentBombs)"
        }
    }
}
