//
//  ARVC+PlaceAnchors.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/1/22.
//

import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func placeExistingMessages(locations: [[String : Double]], vertexPath: [Int]) {
        // get all the locations
        for vertex in vertexPath {
            let loc = CLLocationCoordinate2D(latitude: locations[vertex]["latitude"]!, longitude: locations[vertex]["longitude"]!)
            self.addGeoLocationToAnchor(at: loc)
        }
    }
    
    // addGeoLocation creates an ARGeoAnchor to assign it a location
    func addGeoLocationToAnchor(at location: CLLocationCoordinate2D){
        // Create a geoAnchor variable to assign it our location
        var geoAnchor: ARGeoAnchor!
        // Assign geoLocation
        geoAnchor = ARGeoAnchor(coordinate: location)
        prepareToAddGeoAnchor(geoAnchor)
    }
    
    // ENDS HERE
    // prepareToAddGeoAnchor adds the geoAnchor to our AR world
    func prepareToAddGeoAnchor(_ geoAnchor: ARGeoAnchor){
        // Don't add a geo anchor if Core Location isn't sure yet where the user is.
        #if targetEnvironment(simulator)
        print("in simulator")
        #else
        do {
            guard isGeoTrackingLocalized else {
                debugPrint("LOG - ERROR. Cannot add geo anchor to session because arcore location has not identified where the user is.")
                return
            }
            
            arView.session.add(anchor: geoAnchor)
            
            // create geoAnchorEntity for our message
            let geoAnchorEntity = AnchorEntity(anchor: geoAnchor)
            let entity = try! Entity.load(named: "pin")
            //entity.name = "geo anchor entity message"
            // double scale size
            entity.scale = [3, 3, 3]
            
            // create parent entity
            let parentEntity = ModelEntity()
            parentEntity.addChild(entity)
            
            //parentEntity.name = "geo anchor pin collision box"
            
            // create bounds for parent entity
            let entityBounds = entity.visualBounds(relativeTo: parentEntity)
            parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
            parentEntity.generateCollisionShapes(recursive: false)
            
            // install gestures and add child
            // ARView.installGestures([.all], for: parentEntity)
            geoAnchorEntity.addChild(parentEntity)
            arView.scene.addAnchor(geoAnchorEntity)
        } catch {
            print(error)
        }
        #endif
    }
    
    var isGeoTrackingLocalized: Bool {
        if let status = self.ARView.session.currentFrame?.geoTrackingStatus, status.state == .localized {
            return true
        }
        return false
    }
    
    
}
