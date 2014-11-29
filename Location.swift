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

  var _locationManager: CLLocationManager?

  var locationManager: CLLocationManager {
    get {
      if _locationManager == nil {
        _locationManager = CLLocationManager()
        _locationManager!.delegate = self

        if _locationManager!.respondsToSelector(Selector("requestAlwaysAuthorization")) {
          _locationManager!.requestAlwaysAuthorization()
        }
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
    iiQ.runAfterDelay(1) {
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

      log.add("didChangeAuthorizationStatus \(status.rawValue))")
      for callacback in authorizationDidChangeCallbacks {
        callacback()
      }
  }
}
