//
//  GameViewController.swift
//  Overload
//
//  Created by Easer on 2018/1/26.
//  Copyright © 2018年 Easer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var SCENE :WorldSceneSmall! = nil
    var PlayerNode :Player! = nil
    var joystick :Easy_Joystick! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = WorldSceneSmall.init(size: CGSize.init(width: view.bounds.size.width, height: view.bounds.size.height)) as WorldSceneSmall?{
            self.SCENE = scene
            self.PlayerNode = Player.init()
            self.SCENE.PlayerNode = self.PlayerNode

            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(self.SCENE)
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
            
            self.joystick = Easy_Joystick.init()
            view.addSubview(self.joystick)
            self.joystick.center = CGPoint.init(x: joystick.bounds.midX+30, y: view.bounds.maxY - joystick.bounds.midY - 30)
            self.joystick.directionBlock = {(vc:CGVector) in
                self.PlayerNode.moveActionVector = vc
            }
            self.joystick.isHidden = true
            
            let ButtonImg:UIImage! = UIImage.init(named: "Jump@2x")
            let ButtonMask:UIImage! = UIImage.init(named: "ButtonMask@2x")
            let button:UIButton! = UIButton.init(frame: CGRect.init(origin: CGPoint.init(x: view.bounds.maxX - ButtonMask.size.width - 30, y: view.bounds.maxY - ButtonMask.size.height - 30), size: ButtonMask.size))
            button.setBackgroundImage(ButtonImg, for: .normal)
            button.setImage(ButtonMask, for: .normal)
            button.addTarget(self.PlayerNode, action: #selector(Player.jumpAction), for: .touchDown)
            view.addSubview(button)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first
        let point:CGPoint! = touch.location(in: view)

        if (point.x<view.bounds.midX) {
            if(self.joystick.activeState == .couldActive){
                self.joystick.center = point
                self.joystick.isHidden = false
                self.joystick.touchesBegan(touches, with: event)
            }
        }

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first
        let point:CGPoint! = touch.location(in: view)
        if (point.x<view.bounds.midX && self.joystick.activeState == .activing) {
            self.joystick.touchesMoved(touches, with: event)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first
        let point:CGPoint! = touch.location(in: view)
        if (point.x<view.bounds.midX && self.joystick.activeState == .activing) {
            self.joystick.touchesEnded(touches, with: event)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first
        let point:CGPoint! = touch.location(in: view)
        if (point.x<view.bounds.midX && self.joystick.activeState == .activing) {
            self.joystick.touchesCancelled(touches, with: event)
        }
    }
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
