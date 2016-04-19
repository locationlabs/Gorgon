

/**
 The DaemonType is an empty protocol that all daemons will extend from. This allows us to register a daemon
 1 time and let the app figure out its specific type when a certain event happens.
*/
public protocol DaemonType: class {

}