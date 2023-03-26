//
//  GameScene.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameViewController: GameViewController! = GameData.gameViewController
    var gameMap: SKSpriteNode!
    var gameMapUpdated: SKSpriteNode!
    var pathNodes: [SKSpriteNode]! = []
    var pathPositions: [CGPoint]! = [CGPoint(x: -18, y: -308), CGPoint(x: 65, y: -205), CGPoint(x: -13, y: -136), CGPoint(x: 55, y: -102), CGPoint(x: -19, y: -42), CGPoint(x: 90, y: 97)]
    var player: SKSpriteNode!
    var enterButton: SKSpriteNode!
    var moveToRight: SKAction!
    var moveToLeft: SKAction!
    var rightIdle: SKAction!
    var leftIdle: SKAction!
    var rightMovementTextures: [SKTexture]! = []
    var leftMovementTextures: [SKTexture]! = []
    var idleRightTextures: [SKTexture]! = []
    var idleLeftTextures: [SKTexture]! = []
    var standardSize: CGFloat!
    
    var endingCount: Int! = 0
    var endingScreen: SKSpriteNode!
    var endingTextNode: [SKLabelNode]! = []
    var endingString: [[String]]! = [
        ["How was it?", "Did those moments bring you back?", "Those moments are just 5 of the thousand of memories you experience in your life"]
        , ["You got to met amazing people!", "Some become your best friends", "Some even impress you with thier personality or talent"]
        , ["But!", "Did you know who is the most impressive?", " "]
        , ["You", " ", "The one who have unique memories different than anyone"]
        , ["You", " ", "The one who impress others with your life story"]
        , ["You", " ", "The one who move forward despite the uncertainty"]
        , [" ", "FIN", " "]
    ]
    var endingTextPosition: [CGPoint]! = [CGPoint(x: 0, y: 150), CGPoint(x: 0, y: 0), CGPoint(x: 0, y: -150)]
    
    override func didMove(to view: SKView) {
//        print(self.view!.frame.size)
//        print(GameData.currentPath)
//        print(GameData.stageCleared)
        standardSize = (self.frame.size.width + self.frame.size.height) * 0.05
        
        gameMap = SKSpriteNode(imageNamed: "GameMap")
        gameMap.size = self.view!.frame.size
        gameMap.zPosition = 1
        addChild(gameMap)
        
        gameMapUpdated = SKSpriteNode(imageNamed: "GameMapUnlocked")
        gameMapUpdated.size = self.view!.frame.size
        gameMapUpdated.zPosition = 2
        gameMapUpdated.alpha = 0
        gameMapUpdated.run(SKAction.fadeIn(withDuration: 1))
        
        if GameData.stageCleared == 5 {
            addChild(gameMapUpdated)
        }
        
        for i in 1...6 {
            pathNodes.append(SKSpriteNode(imageNamed: "Path/\(i)"))
            pathNodes[i-1].alpha = 0.01
            pathNodes[i-1].position = pathPositions[i-1]
            pathNodes[i-1].zPosition = 4
            pathNodes[i-1].name = "Path\(i)"
            addChild(pathNodes[i-1])
        }
        
        endingScreen = SKSpriteNode(color: UIColor(red: 242/255, green: 205/255, blue: 164/255, alpha: 255/255), size: view.frame.size)
        endingScreen.zPosition = 5
        endingScreen.alpha = 0
        endingScreen.name = "Ending"
        endingScreen.run(SKAction.fadeIn(withDuration: 1))
        
        endingTextNode = changeEndingText(endingCount)
        
        enterButton = SKSpriteNode(imageNamed: "ButtonUI/Enter")
        enterButton.size = CGSize(width: standardSize * 1.5, height: standardSize * 1.5)
        enterButton.zPosition = 4
        enterButton.position = CGPoint(x: 100, y: -340)
        enterButton.name = "enterButton"
        addChild(enterButton)
        
        for i in 0...35 {
            rightMovementTextures.append(SKTexture(imageNamed: "MoveRight/\(i)"))
        }
        moveToRight = SKAction.animate(with: rightMovementTextures, timePerFrame: 0.02)
        
        for i in 0...35 {
            leftMovementTextures.append(SKTexture(imageNamed: "MoveLeft/\(i)"))
        }
        moveToLeft = SKAction.animate(with: leftMovementTextures, timePerFrame: 0.02)
        
        for i in 0...26 {
            idleRightTextures.append(SKTexture(imageNamed: "IdleRight/\(i)"))
        }
        rightIdle = SKAction.animate(with: idleRightTextures, timePerFrame: 0.02)
        
        for i in 0...26 {
            idleLeftTextures.append(SKTexture(imageNamed: "IdleLeft/\(i)"))
        }
        leftIdle = SKAction.animate(with: idleLeftTextures, timePerFrame: 0.02)
        
        player = SKSpriteNode(imageNamed: "IdleLeft/0")
        player.size = CGSize(width: standardSize * GameData.playerRatio, height: standardSize * GameData.playerRatio)
        player.position = GameData.playerPosition
        player.zPosition = 3
        checkIdlePosition(GameData.currentPath)
        addChild(player)
        
        let tapDetection = UITapGestureRecognizer()
        tapDetection.addTarget(self, action: #selector(tappedView(_:)))
        tapDetection.numberOfTapsRequired = 1
        tapDetection.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapDetection)
    }
    
    @objc func tappedView (_ sender: UITapGestureRecognizer){
        if sender.state == .ended && !GameData.isWalking{
            var post = sender.location(in: sender.view)
            post = self.convertPoint(fromView: post)
            let touchNode = self.atPoint(post)
            
            if let name = touchNode.name {
                if name == "Ending" {
                    switch endingCount! {
                    case 0...5:
                        for i in 0...2 {
                            endingTextNode[i].run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
                        }
                        endingCount += 1
                        endingTextNode = changeEndingText(endingCount)
                        run(SKAction.wait(forDuration: 1), completion: {
                            self.addChild(self.endingTextNode[0])
                            self.addChild(self.endingTextNode[1])
                            self.addChild(self.endingTextNode[2])
                        })
                    default:
                        resetGameData()
                        gameMapUpdated.removeFromParent()
                        endingScreen.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
                        for i in 0...2 {
                            endingTextNode[i].run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
                        }
                    }
                }
                else if name == "Path6" && GameData.currentPath == 5 && GameData.stageCleared >= 5 {
//                else if name == "Path6" {
                    playerMovement(6, CGPoint(x: 90, y: 97), 1.2, moveToRight)
                    addChild(endingScreen)
                    run(SKAction.wait(forDuration: 1), completion: {
                        self.addChild(self.endingTextNode[0])
                        self.addChild(self.endingTextNode[1])
                        self.addChild(self.endingTextNode[2])
                    })
                }
                else if name == "Path5" && GameData.currentPath == 4 && GameData.stageCleared >= 4 {
                    playerMovement(5, CGPoint(x: -19, y: -15), 1.2, moveToLeft)
                }
                else if name == "Path4" && (GameData.currentPath == 3 || GameData.currentPath == 5) && GameData.stageCleared >= 3 {
                    playerMovement(4, CGPoint(x: 55, y: -70), 1.5, moveToRight)
                }
                else if name == "Path3" && (GameData.currentPath == 2 || GameData.currentPath == 4) && GameData.stageCleared >= 2 {
                    playerMovement(3, CGPoint(x: -13, y: -98), 1.7, moveToLeft)
                }
                else if name == "Path2" && (GameData.currentPath == 1 || GameData.currentPath == 3) && GameData.stageCleared >= 1 {
                    playerMovement(2, CGPoint(x: 64, y: -160), 2.1, moveToRight)
                }
                else if name == "Path1" && GameData.currentPath == 2 {
                    playerMovement(1, CGPoint(x: -18, y: -250), 2.5, moveToLeft)
                }
                else if name == "enterButton"{
                    toStageScene()
                }
            }
        }
    }
    
    func playerMovement(_ currentPath: Int, _ newPlayerPosition: CGPoint, _ newPlayerRatio: CGFloat, _ playerMovement: SKAction) -> Void {
        
        let newPlayerWHSize = standardSize * newPlayerRatio
        changeGameData(currentPath, newPlayerPosition, newPlayerRatio)
        
        enterButton.alpha = 0
        run(SKAction.playSoundFileNamed("RunningInGrass-VolumeUp", waitForCompletion: false))
        player.run(SKAction.repeatForever(playerMovement))
        player.run(SKAction.scale(to: CGSize(width: newPlayerWHSize, height: newPlayerWHSize), duration: 1.8))
        player.run(SKAction.move(to: newPlayerPosition, duration: 1.8), completion: {
            self.player.removeAllActions()
            self.checkIdlePosition(currentPath)
            self.enterButton.alpha = 1
            GameData.isWalking = false
        })
    }
    
    func toStageScene() -> Void {
        
        let scene = StageScene(fileNamed: "StageScene")
        scene!.scaleMode = .resizeFill
        scene!.gameViewController = gameViewController
        self.view!.presentScene(scene!, transition: SKTransition.fade(with: UIColor.white, duration: 1))
    }
    
    func checkIdlePosition(_ currentPath: Int) -> Void {
        
        switch GameData.currentPath {
        case 1, 3, 5:
            player.run(SKAction.repeatForever(leftIdle))
        default:
            player.run(SKAction.repeatForever(rightIdle))
        }
    }
    
    func changeGameData(_ currentPath: Int, _ newPlayerPosition: CGPoint, _ newPlayerRatio: CGFloat) -> Void {
        
        GameData.playerRatio = newPlayerRatio
        GameData.currentPath = currentPath
        GameData.playerPosition = newPlayerPosition
        GameData.isWalking = true
    }
    
    func changeEndingText(_ section: Int) -> [SKLabelNode] {
        var newEndingTextNode: [SKLabelNode]! = []
        
        for j in 0...2 {
            let customStringStyle = NSMutableParagraphStyle()
            customStringStyle.alignment = .center
            let range = NSRange(location: 0, length: endingString[section][j].count)
            let endingText = NSMutableAttributedString(string: endingString[section][j])
            endingText.addAttribute(NSAttributedString.Key.paragraphStyle, value: customStringStyle, range: range)
            
            if section == 6 {
                endingText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 100, weight: .bold), range: range)
            }
            else if j == 0 {
                endingText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 40, weight: .medium), range: range)
            }
            else {
                endingText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 30), range: range)
            }
            
            newEndingTextNode.append(SKLabelNode())
            newEndingTextNode[j].attributedText = endingText
            newEndingTextNode[j].preferredMaxLayoutWidth = self.view!.frame.width - 40
            newEndingTextNode[j].numberOfLines = 4
            newEndingTextNode[j].position = endingTextPosition[j]
            newEndingTextNode[j].zPosition = 5
            newEndingTextNode[j].alpha = 0
            newEndingTextNode[j].run(SKAction.fadeIn(withDuration: 2))
        }
        
        return newEndingTextNode
    }
    
    func resetGameData() -> Void {
        GameData.stageCleared = 0
        GameData.currentPath = 1
        GameData.playerPosition = CGPoint(x: -18, y: -250)
        GameData.playerRatio = 2.5
        self.endingCount = 0
        player.size = CGSize(width: standardSize * GameData.playerRatio, height: standardSize * GameData.playerRatio)
        player.position = GameData.playerPosition
        checkIdlePosition(GameData.currentPath)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        print(pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
