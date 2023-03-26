//
//  StageScene.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import SpriteKit
import GameplayKit

class StageScene: SKScene {
    
    var gameViewController: GameViewController! = GameData.gameViewController
    var stageMap: SKSpriteNode!
    var startButtonNode: SKSpriteNode!
    var backButtonNode: SKSpriteNode!
    var playerNode: SKSpriteNode!
    var playerStagePosition: [CGPoint]! = [CGPoint(x: 50, y: -130), CGPoint(x: -65, y: -140), CGPoint(x: 40, y: -140), CGPoint(x: 75, y: -160), CGPoint(x: 15, y: -140)]
    var idleFrontTextures: [SKTexture]! = []
    var frontIdle: SKAction!
    var standardSize: CGFloat!
    
    override func didMove(to view: SKView) {
        standardSize = (self.frame.size.width + self.frame.size.height) * 0.05
        
        stageMap = SKSpriteNode(imageNamed: "StageMap/\(GameData.currentPath)")
        stageMap.zPosition = 1
        addChild(stageMap)
        
        startButtonNode = SKSpriteNode(imageNamed: "ButtonUI/Enter")
        startButtonNode.size = CGSize(width: standardSize * 1.5, height: standardSize * 1.5)
        startButtonNode.zPosition = 3
        startButtonNode.position = CGPoint(x: 100, y: -350)
        startButtonNode.name = "StartButton"
        addChild(startButtonNode)
        
        backButtonNode = SKSpriteNode(imageNamed: "ButtonUI/Back")
        backButtonNode.size = CGSize(width: standardSize * 1.5, height: standardSize * 1.5)
        backButtonNode.zPosition = 3
        backButtonNode.position = CGPoint(x: -100, y: -350)
        backButtonNode.name = "BackButton"
        addChild(backButtonNode)
        
        for i in 0...26 {
            idleFrontTextures.append(SKTexture(imageNamed: "IdleFront/\(i)"))
        }
        frontIdle = SKAction.animate(with: idleFrontTextures, timePerFrame: 0.02)
        
        playerNode = SKSpriteNode(imageNamed: "IdleFront/0")
        playerNode.size = CGSize(width: standardSize * 6, height: standardSize * 6)
        playerNode.zPosition = 2
        playerNode.position = playerStagePosition[GameData.currentPath-1]
        playerNode.run(SKAction.repeatForever(frontIdle))
        addChild(playerNode)
        
        let tapDetection = UITapGestureRecognizer()
        tapDetection.addTarget(self, action: #selector(tappedView(_:)))
        tapDetection.numberOfTapsRequired = 1
        tapDetection.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapDetection)
    }
    
    @objc func tappedView (_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            var post = sender.location(in: sender.view)
            post = self.convertPoint(fromView: post)
            let touchNode = self.atPoint(post)
            
            print(post)
            
            if let name = touchNode.name {
                if name == "StartButton" {
//                    GameData.stageCleared += 1
                    GameData.backgroundMusicPlayer.pause()
                    gameViewController.performSegue(withIdentifier: "toARView", sender: self)
                }
                else if name == "BackButton" {
//                    GameData.backgroundMusicPlayer.play()
                    toGameScene()
                }
            }
        }
    }
    
    func toGameScene() -> Void {
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .resizeFill
        self.view!.presentScene(scene!, transition: SKTransition.fade(with: UIColor.white, duration: 1))
    }
}
