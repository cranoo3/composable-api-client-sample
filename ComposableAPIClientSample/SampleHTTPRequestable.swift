//
//  SampleHTTPRequestable.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/14.
//

import Foundation

struct SampleHTTPRequestable: HTTPRequestable {
    var baseURL: URL = URL(string: "http://localhost:8080")!
    var path: String? = "/notfound.php"
    var method: HTTPMethod = .get
    
    struct Response: HTTPResponse {
        struct Success: DecodableSendable {
            let message: String
        }
        
        struct Failure: DecodableSendable {
            let error: String
        }
    }
}
