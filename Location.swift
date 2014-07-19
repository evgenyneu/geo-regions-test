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
      if !_locationManager {
        _locationManager = CLLocationManager()
        _locationManager!.delegate = self
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
}

// CLLocationManager Delegate
// ------------------------------

typealias ExtCLLocationManagerDelegate = Location

extension ExtCLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager!,
    didChangeAuthorizationStatus status: CLAuthorizationStatus) {

      log.add("didChangeAuthorizationStatus \(status.toRaw())")
      for callacback in authorizationDidChangeCallbacks {
        callacback()
      }
  }
}
