import Medusa


class BazDaemon: NotificationCenterDaemonType {

    var notificationToSelectors = [
        "BazNotification": #selector(doBazNotification(_:))
    ]
    
    @objc func doBazNotification(notification: NSNotification) {
        
    }
}

// MARK: - ApplicationDidBecomeActiveDaemonType
extension BazDaemon: ApplicationDaemonType {
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
}
