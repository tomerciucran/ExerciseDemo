//
//  ViewController.swift
//  ExerciseDemo
//
//  Created by Tomer Ciucran on 24/09/15.
//  Copyright © 2015 tomerciucran. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoUrl: NSURL!
    var timer = NSTimer()
    var counter:Int = 30
    var counterLabel: UILabel!
    var nameLabel: UILabel!
    var variationLabel: UILabel!
    var circleView: CircleView!
    var pickerArray = [Int]()
    var alertController: UIAlertController!
    var skipButton: UIButton!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playVideo()
        loadPickerAlertView()
        addLabelsAndButtons()
        addTimerView()
        addLoopObserver()
    }
    
    //the element sizes are best optimized for iPhone 6s and bigger screen sizes, but it works on all iPhones except for 3.5 inch models.
    //I'd be glad if you point out my mistakes or bad practices to help me improve my programming profile.
    
    // MARK: - Labels & Buttons & Timer methods
    
    private func addLabelsAndButtons() {
        
        // Create name label and add it to the view
        nameLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 100, y: playerLayer.frame.origin.y + playerLayer.bounds.height + 20, width: 200, height: 50))
        nameLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        nameLabel.text = "Squats"
        nameLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nameLabel)
        
        // Create variation label and add it to the view
        variationLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 100, y: playerLayer.frame.origin.y + playerLayer.bounds.height + 100, width: 200, height: 50))
        variationLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        variationLabel.textAlignment = NSTextAlignment.Center
        variationLabel.text = "to chair"
        self.view.addSubview(variationLabel)
        
        // Calculate space between name and variation labels
        let spaceLength = (variationLabel.frame.origin.y - (nameLabel.frame.origin.y + nameLabel.bounds.height))/2 - 1
        
        // Create seperatorView between the labels and add it the view
        let seperatorView = UIView(frame: CGRect(x: 50, y: spaceLength + nameLabel.frame.origin.y + nameLabel.bounds.height, width: self.view.bounds.width - 100, height: 2))
        seperatorView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(seperatorView)
        
        // Create skip button, add a target and add it to the view
        skipButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 - 100, y: self.view.bounds.height - 100, width: 200, height: 50))
        skipButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        skipButton.titleLabel?.textAlignment = NSTextAlignment.Center
        skipButton.setTitle("Skip Exercise", forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        skipButton.addTarget(self, action: Selector("skipButtonAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(skipButton)
    }
    
    // Triggered when "skip" button is tapped
    func skipButtonAction() {
        
        //Present the alert controller
        presentViewController(alertController, animated: true, completion: nil);
        timer.invalidate()
        counterLabel.font = UIFont(name: "AvenirNext-Demibold", size: 20)
        counterLabel.text = "Skipped!"
        circleView.resetCircle()
        
    }
    
    private func addTimerView() {
        
        // Create circle view and add it to the view
        circleView = CircleView(frame: CGRect(x: self.view.bounds.width/2 - 75, y: variationLabel.frame.origin.y + variationLabel.bounds.height + 20, width: 150, height: 150))
        self.view.addSubview(circleView)
        
        // Trigger the circle animation
        circleView.animateCircle(30)
        
        // Create counter label and add it to the view
        counterLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 50, y: variationLabel.frame.origin.y + variationLabel.bounds.height + 70, width: 100, height: 50))
        counterLabel.text = "00:30"
        counterLabel.textAlignment = NSTextAlignment.Center
        counterLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        self.view.addSubview(counterLabel)
        
        // Set timer with time interval and selector
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0
            , target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
    }
    
    // Triggered everytime the timer's interval is set
    func updateTimer(dt: NSTimer)
    {
        
        // Decrement the counter variable
        counter--
        
        if counter == 0{ // Triggered when the counter is zero
            
            // Disable skip button
            skipButton.enabled = false
            
            // Invalidate the timer and reset the timer circle view
            timer.invalidate()
            circleView.resetCircle()
            
            //Present the alert controller
            presentViewController(alertController, animated: true, completion: nil);
            
            // Edit the counter label
            counterLabel.font = UIFont(name: "AvenirNext-Demibold", size: 18)
            counterLabel.text = "Completed!"
        } else{ // Set the remaining seconds to counter label
            if counter < 10 { // Add a "0" to numbers below 10
                counterLabel.text = "00:0\(counter)"
            } else {
                counterLabel.text = "00:\(counter)"
            }
        }
    }
    
    // MARK: - AlertView methods
    
    private func loadPickerAlertView() {
        
        // Create the alert controller
        let title = "How many reps?"
        let message = "\n\n\n\n\n\n\n"
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.modalInPopover = true
        
        // Create the picker
        let picker = UIPickerView(frame: CGRectMake(0, 50, 270, 100))
        
        // Set the pickers datasource and delegate
        picker.delegate = self
        picker.dataSource = self
        
        // Add the picker to the alert controller
        alertController.view.addSubview(picker)
        
        // Create button action and add it to the action controller
        let selectButtonAction = UIAlertAction(title: "Select", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            self.alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(selectButtonAction)
        
        // Populate picker array
        for (var i = 1; i <= 30; i++) {
            pickerArray.append(i)
        }
    }
    
    // MARK: - PickerView delegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerArray[row])"
    }
    
    // MARK: - Video player methods
    
    private func addLoopObserver() {
        
        // Add an observer to trigger when the video ends to create a loop
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil)
    }
    
    private func playVideo() {
        
        // Create the player and playerLayer, add it to the view's layer's sublayers
        if let path = NSBundle.mainBundle().pathForResource("10003", ofType: "mp4") {
            videoUrl = NSURL(fileURLWithPath: path)
            player = AVPlayer(URL: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerLayer.backgroundColor = UIColor.clearColor().CGColor
            self.view.layer.addSublayer(playerLayer)
            player.play()
        } else { // Triggered if the video couldn't be found inside the project bundle
            print("Couldn't find the video")
        }
    }
    
    // Triggered when the video reaches its end
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seekToTime(kCMTimeZero)
        self.player.play()
    }
    
    // MARK - Memory

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

