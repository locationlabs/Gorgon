import UIKit


/**
 This protocol can be used to register for local notifications
 */
public protocol LocalNotificationDaemonType: DaemonType {
    
    /**
     Name used to identify local notification daemon by. Should be equal to the UILocalNotification
     category string value.
     */
    var category: String { get }
    
    /**
     Daemon callback that gets fired when this local notification is received.
     
     - parameter userInfo:          the userInfo attached to the local notification
     */
    func handleNotification(_ userInfo: [String:AnyObject]?)
}

/**
 This protocol can be used to register for local notifications
 */
public protocol LocalActionNotificationDaemonType: LocalNotificationDaemonType {
    
    /**
     Will be called when the user taps a given identifier for the local notification
     
     - parameter identifier:        the identifier of the button that they tapped
     - parameter userInfo:          the userInfo attached to the local notification
     - parameter completionHandler: the completion handler to be called once the action has been completed
     */
    func handleActionWithIdentifier(_ identifier: String?, userInfo: [String:AnyObject]?, completionHandler: () -> Void)
}
