//
//  LocationNotificationSchedulerDelegate.swift
//  LocationNotifier
//
//  Created by Jonathan Samudio on 5/8/19.
//  Copyright © 2019 Jonathan Samudio. All rights reserved.
//

import UserNotifications

protocol LocationNotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    /// Called when the user has denied the notification permission prompt.
    func notificationPermissionDenied()
    
    /// Called when the user has denied the location permission prompt.
    func locationPermissionDenied()
    
    /// Called when the notification request completed.
    ///
    /// - Parameter error: Optional error when trying to add the notification.
    func notificationScheduled(error: Error?)
}
