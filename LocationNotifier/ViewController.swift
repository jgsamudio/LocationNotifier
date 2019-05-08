//
//  ViewController.swift
//  LocationNotifier
//
//  Created by Jonathan Samudio on 5/8/19.
//  Copyright © 2019 Jonathan Samudio. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let locationNotificationScheduler = LocationNotificationScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationNotificationScheduler.delegate = self
    }
    
    @IBAction func scheduleLocationNotification(_ sender: Any) {
        let notificationInfo = LocationNotificationInfo(notificationId: "nyc_promenade_notification_id",
                                                        locationId: "nyc_promenade_location_id",
                                                        radius: 500.0,
                                                        latitude: 0,
                                                        longitude: 0,
                                                        title: "Welcome to the Brooklyn Promenade!",
                                                        body: "Tap to see more information",
                                                        data: ["location": "NYC Brooklyn Promenade"])
        
        locationNotificationScheduler.requestNotification(with: notificationInfo)
    }
}

extension ViewController: LocationNotificationSchedulerDelegate {
    
    func locationPermissionDenied() {
        
    }
    
    func notificationPermissionDenied() {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "nyc_promenade_notification_id" {
            // Call DeepLink Provider Here. response.notification.request.content.userInfo
        }
        completionHandler()
    }
}
