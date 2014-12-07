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

    println("backgroundRefreshStatus \(UIApplication.sharedApplication().backgroundRefreshStatus.rawValue)")

    self.log = Log(textView: logView)
    self.location = Location(log)
    location.setup() // initialize

    
    self.annotations = Annotations(mapView)
    self.regionMonitor = RegionMonitor(log,
      location: location,
      annotations: annotations)

    self.location.authorizationDidChangeCallbacks.append(regionMonitor.authorizationDidChange)
    mapView.showsUserLocation = true
    mapView.delegate = self


    for (name, coords) in myRegions {
      regionMonitor.addRegion(
        CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1]),
        id: name
      )
    }

//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.860530, longitude: 144.978838),
//      id: "Home"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.859773, longitude: 144.980343),
//      id: "Nearby"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.860355, longitude: 144.976535),
//      id: "Topolinos"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.861250, longitude: 144.975131),
//      id: "Leo's"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.863828, longitude: 144.981185),
//      id: "Dr Jekyll"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.866784, longitude: 144.977770),
//      id: "McDonald's"
//    )
//
//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.868402, longitude: 144.979340),
//      id: "Woolworths"
//    )

//    regionMonitor.addRegion(
//      CLLocationCoordinate2D(latitude: -37.891822, longitude: 144.985480),
//      id: "Far away"
//    )

    regionMonitor.startMonitoring()

    log.add("Started")
  }

  private var myRegions: [String: [Double]] {
    return [
      "Where it all begins": [-37.853230, 144.977002],
      "Big tree": [-37.848667, 144.971795],
      "Latte on the lake": [-37.845403, 144.967381],
      "Boats": [-37.842136, 144.964312],
      "Chicane": [-37.842116, 144.971032],
      "Saling together": [-37.850260, 144.976994],
      "Where the food come from": [-37.859254, 144.977918],
      "Home": [-37.860546, 144.978859]
    ]
  }

  @IBAction func onExitTapped(sender: AnyObject) {
    exit(0)
  }

  func doInitialZoom(userLocation: MKUserLocation) {
    if didInitiaZoom { return }
    didInitiaZoom = true
    log.add("doInitialZoom")
    var region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000)
    mapView.setRegion(region, animated:false)
  }

  @IBAction func onRestartButtonTapped(sender: AnyObject) {
    log.clear()

    restartButton.enabled = false
    regionMonitor.stopMonitoringForAllRegions()

    iiQ.runAfterDelay(0.1) {
      self.regionMonitor.startMonitoring()

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
