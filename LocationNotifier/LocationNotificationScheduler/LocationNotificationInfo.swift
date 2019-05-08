//
//  LocationNotificationInfo.swift
//  LocationNotifier
//
//  Created by Jonathan Samudio on 5/8/19.
//  Copyright © 2019 Jonathan Samudio. All rights reserved.
//

import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    /// CLLocation Coordinates 
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
