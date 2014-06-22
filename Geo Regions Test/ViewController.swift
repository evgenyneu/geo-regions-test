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

  var regionMonitor: RegionMonitor!
  var location: Location!
  var annotations: Annotations!
  var log: Log!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.log = Log(textView: logView)
    self.location = Location(log)
    self.annotations = Annotations(mapView)
    self.regionMonitor = RegionMonitor(log,
      location: location,
      annotations: annotations)

    self.location.authorizationDidChangeCallbacks += regionMonitor.authorizationDidChange

    mapView.showsUserLocation = true
    mapView.delegate = self

    regionMonitor.addRegion(
      CLLocationCoordinate2D(latitude: -37.860530, longitude: 144.978838),
      id: "Home"
    )

    regionMonitor.addRegion(
      CLLocationCoordinate2D(latitude: -37.860355, longitude: 144.976535),
      id: "Topolinos"
    )

    regionMonitor.addRegion(
      CLLocationCoordinate2D(latitude: -37.861250, longitude: 144.975131),
      id: "Leo's"
    )

    regionMonitor.startMonitoring()

    location.locationManager // initialize

    log.add("Started")
  }

  func doInitialZoom(userLocation: MKUserLocation) {
    if didInitiaZoom { return }
    didInitiaZoom = true
    log.add("doInitialZoom")
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
