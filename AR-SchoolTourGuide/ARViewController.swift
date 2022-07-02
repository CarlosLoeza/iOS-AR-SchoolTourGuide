//
//  ARViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/1/22.
//

import ARKit
import RealityKit
import UIKit

// locations: coordinate of our paths, type CLLocationCoordinate2D
//var locations = [
//    ["latitude": 37.721500, "longitude": -122.476796], // 0
//    ["latitude": 37.721540, "longitude": -122.476963], // 1
//    ["latitude": 37.721614, "longitude": -122.477128], // 2
//    ["latitude": 37.721517, "longitude": -122.477228], //3
//    ["latitude": 37.721606, "longitude": -122.477456], //4
//    ["latitude": 37.721662, "longitude": -122.477724], //5
//    ["latitude": 37.721695, "longitude": -122.477275], //6
//    ["latitude": 37.721751, "longitude": -122.477425], //7
//    ["latitude": 37.721785, "longitude": -122.477626], //8
//    ["latitude": 37.721812, "longitude": -122.477962], //9
//    ["latitude": 37.721941, "longitude": -122.477988], //10
//    ["latitude": 37.722142, "longitude": -122.478017], //11
//    ["latitude": 37.722147, "longitude": -122.478211], //12
//    ["latitude": 37.722159, "longitude": -122.478459], //13
//    ["latitude": 37.721810, "longitude": -122.478289], //14
//    ["latitude": 37.721805, "longitude": -122.478608], //15
//    ["latitude": 37.721768, "longitude": -122.479000], //16
//    ["latitude": 37.721807, "longitude": -122.479179], //17
//    ["latitude": 37.721754, "longitude": -122.479203], //18
//    ["latitude": 37.721797, "longitude": -122.479372], //19
//    ["latitude": 37.721920, "longitude": -122.478940], //20
//    ["latitude": 37.721964, "longitude": -122.479100], //21
//    ["latitude": 37.722024, "longitude": -122.478895], //22
//    ["latitude": 37.722123, "longitude": -122.479024], //23
//    ["latitude": 37.722220, "longitude": -122.479157], //24
//    ["latitude": 37.722314, "longitude": -122.479107], //25
//    ["latitude": 37.722421, "longitude": -122.479055], //26
//    ["latitude": 37.722527, "longitude": -122.478991], //27
//    ["latitude": 37.722558, "longitude": -122.479136], //28
//    ["latitude": 37.722558, "longitude": -122.479307], //29
//    ["latitude": 37.722717, "longitude": -122.479372], //30
//    ["latitude": 37.722847, "longitude": -122.479420], //31
//
//]


class ARViewController: UIViewController, ARSessionDelegate, CLLocationManagerDelegate {
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
