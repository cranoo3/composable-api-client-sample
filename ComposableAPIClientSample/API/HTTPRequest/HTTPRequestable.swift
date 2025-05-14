import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol HTTPResponse {
    associatedtype Success: Decodable
    associatedtype Failure: Decodable
}

protocol HTTPRequestable {
    var baseURL: URL { get }
    var path: String? { get }
    var query: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var httpBody: HTTPBody? { get }
    associatedtype Response: HTTPResponse
}

private extension HTTPRequestable {
    func formatBaseURL() throws -> URL {
        var urlString = baseURL.absoluteString
        if urlString.hasPrefix("/") {
            urlString = String(urlString.dropLast())
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    func formatPath(_ path: String) throws -> String {
        var tmpPath = path
        if !path.hasPrefix("/") {
            tmpPath = "/" + tmpPath
        }
        if path.hasSuffix("/") && path.count >= 1 {
            tmpPath = String(tmpPath.dropLast())
        }
        
        return tmpPath
    }
    
    func makeURLComponents() throws -> URLComponents {
        let formattedBaseURL = try formatBaseURL()
        guard var components = URLComponents(url: formattedBaseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Could not create URLComponents")
        }
        if let path {
            components.path = try formatPath(path)
        }
        if let query {
            components.queryItems = query
        }
        
        return components
    }
}

extension HTTPRequestable {
    func makeURLRequest() throws -> URLRequest {
        let components = try makeURLComponents()
        guard let url = components.url else {
            fatalError("URL is nil")
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try httpBody?.toJSONData()
        
        return request
    }
}

extension HTTPRequestable {
    var path: String? {
        nil
    }
    var query: [URLQueryItem]? {
        nil
    }
    var headers: [String: String]? {
        nil
    }
    var httpBody: HTTPBody? {
        nil
    }
}
