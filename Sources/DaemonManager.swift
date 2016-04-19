import Foundation



/**
 The Daemon manages the DaemonType's that are registered. The Daemon is a accessed via the sharedInstance and thus
 will live for the life of the application once a daemon has been registered. Daemons are meant to be long lived and
 respond to system events
 */
final public class DaemonManager {
    
    /// list of daemons for the application
    private var daemons = [DaemonType]()
        
    init() {
        self.registerLifecycleNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     Will register a daemon with the VIPER application
     
     - parameter daemon: the daemon to register
     */
    public func register(daemon: DaemonType) {
        daemons.append(daemon)
        
        // setup notification handlers for daemon
        if let notificationCenterDaemon = daemon as? NotificationCenterDaemonType {
            for (notificationName, selector) in notificationCenterDaemon.notificationToSelectors {
                NSNotificationCenter.defaultCenter()
                    .addObserver(daemon,
                                 selector: selector,
                                 name: notificationName,
                                 object: nil)
            }
        }
    }
    
    /**
     Will retrieve daemons for a given type
     
     - parameter type: the type of daemon
     
     - returns: the daemons that implement the given type
     */
    func daemonsForType<T>(type: T.Type) -> [T] {
        return daemons.map { $0 as? T }.flatMap { $0 }
    }
}

// MARK: - Singleton
public extension DaemonManager {
    public static let sharedInstance = DaemonManager()
}

// MARK: - URL
public extension DaemonManager {
    public func application(application: UIApplication, openURL url: NSURL,
                            sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        logDebug("Application open url, url=\(url.path), query=\(url.query), scheme=\(url.scheme),"
            + " host=\(url.host), path=\(url.path), sourceApplication=\(sourceApplication)")
        
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
    
    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        guard let category = notification.category else {
            logDebug("Application did receive location notification without category")
            return
        }
        logDebug("Application did receive local notification, category=\(category),"
            + " userInfo=\(notification.userInfo)")
        
        for daemon in daemonsForType(LocalNotificationDaemonType.self) {
            if daemon.category == category {
                daemon.handleNotification(notification.userInfo as? [String:AnyObject])
                return
            }
        }
        logDebug("Application local notification daemon not found, category=\(category),"
            + " userInfo=\(notification.userInfo)")
    }
    
    public func application(application: UIApplication, handleActionWithIdentifier identifier: String?,
                            forLocalNotification notification: UILocalNotification, completionHandler: () -> Void)
    {
        guard let category = notification.category else {
            logDebug("Application did receive local notification handle action with identifer without category")
            return
        }
        logDebug("Application did receive local notification handle action with identifer, category=\(category),"
            + " userInfo=\(notification.userInfo), identifier=\(identifier)")
        
        for daemon in daemonsForType(LocalActionNotificationDaemonType.self) {
            if daemon.category == category {
                daemon.handleActionWithIdentifier(identifier,
                                                  userInfo: notification.userInfo as? [String:AnyObject],
                                                  completionHandler: completionHandler)
                return
            }
        }
        
        logDebug("Application local notification daemon not found for action handler, category=\(category),"
            + " userInfo=\(notification.userInfo), identifier=\(identifier)")
        completionHandler()
    }
}

// MARK: - APNS/VoIP Notifications
public extension DaemonManager {
    
    /**
     Should be invoked by the APNS or VoIP delegate hook for push token registration
     
     - parameter token: the push token
     */
    public func deviceTokenRegistered(token: Token) {
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
    public func handleRemoveNotification(userInfo: [NSObject:AnyObject], completion: (UIBackgroundFetchResult) -> Void) {
        if let userInfo = userInfo as? [String:AnyObject], let aps = userInfo["aps"] as? [String:AnyObject] {
            // Pushes from legacy systems may not have a category.  We support them
            // with this constant.  Only one daemon can have no category.
            var category = kRemoteNotificationNoCategory
            
            if let categoryFromPush = aps["category"] as? String {
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
        completion(.NoData)
    }
}

// MARK: - Notifications for Application Lifecycle
extension DaemonManager {
    private func registerLifecycleNotifications() {
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationDidFinishLaunching(_:)),
                         name: UIApplicationDidFinishLaunchingNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationWillResignActive(_:)),
                         name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationDidEnterBackground(_:)),
                         name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationWillEnterForeground(_:)),
                         name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationDidBecomeActive(_:)),
                         name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(onApplicationWillTerminate(_:)),
                         name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    @objc func onApplicationDidFinishLaunching(notification: NSNotification) {
        let launchOptions = notification.userInfo?[UIApplicationLaunchOptionsUserActivityDictionaryKey] as? [NSObject:AnyObject]
        logDebug("Application did Finish launching with options, options=\(launchOptions)")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: launchOptions)
        }
    }
    
    @objc func onApplicationWillResignActive(notification: NSNotification) {
        logDebug("Application will resign active")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillResignActive(UIApplication.sharedApplication())
        }
    }
    
    @objc func onApplicationDidEnterBackground(notification: NSNotification) {
        logDebug("Application did enter background")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationDidEnterBackground(UIApplication.sharedApplication())
        }
    }
    
    @objc func onApplicationWillEnterForeground(notification: NSNotification) {
        logDebug("Application will enter foreground")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillEnterForeground(UIApplication.sharedApplication())
        }
    }
    
    @objc func onApplicationDidBecomeActive(notification: NSNotification) {
        logDebug("Application did become active")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationDidBecomeActive(UIApplication.sharedApplication())
        }
    }
    
    @objc func onApplicationWillTerminate(application: UIApplication) {
        logDebug("Application will terminate")
        for daemon in daemonsForType(ApplicationDaemonType.self) {
            daemon.applicationWillTerminate(application)
        }
    }
}
