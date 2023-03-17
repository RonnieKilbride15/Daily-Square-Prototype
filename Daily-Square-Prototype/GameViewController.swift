//
//  GameViewController.swift
//  Daily-Square-Prototype
//
//  Created  by Ronnie Kilbride on 3/16/23.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    var puzzleImage: UIImageView!
    var levelLabel: UILabel!
    var level: Level!
    var scene: GameScene!
    var backButton: UIButton!


    
    //start the level and shuffle the board
    func beginGame() {
      shuffle()
    }
    
    
    
    func getLevel(levelValue: Int) -> Level{
        
        //get the levels json file
        let url = Bundle.main.url(forResource: "levels", withExtension: ".json")!
        var returnedLevel: Level!
        do {
            
            //get the specific level from the json file
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [[[Int]]]
            let level = json[levelValue-1]
            
            //convert the numbers in the json file to colors
            var tiles: [[ColorType]] = []
            for i in 0..<level.count{
                var row: [ColorType] = []
                for j in 0..<level[i].count{
                    
                    var colorType: ColorType!
                    switch level[i][j] {
                    case 1:
                        colorType = ColorType.red
                    case 2:
                        colorType = ColorType.blue
                    case 3:
                        colorType = ColorType.green
                    case 4:
                        colorType = ColorType.yellow
                    case 5:
                        colorType = ColorType.orange
                    case 6:
                        colorType = ColorType.teal
                    case 7:
                        colorType = ColorType.purple
                    case 8:
                        colorType = ColorType.gray
                    default:
                        print("error")
                    }
                    
                    row.append(colorType)
                }
                tiles.append(row)
            }
            
            returnedLevel = Level(tiles: tiles, numberOfRows: tiles.count, numberOfColumns: tiles.count, rank: levelValue)
        } catch{
            print("error")
        }
        
        return returnedLevel
    }

    func shuffle() {
        
        //shuffle the board
        let squares = level.shuffle()
        scene.addSprites(squares: squares)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.level = getLevel(levelValue: 1)
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        //add constraints to the puzzle image so its in the top right corner
        self.puzzleImage = UIImageView(image: UIImage(named: "level1"))
        self.view.addSubview(self.puzzleImage)
        self.puzzleImage.translatesAutoresizingMaskIntoConstraints = false
        self.puzzleImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        self.puzzleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.puzzleImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.puzzleImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        self.view.isMultipleTouchEnabled = false
        
        // Create and configure the scene and start the game
        scene = GameScene(size: self.view.bounds.size, level: level)
        scene.scaleMode = .aspectFill
        var view = self.view as! SKView
        view.presentScene(scene)
        beginGame()

         
    }
    
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
   
}
