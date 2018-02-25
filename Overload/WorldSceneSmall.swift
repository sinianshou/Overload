//
//  WorldSceneSmall.swift
//  Overload
//
//  Created by Easer on 2018/2/5.
//  Copyright © 2018年 Easer. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class WorldSceneSmall: BaseWordScene {
    
    var BackgroundNode :BaseObjectSceneNode! = nil
    var GroundNode :BaseObjectSceneNode! = nil
    var _PlayerNode :Player!
    var PlayerNode :Player!{
        set{
            _PlayerNode = newValue
            
            _PlayerNode.zPosition += self.GroundNode.zPosition
            _PlayerNode.position = CGPoint.init(x: 0, y: _PlayerNode.size.height/2)
            _PlayerNode.setCameraLimit(sceneSize: self.size, backGroundSize: self.BackgroundNode.size)
            self.camera = _PlayerNode.cameraNode
            self.BackgroundNode.addChild(_PlayerNode)
        }
        get{
            return _PlayerNode
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
//        self.physicsWorld.gravity = CGVector.init(dx: 0.0, dy: -9.8)
        let image:UIImage! = UIImage.init(named: "backGround")
        let backGroundTexture = SKTexture.init(image: image)
        let backgroundNode = BaseObjectSceneNode.init(texture: backGroundTexture, color: UIColor.white, size: image.size)
        backgroundNode.zPosition = 1;
        backgroundNode.physicsBody = SKPhysicsBody.init(edgeLoopFrom: backgroundNode.frame)
        BackgroundNode = backgroundNode;
        
        let groundTexture = SKTexture.init(imageNamed: "ground")
        let groundNode = BaseObjectSceneNode.init(texture: groundTexture, color: UIColor.red, size: CGSize.init(width: backgroundNode.size.width, height: backgroundNode.size.height/3))
        groundNode.zPosition += backgroundNode.zPosition;
        groundNode.position = CGPoint.init(x: 0, y: -groundNode.size.height/2)
        groundNode.physicsBody = SKPhysicsBody.init(rectangleOf: groundNode.size)
        groundNode.physicsBody?.restitution = 0.0
        GroundNode = groundNode
        
        self.addChild(backgroundNode)
        backgroundNode.addChild(groundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.PlayerNode != nil){
            self.PlayerNode.refreshAction()
        }
    }
}
