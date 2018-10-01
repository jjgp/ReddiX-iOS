//
//  LoggingMiddleware.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

public let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            print(action)
            return next(action)
        }
    }
}
