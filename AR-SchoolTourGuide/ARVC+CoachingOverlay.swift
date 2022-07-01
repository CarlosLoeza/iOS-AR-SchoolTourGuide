//
//  ARVC+CoachingOverlay.swift
//  AR-SchoolTourGuide
//
//  Created by Carlos Loeza on 7/1/22.
//

import UIKit
import ARKit


extension ARViewController: ARCoachingOverlayViewDelegate {
    

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        //restartSession()
    }

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
}
