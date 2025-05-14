//
//  SampleAPIClient.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/14.
//

import Foundation

struct SampleAPIClient: APIClient {
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    // Xcodeのコード補完はこのように補完しました(°_°)
    func fetch<T>(_ request: T) async throws -> HTTPResponseStatus<T.Response.Success, T.Response.Failure> where T : HTTPRequestable {
        let request = try request.makeURLRequest()
        let (data, _, response) = try await sendRequest(to: request)
        
        if isSuccessStatusCode(response.statusCode) {
            let decode = try JSONDecoder().decode(T.Response.Success.self, from: data)
            return .success(decode)
        } else {
            
            let decode = try JSONDecoder().decode(T.Response.Failure.self, from: data)
            return .failure(decode, handleStatusCodeError(statusCode: response.statusCode))
        }
    }
    
    func isSuccessStatusCode(_ statusCode: Int) -> Bool {
        200...299 ~= statusCode
    }
    
    func handleStatusCodeError(statusCode: Int) -> APIClientError {
        .sample
    }
}

enum APIClientError: Error {
    case sample
}
