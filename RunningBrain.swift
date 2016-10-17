//
//  RunningBrain.swift
//  Running app test
//
//  Created by Bodang on 08/10/2016.
//  Copyright © 2016 Bodang. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

class RunningBrain {
    private let locationManager: CLLocationManager = CLLocationManager()
    private let motionManager: CMMotionManager = CMMotionManager()
    
    private var velocityAssetsIndex = 0
    private var velocityAssets: Array<Double> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    
    func smoothingVelocity(Velocity:Double, Accuracy: Double) -> Double {
        velocityAssets[velocityAssetsIndex % 10] = Velocity
        print(velocityAssets[0])
        print(velocityAssets[1])
        print(velocityAssets[2])
        print(velocityAssets[3])
        print(velocityAssets[4])
        print(velocityAssets[5])
        print(velocityAssets[6])
        print(velocityAssets[7])
        print(velocityAssets[8])
        print(velocityAssets[9])
        print("")
        velocityAssetsIndex += 1
        return (velocityAssets[0] + velocityAssets[1] + velocityAssets[2] + velocityAssets[3] + velocityAssets[4] + velocityAssets[5] + velocityAssets[6] + velocityAssets[7] + velocityAssets[8] + velocityAssets[9]) / 10
    }
    
    func calculatePaceRate(Velocity: Double) -> Dictionary<String, Int>{
        let pace = 1000 / Velocity
        let paceInMinute: Int = Int(pace) / 60
        let paceInSecond: Int = Int(pace) % 60
        
        let paceRate: Dictionary<String, Int> = [
            "minute": paceInMinute,
            "second": paceInSecond
        ]
        return paceRate
    }
    
    public func getLocationManager() -> CLLocationManager {
        return locationManager
    }
    public func getMotionManager() -> CMMotionManager {
        return motionManager
    }
    
}
