//
//  SampleAPIClient.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/11.
//

import Foundation

struct SampleAPIClient {
    var url: URL = URL(string: "example.com")!
    var method: HTTPMethod = .get
    var bodyData: [URLQueryItem]? = nil
    
    struct Request: Encodable {
        let text: String
    }
    struct Response: Decodable {
        let text: String
    }
    
    
    
    
    
    
    
    
    
}
