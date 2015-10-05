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

class ExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, TMRCircleTimerViewDelegate {
    
    var viewModel: ExerciseViewModel!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoUrl: NSURL!
    var nameLabel: UILabel!
    var variationLabel: UILabel!
    var timerView: TMRCircleTimerView!
    var pickerArray = [Int]()
    var alertController: UIAlertController!
    var skipButton: UIButton!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.viewModel = ExerciseViewModel()
        
        playVideo()
        loadPickerAlertView()
        addLabelsAndButtons()
        addTimerView()
        addLoopObserver()
    }
    
    // MARK: - Labels & Buttons & Timer methods
    
    private func addLabelsAndButtons() {
        
        nameLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 100, y: playerLayer.frame.origin.y + playerLayer.bounds.height + 20, width: 200, height: 50))
        nameLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        nameLabel.text = viewModel.exerciseModel.name
        nameLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(nameLabel)
        
        variationLabel = UILabel(frame: CGRect(x: self.view.bounds.width/2 - 100, y: playerLayer.frame.origin.y + playerLayer.bounds.height + 100, width: 200, height: 50))
        variationLabel.font = UIFont(name: "AvenirNext-Demibold", size: 32)
        variationLabel.textAlignment = NSTextAlignment.Center
        variationLabel.text = viewModel.exerciseModel.variation
        self.view.addSubview(variationLabel)
        
        // Calculate space between name and variation labels
        let spaceLength = (variationLabel.frame.origin.y - (nameLabel.frame.origin.y + nameLabel.bounds.height))/2 - 1
        
        // Create seperatorView between the labels and add it the view
        let seperatorView = UIView(frame: CGRect(x: 50, y: spaceLength + nameLabel.frame.origin.y + nameLabel.bounds.height, width: self.view.bounds.width - 100, height: 2))
        seperatorView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(seperatorView)
        
        if UIScreen.mainScreen().bounds.height > 568 { // Changing y of skipButton for 4 inch screens.
            skipButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 - 100, y: self.view.bounds.height - 100, width: 200, height: 50))
        } else {
            skipButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 - 100, y: self.view.bounds.height - 50, width: 200, height: 50))
        }
        
        skipButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        skipButton.titleLabel?.textAlignment = NSTextAlignment.Center
        skipButton.setTitle("Skip Exercise", forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        skipButton.addTarget(self, action: Selector("skipButtonAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(skipButton)
    }
    
    func skipButtonAction() {
        
        presentViewController(alertController, animated: true, completion: nil);
        timerView.resetCircle()
        
    }
    
    private func addTimerView() {
        
        timerView = TMRCircleTimerView(frame: CGRect(x: self.view.bounds.width/2 - 75, y: variationLabel.frame.origin.y + variationLabel.bounds.height + 20, width: 150, height: 150), duration: 30, fillColor: UIColor.lightGrayColor(), strokeColor: UIColor.blueColor(), lineWidth: 5.0)
        timerView.delegate = self
        self.view.addSubview(timerView)
    }
    
    // MARK: - AlertView methods
    
    private func loadPickerAlertView() {
        
        let title = "How many reps?"
        let message = "\n\n\n\n\n\n\n"
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.modalInPopover = true
        
        let picker = UIPickerView(frame: CGRectMake(0, 50, 270, 100))
        
        picker.delegate = self
        picker.dataSource = self
        
        alertController.view.addSubview(picker)
        
        let selectButtonAction = UIAlertAction(title: "Select", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            self.alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(selectButtonAction)
        
        // Populate picker array
        for (var i = 1; i <= viewModel.numberOfRowsInPicker; i++) {
            pickerArray.append(i)
        }
    }
    
    // MARK: - TMRCircleTimerViewDelegate
    
    func timerDidFinish() {
        presentViewController(alertController, animated: true, completion: nil);
        timerView.resetCircle()
    }
    
    // MARK: - PickerView delegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponentsInPicker
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return viewModel.numberOfRowsInPicker
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

