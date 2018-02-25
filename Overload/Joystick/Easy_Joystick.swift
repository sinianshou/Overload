//
//  Easy_Joystick.swift
//  Overload
//
//  Created by Easer on 2018/2/5.
//  Copyright © 2018年 Easer. All rights reserved.
//

import Foundation
import UIKit

enum ActiveState {
    case couldActive
    case activing
}

class Easy_Joystick: UIView{
    var directionButton:UIImageView! = nil
    var dialImg:UIImageView! = nil
    
    var longestLength:CGFloat! = 0
    
    typealias BoolBlockType = ()->(Bool)
    var shouldActiveBlock:BoolBlockType!
    
    
    typealias DirectionBlockType = (CGVector)->()
    var directionBlock:DirectionBlockType!
    
    
    var activeState:ActiveState!
    
    
    
    init() {
        
        let anniuImg:UIImage! = UIImage.init(named: "Joystick_anniu@2x")
        let dipanImg:UIImage! = UIImage.init(named: "Joystick_dipan@2x")
        self.directionButton = UIImageView.init(image: anniuImg)
        self.dialImg = UIImageView.init(image: dipanImg)
        self.directionButton.center = self.dialImg.center
        
        self.longestLength = self.dialImg.bounds.midY*4/3
        self.activeState = .couldActive
        
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: dipanImg.size.width , height: dipanImg.size.height))
        
        
        self.addSubview(self.directionButton)
        self.addSubview(self.dialImg)
        self.bringSubview(toFront: self.directionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.configDirection(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.configDirection(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetDirection()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetDirection()
    }
    
    func callShouldActiveBlock(block:BoolBlockType?) {
        self.shouldActiveBlock = block
    }
    func configDirection(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first
        var point:CGPoint! = touch.location(in: self)
        var xLocation:CGFloat! = point.x - self.bounds.midX
        var yLocation:CGFloat! = point.y - self.bounds.midY
        let length:CGFloat! = hypot(fabs(xLocation), fabs(yLocation))
        
        if(length>self.longestLength){
            xLocation = self.bounds.midX + xLocation*self.longestLength/length
            yLocation = self.bounds.midY + yLocation*self.longestLength/length
            point = CGPoint.init(x: xLocation, y: yLocation)
        }
        self.directionButton.center = point
        if(self.directionBlock != nil){
            self.directionBlock!(CGVector.init(dx: (point.x - self.bounds.midX)/self.dialImg.bounds.midX, dy: -(point.y - self.bounds.midY)/self.dialImg.bounds.midY))
        }
        
        self.activeState = .activing
    }
    func resetDirection(){
        self.directionButton.center = self.dialImg.center
        if(self.directionBlock != nil){
            self.directionBlock!(CGVector.zero)
        }
        self.activeState = .couldActive
        self.isHidden = true
    }
}
