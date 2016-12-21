import Foundation


/**
 The Url class is responsible for parsing an NSURL and matching this for url daemons
*/
final class Url {
    
    /// the url delivered to the application
    fileprivate let url: URL
    
    /// the application that delivered the url
    fileprivate let sourceApplication: String?
    
    init(url: URL, sourceApplication: String?) {
        self.url = url
        self.sourceApplication = sourceApplication
    }
    
    /**
     Will parse and attempt to match the URL path against the given url daemon path
     
     - parameter path:        the url path that the app is currently handling
     - parameter daemonPath:  the daemon urlPath that we will attempt to match
     
     - returns: the url fragments if the url matches, otherwise will return nil
     */
    func matchUrlPathAndBuildFragments(_ host: String, path: String) -> [String:String]? {
        guard url.host == host else {
            return nil
        }
        
        // internal function to parse the url path into parts
        func toParts(_ value: String) -> [String] {
            return value.components(separatedBy: "/").filter { !$0.isEmpty }
        }
        
        // convert paths into parts for comparison
        let pathParts = toParts(url.path)
        let handlerPathParts = toParts(path)
        
        // if pairs don't match, it does not match the url
        guard pathParts.count == handlerPathParts.count else {
            return nil
        }
        
        // generate fragments and ensure matches
        var fragments = [String:String]()
        for (index, part) in handlerPathParts.enumerated() {
            if part.hasPrefix(":") {
                let key = (part as NSString).substring(from: 1)
                fragments[key] = pathParts[index]
            } else if part != pathParts[index] {
                return nil
            }
        }
        
        // if we get to this point, then we have matched a url
        return fragments
    }
    
    /**
     Will create a map from the query params
     
     - parameter query: the query param strings (e.g. foo=bar&boo=baz)
     
     - returns: a map of key-value pairs from the query string
     */
    func paramsForQueryString() -> [String:String] {
        var params = [String:String]()
        if let parts = url.query?.components(separatedBy: "&") {
            for part in parts {
                let pairs = part.components(separatedBy: "=")
                if pairs.count == 2 {
                    // handle encodings
                    params[pairs[0]] = pairs[1]
                        .replacingOccurrences(of: "+", with: " ")
                        .removingPercentEncoding
                }
            }
        }
        return params
    }
}
