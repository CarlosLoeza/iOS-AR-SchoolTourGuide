//
//  MapViewController.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/27/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // region used for our map
    let mapRegionInMeters: Double = 1000
    // Manages location actions
    private let locationManager = CLLocationManager()
    // user's location
    private var currentCoordinates: CLLocationCoordinate2D?
    // mapView is the map shown in our app
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServies()
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
        print(locationManager.location?.coordinate)
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
}


extension MapViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

