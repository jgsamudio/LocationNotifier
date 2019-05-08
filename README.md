# LocationNotifier
Location Triggered Notification App using UNLocationNotificationTrigger

Tapping the _"Schedule Location Notification"_ button will schedule a notification to go off when the device is ~500 meters away from the Brooklyn Promenade

## Usage

```
let locationNotificationScheduler = LocationNotificationScheduler()

let notificationInfo = LocationNotificationInfo(notificationId: "nyc_promenade_notification_id",
                                                locationId: "nyc_promenade_location_id",
                                                radius: 500.0,
                                                latitude: 40.696503,
                                                longitude: -73.997809,
                                                title: "Welcome to the Brooklyn Promenade!",
                                                body: "Tap to see more information",
                                                data: ["location": "NYC Brooklyn Promenade"])
        
locationNotificationScheduler.requestNotification(with: notificationInfo)
```

The `LocationNotificationScheduler` needs a `LocationNotificationInfo` object to request a notification. 

### LocationNotificationInfo Properties

- `notificationId` - Unique Id used to identify this specific type of notification
- `locationId` - Unique Id used to identify this specific location
- `radius` - Double radius from the center in meters
- `latitude` - Center latitude of the location
- `longitude` - Center longitude of the location
- `title` - Title of the notification
- `body` - Body message of the notification
- `data` - Optional data that will be sent with the notification

### LocationNotificationSchedulerDelegate

The `LocationNotificationSchedulerDelegate` will provide functions to interact with the `LocationNotificationScheduler`. 

### Set the delegate

`locationNotificationScheduler.delegate = self`

### Available Functions 

```
/// Called when the user has denied the notification permission prompt.
func notificationPermissionDenied()

/// Called when the user has denied the location permission prompt.
func locationPermissionDenied()

/// Called when the notification request completed.
///
/// - Parameter error: Optional error when trying to add the notification.
func notificationScheduled(error: Error?)
```

### UNUserNotificationCenterDelegate

The `LocationNotificationSchedulerDelegate` also extends the `UNUserNotificationCenterDelegate` which provides extra functions that interact with the notification. 

The `didReceive` function below is used to handle when a user selects the notification. This function will be called when the app is in the foreground or background.

```
func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

    if response.notification.request.identifier == "nyc_promenade_notification_id" {
        let notificationData = response.notification.request.content.userInfo
        
        // Do something with this notification data. 
        // This is the same as the data in the LocationNotificationInfo
    }
    
    completionHandler()
}
```

## References

- [UNLocationNotificationTrigger](https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger)

