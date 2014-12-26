//
//  Location.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
  var log: Log!

  var locationAccuracy: CLLocationAccuracy = 10_000

  private var _locationManager: CLLocationManager?

  func setup() {
    let a = locationManager
  }

  func stopMonitoringForRegion(region: CLRegion) {
    locationManager.stopMonitoringForRegion(region)
  }

  func startMonitoringForRegion(region: CLRegion) {
    locationManager.startMonitoringForRegion(region)
  }

  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }

  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }

  var monitoredRegions: [CLRegion] {
    var result = [CLRegion]()
    for region in self.locationManager.monitoredRegions {
      if let currentRegion = region as? CLRegion {
        result.append(currentRegion)
      }

    }
    return result
  }

  private var locationManager: CLLocationManager {
    get {
      if _locationManager == nil {
        let newManager = CLLocationManager()
        newManager.delegate = self

        _locationManager = newManager

        if newManager.respondsToSelector(Selector("requestAlwaysAuthorization")) {
          newManager.requestAlwaysAuthorization()
        }
      }
      return _locationManager!
    }
  }

  init(_ log: Log) {
    super.init()
    self.log = log
  }

  var authorizedOrUndetermined: Bool {
    get {
      let status = CLLocationManager.authorizationStatus()

      return status == CLAuthorizationStatus.Authorized ||
          status == CLAuthorizationStatus.NotDetermined
    }
  }

  func requestStateForRegion(region: CLRegion) {
    iiQ.runAfterDelay(0.5) {
      self.locationManager.requestStateForRegion(region)
    }
  }
}

// CLLocationManager Delegate
// ------------------------------

typealias ExtCLLocationManagerDelegate = Location

extension ExtCLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!,
    didChangeAuthorizationStatus status: CLAuthorizationStatus) {

    let statusText = status == CLAuthorizationStatus.Authorized ? "authorized" : "NOT authorized \(CLAuthorizationStatus.Authorized.rawValue)"

    log.add("didChangeAuthorizationStatus \(statusText)")
  }

  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    for location in locations {
      if let currentLocation = location as? CLLocation {
        IsInsideRegion.checkIfRegionsReachedFirstNameAndNotify(currentLocation)

        if locationAccuracy != currentLocation.horizontalAccuracy {
          log.add("location accuracy: \(currentLocation.horizontalAccuracy)")
          locationAccuracy = currentLocation.horizontalAccuracy
        }
      }
    }
  }
}
