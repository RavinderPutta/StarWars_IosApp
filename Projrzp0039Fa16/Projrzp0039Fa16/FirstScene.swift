//
//  FirstScene.swift
//  Projrzp0039Fa16
//
//  Created by Ravinder Putta on 11/24/16.
//  Copyright © 2016 Ravinder Putta. All rights reserved.
//

import SpriteKit

class FirstScene: SKScene {
    var starStreamNode:SKEmitterNode!
    var playButtonNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        starStreamNode = self.childNode(withName: "StarStreamEmitter") as! SKEmitterNode
        playButtonNode = self.childNode(withName: "playButton") as! SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first
        if let location = firstTouch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playButton"
            {
                let beginTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let game = GameScene(size: self.size)
                self.view?.presentScene(game, transition: beginTransition)
            }
        }
        
    }
}
