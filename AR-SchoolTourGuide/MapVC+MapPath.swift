//
//  MapVC+MapPath.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 6/28/22.
//

import Foundation
import RealityKit
import ARKit
import UIKit


extension MapViewController {
    
    
    // Second use location and altitude to create our geoAnchor
    // This addGeoAnchor figures out which coordinates to use
    // Ex: location aka (latitude and longitude) and altitude
    func addGeoAnchor(at location: CLLocationCoordinate2D, altitude: CLLocationDistance? = nil) {
        print("addGeo1")
        var geoAnchor: ARGeoAnchor!
        // if we have an altitude, include it in our geoAnchor
//        if let altitude = altitude {
//            geoAnchor = ARGeoAnchor(coordinate: location, altitude: altitude)
//        // else only include location aka latitude and longitude
//        } else {
        //geoAnchor = ARGeoAnchor(coordinate: location)
        
        
        //}
        // Pass the geoAnchor created to addGeoAnchor()
        
        //addGeoAnchor(geoAnchor)
    }
    
    // This addGeoAnchor gets the geoAnchor created above and places it
    func addGeoAnchor(_ geoAnchor: ARGeoAnchor) {
        print("addGeo2: \(geoAnchor)")
        
        // Don't add a geo anchor if Core Location isn't sure yet where the user is.
        guard isGeoTrackingLocalized else {
       
        alertUser(withTitle: "Cannot add geo anchor", message: "Unable to add geo anchor because geotracking has not yet localized.")
            return
        }
        if geoAnchor == nil {
            print("yes nil")
        } else {
            print("not nil")
        }
        
        arView.session.add(anchor: geoAnchor)
    }
    

    var isGeoTrackingLocalized: Bool {
//        if let status = arView.session.currentFrame?.geoTrackingStatus, status.state == .localized {
//            return true
//        }
//        return false
        return true
    }

}
