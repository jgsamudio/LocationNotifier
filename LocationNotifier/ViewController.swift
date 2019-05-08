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
                                                        latitude: 40.696503,
                                                        longitude: -73.997809,
                                                        title: "Welcome to the Brooklyn Promenade!",
                                                        body: "Tap to see more information",
                                                        data: ["location": "NYC Brooklyn Promenade"])
        
        locationNotificationScheduler.requestNotification(with: notificationInfo)
    }
}

extension ViewController: LocationNotificationSchedulerDelegate {
    
    func locationPermissionDenied() {
        let message = "The location permission was not authorized. Please enable it in Settings to continue."
        presentSettingsAlert(message: message)
    }
    
    func notificationPermissionDenied() {
        let message = "The notification permission was not authorized. Please enable it in Settings to continue."
        presentSettingsAlert(message: message)
    }
    
    func notificationScheduled(error: Error?) {
        if let error = error {
            let alertController = UIAlertController(title: "Notification Schedule Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Notification Scheduled!",
                                                    message: "You will be notified when you are near the location!",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "nyc_promenade_notification_id" {
            let notificationData = response.notification.request.content.userInfo
            let message = "You have reached \(notificationData["location"] ?? "your location!")"
            
            let alertController = UIAlertController(title: "Welcome!",
                                                    message: message,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
        completionHandler()
    }
    
    private func presentSettingsAlert(message: String) {
        let alertController = UIAlertController(title: "Permissions Denied!",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}
