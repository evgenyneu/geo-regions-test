//
//  MyAnnotation.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import MapKit
import CoreLocation

class MyAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D

  init(_ coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }

  var title: String?
  var subtitle: String?
}