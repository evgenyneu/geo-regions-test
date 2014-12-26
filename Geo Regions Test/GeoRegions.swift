//
//  GeoRegions.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 26/12/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoRegions {
  static private(set) var regions = [GeoRegion]()

  static func addRegion(center: CLLocationCoordinate2D, id: String) {
    let region = GeoRegion(center: center,
      radius: RegionConstants.regionRediusMeters, identifier: id)

    region.notifyOnEntry = true
    region.notifyOnExit = true

    regions.append(region)
  }

  static func reachedFirstTimeRegions(coordinate: CLLocationCoordinate2D) -> [String] {
    var regionReached = [String]()
    for region in regions {
      if region.reachedFirstTime(coordinate) {
        regionReached.append(region.identifier!)
      }
    }

    return regionReached
  }

  static func clear() {
    regions = []
  }
}