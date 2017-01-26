//
//  GameViewController.swift
//  Projrzp0039Fa16
//
//  Created by Ravinder Putta on 11/23/16.
//  Copyright © 2016 Ravinder Putta. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'FirstScene.sks'
            if let scene = SKScene(fileNamed: "FirstScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
//    func doubleTap()
//    {
//        let beginTransition = SKTransition.flipHorizontal(withDuration: 0.5)
//        let last = SKScene(fileNamed: "GameEndScene") as! GameEndScene
//        //self.view?.presentScene(last, transition: beginTransition)
//        print("Double tap detected")
//    }

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
