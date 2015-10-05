//
//  CircleView.swift
//  ExerciseDemo
//
//  Created by Tomer Ciucran on 24/09/15.
//  Copyright © 2015 tomerciucran. All rights reserved.
//

import UIKit

class TMRCircleView: UIView {

    var circleLayer: CAShapeLayer!
    
    init(frame: CGRect, fillColor: UIColor, strokeColor: UIColor, lineWidth: CGFloat) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        // Draw the circle path with UIBezierPath
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = fillColor.CGColor
        circleLayer.strokeColor = strokeColor.CGColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 0.0
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: Int) {
        
        // Animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = Double(duration)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
