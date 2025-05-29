//
//  ComposableAlert.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/29.
//

import SwiftUI

//
// {
//     "error": [
//         {
//             "code": "invalid_request",
//             "message": "無効なリクエスト"
//         },
//         {
//             "code": "invalid_userId",
//             "message": "無効なユーザーID"
//         }
//     ]
// }
//

protocol ComposableError: Error {
    var title: String { get }
    var message: String { get }
}

enum SampleLocalizedError: ComposableError {
    case networkError
    case internalServerError
    
    var title: String {
        switch self {
        case .networkError:
            "エラーが発生しました"
        case .internalServerError:
            "サーバーエラー"
        }
    }
    
    var message: String {
        switch self {
        case .networkError:
            "ネットワークに接続していません。ざんねん！"
        case .internalServerError:
            "ざんねんむねんまたらいねん"
        }
    }
}

struct ComposableAlert: View {
    @State private var anErrorOccurred = false
    @State private var error = SampleLocalizedError.networkError
    
    var body: some View {
        VStack {
            Button("Switch Error") {
                if error == .networkError {
                    error = .internalServerError
                } else {
                    error = .networkError
                }
            }
            
            Button("Error発生！") {
                anErrorOccurred = true
            }
            
            Text("Hello, World!")
        }
        .alert(error.title, isPresented: $anErrorOccurred) {
            switch error {
            case .networkError:
                Button("OK", role: .cancel) {}
                Button("NG", role: .destructive) {}
            case .internalServerError:
                Button("OK", role: .cancel) {}
            }
        } message: {
            Text(error.message)
        }
        
    }
}

#Preview {
    ComposableAlert()
}
