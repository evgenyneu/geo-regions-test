//
//  region_monitor.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import CoreLocation

class RegionMonitor {
  var regions = CLCircularRegion[]()
  var log: Log!
  var location: Location!
  var monitoringStarted = false

  init(_ log: Log, location: Location) {
    self.log = log
    self.location = location
  }

  func addRegion(center:CLLocationCoordinate2D, id: String) {
    regions += createRegion(center, id: id)
  }

  func createRegion(center: CLLocationCoordinate2D, id: String) -> CLCircularRegion {
    var region = CLCircularRegion(center: center,
      radius: CLLocationDistance(50), identifier: id)

    region.notifyOnEntry = true
    region.notifyOnExit = true

    return region
  }

  func startMonitoring() {
    if monitoringStarted { return }
    if !location.authorized {
      location.locationManager // initialize
      return
    }

    monitoringStarted = true

    for region in regions {
      location.locationManager.startMonitoringForRegion(region)
    }
  }

  func authorizationDidChange() {
    startMonitoring()
  }
}


