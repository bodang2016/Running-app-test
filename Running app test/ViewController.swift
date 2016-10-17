//
//  ViewController.swift
//  Running app test
//
//  Created by Bodang on 28/09/2016.
//  Copyright © 2016 Bodang. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var altitudeLbl: UILabel!
    @IBOutlet weak var horizontalAccuracyLbl: UILabel!
    @IBOutlet weak var verticalAccuracyLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var velocityLbl: UILabel!
    @IBOutlet weak var accXLbl: UILabel!
    @IBOutlet weak var accYLbl: UILabel!
    @IBOutlet weak var accZLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var paceSmoothLbl: UILabel!
    
    
    //Model
    var runningBrain = RunningBrain()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //GPS service
        runningBrain.getLocationManager().delegate = self
        runningBrain.getLocationManager().desiredAccuracy = kCLLocationAccuracyBest
        runningBrain.getLocationManager().distanceFilter = 1
        runningBrain.getLocationManager().requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            runningBrain.getLocationManager().startUpdatingLocation()
        }

        //Accelerometer service
        runningBrain.getMotionManager().accelerometerUpdateInterval = 0.1
        if runningBrain.getMotionManager().isAccelerometerAvailable {
            runningBrain.getMotionManager().startAccelerometerUpdates(to: OperationQueue.main, withHandler: {
                (motion: CMAccelerometerData?, error: Error?) -> Void in
                let textX = "Gravity X: \(motion!.acceleration.x)"
                let textY = "Gravity Y: \(motion!.acceleration.y)"
                let textZ = "Gravity Z: \(motion!.acceleration.z)"
                
                DispatchQueue.main.async(execute: {
                    self.accXLbl.text = textX
                    self.accYLbl.text = textY
                    self.accZLbl.text = textZ
                })
            })
        }
        
    }
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        
        let paceInMinute = runningBrain.calculatePaceRate(Velocity: currentLocation.speed)["minute"]!
        let paceInSecond = runningBrain.calculatePaceRate(Velocity: currentLocation.speed)["second"]!
        
        let paceSmoothInMinute = runningBrain.calculatePaceRate(Velocity: runningBrain.smoothingVelocity(Velocity: currentLocation.speed, Accuracy: currentLocation.horizontalAccuracy))["minute"]!
        let paceSmoothInSecond = runningBrain.calculatePaceRate(Velocity: runningBrain.smoothingVelocity(Velocity: currentLocation.speed, Accuracy: currentLocation.horizontalAccuracy))["second"]!
        let paceInMinuteNorm = String(format:"%02d",paceInMinute)
        let paceInSecondNorm = String(format:"%02d",paceInSecond)
        let paceSmoothInMinuteNorm = String(format:"%02d",paceSmoothInMinute)
        let paceSmoothInSecondNorm = String(format:"%02d",paceSmoothInSecond)
        
        longitudeLbl.text = "Longitude: \(currentLocation.coordinate.longitude)"
        latitudeLbl.text = "Latitude: \(currentLocation.coordinate.latitude)"
        altitudeLbl.text = "Altitude: \(currentLocation.altitude)"
        horizontalAccuracyLbl.text = "Horizontal accuracy: \(currentLocation.horizontalAccuracy)"
        verticalAccuracyLbl.text = "Vertical accuracy: \(currentLocation.verticalAccuracy)"
        headingLbl.text = "Heading: \(currentLocation.course)"
        velocityLbl.text = "Velocity: \(runningBrain.smoothingVelocity(Velocity: currentLocation.speed, Accuracy: currentLocation.horizontalAccuracy))"
        paceSmoothLbl.text = "PaceSmooth: \(paceSmoothInMinuteNorm):\(paceSmoothInSecondNorm)"
        paceLbl.text = "Pace: \(paceInMinuteNorm):\(paceInSecondNorm)"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

