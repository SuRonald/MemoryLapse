//
//  GameData.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import Foundation
import SpriteKit
import AVFoundation
import Photos

class GameData {
    // Game Part
    static var stageCleared: Int = 0
    static var currentPath: Int = 1
    static var playerPosition: CGPoint = CGPoint(x: -18, y: -250)
    static var playerRatio: CGFloat = 2.5
    static var isWalking: Bool = false
    
    // Segue
    static var gameViewController: GameViewController!
    
    // BGM
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
    
    // Photo Part
    static var places: [String] = []
    static var momentCount: Int = 0
    
    static var momentList: [String: [PHAssetCollection]] = {
        let momentOptions = PHFetchOptions()
        momentOptions.sortDescriptors = [NSSortDescriptor(key: "estimatedAssetCount", ascending: false)]
        momentOptions.predicate = NSPredicate(format:"title != nil")
        let momentList = PHAssetCollection.fetchMoments(with: momentOptions)
        var distinctPlaces = Set<String>()
        
        var momentDicts: [String: [PHAssetCollection]] = [:]
        var momentAssetCount: [String: Int] = [:]

        for index in 0..<momentList.count {
            let a = momentList[index]
//            print(a)
            let sta = a.localizedTitle
            let stb = a.localizedLocationNames
            let assetCount = a.estimatedAssetCount
            print(index, sta ?? "--", stb, assetCount)
            
            if !distinctPlaces.contains(sta!){
                distinctPlaces.insert(sta!)
                momentDicts[sta!] = [a]
                momentAssetCount[sta!] = assetCount
            }
            else {
                momentDicts[sta!]!.append(a)
                momentAssetCount[sta!]! += assetCount
            }
        }
        
        print("-------------------------")
        for moment in momentDicts {
            print(moment.key, moment.value.count)
        }
        
        print("-------------------------")
        for moment in momentAssetCount {
            print(moment.key, moment.value)
        }
        
        switch momentDicts.count {
        case 0...4:
            print("Kurang atau Pas")
            GameData.momentCount = momentDicts.count
            for moment in momentDicts {
                GameData.places.append(moment.key)
            }
        default:
            print("Lebih")
            GameData.momentCount = momentDicts.count
            var newMomentList: [String: [PHAssetCollection]] = [:]
            for i in 0...3 {
                let mostAssets = momentAssetCount.max { $0.value < $1.value }
                newMomentList[mostAssets!.key] = momentDicts[mostAssets!.key]
                GameData.places.append(mostAssets!.key)
                momentAssetCount.removeValue(forKey: mostAssets!.key)
            }
            momentDicts = newMomentList
        }
        
        print("-------------------------")
        for moment in momentDicts {
            print(moment.key, moment.value.count)
        }
        
        print(GameData.places)
        
        return momentDicts
    }()
}
