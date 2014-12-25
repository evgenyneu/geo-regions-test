//
//  Notification.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 7/12/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class Notification {
  class func send(text: String) {
    let notification = UILocalNotification()
    notification.fireDate = nil
    notification.alertBody = text
    notification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }

  class func registerNotifications() {
    if !UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))
    {
      return // there is no need to register local notifications in iOS 7
    }

    sendNotificationRegisterRequest()
  }

  private class func sendNotificationRegisterRequest() {
    let settings = UIUserNotificationSettings(
      forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
      categories: nil)

    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
  }
}
