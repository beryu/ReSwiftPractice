//
//  AppReducer.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import ReSwift
import ReSwiftRouter

struct AppReducer: Reducer {
    func handleAction(action: Action, state: State?) -> State {
        return State(navigationState: NavigationReducer.handleAction(action, state: state?.navigationState),
                     partState: partReducer(state: state?.partState, action: action),
                     paymentState: paymentReducer(state: state?.paymentState, action: action))
    }
}
