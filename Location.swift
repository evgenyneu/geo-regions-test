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
  var authorizationDidChangeCallbacks: [(()->())] = []

  private var _locationManager: CLLocationManager?

  func setup() {
    iiQ.main { let a = self.locationManager }
  }

  func stopMonitoringForRegion(region: CLRegion) {
    iiQ.main { self.locationManager.stopMonitoringForRegion(region) }
  }

  func startMonitoringForRegion(region: CLRegion) {
    iiQ.main { self.locationManager.startMonitoringForRegion(region) }
  }

  func monitoredRegions(callback: ([CLRegion])->()) {
    iiQ.main {
      var result = [CLRegion]()
      for region in self.locationManager.monitoredRegions {
        if let currentRegion = region as? CLRegion {
          result.append(currentRegion)
        }

      }
      callback(result)
    }
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

        newManager.pausesLocationUpdatesAutomatically = false

        log.add("kCLLocationAccuracyBest \(kCLLocationAccuracyBest)")
        log.add("desiredAccuracy \(newManager.desiredAccuracy)")

        log.add("kCLDistanceFilterNone \(kCLDistanceFilterNone)")
        log.add("distanceFilter \(newManager.distanceFilter)")

        log.add("CLActivityTypeOther \(CLActivityType.Other.rawValue)")
        log.add("activityType \(newManager.activityType.rawValue)")

        newManager.activityType = CLActivityType.Fitness
      }
      return _locationManager!
    }
  }

  init(_ log: Log) {
    super.init()
    self.log = log
  }

  var authorized: Bool {
    get {
      return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized
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
      
      for callacback in authorizationDidChangeCallbacks {
        callacback()
      }
  }
}
