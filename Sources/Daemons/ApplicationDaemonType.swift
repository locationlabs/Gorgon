import UIKit


/**
 The ApplicationDaemonType provides application state changes
 */
public protocol ApplicationDaemonType: DaemonType {
    
    /**
     This function will be called when the application did finished launching and VIPER booted up with
     the provided launch options
     */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
    
    /**
     This function will be called when the application is transitioning to inactive or background state
     */
    func applicationWillResignActive(application: UIApplication)
    
    /**
     This function will be called when the application enters the background state
     */
    func applicationDidEnterBackground(application: UIApplication)
    
    /**
     This function will be called when the application enters active state
     */
    func applicationDidBecomeActive(application: UIApplication)
    
    /**
     This function will be called application is about to terminate.
     */
    func applicationWillTerminate(application: UIApplication)
    
    /**
     This function will be called when application enters to active state from the background.
     */
    func applicationWillEnterForeground(application: UIApplication)
}


public extension ApplicationDaemonType {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        // no-op
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // no-op
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // no-op
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // no-op
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // no-op
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // no-op
    }
}