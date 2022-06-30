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


var annotationLocations = [
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
    var vertexPath: [Int]?
    // region used for our map
    let mapRegionInMeters: Double = 500
    // Manages location actions
    private let locationManager = CLLocationManager()
    // user's location
    private var currentCoordinates: CLLocationCoordinate2D?
    // mapView is the map shown in our app
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var arView: ARView!
//     Geo anchors ordered by the time of their addition to the scene.
//     geoAnchors is an array of type GeoAnchorWithAssociatedData
    
    var geoAnchors: [GeoAnchorWithData] = []
    //var test: CLLocationCoordinate2D
    
    var test = CLLocationCoordinate2DMake(37.71837700863713, -122.39184451228083)
    
    
    //-122.39184451228083
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServies()
        // Set this view controller as the MKMapView delegate.
        // This is what shows the map on the bottom half of the screen
        mapView.delegate = self
        // If user clicks on the map shown on the bottom half
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnMapView(_:))))
        //placeAnchorsOnMap(locations: annotationLocations)
        print("------------")
        print(vertexPath)
        print("------------")

    }
    
    
    // placeAnchorsOnMap allows us to place a pin on our map.
    // Currently places red pins but I also want to add other colors
    func placeAnchorsOnMap(locations: [[String : Double]]){
        // get all the locations
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            let truncated_latitude = annotation.coordinate.latitude.truncate(places: 2)
            if (truncated_latitude != 37.72){
                // brute force to assign a title to each annotation.
                // title determines the color of annotation. (see func mapView() below for reference)
                annotation.title = "Friends"
                
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
        // Pin colors:
        // 1. Twitter blue
        let twitterBlue = UIColor(red: 0/255.0, green: 172/255.0, blue: 238/255.0, alpha: 1.0)
        // 2. Memoir green
        let memoirGreen = UIColor(red: 130/255.0, green: 255/255.0, blue: 175/255.0, alpha: 1.0)
        // 3. SF State purple
        let sfStatePurple = UIColor(red: 70/255.0, green: 48/255.0, blue: 119/255.0, alpha: 1.0)
        // 4. SF State yellow
        let sfStateYellow = UIColor(red: 201/255.0, green: 151/255.0, blue: 0/255.0, alpha: 1.0)
        // Check if message is for public view or only friends, and determine what color to assing it.
        // Blue is public and green is friends only
        switch annotation.title! {
            case "Public":
                // Color: Memoir green
                annotationView.markerTintColor = memoirGreen
                annotationView.glyphImage = UIImage(systemName: "person.3.fill")
            case "Friends":
                // Color: Twitter blue
                annotationView.markerTintColor = twitterBlue
                annotationView.glyphImage = UIImage(systemName: "star.fill")
            case "Students":
                // Color: SF State purple
                annotationView.markerTintColor = sfStatePurple
                annotationView.glyphImage = UIImage(systemName: "laptopcomputer")
            case "Student&Friend":
                // Color: SF State yellow
                annotationView.markerTintColor = sfStateYellow
                annotationView.glyphImage = UIImage(systemName: "star.fill")
            default:
                annotationView.markerTintColor = twitterBlue
        }
        return annotationView
    }
    
    // Responds to a user tap on the map view.
    @objc
    func handleTapOnMapView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let location = mapView.convert(point, toCoordinateFrom: mapView)
        print("handleTapOnMapView()")
        //addGeoAnchor(at: location)
        
        // add blue dot to map
        
    
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
            centerViewOfUserOnMap()
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
    
    // MARK: - ARSessionDelegate
    // THIS FUNCTION HELPS US ADD THE AR ANCHOR TO OUR AR WORLD AND MAP VIEW FOUND
    // ON THE BOTTOM HALF
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("inside session")
        // CYCLE THROUGH ALL OF OUR GEOANCHORS
        for geoAnchor in anchors.compactMap({ $0 as? ARGeoAnchor }) {
            // Effect a spatial-based delay to avoid blocking the main thread.
            DispatchQueue.main.asyncAfter(deadline: .now() + (distanceFromDevice(geoAnchor.coordinate) / 10)) {
                // Add an AR placemark visualization for the geo anchor.
                // Entity.placemarkEntity(for: geoAnchor) -> returns AnchorEntity
                
                //self.arView.scene.addAnchor(Entity.placemarkEntity(for: geoAnchor))
            }
            // Add a visualization for the geo anchor in the map view.
            let anchorIndicator = AnchorIndicator(center: geoAnchor.coordinate)
            self.mapView.addOverlay(anchorIndicator)

            // Remember the geo anchor we just added
            let anchorInfo = GeoAnchorWithData(geoAnchor: geoAnchor, mapOverlay: anchorIndicator)
            self.geoAnchors.append(anchorInfo)
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

