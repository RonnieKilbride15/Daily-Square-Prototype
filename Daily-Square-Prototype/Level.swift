//
//  Level.swift
//  Daily-Square-Prototype
//
//  Created by Ronnie Kilbride on 3/16/23.
//

import Foundation
import SpriteKit

class Level{
    
    var correctPuzzle: [[Square]] = []
    var puzzle: [[Square]] = []
    var numberOfRows: Int
    var numberOfColumns: Int
    var movesCount = 0
    var gameOver: Bool = false
    var rank: Int
    var time: Int = 0
    
    init(rank:Int){
        var square1 = Square(column: 0, row: 0, color: ColorType.orange)
        var square2 = Square(column: 0, row: 1, color: ColorType.blue)
        var square3 = Square(column: 0, row: 2, color: ColorType.blue)
        var square4 = Square(column: 0, row: 3, color: ColorType.red)
        var square5 = Square(column: 1, row: 0, color: ColorType.red)
        var square6 = Square(column: 1, row: 1, color: ColorType.orange)
        var square7 = Square(column: 1, row: 2, color: ColorType.green)
        var square8 = Square(column: 1, row: 3, color: ColorType.orange)
        var square9 = Square(column: 2, row: 0, color: ColorType.red)
        var square10 = Square(column: 2, row: 1, color: ColorType.blue)
        var square11 = Square(column: 2, row: 2, color: ColorType.orange)
        var square12 = Square(column: 2, row: 3, color: ColorType.red)
        var square13 = Square(column: 3, row: 0, color: ColorType.green)
        var square14 = Square(column: 3, row: 1, color: ColorType.blue)
        var square15 = Square(column: 3, row: 2, color: ColorType.green)
        var square16 = Square(column: 3, row: 3, color: ColorType.green)

        
        self.puzzle = [[square1,square2, square3, square4], [square5,square6, square7, square8], [square9,square10, square11, square12],[square13,square14, square15, square16]]
        self.rank = -1
        self.numberOfRows = 4
        self.numberOfColumns = 4
        self.time = 0
        
        
    }
    
    init(tiles: [[ColorType]], numberOfRows: Int, numberOfColumns: Int, rank: Int) {
        
        if rank != -1 {
            //go through the tiles and add the squares for the puzzle
            for i in 0..<tiles.count{
                var row: [Square] = []
                var row1: [Square] = []
                for j in 0..<tiles[i].count{
                    
                    var color = tiles[i][j]
                    switch color {
                    case ColorType.red:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.blue:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.green:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.yellow:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.orange:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.teal:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.purple:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    case ColorType.gray:
                        row.append(Square(column: i, row: j, color: color))
                        row1.append(Square(column: i, row: j, color: color))
                    default:
                        print("error")
                    }
                }
                
                puzzle.append(row)
                correctPuzzle.append(row1)
            }
        } else {
            
        }
        
        
        
        //set the number of rows and columns for the level
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.rank = rank
        
        //set the time based on the number of rows
        if numberOfRows == 3 || numberOfRows == 4 {
            self.time = 60
        } else if numberOfRows == 5{
            self.time = 90
        } else if numberOfRows == 6{
            self.time = 120
        }else if numberOfRows == 7 || numberOfRows == 8{
            self.time = 150
        }
        
    }
    
    //function for shifting the column down
    func shiftColumnDown(columnIndex: Int, scene: GameScene){
        

        if !gameOver{

            //get the first square in the puzzle
            var temp = puzzle[columnIndex][0]
            
            //move the first square to the end of the column
            puzzle[columnIndex][0].sprite.run(SKAction.move(to: puzzle[columnIndex][numberOfRows-1].sprite.position, duration: 0.15)){
                
                //add 1 to the moves count since the square was moved
                self.movesCount += 1
                
                //when all squares are moved enable swiping
                if self.movesCount == self.numberOfRows{
                    scene.isUserInteractionEnabled = true
                    self.movesCount = 0
                }
            }
            

            //move each sqaure down one spot
            for i in 0..<numberOfRows-1 {
                puzzle[columnIndex][i+1].sprite.run(SKAction.move(to: puzzle[columnIndex][i].sprite.position, duration: 0.15)){
                    
                    self.movesCount += 1
                    
                    if self.movesCount == self.numberOfRows{
                        scene.isUserInteractionEnabled = true
                        self.movesCount = 0
                    }
                }
                puzzle[columnIndex][i] = puzzle[columnIndex][i+1]
                puzzle[columnIndex][i].row = i

            }
            
            //last square in the column should be the first square
            puzzle[columnIndex][numberOfRows-1] = temp
            puzzle[columnIndex][numberOfRows-1].row = numberOfRows - 1
            
            //if the puzzle is not the demo puzzle
            if self.rank != -1{
                
            //if the puzzle matches the correct pattern then game over
                if puzzle == correctPuzzle{
                    gameOver = true
                }
            }
        }
        
    }

    func shiftColumnUp(columnIndex: Int, scene: GameScene){
     
        

        if !gameOver{

            //get the last square in the column
            var last = puzzle[columnIndex][puzzle[columnIndex].count - 1]
            
            //move the last square to the beginning of the column
            puzzle[columnIndex][numberOfRows-1].sprite.run(SKAction.move(to: puzzle[columnIndex][0].sprite.position, duration: 0.15)){
                
                //add 1 to the moves count since the square was moved
                self.movesCount += 1
                
                //when all squares are moved enable editing
                if self.movesCount == self.numberOfRows{
                    scene.isUserInteractionEnabled = true
                    self.movesCount = 0
                }
            }
            
            //move each sqaure up one spot
            for i in stride(from: numberOfRows-1, to: 0, by: -1) {
                puzzle[columnIndex][i-1].sprite.run(SKAction.move(to: puzzle[columnIndex][i].sprite.position, duration: 0.15)){
                    
                    //add 1 to the moves count since the square was moved
                    self.movesCount += 1
                
                    //when all squares are moved enable editing
                    if self.movesCount == self.numberOfRows{
                        scene.isUserInteractionEnabled = true
                        self.movesCount = 0
                    }
                }
                puzzle[columnIndex][i] = puzzle[columnIndex][i-1]
                puzzle[columnIndex][i].row = i
            }
            
            //first square in the column should be the last square
            puzzle[columnIndex][0] = last
            puzzle[columnIndex][0].row = 0
            
            //if the puzzle is not the demo puzzle
            if self.rank != -1{
                
            //if the puzzle matches the correct pattern then game over
                if puzzle == correctPuzzle{
                    gameOver = true
                }
            }
        }
    }

    func shiftRowLeft(rowIndex: Int, scene: GameScene){

        if !gameOver{

            //get the first square in the puzzle
            var temp = puzzle[0][rowIndex]
            
            //move the first square to the end of the row
            puzzle[0][rowIndex].sprite.run(SKAction.move(to: puzzle[numberOfColumns-1][rowIndex].sprite.position, duration: 0.15)){
                
                //add 1 to the moves count since the square was moved
                self.movesCount += 1
                
                //when all squares are moved enable swiping
                if self.movesCount == self.numberOfColumns{
                    scene.isUserInteractionEnabled = true
                    self.movesCount = 0
                }
            }

            //move each sqaure to the left one spot
            for i in 0..<puzzle.count-1 {
                puzzle[i+1][rowIndex].sprite.run(SKAction.move(to: puzzle[i][rowIndex].sprite.position, duration: 0.15)){
                    
                    //add 1 to the moves count since the square was moved
                    self.movesCount += 1
                    
                    //add 1 to the moves count since the square was moved
                    if self.movesCount == self.numberOfColumns{
                        scene.isUserInteractionEnabled = true
                        self.movesCount = 0
                    }
                }
                puzzle[i][rowIndex] = puzzle[i+1][rowIndex]
                puzzle[i][rowIndex].column = i

            }
            
            //last square in the row should be the first square
            puzzle[numberOfColumns - 1][rowIndex] = temp
            puzzle[numberOfColumns-1][rowIndex].column = numberOfColumns - 1
            
            //if the puzzle is not the demo puzzle
            if self.rank != -1{
                
            //if the puzzle matches the correct pattern then game over
                if puzzle == correctPuzzle{
                    gameOver = true
                }
            }
        }
    }
    
    func shiftRowRight(rowIndex: Int, scene: GameScene){
        

        if !gameOver{
            
            //get the last square in the row
            var last = puzzle[puzzle.count-1][rowIndex]
            
            //move the last square to the beginning of the row
            puzzle[numberOfColumns-1][rowIndex].sprite.run(SKAction.move(to: puzzle[0][rowIndex].sprite.position, duration: 0.15)){
                
                //add 1 to the moves count since the square was moved
                self.movesCount += 1
                
                //when all squares are moved enable swiping
                if self.movesCount == self.numberOfColumns{
                    scene.isUserInteractionEnabled = true
                    self.movesCount = 0
                }
            }
            
            //move each sqaure to the right one spot
            for i in stride(from: puzzle.count-1, to: 0, by: -1) {
                
                //move the square to the right
                puzzle[i-1][rowIndex].sprite.run(SKAction.move(to: puzzle[i][rowIndex].sprite.position, duration: 0.15)){
                    
                    //add 1 to the moves count since the square was moved
                    self.movesCount += 1
                    
                    //when all squares are moved enable swiping
                    if self.movesCount == self.numberOfColumns{
                        scene.isUserInteractionEnabled = true
                        self.movesCount = 0
                    }
                }

                puzzle[i][rowIndex] = puzzle[i-1][rowIndex]
                puzzle[i][rowIndex].column = i

                
            }

            //first square in the row should be the last square
            puzzle[0][rowIndex] = last
            puzzle[0][rowIndex].column = 0
            
            //if the puzzle is not the demo puzzle
            if self.rank != -1{
                
            //if the puzzle matches the correct pattern then game over
                if puzzle == correctPuzzle{
                    gameOver = true
                }
            }

        }
    }
    
    //get the square
    func square(row: Int, column: Int) -> Square?{
        precondition(column >= 0 && column < numberOfColumns)
          precondition(row >= 0 && row < numberOfRows)
          return puzzle[row][column]
    }
    
    //shuffle the board
    func shuffle() -> [[Square]]{
      return createInitialPuzzle()
    }

    //shuffle the puzzle array
    private func createInitialPuzzle() -> [[Square]] {
        var iter = self.puzzle.joined().shuffled().makeIterator()
        var set = puzzle.map { $0.compactMap { _ in iter.next() }}
        for i in 0..<set.count{
            for j in 0..<set[i].count{
                set[i][j].column = i
                set[i][j].row = j
            }
        }
        
        return set

    }
}

