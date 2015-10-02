//
//  ExerciseViewModel.swift
//  ExerciseDemo
//
//  Created by Tomer Ciucran on 02/10/15.
//  Copyright © 2015 tomerciucran. All rights reserved.
//

import UIKit

class ExerciseViewModel: NSObject {
    
    struct Exercise {
        var name: String!
        var videoIdentifier: String!
        var variation: String!
        
        init(name: String, videoIdentifier: String, variation: String) {
            self.name = name
            self.videoIdentifier = videoIdentifier
            self.variation = variation
        }
    }

    var exerciseModel: Exercise!
    let numberOfComponentsInPicker = 1
    let numberOfRowsInPicker = 30
    
    override init() {
        super.init()
        
        exerciseModel = Exercise(name: "Squats", videoIdentifier: "squats_to_chair", variation: "to chair")
    }
}
