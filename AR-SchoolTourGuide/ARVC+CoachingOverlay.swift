//
//  ARVC+CoachingOverlay.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/1/22.
//

import UIKit
import ARKit


extension ARViewController: ARCoachingOverlayViewDelegate {

    // Sets up the coaching view.
    func setupCoachingOverlay() {
        coachingOverlay.delegate = self
        // This places the coaching overlay on the AR map side (top half) only. They
        // do this by adding it to the arView
        arView.addSubview(coachingOverlay)
        coachingOverlay.goal = .geoTracking
        coachingOverlay.session = arView.session
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: arView.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: arView.heightAnchor)
            ])
    }
    // Call this function to display AR coaching overlay
    // AR coaching overlay is the visual example which shows the user how to get an acceptable surface
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // While our AR coaching overlay is being shown, do not show error message
        
        // Do not let the user interact with the screen while AR coaching overlay is being shown
        view.isUserInteractionEnabled = false
    }
    
    // Call this function once our AR coaching overlay is finished
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // Do not ignore error message since our coaching overlay is done
        // Allow user to interact with screen
        // Ex: create, delete, or drag message
        placeExistingMessages(locations: locations, vertexPath: vertexPath)
        view.isUserInteractionEnabled = true
    }
    
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        runARSession()
    }
}
