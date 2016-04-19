import Foundation


/**
 The protocol for the DeviceDaemonType allows for device registration for tokens.
 */
public protocol DeviceDaemonType: DaemonType {
    
    /**
     The application has registered the device token that can be used to send push notifications
     
     - parameter token: the device token to target push notifications
     */
    func deviceTokenRegistered(token: Token)
}