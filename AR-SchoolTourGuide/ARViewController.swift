//
//  ARViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/1/22.
//

import ARKit
import RealityKit
import UIKit




class ARViewController: UIViewController, ARSessionDelegate, CLLocationManagerDelegate {
    // locations: coordinate of our paths, type CLLocationCoordinate2D
    var locations: [[String : Double]]!
    // vertexPath contains the path from start to destination
    var vertexPath: [Int]!
    // AR view in our app
    @IBOutlet weak var arView: ARView!
    let locationManager = CLLocationManager()
    // coachingOverlay helps us setup our AR environment
    let coachingOverlay = ARCoachingOverlayView()
    // Gets the anchors from the last frame captured by rear iPhone camera
    var currentAnchors: [ARAnchor] {
        return arView.session.currentFrame?.anchors ?? []
    }
    // Geo anchors ordered by the time of their addition to the scene.
    // geoAnchors is an array of type GeoAnchorWithAssociatedData
    var geoAnchors: [GeoAnchorWithData] = []
    
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Set this view controller as the session's delegate.
        arView.session.delegate = self
        // Enable coaching.
        setupCoachingOverlay()
        // Set this view controller as the Core Location manager delegate.
        locationManager.delegate = self
        // Disable automatic configuration and set up geotracking
        // Look into why they configure it manually
        arView.automaticallyConfigureSession = false
        // Run a new AR Session.
        // Look into why they reset session; Is it to load the features above??
        runARSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start listening for location updates from Core Location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // Disable Core Location when the view disappears.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    func runARSession() {
        ARGeoTrackingConfiguration.checkAvailability { (available, error) in
            guard available else {
                print("LOG ERROR - Geolocation availability does not work. See: https://developer.apple.com/documentation/arkit/argeotrackingconfiguration/3571351-checkavailability")
                self.runARSession()
                return
            }

            let geoTrackingConfig = ARGeoTrackingConfiguration()
            geoTrackingConfig.planeDetection = [.horizontal]
            //self.ARView.debugOptions = [.showPhysics]
            self.arView.session.run(geoTrackingConfig)
            
        }
        
    }
    
    
}
