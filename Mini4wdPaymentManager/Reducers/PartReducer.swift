//
//  PartsReducer.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import Foundation
import UIKit
import ReSwift
import ReSwiftRouter
import APIKit
import Result

func partReducer(state: PartState?, action: Action) -> PartState {
    var state = state ?? initialPartState()
    switch action {
    case let action as FetchPartAction:
        let request = GetPartRequest(id: action.id)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Session.send(request) { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success(let response):
                store.dispatch(SetPartAction(id: response.id, name: response.name, description: response.description, price: response.price))
            case .failure(let error):
                print("[ERROR]: \(error)")
            }
        }
        return state
    case let action as SetPartAction:
        state.id = action.id
        state.name = action.name
        state.description = action.description
        state.price = action.price
        return state
    default:
        return state
    }
}

func initialPartState() -> PartState {
    return PartState(id: nil, name: nil, description: nil, price: nil)
}
