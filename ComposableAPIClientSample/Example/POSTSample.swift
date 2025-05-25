//
//  POSTSample.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/25.
//

import SwiftUI

struct POSTSampleAPIClient: APIClient {
    // Xcodeのコード補完はこのように補完しました(°_°)
    func fetch<T>(_ request: T) async throws -> HTTPResponseStatus<T.Response.Success, T.Response.Failure> where T : HTTPRequestable {
        let request = try request.makeURLRequest()
        let (data, _, response) = try await sendRequest(to: request)
        
        let decode = try JSONDecoder().decode(T.Response.Success.self, from: data)
        return .success(decode)
    }
    
}

struct POSTSampleRequest: HTTPRequestable {
    var baseURL = URL(string: "https://www.sample.com")!
    
    var method: HTTPMethod = .post
    
    struct Response: HTTPResponse {
        struct Success: DecodableSendable {
            let message: String
        }
        struct Failure: DecodableSendable {
            let errors: [SampleFailureError]
            
            struct SampleFailureError: DecodableSendable {
                let code: String
                let message: String
            }
        }
        
    }
    
    
}

@Observable
final class POSTSampleViewModel {
    @ObservationIgnored let apiClient = POSTSampleAPIClient()
    
    var responseMessage = ""
    var isLoading = false
    var errorMessage: String?
    
    func fetch() {
        Task {
            let request = POSTSampleRequest()
            let result = try await apiClient.fetch(request)
            switch result {
            case .success(let success):
                responseMessage = success.message
            case .failure(let failure, let error):
                errorMessage = failure.errors.first?.message
            }
        }
    }
}

struct POSTSample: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    POSTSample()
}
