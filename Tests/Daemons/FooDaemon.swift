import Medusa


class FooDaemon {
    var appProp: String?
    var envProp: String?
}

// MARK: - ApplicationDidBecomeActiveDaemonType
extension FooDaemon: ApplicationDaemonType {
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
}