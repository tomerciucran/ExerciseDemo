//
//  TMRCircleTimerView.swift
//  ExerciseDemo
//
//  Created by Tomer Ciucran on 04/10/15.
//  Copyright © 2015 tomerciucran. All rights reserved.
//

import UIKit

protocol TMRCircleTimerViewDelegate: class {
    func timerDidFinish()
}

class TMRCircleTimerView: UIView {
    
    var delegate: TMRCircleTimerViewDelegate?
    var circleView: TMRCircleView!
    var timer = NSTimer()
    var counter: Int!
    var counterLabel: UILabel!
    var duration: Int!

    init(frame: CGRect, duration: Int, fillColor: UIColor, strokeColor: UIColor, lineWidth: CGFloat) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        circleView = TMRCircleView(frame: frame, fillColor: fillColor, strokeColor: strokeColor, lineWidth: 5.0)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circleView)
        
        self.counter = duration
        self.duration = duration
        circleView.animateCircle(duration)
        counterLabel = UILabel()
        counterLabel.numberOfLines = 1
        counterLabel.adjustsFontSizeToFitWidth = true
        counterLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        counterLabel.backgroundColor = UIColor.clearColor()
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setCounterLabel()
        
        counterLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(counterLabel)
        
        let counterLabelLeadingConstraint = NSLayoutConstraint(item: counterLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20)
        
        let counterLabelTrailingConstraint = NSLayoutConstraint(item: counterLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20)
        
        let counterLabelTopConstraint = NSLayoutConstraint(item: counterLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20)
        
        let counterLabelBottomConstraint = NSLayoutConstraint(item: counterLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20)
        
        addConstraints([counterLabelLeadingConstraint, counterLabelTrailingConstraint, counterLabelTopConstraint, counterLabelBottomConstraint])
        
        let circleViewCenterXConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        
        let circleViewCenterYConstraint = NSLayoutConstraint(item: circleView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        
        addConstraints([circleViewCenterXConstraint, circleViewCenterYConstraint])
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0
            , target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateTimer(dt: NSTimer)
    {
        counter!--
        if counter == 0 {
            
            delegate?.timerDidFinish()
            timer.invalidate()
            resetCircle()
            setCounterLabel()
        } else {
            setCounterLabel()
        }
    }
    
    // MARK: - Private Methods
    
    private func timeFromTimeInterval(interval:Int) -> (Int, Int)? {
        
        let ti = NSInteger(interval)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return (minutes, seconds)
    }

    func resetCircle() {
        circleView.circleLayer.removeAllAnimations()
        circleView.circleLayer.strokeEnd = 1.0
        timer.invalidate()
    }
    
    private func setCounterLabel() {
        if let time = timeFromTimeInterval(counter) {
            if time.0 < 10 && time.1 < 10 {
                counterLabel.text = "0\(time.0):0\(time.1)"
            } else if time.0 < 10 && time.1 > 9 {
                counterLabel.text = "0\(time.0):\(time.1)"
            } else if time.0 > 9 && time.1 < 10 {
                counterLabel.text = "\(time.0):0\(time.1)"
            }
        }
    }
}
