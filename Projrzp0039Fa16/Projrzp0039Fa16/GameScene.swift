//
//  GameScene.swift
//  Projrzp0039Fa16
//
//  Created by Ravinder Putta on 11/23/16.
//  Copyright © 2016 Ravinder Putta. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starStream:SKSpriteNode!
    var cpuPlayer:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var alien : SKSpriteNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer:Timer!

    var alienArray = ["alienShip1", "alienShip2", "alienShip3"]
    
    let cpUPlayerIdentifier: UInt32 = 0b1
    let missileIdentifier: UInt32 = 0b10
    let enemyIdentifier: UInt32 = 0b10
    let None: UInt32 = 0
    
    var livesLabel:SKLabelNode!
    var lives:Int = 3{
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    var timeMissiles:Double = 2
    
    
    override func didMove(to view: SKView) {
        
        addStarStream()
        addSpaceShip()
        addScoreNode()
        gameTimer = Timer.scheduledTimer(timeInterval: timeMissiles, target: self, selector: #selector(addAlienShips), userInfo: nil, repeats: true)
//        if (self.score <= 10) {
//            gameTimer = Timer.scheduledTimer(timeInterval: timeMissiles, target: self, selector: #selector(addAlienShips), userInfo: nil, repeats: true)
//            print("less than 10")
//        }
//        else
//        {
//            gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addAlienShips), userInfo: nil, repeats: true)
//            print("more than 10")
//        }
        addLives()
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        tap.direction = .up
        //tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
    }
    
    func swipeUp()
    {
        let beginTransition = SKTransition.flipHorizontal(withDuration: 0.5)
        let last = SKScene(fileNamed: "GameEndScene") as! GameEndScene
        self.view?.presentScene(last, transition: beginTransition)
    }
    
    func addLives()
    {
        livesLabel = SKLabelNode(text: "Lives: 3")
        livesLabel.position = CGPoint(x: 320, y: self.frame.size.height - 60)
        livesLabel.fontName = "Noteworthy-Bold"
        livesLabel.fontSize = 36
        livesLabel.fontColor = UIColor.white
        lives = 3
        
        self.addChild(livesLabel)

    }
    
    func addStarStream()
    {
        starStream = SKSpriteNode(fileNamed: "StarStream")
        starStream.position = CGPoint(x: 0, y: 1000)
        starStream.zPosition = 0
        self.addChild(starStream)
    }
    
    func addSpaceShip()
    {
        cpuPlayer = SKSpriteNode(imageNamed: "spaceship-1")
        //cpuPlayer.scale(to: 0.5)
        cpuPlayer.position = CGPoint(x: self.frame.size.width / 2, y: cpuPlayer.size.height / 2 + 20)
        cpuPlayer.setScale(0.7)
        cpuPlayer.zPosition=2
        cpuPlayer.physicsBody = SKPhysicsBody(rectangleOf: cpuPlayer.size)
        cpuPlayer.physicsBody!.affectedByGravity = false
        cpuPlayer.physicsBody!.categoryBitMask = cpUPlayerIdentifier
        cpuPlayer.physicsBody!.collisionBitMask = None
        cpuPlayer.physicsBody!.contactTestBitMask = enemyIdentifier
        
        self.addChild(cpuPlayer)
    }
    
    func addScoreNode()
    {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 60)
        scoreLabel.fontName = "Noteworthy-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
    }
    
    func addAlienShips () {
        alienArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: alienArray) as! [String]
        
        alien = SKSpriteNode(imageNamed: alienArray[2])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 4, highestValue: 410)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        alien.zPosition=2
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody!.affectedByGravity = false
        alien.physicsBody!.categoryBitMask = enemyIdentifier
        alien.physicsBody!.collisionBitMask = None
        alien.physicsBody!.contactTestBitMask = cpUPlayerIdentifier | missileIdentifier
        
        self.addChild(alien)
        
        var animationDuration:TimeInterval = 6
        
        if(score>50)
        {
            animationDuration = 2
        }
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(y: -self.size.height, duration: animationDuration))
        actionArray.append(SKAction.run {
            if self.lives>0
            {
                self.lives = self.lives - 1
            }
            if(self.lives==0)
            {
                let beginTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let last = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                self.view?.presentScene(last, transition: beginTransition)
            }
            
        })
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
    }

    
    func fireMissiles()
    {
        let missile = SKSpriteNode(imageNamed: "missile")
        missile.zPosition = 1
        missile.position = cpuPlayer.position
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody!.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = missileIdentifier
        missile.physicsBody!.collisionBitMask = None
        missile.physicsBody!.contactTestBitMask = enemyIdentifier
        
        self.addChild(missile)
        
        //code to animate the missile from the fired position to out of the screen vertically
        let animateMissile = SKAction.moveTo(y: self.size.height + missile.size.height, duration: 0.5)
        let playSound = SKAction.playSoundFileNamed("laser.mp3", waitForCompletion: false)
        let removeMissile = SKAction.removeFromParent()
        let sequenceOfActions = SKAction.sequence([playSound, animateMissile, removeMissile])
        missile.run(sequenceOfActions)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.physicsWorld.contactDelegate = self
        fireMissiles()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousLocation.x
            cpuPlayer.position.x += amountDragged
        }
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Hello WorldDDDDDDDDDD")
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask
        {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        else{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        
        if body1.categoryBitMask == missileIdentifier && body2.categoryBitMask == enemyIdentifier
        {
            let alienNode = body2.node as! SKSpriteNode
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            let particleEmitter = SKSpriteNode(fileNamed: "Explosion")!
            particleEmitter.position = alienNode.position
            self.addChild(particleEmitter)
            score+=5
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
