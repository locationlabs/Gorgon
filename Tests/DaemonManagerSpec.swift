import Quick
import Nimble
@testable import Medusa


class DaemonManagerSpec: QuickSpec {
    
    override func spec() {
        describe("daemon manager") {
            
            var daemonManager: DaemonManager!
            beforeEach {
                daemonManager = DaemonManager()
            }
            
            it("can filter for daemons") {
                
                let foo = FooDaemon()
                let bar = BarDaemon()
                
                daemonManager.register(foo)
                daemonManager.register(bar)
                
                let appStateDaemons = daemonManager.daemonsForType(ApplicationDaemonType.self)
                expect(appStateDaemons.count) == 1
                expect(appStateDaemons[0] === foo) == true
                
                let noteDaemons = daemonManager.daemonsForType(NotificationCenterDaemonType.self)
                expect(noteDaemons.count) == 1
                expect(noteDaemons[0] === bar) == true
            }
            
            it("can filter multi type daemons") {
                let foo = FooDaemon()
                let bar = BarDaemon()
                let baz = BazDaemon()
                
                daemonManager.register(foo)
                daemonManager.register(bar)
                daemonManager.register(baz)
                
                let appStateDaemons = daemonManager.daemonsForType(ApplicationDaemonType.self)
                expect(appStateDaemons.count) == 2
                expect(appStateDaemons[0] === foo) == true
                expect(appStateDaemons[1] === baz) == true
                
                let noteDaemons = daemonManager.daemonsForType(NotificationCenterDaemonType.self)
                expect(noteDaemons.count) == 2
                expect(noteDaemons[0] === bar) == true
                expect(noteDaemons[1] === baz) == true
            }
        }
    }
}
