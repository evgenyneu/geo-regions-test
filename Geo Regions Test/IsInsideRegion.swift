//
//  IsInsideRegion.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 26/12/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit
import CoreLocation

struct IsInsideRegion {
  static func checkIfRegionsReachedFirstNameAndNotify(location: CLLocation) {
    let reachedRegionNames = GeoRegions.reachedFirstTimeRegions(location.coordinate)
    if reachedRegionNames.isEmpty { return }

    let names = ", ".join(reachedRegionNames)
    Notification.send("You reached regions: \(names)")
  }
}
