//
//  GetRegion.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 26/12/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import CoreLocation

class GeoRegion: CLCircularRegion {
  var reached = false

  func reachedFirstTime(coordinate: CLLocationCoordinate2D) -> Bool {
    if reached { return false }

    if containsCoordinate(coordinate) {
      reached = true
      return true
    }
    return false
  }
}
