//
//  AsyncMiddleware.swift
//  UNI
//
//  Created by Jason Prasad on 9/30/18.
//  Copyright © 2018 Jason Prasad. All rights reserved.
//

import ReSwift

protocol AsyncAction: Action {
    
    func run(dispatch: @escaping DispatchFunction, getState: @escaping () -> AppState?)
    
}

public let asyncMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            if let action = action as? AsyncAction {
                action.run(dispatch: dispatch, getState: getState)
                return
            }
            next(action)
        }
    }
}
