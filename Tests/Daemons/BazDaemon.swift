import Medusa


class BazDaemon: NotificationCenterDaemonType {

    var notificationToSelectors = [
        "BazNotification": #selector(doBazNotification(_:))
    ]
    
    @objc func doBazNotification(_ notification: Notification) {
        
    }
}

// MARK: - ApplicationDidBecomeActiveDaemonType
extension BazDaemon: ApplicationDaemonType {
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
}
