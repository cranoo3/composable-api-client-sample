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
    
    @Test
    func formatOfThePATHCorrect() {
        do {
            let mock = HTTPRequesableMock()
            let resultURL = try mock.makeURL()
            #expect(resultURL.absoluteString == "https://www.example.com/greetings/morning?greetings=hello")
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

struct HTTPRequesableMock: HTTPRequestable {
    var baseURL: URL = URL(string: "https://www.example.com/")!
    var path: String? = "/greetings/morning/"
    var query: [URLQueryItem]? = [.init(name: "greetings", value: "hello")]
    
    var method: ComposableAPIClientSample.HTTPMethod = .get
    var headers: [String : String]? = nil
    
    struct Response: Decodable {
        var greeting: String
    }
}
