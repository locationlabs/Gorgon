import Foundation


/**
 The Token class represents a push token that is delivered from the system from either PushKit (e.g. VoIP) or APNS
*/
final public class Token {
    
    /// the push token that is used to idenitify the client
    public let token: Data
    
    /// the origin of the push token
    public let origin: Origin
    
    init(token: Data, origin: Origin) {
        self.token = token
        self.origin = origin
    }
    
    /**
     The origin of the push token
     
     - PushKit: push token is delivered by PushKit
     - APNS:    push token is delivered by APNS
     */
    public enum Origin: String {
        case PushKit = "PushKit"
        case APNS = "APNS"
    }
}

// MARK: - CustomStringConvertible
extension Token: CustomStringConvertible {
    public var description: String {
        return "{token=\(token), origin=\(origin)}"
    }
}
