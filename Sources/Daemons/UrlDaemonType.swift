import Foundation


/**
 Defines a protocol for registering a URL handler for external urls for a viper module
 */
public protocol UrlDaemonType: DaemonType  {
    
    /**
     The URL path in which the handler should be invoked. This should ONLY by the path of the URL.
     For example, if your url is "trouver://foo.locationlabs.com/bar?boo=baz" then your urlPath
     should be "/bar".
     
     If your url path contains fragments, then you need to specify those with a colon. For
     example, if your url is "trouver://foo.locationlabs.com/bar/5552221000", to denote the mdn as
     a url fragement, your urlPath should be "/bar/:mdn"
     */
    var urlPath: String { get }
    
    /**
     The URL path in which the handler should be invoked. This should ONLY by the host of the URL.
     For example, if your url is "trouver://foo.locationlabs.com/bar?boo=baz" then your urlHost
     should be "foo.locationlabs.com".
     */
    var urlHost: String { get }
    
    /**
     Will be invoked when your an external URL is matched with your URL path.
     
     - parameter url:         the url instance
     - parameter fragments:  the url fragments if the urlPath specifies them
     - parameter queryParams: the parsed query param string as key-value pairs
     
     - returns: true if handled, false otherwise
     */
    func handleUrl(_ url: URL, fragments: [String:String], queryParams: [String:String]) -> Bool
}
