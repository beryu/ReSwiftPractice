//
//  PaymentReducer.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/07.
//  Copyright © 2017年 blk. All rights reserved.
//

import Foundation
import ReSwift

func paymentReducer(state: PaymentState?, action: Action) -> PaymentState {
    var state = state ?? initialPaymentState()
    switch action {
    case let action as AddPaymentAction:
        let payment = Payment(id: UUID().uuidString, itemId: action.itemId, name: action.name, price: action.price, store: action.store, date: action.date)
        state.payments.insert(payment, at: 0)
        return state
    default:
        return state
    }
}

func initialPaymentState() -> PaymentState {
    return PaymentState(payments: [])
}
