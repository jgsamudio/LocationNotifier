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
    
    // MARK: - Public Properties
    
    weak var delegate: LocationNotificationSchedulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Public Functions
    
    /// Request a geo location notification with optional data.
    ///
    /// - Parameter data: Data that will be sent with the notification.
    func requestNotification(with notificationInfo: LocationNotificationInfo) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .authorizedWhenInUse, .authorizedAlways:
            askForNotificationPermissions(notificationInfo: notificationInfo)
        case .restricted, .denied:
            delegate?.locationPermissionDenied()
            break
        }
    }
}

// MARK: - Private Functions

private extension LocationNotificationScheduler {
    
    func askForNotificationPermissions(notificationInfo: LocationNotificationInfo) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { [weak self] granted, _ in
                guard granted else {
                    DispatchQueue.main.async {
                        self?.delegate?.notificationPermissionDenied()
                    }
                    return
                }
                self?.requestNotification(notificationInfo: notificationInfo)
        })
    }
    
    func requestNotification(notificationInfo: LocationNotificationInfo) {
        let notification = notificationContent(notificationInfo: notificationInfo)
        let destRegion = destinationRegion(notificationInfo: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationId,
                                            content: notification,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.delegate?.notificationScheduled(error: error)
            }
        }
    }
    
    func notificationContent(notificationInfo: LocationNotificationInfo) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
    
    func destinationRegion(notificationInfo: LocationNotificationInfo) -> CLCircularRegion {
        let destRegion = CLCircularRegion(center: notificationInfo.coordinates,
                                          radius: notificationInfo.radius,
                                          identifier: notificationInfo.locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        return destRegion
    }
}
