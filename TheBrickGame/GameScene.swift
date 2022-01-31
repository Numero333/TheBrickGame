//
//  GameScene.swift
//  TheBrickGame
//
//  Created by François-Xavier Méité on 30/01/2022.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate {
    @Published var score = 0
    @Published var isGameOver = false
    @Published var level = 1
    
    let ball = SKShapeNode(circleOfRadius: CGFloat(12))
    let racket = SKSpriteNode(color: SKColor(.white), size: CGSize(width: 120, height: 16))
    let floor = SKSpriteNode(color: SKColor(.brown), size: CGSize(width: UIScreen.main.bounds.width, height: 20))
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .fill
        
        backgroundColor = .black
        
        let border = SKPhysicsBody(edgeLoopFrom: frame)
        border.friction = 0
        physicsBody = border
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        makeBall()
        makeRacket()
        makeBricks()
        makeFloor()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        racket.position = CGPoint(x: location.x, y: 40)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Brick" {
            removeBrick(contact.bodyB.node!)
            updateScore(1)
            
            if children.count <= 3 {
                ball.removeFromParent()
                level += 1
                
                //                makeBall()
                //                makeBricks()
            }
        }
        
        if contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Floor" {
            ball.removeFromParent()
            isGameOver.toggle()
        }
        
    }
    
    func removeBrick(_ node: SKNode){
        node.removeFromParent()
    }
    
    func updateScore(_ newScore: Int) {
        score += newScore
    }
    
    func makeBall(){
        ball.name = "Ball"
        ball.fillColor = .white
        ball.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.6)
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 24))
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        
        addChild(ball)

        ball.physicsBody!.applyImpulse(CGVector(dx: 8, dy: -8))
        //ball.physicsBody!.applyImpulse(CGVector(dx: Int.random(in: 1..<20), dy: Int.random(in: 1..<20)))
        
    }
    
    func makeBricks(){
        let rows = [
            row(color: .red, positionY: UIScreen.main.bounds.height / 1.14),
            row(color: .red, positionY: UIScreen.main.bounds.height / 1.17),
            row(color: .orange, positionY: UIScreen.main.bounds.height / 1.202),
            row(color: .orange, positionY: UIScreen.main.bounds.height / 1.235),
            row(color: .green, positionY: UIScreen.main.bounds.height / 1.272),
            row(color: .green, positionY: UIScreen.main.bounds.height / 1.310),
            row(color: .yellow, positionY: UIScreen.main.bounds.height / 1.350),
            row(color: .yellow, positionY: UIScreen.main.bounds.height / 1.392)
        ]
        
        rows.forEach {
            makeRows(color: $0.color, positionY: $0.positionY)
        }
    }
    
    func makeRows(color: UIColor, positionY: CGFloat) {
        let numberOfBricks = 8
        let brickWidth: CGFloat = 50
        let brickHeight: CGFloat = 16
        let totalBrickWidth = brickWidth * CGFloat(numberOfBricks)
        let xOffset = (frame.width - totalBrickWidth) / 2
        
        for index in 0..<numberOfBricks {
            let brick = SKSpriteNode(color: color, size:CGSize(width: 35, height: brickHeight))
            brick.name = "Brick"
            brick.position = CGPoint(x: xOffset + CGFloat(CGFloat(index) + 0.5) * brickWidth, y: positionY)
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
            brick.physicsBody!.friction = 0
            brick.physicsBody!.allowsRotation = false
            brick.physicsBody!.isDynamic = false
            
            addChild(brick)
        }
    }
    
    func makeFloor(){
        floor.name = "Floor"
        floor.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: UIScreen.main.bounds.width, height: 24))
        floor.physicsBody!.isDynamic = false
        floor.physicsBody!.allowsRotation = false
        floor.physicsBody!.contactTestBitMask = floor.physicsBody!.collisionBitMask
        
        addChild(floor)
    }
    
    func makeRacket(){
        racket.name = "Racket"
        racket.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 40)
        racket.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 24))
        racket.physicsBody!.isDynamic = false
        racket.physicsBody!.friction = 0
        racket.physicsBody!.restitution = 1
        racket.physicsBody!.allowsRotation = false
        racket.physicsBody!.contactTestBitMask = racket.physicsBody!.collisionBitMask
        
        addChild(racket)
    }
    
    
}

struct row {
    let color: UIColor
    let positionY: CGFloat
}
