//
//  MyLogger.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Log {
  var textView: UITextView!

  init(textView: UITextView) {
    self.textView = textView
  }

  func add(text: String){
    textView.text = "\(currentTime()) \(text)\n\(textView.text)"
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

  func clear() {
    textView.text = ""
  }
}
