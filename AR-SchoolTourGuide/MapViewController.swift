//
//  MapViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/27/22.
//

import UIKit
import MapKit




// Helps us truncate location latitude so we know where pins are location.
// We will use this to distinguish SF State pins
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // locations: coordinate of our paths, type CLLocationCoordinate2D
    var locations: [[String : Double]]!
    // vertexPath contains the path from start to destination
    var vertexPath: [Int]!
    // our unit of measurement in our map
    let mapRegionInMeters: Double = 500
    // Manages location actions
    private let locationManager = CLLocationManager()
    // user's location
    private var currentCoordinates: CLLocationCoordinate2D?
    // mapView is the map shown in our app
    @IBOutlet weak var mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServies()
        // Set this view controller as the MKMapView delegate.
        // This is what shows the map on the bottom half of the screen
        mapView.delegate = self
        // set map style to satellite flyover
        mapView.mapType = MKMapType.satelliteFlyover
        // placeAnchorsMap() will place path on map
        placeAnchorsOnMap(locations: locations, vertexPath: vertexPath)
    }
    

    /*
        placeAnchorsOnMap() allows us to place a pin on our map.
        locations: array of our locations in latitude, longitude
        vertexPath: array containing path from start to finish
    */
    func placeAnchorsOnMap(locations: [[String : Double]], vertexPath: [Int]){
        // get all the locations
        for i in 0...vertexPath.count-1 {
            var vertex = vertexPath[i]
            let annotation = MKPointAnnotation()
           
            if i == 0 {
                annotation.title = "Start"
            } else if i == vertexPath.count-1 {
                annotation.title = "Destination"
            } else {
                annotation.title = ""
            }
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: locations[vertex]["latitude"]!, longitude: locations[vertex]["longitude"]!)
            
            // Add pin to map
            mapView.addAnnotation(annotation)
        }
    }
    
    
    // Create pin and assign it a color and image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // SF State purple
        let sfStatePurple = UIColor(red: 70/255.0, green: 48/255.0, blue: 119/255.0, alpha: 1.0)
        // SF State yellow
        let sfStateYellow = UIColor(red: 201/255.0, green: 151/255.0, blue: 0/255.0, alpha: 1.0)
        // if annotation location == user's location, do not assign it a colored pin.
        // We want to keept the user's location appearance as a blue dot.
        // Ex: blue dot on Apple Maps showing your location
        guard !(annotation is MKUserLocation) else { return nil }
        // create the balloon pin which shows the location of messages posted
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        
        print("title: \(annotation.title!)")
        
        // Check if message is for public view or only friends, and determine what color to assing it.
        // Blue is public and green is friends only
        switch annotation.title! {
            case "Start":
                // Color: Memoir green
                annotationView.markerTintColor = sfStatePurple
                annotationView.glyphImage = UIImage(systemName: "building.2.crop.circle.fill")
            case "Destination":
                // Color: Twitter blue
                annotationView.markerTintColor = sfStatePurple
                annotationView.glyphImage = UIImage(systemName: "building.2.crop.circle.fill")
            default:
                annotationView.markerTintColor = sfStateYellow
                annotationView.glyphImage = UIImage(systemName: "figure.walk.circle.fill")
        }

        return annotationView
    }
    
    
    // centerViewOfSchoolOnMap() focuses our map at SF State
    func centerViewOfSchoolOnMap() {
        let schoolLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.722160, -122.478092)
        // convert user location of MKCoordinateRegion in order to place it on our map
        let region = MKCoordinateRegion.init(center: schoolLocation, latitudinalMeters: mapRegionInMeters, longitudinalMeters: mapRegionInMeters)
        // place center view on map
        mapView.setRegion(region, animated: true)
    }
    
    
    // centerViewOfUserOnMap() focuses our map at SF State
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

