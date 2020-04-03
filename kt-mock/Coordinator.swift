//
//  Coordinater.swift
//  kt-mock
//
//  Created by Matthew Weil on 4/2/20.
//  Copyright © 2020 Matthew Weil. All rights reserved.
//

import UIKit
import Mapbox

final class Coordinator: NSObject, MGLMapViewDelegate {
    var control: MapView
    
    init(_ control: MapView) {
        self.control = control
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
        
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

