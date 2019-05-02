//
//  DashboardViewController.swift
//  LocationNotifier
//
//  Created by Jonathan Samudio on 5/1/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class HomeViewController: UIViewController {
    
    @IBAction func didSelectAddNotification(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                guard granted else {
                    return
                }
                // Location's coordinates center
                let center = CLLocationCoordinate2D(latitude: 40.700212, longitude: -73.987238)
                
                let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "UniqueLocationIdentifier")
                region.notifyOnEntry = true
                region.notifyOnExit = false
                let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                
                // Notification to display
                let notification = UNMutableNotificationContent()
                notification.title = "Welcome!"
                notification.body = "You've reached your destination"
                notification.sound = UNNotificationSound.default
                notification.userInfo = ["destinationId": 1234]
                
                // Setup request and add request to the Notification Center.
                let request = UNNotificationRequest(identifier: "destAlarm", content: notification, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error == nil {
                        print("Successful notification")
                        print(request)
                    } else {
                        print(error ?? "Error")
                    }
                })
        })
    }
    
}
