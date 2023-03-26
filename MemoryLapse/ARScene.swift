//
//  ARScene.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import SpriteKit
import ARKit

class ARScene: SKScene {
    
    var arViewController: ARViewController!
    var backButtonNode: SKSpriteNode!
    var standardSize: CGFloat!
    
    override func didMove(to view: SKView) {
        standardSize = (self.frame.size.width + self.frame.size.height) * 0.05
        
        // Setup your scene here
        backButtonNode = SKSpriteNode(imageNamed: "ButtonUI/Back")
        backButtonNode.size = CGSize(width: standardSize * 1.5, height: standardSize * 1.5)
        backButtonNode.position = CGPoint(x: -130, y: 350)
        backButtonNode.name = "BackButton"
        addChild(backButtonNode)
        
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
            
            if let name = touchNode.name {
                if name == "BackButton" {
                    GameData.backgroundMusicPlayer.play()
                    GameData.stageCleared += 1
                    arViewController.dismiss(animated: true)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        print("TouchsBegan")
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.8
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
}
