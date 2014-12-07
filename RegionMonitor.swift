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
    regions.append(createRegion(center, id: id))
  }

  func createRegion(center: CLLocationCoordinate2D, id: String) -> CLCircularRegion {
    var region = CLCircularRegion(center: center,
      radius: CLLocationDistance(100), identifier: id)

    region.notifyOnEntry = true
    region.notifyOnExit = true

    return region
  }

  func stopMonitoringForAllRegions() {
    currentRegions { regions in
      for region in regions {
        self.location.stopMonitoringForRegion(region)
      }
      self.monitoringStarted = false
    }
  }

  func startMonitoring() {
    checkRegionMonitoringAvailability()
    if !location.authorized { return }

    if monitoringStarted { return }
    monitoringStarted = true

    for region in regions {
      startMonitoring(region)
    }
  }

  func startMonitoring(region: CLCircularRegion) {
    isMonitoring(region) { alreadyStarted in
      if alreadyStarted {
        self.location.requestStateForRegion(region)
      } else {
        self.location.startMonitoringForRegion(region)
      }
    }
  }

  func isMonitoring(region: CLCircularRegion, callback: (Bool)->()) {
    currentRegions { regions in

      for currentRegion in regions {
        if let currentCircularRegion = currentRegion as? CLCircularRegion {
          if currentCircularRegion.identifier == region.identifier &&
            currentCircularRegion.center.latitude == region.center.latitude &&
            currentCircularRegion.center.longitude == region.center.longitude {

            callback(true)
            return
          }
        }
      }

      callback(false)
    }
  }

  func showAnnotations() {
    currentRegions { regions in
      for region in regions {
        if let circularRegion = region as? CLCircularRegion {
          self.annotations.add(circularRegion.center, id: circularRegion.identifier)
        }
      }
    }
  }

  func currentRegions(callback: ([CLRegion])->()) {
    location.monitoredRegions(callback)
  }

  func authorizationDidChange() {
    startMonitoring()

    if location.authorized {
      showAnnotations()
    } else {
      annotations.removeAll()
    }
  }

  private func checkRegionMonitoringAvailability() {

    let regionMonitoringAvailable = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)

    let status = regionMonitoringAvailable ? "available" : "NOT available"
    log.add("Region monotoring available \(regionMonitoringAvailable)")
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
    Notification.send("You exited region: \(region.identifier)")
    log.add("didExitRegion \(region.identifier)")
  }
}

