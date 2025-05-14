//
//  ContentView.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/11.
//

import SwiftUI

struct ContentView: View {
    @State var vm = ViewModel()
    
    var body: some View {
        VStack {
            Button("取得する!") {
                Task {
                    try await vm.fetch()
                }
            }
            
            Text("メッセージ")
                .font(.title)
            Text(vm.message)
        }
        .padding()
    }
}

@Observable
class ViewModel {
    let apiClient = SampleAPIClient()
    let requestable = SampleHTTPRequestable()
    
    var message = ""
    
    func fetch() async throws {
        let response = try await apiClient.fetch(requestable)
        switch response {
        case .success(let success):
            message = success.message
        case .failure(let failure, let error):
            message = "\(failure.error): \(error)"
        }
    }
}

#Preview {
    ContentView()
}
