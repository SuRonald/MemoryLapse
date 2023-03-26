//
//  GameViewController.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import UIKit
import SpriteKit
import GameplayKit
import Photos

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
        
        if !GameData.bgmIsPlaying {
            GameData.backgroundMusicPlayer.play()
        }
        
        GameData.gameViewController = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
    
    func checkPermission() -> Void {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: {_ in
                print("Access Granted")
            })
        }
    }
}
