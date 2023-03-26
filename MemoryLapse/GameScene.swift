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
    var pathNodes: [SKSpriteNode]! = []
    var pathPositions: [CGPoint]! = [CGPoint(x: -18, y: -310), CGPoint(x: 64, y: -208), CGPoint(x: -13, y: -136), CGPoint(x: 55, y: -102), CGPoint(x: -19, y: -42)]
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
    
    override func didMove(to view: SKView) {
//        print(self.view!.frame.size)
//        print(GameData.currentPath)
//        print(GameData.stageCleared)
        standardSize = (self.frame.size.width + self.frame.size.height) * 0.05
        
        gameMap = SKSpriteNode(imageNamed: "GameMap")
        gameMap.size = self.view!.frame.size
        gameMap.zPosition = 1
        addChild(gameMap)
        
        for i in 1...5 {
            pathNodes.append(SKSpriteNode(imageNamed: "Path/\(i)"))
            pathNodes[i-1].alpha = 0.01
            pathNodes[i-1].position = pathPositions[i-1]
            pathNodes[i-1].zPosition = 3
            pathNodes[i-1].name = "Path\(i)"
            addChild(pathNodes[i-1])
        }
        
        enterButton = SKSpriteNode(imageNamed: "ButtonUI/Enter")
        enterButton.size = CGSize(width: standardSize * 1.5, height: standardSize * 1.5)
        enterButton.zPosition = 2
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
        player.zPosition = 2
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
                if name == "Path5" && GameData.currentPath == 4 && GameData.stageCleared >= 4 {
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
        
        run(SKAction.playSoundFileNamed("RunningInGrass-VolumeUp", waitForCompletion: false))
        player.run(SKAction.repeatForever(playerMovement))
        player.run(SKAction.scale(to: CGSize(width: newPlayerWHSize, height: newPlayerWHSize), duration: 1.8))
        player.run(SKAction.move(to: newPlayerPosition, duration: 1.8), completion: {
            self.player.removeAllActions()
            self.checkIdlePosition(currentPath)
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
