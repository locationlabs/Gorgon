import Medusa


class BarDaemon: NotificationCenterDaemonType {
    
    var notificationToSelectors = [
        "BarNotification": #selector(doBarNotification(_:))
    ]
    
    @objc func doBarNotification(notification: NSNotification) {
        
    }
}