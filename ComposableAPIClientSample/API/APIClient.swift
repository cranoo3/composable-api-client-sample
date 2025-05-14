//
//  APIClient.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/14.
//

import Foundation

protocol DecodableSendable: Decodable, Sendable {}

enum HTTPResponseStatus<Success: DecodableSendable, Failure: DecodableSendable> {
    case success(Success)
    // この実装変じゃない？
    // これならErrorもジェネリクスにした方が統一感ありあそうですが...
    // 気のせいでした。
    case failure(Failure, Error)
}

protocol APIClient {
    func fetch<T: HTTPRequestable>(_ request: T) async throws -> HTTPResponseStatus<T.Response.Success, T.Response.Failure>
    func sendRequest(to request: URLRequest, session: URLSession) async throws -> (Data, URLRequest, HTTPURLResponse)
    func decodeFromJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension APIClient {
    func sendRequest(to request: URLRequest, session: URLSession = .init(configuration: .default)) async throws -> (Data, URLRequest, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let httpURLResponse = response as? HTTPURLResponse else {
            fatalError("HTTPURLResponse expected.")
        }
        
        return (data, request, httpURLResponse)
    }
    
    func decodeFromJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}
