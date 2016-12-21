import UIKit


/**
 The ApplicationDaemonType provides application state changes
 */
public protocol ApplicationDaemonType: DaemonType {
    
    /**
     This function will be called when the application did finished launching and VIPER booted up with
     the provided launch options
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?)
    
    /**
     This function will be called when the application is transitioning to inactive or background state
     */
    func applicationWillResignActive(_ application: UIApplication)
    
    /**
     This function will be called when the application enters the background state
     */
    func applicationDidEnterBackground(_ application: UIApplication)
    
    /**
     This function will be called when the application enters active state
     */
    func applicationDidBecomeActive(_ application: UIApplication)
    
    /**
     This function will be called application is about to terminate.
     */
    func applicationWillTerminate(_ application: UIApplication)
    
    /**
     This function will be called when application enters to active state from the background.
     */
    func applicationWillEnterForeground(_ application: UIApplication)
}


public extension ApplicationDaemonType {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        // no-op
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // no-op
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // no-op
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // no-op
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // no-op
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // no-op
    }
}
