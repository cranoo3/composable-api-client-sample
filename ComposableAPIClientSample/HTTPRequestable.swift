//
//  HTTPRequestable.swift
//  ComposableAPIClientSample
//
//  Created by cranoo on 2025/05/11.
//

import Foundation

protocol HTTPRequestable {
    var baseURL: URL { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    
    associatedtype Response: Decodable
}

enum HTTPClientErrors: Error {
    case invalidURL
    case responseNotReturned
    case badStatusCode(Int)
}

enum HTTPMethod {
    case get
    case post
    case custom(String)
    
    var rawValue: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .custom(let value):
            value
        }
    }
}

// ビジネスロジックをまとめる
private extension HTTPRequestable {
    /// path変数の
    /// 最初に`/`がついていない場合に付与する
    /// 最後に`/`がついている場合は削除する
    func pathFormat(from path: String) -> String {
        var tmpPath = path
        if !path.hasPrefix("/") {
            tmpPath = "/" + tmpPath
        }
        if path.hasSuffix("/") {
            tmpPath = String(tmpPath.dropLast())
        }
        
        return tmpPath
    }
    
    /// 引数に渡されたJSONのデータを構造体へ変換します
    /// APIクライアントからのレスポンスを構造体へ変換することを想定しています
    func convertToStructure(from jsonData: Data) throws -> Response {
        let decoder = JSONDecoder()
        let result = try decoder.decode(Response.self, from: jsonData)
        
        return result
    }
}

extension HTTPRequestable {
    /// URLを作成します
    /// queryの値をURLに含める処理も行います
    func makeURL() throws -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = query
        if let path {
            components?.path = pathFormat(from: path)
        }
        
        guard let url = components?.url else {
            throw HTTPClientErrors.invalidURL
        }
        return url
    }
    
    /// 引数のURLへリクエストを送信しレスポンスを受け取る
    func sendRequest(_ url: URL) async throws -> Data {
        // リクエストを作成
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if let headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        // リクエスト送信
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        
        // レスポンスデータを確認
        guard let response = response as? HTTPURLResponse else {
            throw HTTPClientErrors.responseNotReturned
        }
        // ステータスコードを確認
        guard 200..<300 ~= response.statusCode else {
            throw HTTPClientErrors.badStatusCode(response.statusCode)
        }
        
        return data
    }
    
    /// 情報を取得するメソッド
    func fetch() async throws -> Response {
        // urlを取得
        let url = try makeURL()
        
        // リクエストを送信
        let response = try await sendRequest(url)
        print(String(data: response, encoding: .utf8)!)
        
        // 受け取ったデータをパースする
        let decodeData = try convertToStructure(from: response)
        
        // デコードデータを返す
        return decodeData
    }
}
