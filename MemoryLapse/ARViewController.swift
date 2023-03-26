//
//  ARViewController.swift
//  MemoryLapse
//
//  Created by Ronald Sumichael Sunan on 26/03/23.
//

import UIKit
import ARKit
import SpriteKit
import Photos

class ARViewController: UIViewController, ARSKViewDelegate {
    
    let manager = PHImageManager.default()
    var loadType: String = ""

    @IBOutlet weak var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameData.momentList
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = ARScene(fileNamed: "ARScene") {
            scene.arViewController = self
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        print("Masuk")
        var image: UIImage!
        
        if GameData.currentPath <= GameData.momentCount {
            image = loadImage(GameData.places[GameData.currentPath-1])
            loadType = "Image"
        }
        else {
            image = loadPlaceHolder()
            loadType = "Placeholder"
        }
        
        let texture = SKTexture(image: image)
        
        let node = SKSpriteNode(texture: texture)
        switch loadType {
        case "Image":
            node.size.height = CGFloat(image.size.height * 0.2)
            node.size.width = CGFloat(image.size.width * 0.2)
        case "Placeholder":
            node.size.height = CGFloat(image.size.height * 0.052)
            node.size.width = CGFloat(image.size.width * 0.052)
        default:
            node.size.height = CGFloat(image.size.height * 0.2)
            node.size.width = CGFloat(image.size.width * 0.2)
        }
        
        return node;
    }
    
    func loadImage(_ index: String) -> UIImage {
        var image: UIImage!
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: GameData.momentList[index]![Int.random(in: 0..<GameData.momentList[index]!.count)], options: fetchOption())

        print("Masuk")
        print(fetchResult.count)
        print("Image Metadata")
        print(fetchResult.object(at: 0))

        manager.requestImage(for: fetchResult.object(at: Int.random(in: 0..<fetchResult.count)), targetSize: CGSize(width: 650, height: 650), contentMode: .default, options: requestOptions()) { imgData, err  in
            guard let img = imgData else {
                print(err!)
                return
            }
            image = img
        }

        return image
    }
    
    func fetchOption() -> PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOption
    }
    
    func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }
    
    func loadPlaceHolder() -> UIImage {
        var image: UIImage!
        
        image = UIImage(named: "Placeholder/\(Int.random(in: 0...66))")
        
        return image
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}
