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
  var regions = [CLCircularRegion]()
  var log: Log!
  var location: Location!
  var annotations: Annotations!

  var monitoringStarted = false

  init(_ log: Log, location: Location, annotations: Annotations) {
    self.log = log
    self.location = location
    self.annotations = annotations
  }

  func addRegion(center:CLLocationCoordinate2D, id: String) {
    regions += createRegion(center, id: id)
  }

  func createRegion(center: CLLocationCoordinate2D, id: String) -> CLCircularRegion {
    var region = CLCircularRegion(center: center,
      radius: CLLocationDistance(100), identifier: id)

    region.notifyOnEntry = true
    region.notifyOnExit = true

    return region
  }

  func startMonitoring() {
    if !location.authorized { return }

    if monitoringStarted { return }
    monitoringStarted = true

    for region in regions {
      startMonitoring(region);
    }
  }

  func startMonitoring(region: CLCircularRegion) {
    if isMonitoring(region) { return }
    location.locationManager.startMonitoringForRegion(region)
  }

  func isMonitoring(region: CLCircularRegion) -> Bool {
    var current = currentRegions()
    return current.filter({ el in
      return (el.identifier == region.identifier &&
        el.center.latitude == region.center.latitude &&
        el.center.longitude == region.center.longitude)
      }).count > 0
  }

  func showAnnotations() {
    var current = currentRegions()
    for region in current {
      annotations.add(region.center, id: region.identifier)
    }
  }

  func currentRegions() -> Array<CLCircularRegion> {
    return location.locationManager.monitoredRegions.allObjects as Array<CLCircularRegion>
  }

  func authorizationDidChange() {
    startMonitoring()

    if location.authorized {
      showAnnotations()
    } else {
      annotations.removeAll()
    }
  }
}


// CLLocationManager Delegate (Regions)
// ------------------------------

typealias ExtCLLocationManagerRegionsDelegate = Location

extension ExtCLLocationManagerRegionsDelegate {
  func locationManager(manager: CLLocationManager!,
    didStartMonitoringForRegion region: CLCircularRegion!) {

    log.add("didStartMonitoringForRegion \(region.identifier)")
  }

  func locationManager(manager: CLLocationManager!,
    monitoringDidFailForRegion region: CLCircularRegion!,
    withError error: NSError!) {

    log.add("monitoringDidFailForRegion \(region.identifier) \(error.localizedDescription) \(error.localizedFailureReason)");
  }

  func locationManager(manager: CLLocationManager!,
    didEnterRegion region: CLCircularRegion!) {

      log.add("didEnterRegion \(region.identifier)");
  }

  func locationManager(manager: CLLocationManager!,
    didExitRegion region: CLCircularRegion!) {

      log.add("didExitRegion \(region.identifier)");
  }
}

