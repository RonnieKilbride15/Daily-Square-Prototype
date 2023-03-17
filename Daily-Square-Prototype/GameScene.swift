//
//  GameScene.swift
//  Daily-Square-Prototype
//
//  Created by Ronnie Kilbride on 3/16/23.
//

import SpriteKit
import GameplayKit
import StoreKit

class GameScene: SKScene {
    

    var level: Level!
    let tileWidth: CGFloat = 42
    let tileHeight: CGFloat = 42
    let gameLayer = SKNode()
    let squaresLayer = SKNode()
    var popupIsDisplayed: Bool = false
    var timeLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Thonburi-Bold")
        label.fontColor = UIColor.black
        label.fontSize = 20
        return label
    }()
    //var bannerView: GADBannerView!

    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?

    var popupView: UIView!
    
    //setup the size of the game scene and add the layers for the  squares
    init(size: CGSize, level: Level) {
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.level = level
        let background = SKSpriteNode(color: .white, size: size)
        addChild(background)
        
        addChild(gameLayer)

        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(level.numberOfColumns) / 2,
            y: -tileHeight * CGFloat(level.numberOfRows) / 2)

        squaresLayer.position = layerPosition
        gameLayer.addChild(squaresLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //add the squares to the board on the UI
    func addSprites(squares: [[Square]]) {
        
        for i in 0..<squares.count{
            for j in 0..<squares[i].count{
                
                var sprite: SKSpriteNode = SKSpriteNode()
                var color: ColorType = squares[i][j].color
                
                switch color {
                case ColorType.red:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(255.0/255.0), green: CGFloat(59.0/255.0), blue: CGFloat(48.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.blue:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(0.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.green:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(52.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(89.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.yellow:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(255.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(0.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.orange:
                    
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(255.0/255.0), green: CGFloat(149.0/255.0), blue: CGFloat(0.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.teal:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(90/255.0), green: CGFloat(200.0/255.0), blue: CGFloat(250.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.purple:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(175.0/255.0), green: CGFloat(82.0/255.0), blue: CGFloat(222.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                case ColorType.gray:
                    sprite = SKSpriteNode(color: UIColor(red: CGFloat(142.0/255.0), green: CGFloat(142.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1), size: CGSize(width: tileWidth, height: tileHeight))
                    
                default:
                    print("error")
                }
                
                
                
                sprite.position = pointFor(column: squares[i][j].column, row: squares[i][j].row)
                squaresLayer.addChild(sprite)
                squares[i][j].sprite = sprite
            }
        }
        
        self.level.puzzle = squares
        
    }
    
    //get a point from the column and row
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * tileWidth + tileWidth / 2, y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    //convert a point to a column and row
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(level.numberOfColumns) * tileWidth &&
            point.y >= 0 && point.y < CGFloat(level.numberOfRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        

        guard let touch = touches.first else { return }
        let location = touch.location(in: squaresLayer)
        // 2
        let (success, column, row) = convertPoint(location)
        if success {
            // 3
            if let square = level.square(row: row, column: column){
                // 4
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !popupIsDisplayed{
            
            guard swipeFromColumn != nil else { return }

            guard let touch = touches.first else { return }
            let location = touch.location(in: squaresLayer)

            let (success, column, row) = convertPoint(location)
            if success {

                var horizontalDelta = 0, verticalDelta = 0
                if column < swipeFromColumn! {          // swipe left
                  horizontalDelta = -1
                } else if column > swipeFromColumn! {   // swipe right
                  horizontalDelta = 1
                } else if row < swipeFromRow! {         // swipe down
                  verticalDelta = -1
                } else if row > swipeFromRow! {         // swipe up
                  verticalDelta = 1
                }

                if horizontalDelta != 0 || verticalDelta != 0 {

                    self.isUserInteractionEnabled = false
                    if horizontalDelta == -1 {
                        level.shiftRowLeft(rowIndex: row, scene: self)
                        
                    } else if horizontalDelta == 1{
                        level.shiftRowRight(rowIndex: row, scene: self)

                    }else if verticalDelta == -1{
                        level.shiftColumnDown(columnIndex: column, scene: self)

                    }else if verticalDelta == 1{
                        level.shiftColumnUp(columnIndex: column, scene: self)

                    }
                    
                    if level.gameOver{
                        self.removeAllActions()
                        self.isUserInteractionEnabled = false
                        if level.rank == UserDefaults.standard.integer(forKey: "level"){
                            UserDefaults.standard.setValue(level.rank+1, forKey: "level")
                        }
                        
                        //bannerPopup()
                        winnerPopup()
                        
                    }
                    
                    swipeFromColumn = nil

                }
            }
        }
    }
    
    //create the winner popup
    //add two buttons for going to the main menu and next level
    func winnerPopup(){
        
        
        self.popupIsDisplayed = true
        var congratsLabel: UILabel = {
            var label = UILabel()
            label.textAlignment = .left
            label.font = UIFont(name: "TrebuchetMS-Bold", size: 16)
            label.numberOfLines = 0
            label.text = "Congrats! You're a little smart"
            return label
        }()
        
        
        var gameOverView: UIView = UIView()
        gameOverView.tag = 100
        self.popupView = gameOverView
        gameOverView.layer.borderWidth = 1.0
        gameOverView.layer.borderColor = UIColor.black.cgColor
        gameOverView.layer.cornerRadius = 10
    
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.duration = 1
        gameOverView.layer.add(transition, forKey: nil)
        self.view!.addSubview(gameOverView)
        
        self.view!.addSubview(gameOverView)
        gameOverView.backgroundColor = .white
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gameOverView.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: 50).isActive = true
        self.view!.trailingAnchor.constraint(equalTo: gameOverView.trailingAnchor, constant: 50).isActive = true
        gameOverView.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
        gameOverView.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor).isActive = true
        
        gameOverView.addSubview(congratsLabel)

        congratsLabel.translatesAutoresizingMaskIntoConstraints = false
        congratsLabel.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor).isActive = true
        congratsLabel.centerYAnchor.constraint(equalTo: gameOverView.centerYAnchor).isActive = true
        
    }
    
     
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromColumn = nil
        swipeFromRow = nil

    }

}

extension UIView{// :GADFullScreenContentDelegate {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

