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

  @IBOutlet var mapView : MKMapView!
  @IBOutlet var logView : UITextView!
  @IBOutlet weak var restartButton: UIBarButtonItem!

  var didInitiaZoom = false

  var regionMonitor: RegionMonitor!
  var location: Location!
  var annotations: Annotations!
  var log: Log!

  override func viewDidLoad() {
    super.viewDidLoad()

    log = Log(textView: logView)
    geoLog = log
    self.location = Location(log)
    location.setup() // initialize

    self.annotations = Annotations(mapView)
    self.regionMonitor = RegionMonitor(log,
      location: location,
      annotations: annotations)

//    mapView.showsUserLocation = true
    mapView.delegate = self
    Notification.registerNotifications()
    startMonitoring()
  }

  private func zoomToFirstRegion() {
    if let region = myRegions.values.first {
      let coordinate = CLLocationCoordinate2D(latitude: region[0], longitude: region[1])
      doInitialZoom(coordinate)
    }
  }

  private var myRegions: [String: [Double]] {
    return [
//      "Where it all begins": [-37.853230, 144.977002],
//      "Big tree": [-37.848667, 144.971795],
//      "Latte on the lake": [-37.845403, 144.967381],
//      "Boats": [-37.842136, 144.964312],
//      "Chicane": [-37.842116, 144.971032],
//      "Saling together": [-37.850260, 144.976994],
      "Where the food come from": [-37.859254, 144.977918],
      "Home": [-37.860546, 144.978859],
      "Nearby": [-37.859773, 144.980343],
      "Dr Jekyll": [-37.863828, 144.981185],
    ]
  }

  @IBAction func onExitTapped(sender: AnyObject) {
    exit(0)
  }

  func doInitialZoom(userLocation: MKUserLocation) {
    doInitialZoom(userLocation.location.coordinate)
  }

  func doInitialZoom(coordinate: CLLocationCoordinate2D) {
    if didInitiaZoom { return }
    didInitiaZoom = true
    var region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
    mapView.setRegion(region, animated:false)
  }

  @IBAction func onRestartButtonTapped(sender: AnyObject) {
    restartButton.enabled = false
    startMonitoring()

    iiQ.runAfterDelay(1) {
      self.restartButton.enabled = true
    }
  }

  private func showAnnotations() {
    annotations.removeAll()
    for region in GeoRegions.regions {
      self.annotations.add(region.center, id: region.identifier)
    }
  }

  private func startMonitoring() {
    // Clear
    log.clear()
    regionMonitor.stopMonitoring()
    location.stopUpdatingLocation()
    GeoRegions.clear()

    // Start
    // -------------

    for (name, coords) in myRegions {
      let coordinate = CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
      GeoRegions.addRegion(coordinate, id: name)
    }

    showAnnotations()
    zoomToFirstRegion()

    iiQ.runAfterDelay(0.1) {
      self.regionMonitor.startMonitoring()
      self.location.startUpdatingLocation()

      iiQ.runAfterDelay(1) {
        self.restartButton.enabled = true
      }
    }
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
