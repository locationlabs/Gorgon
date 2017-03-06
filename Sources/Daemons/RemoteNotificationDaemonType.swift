import UIKit


// Pushes from legacy systems may not have a category.  We support them with this constant.
// Only one daemon can have the category set to this.
public let kRemoteNotificationNoCategory = "no.category"

/**
 This protocol can be used to register for remote notifications sent to the app via APNS
 */
public protocol RemoteNotificationDaemonType: DaemonType {
    
    /**
     Represents the APN category. This is must match what the server sends in the `category` property.
     This must be unique for each remote notification (e.g. 1 remote notification daemon per category)
     */
    var category: String { get }
    
    /**
     Handler for the remote notification. The app can be in the background or foreground when this
     notification is handled. You can check the application state of the UIApplication sharedInstance
     to determine the background/foreground mode
     
     - parameter notification: the `aps` userInfo object
     - parameter completion:   the completion handler to be called once the processing is completed
     */
    func handleNotification(_ notification: [String:AnyObject], completion: @escaping (UIBackgroundFetchResult) -> ())
}
