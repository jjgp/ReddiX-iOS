//
//  Request.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

public enum Method: String {
    
    case get = "GET"
    
}

public typealias Parameters = [String: String]

public enum RequestError: Error {
    
    case urlInvalid
    
}

public struct Request<J: JSON>: Processable {
    
    public typealias Map = J
    
    public let method: Method
    public let parameters: Parameters
    public let URLPath: String
    
    public init(method: Method = .get,
                parameters: Parameters,
                URLPath: String) {
        self.method = method
        self.parameters = parameters
        self.URLPath = URLPath
    }
    
}

extension Request {
    
    public func URLRequest(for host: String) throws -> URLRequest {
        var components = URLComponents(string: "\(host)\(URLPath)")
        components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = components?.url else {
            throw RequestError.urlInvalid
        }
    
        var request = Foundation.URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
}
