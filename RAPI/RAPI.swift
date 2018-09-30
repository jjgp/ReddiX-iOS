//
//  RAPI.swift
//  ReddiX
//
//  Created by Jason Prasad on 9/29/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import Foundation

public class RAPI {
    
    public let host: String
    public let session: URLSession
    
    public init(host: String = "https://reddit.com",
                URLSession: URLSession = .shared) {
        self.host = host
        self.session = URLSession
    }
    
}

public protocol Processable {
    
    associatedtype Map: JSON
    
    func URLRequest(for host: String) throws -> URLRequest
    
}

public extension RAPI {
    
    typealias Completion<J: JSON> = (J?, HTTPURLResponse?, Error?) -> Void
    
    func process<P: Processable>(_ request: P, completion: Completion<P.Map>? = nil) {
        /*
         * NOTE: try! in constructing the URLRequest, if we are constructing
         * incorrect URLs that is a development time error
         */
        session.dataTask(with: try! request.URLRequest(for: host)) { data, response, error in
            let response = response as? HTTPURLResponse
            var json: P.Map?
            var completionError = error
            
            if completion != nil,
                let code = response?.statusCode,
                200..<400 ~= code,
                let data = data {
                do {
                    json = try P.Map.map(data: data)
                } catch {
                    json = nil
                    completionError = error
                }
            }
            
            completion?(json, response, completionError)
        }.resume()
    }
    
}
