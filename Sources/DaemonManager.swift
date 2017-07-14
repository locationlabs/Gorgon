import Foundation



/**
 The Daemon manages the DaemonType's that are registered. The Daemon is a accessed via the sharedInstance and thus
 will live for the life of the application once a daemon has been registered. Daemons are meant to be long lived and
 respond to system events
 */
final public class DaemonManager {
    
    /// list of daemons for the application
    fileprivate var daemons = [DaemonType]()
        
    init() {
        self.registerLifecycleNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Will register a daemon with the VIPER application
     
     - parameter daemon: the daemon to register
     */
    public func register(_ daemon: DaemonType) {
        daemons.append(daemon)
        
        // setup notification handlers for daemon
        if let notificationCenterDaemon = daemon as? NotificationCenterDaemonType {
            for (notificationName, selector) in notificationCenterDaemon.notificationToSelectors {
                NotificationCenter.default
                    .addObserver(daemon,
                                 selector: selector,
                                 name: NSNotification.Name(rawValue: notificationName),
                                 object: nil)
            }
        }
    }
    
    /**
     Will retrieve daemons for a given type
     
     - parameter type: the type of daemon
     
     - returns: the daemons that implement the given type
     */
    public func daemonsForType<T>(_ type: T.Type) -> [T] {
        return daemons.map { $0 as? T }.flatMap { $0 }
    }
}

// MARK: - Singleton
public extension DaemonManager {
    public static let sharedInstance = DaemonManager()
}

// MARK: - URL
public extension DaemonManager {
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[.sourceApplication] as? String
        logDebug("Application open url, url=\(url.path), query=\(String(describing: url.query)), scheme=\(String(describing: url.scheme)),"
            + " host=\(String(describing: url.host)), path=\(url.path), sourceApplication=\(String(describing: sourceApplication))")
        
        let _url = Url(url: url, sourceApplication: sourceApplication)
        for daemon in daemonsForType(UrlDaemonType.self) {
            if let fragments = _url.matchUrlPathAndBuildFragments(daemon.urlHost, path: daemon.urlPath) {
                return daemon.handleUrl(url, fragments: fragments, queryParams: _url.paramsForQueryString())
            }
        }
        return false
    }
    
}

// MARK: - Local Notifications
public extension DaemonManager {
    
    public func application(_ application: UIApplication,
                            didReceiveLocalNotification notification: UILocalNotification) {
        guard let category = notification.category else {
            logDebug("Application did receive location notification without category")
            return
        }
        logDebug("Application did receive local notification, category=\(category),"
            + " userInfo=\(String(describing: notification.userInfo))")
        
        for daemon in daemonsForType(LocalNotificationDaemonType.self) {
            if daemon.category == category {
                daemon.handleNotification(notification.userInfo as? [String:AnyObject])
                return
            }
        }
        logDebug("Application local notification daemon not found, category=\(category),"
            + " userInfo=\(String(describing: notification.userInfo))")
    }
    
    public func application(_ application: UIApplication,
                            handleActionWithIdentifier identifier: String?,
                            for notification: UILocalNotification,
                            completionHandler: @escaping () -> Void) {
        guard let category = notification.category else {
            logDebug("Application did receive local notification handle action with identifer without category")
            return
        }
        logDebug("Application did receive local notification handle action with identifer, category=\(category),"
            + " userInfo=\(String(describing: notification.userInfo)), identifier=\(String(describing: identifier))")
        
        for daemon in daemonsForType(LocalActionNotificationDaemonType.self) {
            if daemon.category == category {
                daemon.handleActionWithIdentifier(identifier,
                                                  userInfo: notification.userInfo as? [String:AnyObject],
                                                  completionHandler: completionHandler)
                return
            }
        }
        
        logDebug("Application local notification daemon not found for action handler, category=\(category),"
            + " userInfo=\(String(describing: notification.userInfo)), identifier=\(String(describing: identifier))")
        completionHandler()
    }
}

// MARK: - APNS/VoIP Notifications
public extension DaemonManager {
    
    /**
     Should be invoked by the APNS or VoIP delegate hook for push token registration
     
     - parameter token: the push token
     */
    public func deviceTokenRegistered(_ token: Token) {
        logDebug("Application device token registered, token=\(token)")
        for daemon in DaemonManager.sharedInstance.daemonsForType(DeviceDaemonType.self) {
            daemon.deviceTokenRegistered(token)
        }
    }
    
    /**
     Should be invoked by the APNS or VoIP delegates when a push notification is handled by the application. This will
     look up the correct daemon to handle the push notification
     
     - parameter userInfo:   the payload of the push
     - parameter completion: the completion callback
     */
    public func handleRemoteNotification(_ userInfo: [AnyHashable: Any], completion: @escaping (UIBackgroundFetchResult) -> Void) {
        if let userInfo = userInfo as? [String:AnyObject] {
            // Pushes from legacy systems may not have a category.  We support them
            // with this constant.  Only one daemon can have no category.
            var category = kRemoteNotificationNoCategory
            
            if let aps = userInfo["aps"] as? [String:AnyObject],
                let categoryFromPush = aps["category"] as? String {
                logDebug("Application did receive remove notification, category=\(category), userInfo=\(userInfo)")
                category = categoryFromPush
            } else {
                logDebug("Application did receive remove notification without category, userInfo=\(userInfo)")
            }
            // find daemon to handle push
            for daemon in DaemonManager.sharedInstance.daemonsForType(RemoteNotificationDaemonType.self) {
                if daemon.category == category {
                    daemon.handleNotification(userInfo, completion: completion)
                    return
                }
            }
        }
        logDebug("Application unable to handle remove notification, userInfo=\(userInfo)")
        completion(.noData)
    }
    
    public func handleInvalidatePushToken() {
        for daemon in DaemonManager.sharedInstance.daemonsForType(RemoteNotificationErrorDaemonType.self) {
                daemon.didInvalidatePushToken()
        }
    }
}

// MARK: - Notifications for Application Lifecycle
extension DaemonManager {
    fileprivate func registerLifecycleNotifications() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationDidFinishLaunching(_:)),
                         name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationWillResignActive(_:)),
                         name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationDidEnterBackground(_:)),
                         name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationWillEnterForeground(_:)),
                         name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationDidBecomeActive(_:)),
                         name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onApplicationWillTerminate(_:)),
                         name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    @objc func onApplicationDidFinishLaunching(_ notification: Notification) {
        let launchOptions = notification.userInfo?[UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any]
        logDebug("Application did Finish launching with options, options=\(launchOptions)")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    @objc func onApplicationWillResignActive(_ notification: Notification) {
        logDebug("Application will resign active")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillResignActive(UIApplication.shared)
        }
    }
    
    @objc func onApplicationDidEnterBackground(_ notification: Notification) {
        logDebug("Application did enter background")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationDidEnterBackground(UIApplication.shared)
        }
    }
    
    @objc func onApplicationWillEnterForeground(_ notification: Notification) {
        logDebug("Application will enter foreground")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillEnterForeground(UIApplication.shared)
        }
    }
    
    @objc func onApplicationDidBecomeActive(_ notification: Notification) {
        logDebug("Application did become active")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationDidBecomeActive(UIApplication.shared)
        }
    }
    
    @objc func onApplicationWillTerminate(_ application: UIApplication) {
        logDebug("Application will terminate")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillTerminate(application)
        }
    }
}
