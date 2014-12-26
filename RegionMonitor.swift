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
  var log: Log!
  var location: Location!
  var annotations: Annotations!

  var monitoringStarted = false

  init(_ log: Log, location: Location, annotations: Annotations) {
    self.log = log
    self.location = location
    self.annotations = annotations
  }

  func stopMonitoring() {
    for region in location.monitoredRegions {
      self.location.stopMonitoringForRegion(region)
    }
    monitoringStarted = false
  }

  func startMonitoring() {
    if !location.authorizedOrUndetermined { return }

    if monitoringStarted { return }
    monitoringStarted = true

    for region in GeoRegions.regions {
      startMonitoring(region)
    }
  }

  private func startMonitoring(region: CLCircularRegion) {
    if isMonitoring(region) {
      location.requestStateForRegion(region)
    } else {
      location.startMonitoringForRegion(region)
    }
  }

  private func isMonitoring(region: CLCircularRegion) -> Bool {
    for thisRegion in location.monitoredRegions {
      if let currentCircularRegion = thisRegion as? CLCircularRegion {
        if currentCircularRegion.identifier == region.identifier &&
          currentCircularRegion.center.latitude == region.center.latitude &&
          currentCircularRegion.center.longitude == region.center.longitude {

          return true
        }
      }
    }

    return false
  }
}


// CLLocationManager Delegate (Regions)
// ------------------------------

typealias ExtCLLocationManagerRegionsDelegate = Location

extension ExtCLLocationManagerRegionsDelegate {
  func locationManager(manager: CLLocationManager!,
    didStartMonitoringForRegion region: CLRegion!) {

    log.add("didStartMonitoringForRegion \(region.identifier)")


    requestStateForRegion(region)
  }

  func locationManager(manager: CLLocationManager!,
    monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {

    log.add("monitoringDidFailForRegion \(region.identifier) \(error.localizedDescription) \(error.localizedFailureReason)")
  }

  func locationManager(manager: CLLocationManager!,
    didDetermineState state: CLRegionState, forRegion region: CLRegion!) {

    var stateName = ""

    switch state {
    case .Inside:
      stateName = "Inside"
    case .Outside:
      stateName = "Outside"
    case .Unknown:
      stateName = "Unknown"
    }

    log.add("didDetermineState \(stateName) \(region.identifier)")
  }

  func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    Notification.send("You reached region: \(region.identifier)")
    log.add("didEnterRegion \(region.identifier)")
  }

  func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
//    Notification.send("You exited region: \(region.identifier)")
//    log.add("didExitRegion \(region.identifier)")
  }
}

