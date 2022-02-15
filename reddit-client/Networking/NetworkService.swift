//
//  NetworkService.swift
//  reddit-client
//
//  Created by Elina Semenko on 15.02.2022.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidUrlError
    case sessionError
    case decodingError
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
typealias ReaquestHeaders = [String: String]
typealias RequestParameters = [Parameters : Any?]

protocol RequestProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
    
    func urlRequest() -> URLRequest?
}

class RedditRequest: RequestProtocol {
    var baseURL: String = "https://www.reddit.com"
    var path: String = "/r"
    var method: RequestMethod = .get
    var headers: ReaquestHeaders? = nil
    var parameters: RequestParameters? = [Parameters.limit : 1]
    var subreddit: Subreddit = .ios
    var sorting: Sorting = .top
    
    init() {}
    
    init(subreddit: Subreddit, sorting: Sorting, parameters: [Parameters:String]?) {
        self.parameters = parameters
        self.sorting = sorting
        self.subreddit = subreddit
    }
    
    func urlRequest() -> URLRequest? {
        let additionalPath = subreddit.rawValue + sorting.rawValue
        guard let url = url(with: baseURL, additionalPath: additionalPath) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}

final class NetworkService {
    static var instance: NetworkService = { NetworkService() }()
    
    private init() { }
    
    func performBaseRequest(completion: @escaping (Result<[Post], NetworkServiceError>)->()) {
        
        guard let urlRequest = RedditRequest().urlRequest() else {
            completion(.failure(.invalidUrlError))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                completion(.failure(.sessionError))
                return
            }
            if let data = data {
                guard let result = try? JSONDecoder().decode(Data.self, from: data), let posts = result.data?.children?.compactMap({ $0.data }) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(posts))
            }
        }
        task.resume()
    }
    
    func performRequest(subreddit: Subreddit, sorting: Sorting, parameters: [Parameters:String]?, completion: @escaping (Result<[Post], NetworkServiceError>)->()) {
        
        guard let urlRequest = RedditRequest(subreddit: subreddit, sorting: sorting, parameters: parameters).urlRequest() else {
            completion(.failure(.invalidUrlError))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                completion(.failure(.sessionError))
                return
            }
            if let data = data {
                guard let result = try? JSONDecoder().decode(Data.self, from: data), let posts = result.data?.children?.compactMap({ $0.data }) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(posts))
            }
        }
        task.resume()
    }
}

extension RequestProtocol {
    func urlRequest() -> URLRequest? {
        guard let url = url(with: baseURL) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func url(with baseURL: String, additionalPath: String? = nil) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        urlComponents.path = urlComponents.path + path + (additionalPath ?? "")
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else {
            return nil
        }
        return parameters.map { (key: Parameters, value: Any?) -> URLQueryItem in
            if let value = value {
                return URLQueryItem(name: key.rawValue, value: String(describing: value))
            }
            return URLQueryItem(name: key.rawValue, value: "")
        }
    }
}

enum Parameters: String {
    case after = "after", limit = "limit"
}

enum Sorting: String {
    case top = "/top.json"
}

enum Subreddit: String {
    case ios = "/ios", android = "/android"
}
