//
//  HTTPBody.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/14.
//

import Foundation

struct HTTPBody {
    let dictionaryData: [String : String]
    
    init(dictionaryData: [String : String]) {
        self.dictionaryData = dictionaryData
    }
    
    func toJSONData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: dictionaryData, options: [])
    }
}
