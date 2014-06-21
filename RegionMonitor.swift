//
//  region_monitor.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import CoreLocation

class RegionMonitor: NSObject, CLLocationManagerDelegate {
  @lazy var locationManager = CLLocationManager()

  func start() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
  }

  func monitorRegion(lat: Double, lon: Double, id: String) {
    var region = createRegion(lat, lon: lon, id: id)
    locationManager.startMonitoringForRegion(region)
  }
}
