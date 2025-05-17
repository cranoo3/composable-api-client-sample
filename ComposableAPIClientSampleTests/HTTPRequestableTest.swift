//
//  HTTPRequestableTest.swift
//  ComposableAPIClientSampleTests
//
//  Created by cranoo on 2025/05/11.
//

import Foundation
import Testing
@testable import ComposableAPIClientSample

struct HTTPRequestableTest {
    struct TestHTTPRequestable: HTTPRequestable {
        var baseURL: URL
        var path: String?
        var method: HTTPMethod
        var query: [URLQueryItem]?
        var headers: [String : String]?
        var httpBody: HTTPBody?
        
        struct Response: HTTPResponse {
            struct Success: DecodableSendable {
                let message: String
            }
            
            struct Failure: DecodableSendable {
                let error: String
            }
        }
    }
    
    
    @Test
    func testCorrectFormatConversion() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080")!,
            path: "/sample/notfound.php",
            method: .get
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php")
    }
    
    @Test
    func testFormatPathWithoutLeadingSlash() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080")!,
            path: "sample/notfound.php",
            method: .get
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php")
    }
    
    @Test
    func testFormatURLWithQueryItems() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080")!,
            path: "/sample/notfound.php",
            method: .get,
            query: [
                URLQueryItem(name: "key1", value: "value1"),
                URLQueryItem(name: "key2", value: "value2")
            ]
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php?key1=value1&key2=value2")
    }
    
    // FIXME: query:[] だとバグります
    @Test
    func testFormatURLWithEmptyQueryItems() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080")!,
            path: "/sample/notfound.php",
            method: .get,
            query: nil
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php")
    }
    
    @Test
    func testFormatURLWithLeadingSlash() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080/")!,
            path: "sample/notfound.php",
            method: .get
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php")
    }
    
    @Test
    func testFormatURLAndPathWithLeadingSlash() {
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080/")!,
            path: "/sample/notfound.php",
            method: .get
        )
        let resultURL = try! mock.makeURLRequest().url!
        #expect(resultURL.absoluteString == "http://localhost:8080/sample/notfound.php")
    }
    
    @Test
    func testBodyHeader() {
        let header = ["key": "value", "key2": "value2"]
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080/")!,
            path: "/sample/notfound.php",
            method: .get,
            headers: header
        )
        let resultHeader = try! mock.makeURLRequest().allHTTPHeaderFields
        
        #expect(resultHeader == header)
    }
    
    @Test
    func testBodyData() {
        let dictionary = ["key": "value", "key2": "value2"]
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        let mock = TestHTTPRequestable(
            baseURL: URL(string: "http://localhost:8080/")!,
            path: "/sample/notfound.php",
            method: .post,
            httpBody: .init(dictionaryData: dictionary)
        )
        
        let resultData = try! mock.makeURLRequest().httpBody!
        #expect(data == resultData)
    }
}
