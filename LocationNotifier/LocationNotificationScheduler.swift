//
//  LocationNotificationScheduler.swift
//  LocationNotifier
//
//  Created by Jonathan Samudio on 5/8/19.
//  Copyright © 2019 Jonathan Samudio. All rights reserved.
//

import CoreLocation
import UserNotifications

class LocationNotificationScheduler: NSObject {
    
    // MARK: - Private Properties
    
    // Made By We's coordinates center
    private let centerCoordinates = CLLocationCoordinate2D(latitude: 40.739357, longitude: -73.989711)
    private let locationManager = CLLocationManager()
    
    // MARK: - Constants
    
    private let notificationId = "notification_id"
    private let locationId = "location_id"
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Public Functions
    
    /// Request a geo location notification with optional data.
    ///
    /// - Parameter data: Data that will be sent with the notification.
    func requestNotification(with data: [String: Any]? = nil) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            askForNotificationPermissions(data: data)
        case .restricted, .denied:
            // TODO: Route to settings
            // https://jira.weworkers.io/browse/RET-1422
            break
        }
    }
}

// MARK: - Private Functions

private extension LocationNotificationScheduler {
    
    func askForNotificationPermissions(data: [String: Any]?) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    // TODO: Route to settings
                    // https://jira.weworkers.io/browse/RET-1422
                    return
                }
                self?.requestNotification(data: data)
        })
    }
    
    func requestNotification(data: [String: Any]?) {
        let notification = UNMutableNotificationContent()
        notification.title = ""
        notification.body = ""
        notification.sound = UNNotificationSound.default
        
        if let data = data {
            notification.userInfo = data
        }
        
        let destRegion = CLCircularRegion(center: centerCoordinates, radius: 500.0, identifier: locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationId, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocationNotificationScheduler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == notificationId {
            // Call DeepLink Provider Here. response.notification.request.content.userInfo
        }
        completionHandler()
    }
}
