//
//  ViewController.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet var mapView : MKMapView
  @IBOutlet var logView : UITextView

  var didInitiaZoom = false

  let regionMonitor = RegionMonitor()

  override func viewDidLoad() {
    super.viewDidLoad()

    mapView.showsUserLocation = true

    mapView.delegate = self

    regionMonitor.start()

    addLog("Started")
  }

  func doInitialZoom(userLocation: MKUserLocation) {
    if didInitiaZoom { return }
    didInitiaZoom = true
    addLog("doInitialZoom")
    var region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500, 500)
    mapView.setRegion(region, animated:false)
  }
}

// MapView Delegate
// ------------------------------

typealias VCExtensionMapViewDelegate = ViewController

extension VCExtensionMapViewDelegate {
  func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    doInitialZoom(userLocation)
  }
}

// Helpers
// ------------------------------

typealias VCExtensionHelpers = ViewController

extension VCExtensionHelpers {
  func addLog(text: String){
    logView.text = "\(currentTime()) \(text)\n\(logView.text)"
  }

  func coordToString(location: CLLocation) -> String {
    let lat = NSString(format: "%.6f", location.coordinate.latitude)
    let lon = NSString(format: "%.6f", location.coordinate.longitude)

    return "\(lat), \(lon)"
  }

  func currentTime() -> String {
    let date = NSDate()
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    return formatter.stringFromDate(date)
  }
}

