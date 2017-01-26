//
//  GameOverScene.swift
//  Projrzp0039Fa16
//
//  Created by Ravinder Putta on 11/30/16.
//  Copyright © 2016 Ravinder Putta. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var starStreamNodeEnd:SKEmitterNode!
    var playButtonNodeEnd:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        starStreamNodeEnd = self.childNode(withName: "starStreamInOverScene") as! SKEmitterNode
        
        playButtonNodeEnd = self.childNode(withName: "newGameButtonOver") as! SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first
        if let location = firstTouch?.location(in: self)
        {
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "newGameButtonOver"
            {
                let beginTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let game = GameScene(size: self.size)
                self.view?.presentScene(game, transition: beginTransition)
            }
        }
        
    }
}
