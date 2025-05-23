//
//  ViewController.swift
//  Bombsweeper
//
//  Created by HPro2 on 1/14/25.
//

import UIKit

class ViewController: UIViewController {
    
    /*OPTIONS COMPLETED:
     timer starts with first click
     flags (placing and removing)
     difficulty levels (size)
     color/appearance changes
     pause game timer (hide field)
     replay game
     show current/best time in win alert
     change color of number of bombs
     welcome screen
     pause screen cover board
     not die on first click
     user picks color/theme
     instructions
     */
    
    
    let myDefaults = UserDefaults(suiteName: "com.jonesclass.bombsweeper.hu")
    var lowestTime = -1
    
    var board: Board
    var boardSize: Int = 20
    let buttonMargin: CGFloat = 4.0
    var buttons: [Button] = []
    var oneSecondTimer: Timer?
    var pause = false
    var color = UIColor.darkGray
    
    var moves: Int = 0 {
        didSet {
            movesLabel.text = "Moves: \(moves)"
        }
    }
    
    var timeTaken: Int = 0 {
        didSet {
            timeLabel.text = "Time: \(timeTaken)"
        }
    }
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    
    @IBAction func newGamePressed(_ sender: UIBarButtonItem) {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
        startNewGame()
    }
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    @IBAction func pausePressed(_ sender: UIBarButtonItem) {
        let cover = UIView(frame: CGRect(x: 10, y: 150, width: 355, height: 355))
        cover.backgroundColor = color
        if pause {
            pause = false
            if let removable = self.view.viewWithTag(1) {
                removable.removeFromSuperview()
            }
            pauseButton.title = "Pause"
            oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecond), userInfo: nil, repeats: true)
            oneSecondTimer?.tolerance = 0.5
        } else {
            pause = true
            self.view.addSubview(cover)
            cover.tag = 1
            pauseButton.title = "Play"
            oneSecondTimer?.invalidate()
        }
    }
    
    @objc func play() {
        pause = false
        pauseButton.title = "Pause"
        oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecond), userInfo: nil, repeats: true)
        oneSecondTimer?.tolerance = 0.5
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //initializeBoard()
        //startNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        boardView.backgroundColor = color.withAlphaComponent(0.7)
        if let storedInt = myDefaults?.integer(forKey: "com.jonesclass.bombsweeper.hu.time") {
            lowestTime = storedInt
        }

        initializeBoard()
        startNewGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        board = Board(size: boardSize)
        super.init(coder: aDecoder)!
    }
    
    func initializeBoard() {
        board = Board(size: boardSize)
        for row in 0..<boardSize {
            for column in 0..<boardSize {
                let square = board.squares[row][column]
                let buttonSize: CGFloat = (boardView.frame.width - CGFloat(boardSize-1) * buttonMargin) / CGFloat(boardSize)
                let button = Button(size: buttonSize, margin: buttonMargin, square: square)
                button.backgroundColor = color
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(flagged))
                longPress.minimumPressDuration = 0.5
                button.addGestureRecognizer(longPress)
                
                buttons.append(button)
                boardView.addSubview(button)
            }
        }
    }
    
    @objc func buttonPressed(button: Button) {
        if !button.square.isClicked && !button.square.isFlagged {
            //button.square.isClicked = true
            button.backgroundColor = color.withAlphaComponent(0)
            button.setTitleColor(findColor(number: button.getLabel(false)), for: .normal)
            button.setTitle(button.getLabel(false), for: .normal)
            moves += 1
            
            if button.square.isBomb {
                if moves == 1 {
                    button.square.isBomb = false
                    for neighbor in board.getNeighbors(square: button.square) {
                        if !neighbor.isBomb {
                            neighbor.adjacentBombs -= 1
                            button.setTitleColor(findColor(number: button.getLabel(false)), for: .normal)
                            button.setTitle(button.getLabel(false), for: .normal)
                        }
                    }
                } else {
                    endGame(winner: false)
                }
            } else {
                swifterClicker(button: button)
                if checkForWinner() {
                    endGame(winner: true)
                }
            }
        }
        
        if moves == 1 {
            oneSecondTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(oneSecond), userInfo: nil, repeats: true)
            oneSecondTimer?.tolerance = 0.5
        }
    }
    
    @objc func flagged(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let button: Button = sender.view as! Button
            if !button.square.isClicked && !button.square.isFlagged {
                button.square.isFlagged = true
                button.setTitle("⛳️", for: .normal)
            } else if button.square.isFlagged {
                button.square.isFlagged = false
                button.setTitle("", for: .normal)
            }
        }
    }
    
    func swifterClicker(button: Button) {
        if !button.square.isClicked {
            button.square.isClicked = true
            button.backgroundColor = color.withAlphaComponent(0)
            button.setTitleColor(findColor(number: button.getLabel(false)), for: .normal)
            button.setTitle(button.getLabel(false), for: .normal)
            if button.square.adjacentBombs == 0 {
                for square in board.getNeighbors(square: button.square) {
                    for button in buttons {
                        if button.square.row == square.row && button.square.column == square.column {
                            swifterClicker(button: button)
                        }
                    }
                }
            }
        }
    }

    func startNewGame() {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
        moves = 0
        timeTaken = 0
        for button in buttons {
            button.setTitle("", for: .normal)
            button.backgroundColor = color
        }
        board.resetBoard()
    }
    
    func startNewGame(action: UIAlertAction) {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
        moves = 0
        timeTaken = 0
        for button in buttons {
            button.setTitle("", for: .normal)
            button.backgroundColor = color
        }
        board.resetBoard()
    }
    
    @objc func oneSecond() {
        timeTaken += 1
    }
    
    func checkForWinner() -> Bool {
        var total = 0
        for row in 0..<boardSize {
            for column in 0..<boardSize {
                if board.squares[row][column].isClicked && !board.squares[row][column].isBomb {
                    total += 1
                } else if !board.squares[row][column].isClicked && board.squares[row][column].isBomb {
                    total += 1
                }
            }
        }
        if total == boardSize * boardSize {
            return true
        }
        return false
    }
    
    func endGame(winner: Bool) {
        oneSecondTimer?.invalidate()
        oneSecondTimer = nil
        for row in 0..<boardSize {
            for column in 0..<boardSize {
                board.squares[row][column].isClicked = true
            }
        }
        
        for button in buttons {
            button.setTitleColor(findColor(number: button.getLabel(false)), for: .normal)
            button.setTitle(button.getLabel(winner), for: .normal)
            button.backgroundColor = color.withAlphaComponent(0)
        }
        
        if winner {
            if lowestTime == -1 || timeTaken < lowestTime {
                lowestTime = timeTaken
                myDefaults?.set(lowestTime, forKey: "com.jonesclass.bombsweeper.hu.time")
            }

            let ac = UIAlertController(title: "You're the bomb!", message: "You won in \(timeTaken) seconds with \(moves) moves. Your lowest time is \(lowestTime) seconds. ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: startNewGame))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "You lose!", message: ":(", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: startNewGame))
            present(ac, animated: true)
        }
    }
    
    func findColor(number: String) -> UIColor {
        var color: UIColor
        if number == "1" {
            color = UIColor.blue
        } else if number == "2" {
            color = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1.0)
        } else if number == "3" {
            color = UIColor.systemRed
        } else if number == "4" {
            color = UIColor.magenta
        } else if number == "5" {
            color = UIColor.systemYellow
        } else if number == "6" {
            color = UIColor.systemCyan
        } else if number == "7" {
            color = UIColor.systemMint
        } else {
            color = UIColor.systemPink
        }
        return color
    }
    
    
}

