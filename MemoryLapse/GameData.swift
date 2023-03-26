//
//  GameData.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import Foundation
import SpriteKit
import AVFoundation

class GameData {
    static var stageCleared: Int = 0
    static var currentPath: Int = 1
    static var playerPosition: CGPoint = CGPoint(x: -18, y: -250)
    static var playerRatio: CGFloat = 2.5
    static var isWalking: Bool = false
    
    static var gameViewController: GameViewController!
    
    static var bgmIsPlaying: Bool = false
    static var backgroundMusic = Bundle.main.url(forResource: "Closers-GangnamBGM", withExtension: "mp3")
    static var backgroundMusicPlayer: AVAudioPlayer! = {
        do {
            let player = try AVAudioPlayer(contentsOf: GameData.backgroundMusic!)
            player.numberOfLoops = -1
            player.volume = 0.2
            return player
        }
        catch {
            print(error)
            return nil
        }
    }()
}
