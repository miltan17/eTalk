//
//  AnimatedStartButton.swift
//  eTalk
//
//  Created by Miltan on 12/24/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class AnimatedStartButton: UIButton {

    // The horizontal disantce between the two lines in pause mode
    let pauseSpace: CGFloat = 10.0
    
    // This is due to the graphic being larger from the drop shadows
    let shadowPadding: CGFloat = 8.0
    
    
    let linePath: CGPath = {
        let path = CGMutablePath() //UIBezierPath() //CGPathCreateMutable()
//        CGPathMoveToPoint(path, nil, 0, 0)
//        CGPathAddLineToPoint(path, nil, 0, 12)
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: 12.0))
        
        return path as! CGPath
    }()
    
    let bottomTransform = CATransform3DRotate(CATransform3DMakeTranslation(0, 2, 0), CGFloat(M_PI/4), 0, 0, 1)
    let topTransform = CATransform3DRotate(CATransform3DMakeTranslation(-10, -2, 0), CGFloat(-M_PI/4), 0, 0, 1)
    
    override var isSelected: Bool {
        didSet {
            addTransforms()
        }
    }
    
    var top: CAShapeLayer! = CAShapeLayer()
    var bottom: CAShapeLayer! = CAShapeLayer()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.setupPaths()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupPaths(frame: frame)
    }
    
    func setupPaths(frame: CGRect) {
        let lineWidth: CGFloat = 2
        
        self.top.path = linePath
        self.bottom.path = linePath
        
        for layer in [ self.top, self.bottom ] {
            layer?.fillColor = nil
            layer?.strokeColor = UIColor.white.cgColor
            layer?.lineWidth = lineWidth
            layer?.lineCap = kCALineCapSquare
            layer?.masksToBounds = true
            
            let strokingPath = CGPath(roundedRect: frame, cornerWidth: lineWidth * 2, cornerHeight: 10.0, transform: nil)
//            let strokingPath = CGPath(__byStroking: (layer?.path)!, transform: nil, lineWidth: lineWidth*2, lineCap: kCALineCapSquare, lineJoin: kCALineJoinMiter, miterLimit: 0)
            
            layer?.bounds = strokingPath.boundingBoxOfPath
            layer?.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer!)
        }
        
        self.top.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.top.position = CGPoint(x: self.frame.size.width / 2 + pauseSpace / 2, y: (self.frame.size.height-shadowPadding)/2 - 12/2)
        self.top.transform = topTransform
        
        self.bottom.anchorPoint =  CGPoint(x: 0.5, y: 1.0)
        self.bottom.position = CGPoint(x: self.frame.size.width/2 - pauseSpace/2, y: self.top.position.y + 12 +  shadowPadding/2)
        self.bottom.transform = bottomTransform
    }
    
    
    func addTransforms() {
        let bottomAnimation = CABasicAnimation(keyPath: "transform")
        bottomAnimation.duration = 0.4
        bottomAnimation.fillMode = kCAFillModeBackwards
        bottomAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        
        let topAnimation = bottomAnimation.copy() as! CABasicAnimation
        
        if (isSelected) {
            bottomAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
            topAnimation.toValue  = NSValue(caTransform3D: CATransform3DIdentity)
        }
        else {
            bottomAnimation.toValue = NSValue(caTransform3D: bottomTransform)
            topAnimation.toValue = NSValue(caTransform3D: topTransform)
        }
        self.bottom.kv_applyAnimation(bottomAnimation)
        self.top.kv_applyAnimation(topAnimation)
    }
    
}

extension CALayer {
    func kv_applyAnimation(_ animation: CABasicAnimation) {
        let copy = animation.copy() as! CABasicAnimation
        
        if copy.fromValue == nil {
            copy.fromValue = self.presentation()?.value(forKeyPath: copy.keyPath!)
        }
        
        self.add(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
    }

}
