import Gorgon


class BarDaemon: NotificationCenterDaemonType {
    
    var notificationToSelectors = [
        "BarNotification": #selector(doBarNotification(_:))
    ]
    
    @objc func doBarNotification(_ notification: Notification) {
        
    }
}
