//
//  MapViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/27/22.
//

import UIKit
import MapKit
import RealityKit
import CoreLocation
import ARKit


var locations = [
    ["latitude": 37.721500, "longitude": -122.476796], // 0
    ["latitude": 37.721540, "longitude": -122.476963], // 1
    ["latitude": 37.721614, "longitude": -122.477128], // 2
    ["latitude": 37.721517, "longitude": -122.477228], //3
    ["latitude": 37.721606, "longitude": -122.477456], //4
    ["latitude": 37.721662, "longitude": -122.477724], //5
    ["latitude": 37.721695, "longitude": -122.477275], //6
    ["latitude": 37.721751, "longitude": -122.477425], //7
    ["latitude": 37.721785, "longitude": -122.477626], //8
    ["latitude": 37.721812, "longitude": -122.477962], //9
    ["latitude": 37.721941, "longitude": -122.477988], //10
    ["latitude": 37.722142, "longitude": -122.478017], //11
    ["latitude": 37.722147, "longitude": -122.478211], //12
    ["latitude": 37.722159, "longitude": -122.478459], //13
    ["latitude": 37.721810, "longitude": -122.478289], //14
    ["latitude": 37.721805, "longitude": -122.478608], //15
    ["latitude": 37.721768, "longitude": -122.479000], //16
    ["latitude": 37.721807, "longitude": -122.479179], //17
    ["latitude": 37.721754, "longitude": -122.479203], //18
    ["latitude": 37.721797, "longitude": -122.479372], //19
    ["latitude": 37.721920, "longitude": -122.478940], //20
    ["latitude": 37.721964, "longitude": -122.479100], //21
    ["latitude": 37.722024, "longitude": -122.478895], //22
    ["latitude": 37.722123, "longitude": -122.479024], //23
    ["latitude": 37.722220, "longitude": -122.479157], //24
    ["latitude": 37.722314, "longitude": -122.479107], //25
    ["latitude": 37.722421, "longitude": -122.479055], //26
    ["latitude": 37.722527, "longitude": -122.478991], //27
    ["latitude": 37.722558, "longitude": -122.479136], //28
    ["latitude": 37.722558, "longitude": -122.479307], //29
    ["latitude": 37.722717, "longitude": -122.479372], //30
    ["latitude": 37.722847, "longitude": -122.479420], //31

]

// Helps us truncate location latitude so we know where pins are location.
// We will use this to distinguish SF State pins
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ARSessionDelegate {
    var vertexPath: [Int]!
    var vertexCoordinates: [String: Double]!
    // region used for our map
    let mapRegionInMeters: Double = 500
    // Manages location actions
    private let locationManager = CLLocationManager()
    // user's location
    private var currentCoordinates: CLLocationCoordinate2D?
    // mapView is the map shown in our app
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var arView: ARView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServies()
        // Set this view controller as the MKMapView delegate.
        // This is what shows the map on the bottom half of the screen
        mapView.delegate = self
        mapView.mapType = MKMapType.satelliteFlyover
        // placeAnchorsMap() will place path on map
        placeAnchorsOnMap(locations: locations, vertexPath: vertexPath)


    }
    
    func getlocationCoordinates(locations: [[String: Double]], vertexPath: [Int])->[[String: Double]]{
        var locationCoordinates: [[String: Double]] = [[:]]
        for vertex in vertexPath {
            var value = locations[vertex]
            print("value : \(value)")
            locationCoordinates.append(value)
        }
        return locationCoordinates
    }
    
    
    // placeAnchorsOnMap allows us to place a pin on our map.
    // Currently places red pins but I also want to add other colors
    func placeAnchorsOnMap(locations: [[String : Double]], vertexPath: [Int]){
        // get all the locations
        for vertex in vertexPath {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: locations[vertex]["latitude"]!, longitude: locations[vertex]["longitude"]!)
            let truncated_latitude = annotation.coordinate.latitude.truncate(places: 2)
            var test = 0.0 // 37.72
            // look into this if statement
            if (truncated_latitude != test){
                // brute force to assign a title to each annotation.
                // title determines the color of annotation. (see func mapView() below for reference)
            }
            // Add pin to map
            mapView.addAnnotation(annotation)
        }
    }
    
    
    // Create pin and assign it a color
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // if annotation location == user's location, do not assign it a colored pin.
        // We want to keept the user's location appearance as a blue dot.
        // Ex: blue dot on Apple Maps showing your location
        guard !(annotation is MKUserLocation) else { return nil }
        // create the balloon pin which shows the location of messages posted
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        // Pin color:
        let twitterBlue = UIColor(red: 0/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1.0)
        // Assign color to pin
        annotationView.markerTintColor = twitterBlue
        // Assign image to pin
        annotationView.glyphImage = UIImage(systemName: "figure.walk.circle.fill")

        return annotationView
    }
    
    
    //
    func centerViewOfSchoolOnMap() {
        let schoolLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.722160, -122.478092)
        // convert user location of MKCoordinateRegion in order to place it on our map
        let region = MKCoordinateRegion.init(center: schoolLocation, latitudinalMeters: mapRegionInMeters, longitudinalMeters: mapRegionInMeters)
        // place center view on map
        mapView.setRegion(region, animated: true)
    }
    
    // center our map view around the user to make it easier for them to locate
    // themselves on the map
    func centerViewOfUserOnMap() {
        // if we can get user's location
        if let location = locationManager.location?.coordinate {
            // convert user location of MKCoordinateRegion in order to place it on our map
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: mapRegionInMeters, longitudinalMeters: mapRegionInMeters)
            // place center view on map
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager (){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServies () {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("Location error in func checkLocationStatus()")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            //centerViewOfUserOnMap() // center map around user
            centerViewOfSchoolOnMap()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

    
    func distanceFromDevice(_ coordinate: CLLocationCoordinate2D) -> Double {
        if let devicePosition = locationManager.location?.coordinate {
            return MKMapPoint(coordinate).distance(to: MKMapPoint(devicePosition))
        } else {
            return 0
        }
    }

    
}


extension MapViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // make sure we have a location, else return
        guard let location = locations.last else {return}
        // get center of location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: mapRegionInMeters, longitudinalMeters: mapRegionInMeters)
        //
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // if our location settings change
        checkLocationServies()
    }
}

