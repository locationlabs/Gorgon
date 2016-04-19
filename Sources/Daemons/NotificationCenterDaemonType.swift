

/**
 The NotificationCenterDaemonType to handle notifications from the default NSNotificationCenter
 */
public protocol NotificationCenterDaemonType: DaemonType {
    
    /**
     Name of the notifications mapped to their selector handlers
     
     ```
     var notificationToSelectors = [
         "FooNotification": #selector(doFooNotification(_:))
     ]
     ```
     */
    var notificationToSelectors: [String:Selector] { get }
}