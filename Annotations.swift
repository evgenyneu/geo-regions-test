//
//  Annotations.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 22/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Annotations {
  var mapView: MKMapView!
  var all = Dictionary<String, Annotation>()

  init(_ mapView: MKMapView) {
    self.mapView = mapView
  }

  func add(coordinate: CLLocationCoordinate2D, id: String) {
    if all[id] != nil { return }

    var annotation = Annotation(centerCoordinate: coordinate,
      radius: RegionConstants.regionRediusMeters)

    annotation.title = id
    all[id] = annotation
    mapView.addAnnotation(annotation)
    mapView.addOverlay(annotation)
  }

  func remove(id: String) {
    if all[id] != nil {
      mapView.removeAnnotation(all[id])
      mapView.removeOverlay(all[id])
      all[id] = nil
    }
  }

  func removeAll() {
    var idsToRemove = [String]()
    for name in all.keys {
      idsToRemove.append(name)
    }

    for id in idsToRemove {
      remove(id)
    }
  }
}
