//
//  Player.swift
//  Overload
//
//  Created by Easer on 2018/2/2.
//  Copyright © 2018年 Easer. All rights reserved.
//
import SpriteKit
import GameplayKit

enum PlayerActionState {
    case normal
    case jumping
}

class Player: BaseBiologySpriteNode{
    
    var cameraNode:SKCameraNode!
    var moveActionVector:CGVector! = CGVector.zero
    var moveActionScale:CGFloat! = 10.0
    var jumpActionScale:CGFloat! = 100.0
    var jumpActionCount:CGFloat! = 0.0
    var jumpActionMaxCount:CGFloat! = 1.0
    var cameraLimitRect:CGRect!
    
    
    var _actionState:PlayerActionState!
    var actionState:PlayerActionState! {
        set{
            if(_actionState == newValue){
                 return
            }
            _actionState  = newValue
            switch _actionState {
            case .normal:
                self.jumpActionCount = 0.0
                break
                
            case .jumping:
                self.jumpActionCount =  self.jumpActionCount+1.0
                break
                
            default:
                break
                
            }
        }
        get{
            return _actionState
        }
    }
    
    convenience init() {
        self.init(imageNamed:"player")
    }
    
    init(imageNamed name:String) {
        let image:UIImage! = UIImage.init(named: name)
        let SKT:SKTexture! = SKTexture.init(image: image)
        super.init(texture: SKT, color: UIColor.clear, size: image.size)
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.cameraNode = SKCameraNode.init()
        self.addChild(self.cameraNode)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc public func jumpAction(){
        if (self.actionState == .normal || self.jumpActionCount < self.jumpActionMaxCount) {
            self.physicsBody?.applyImpulse(CGVector.init(dx: self.moveActionScale*self.moveActionVector.dx, dy: self.jumpActionScale))
            if(self.jumpActionCount>0){
                self.jumpActionCount =  self.jumpActionCount+1.0
            }
        }
    }
    
    func refreshAction(){
        if (self.isStaying()) {
            self.actionState = .normal
        }else{
            self.actionState = .jumping
        }
        if(self.moveActionVector.dx != 0){
            let moveAction = SKAction.move(by: CGVector.init(dx: self.moveActionVector.dx*self.moveActionScale, dy: 0), duration: 1/60)
            self.run(moveAction)
        }
        if (!self.cameraLimitRect.contains(self.position)) {
            let x:CGFloat! = self.position.x>self.cameraLimitRect.maxX ? self.cameraLimitRect.maxX : (self.position.x<self.cameraLimitRect.minX ? self.cameraLimitRect.minX : self.position.x)
            let y:CGFloat! = self.position.y>self.cameraLimitRect.maxY ? self.cameraLimitRect.maxY : (self.position.y<self.cameraLimitRect.minY ? self.cameraLimitRect.minY : self.position.y)
            let point:CGPoint! = CGPoint.init(x: x-self.position.x, y: y-self.position.y);
            self.cameraNode.position = point
        }
    }
    func isStaying() -> Bool {
        let dx:CGFloat! = self.physicsBody?.velocity.dx
        let dy:CGFloat! = self.physicsBody?.velocity.dy
        return (fabs(dx)<10 && fabs(dy)<10) //判断精致状态的条件不精准，待后处理
    }
    
    func setCameraLimit(sceneSize:CGSize ,backGroundSize:CGSize) -> () {
        let size:CGSize! = CGSize.init(width: backGroundSize.width-sceneSize.width, height: backGroundSize.height-sceneSize.height)
        self.cameraLimitRect = CGRect.init(origin: CGPoint.init(x: -size.width/2, y: -size.height/2), size: size)
    }
    
}
