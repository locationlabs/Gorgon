import Quick
import Nimble
@testable import Gorgon


class UrlSpecSpec: QuickSpec {
    
    override func spec() {
        describe("url") {
            
            it("can match host without path") {
                let url = Url(url: NSURL(string: "http://localhost.com")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "")
                expect(fragments).toNot(beNil())
                expect(fragments!.isEmpty) == true
            }
            
            it("can match host with simple path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/foo")
                expect(fragments).toNot(beNil())
                expect(fragments!.isEmpty) == true
            }
            
            it("can match host with multi path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/foo/bar")
                expect(fragments).toNot(beNil())
                expect(fragments!.isEmpty) == true
            }
            
            it("wont match different hosts") {
                let url = Url(url: NSURL(string: "http://localhost.com")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("locationlabs.com", path: "")
                expect(fragments).to(beNil())
            }
            
            it("wont match hosts with different paths") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/bar")
                expect(fragments).to(beNil())
            }
            
            it("wont match hosts with different leading paths") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/baz")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/bar/baz")
                expect(fragments).to(beNil())
            }
            
            it("wont match hosts with different trailing paths") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/foo/baz")
                expect(fragments).to(beNil())
            }
            
            it("can match host with variable path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/:id")
                expect(fragments).toNot(beNil())
                expect(fragments!.count) == 1
                expect(fragments!["id"]) == "foo"
            }
            
            it("can match host with leading variable path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/:id/bar")
                expect(fragments).toNot(beNil())
                expect(fragments!.count) == 1
                expect(fragments!["id"]) == "foo"
            }
            
            it("can match host with trailing variable path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/foo/:id")
                expect(fragments).toNot(beNil())
                expect(fragments!.count) == 1
                expect(fragments!["id"]) == "bar"
            }
            
            it("can match host with multi variable path") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar/baz/zoo")!, sourceApplication: nil)
                let fragments = url.matchUrlPathAndBuildFragments("localhost.com", path: "/foo/:id/baz/:id2")
                expect(fragments).toNot(beNil())
                expect(fragments!.count) == 2
                expect(fragments!["id"]) == "bar"
                expect(fragments!["id2"]) == "zoo"
            }
            
            it("can handle no query params") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar")!, sourceApplication: nil)
                let params = url.paramsForQueryString()
                expect(params.isEmpty) == true
            }
            
            it("can handle single query params") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar?baz=boo")!, sourceApplication: nil)
                let params = url.paramsForQueryString()
                expect(params.count) == 1
                expect(params["baz"]) == "boo"
            }
            
            it("can handle multi query params") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar?baz=boo&zoo=fiz")!, sourceApplication: nil)
                let params = url.paramsForQueryString()
                expect(params.count) == 2
                expect(params["baz"]) == "boo"
                expect(params["zoo"]) == "fiz"
            }
            
            it("can handle encodings query params") {
                let url = Url(url: NSURL(string: "http://localhost.com/foo/bar?baz=hello%20world")!, sourceApplication: nil)
                let params = url.paramsForQueryString()
                expect(params.count) == 1
                expect(params["baz"]) == "hello world"
            }
        }
    }
}
