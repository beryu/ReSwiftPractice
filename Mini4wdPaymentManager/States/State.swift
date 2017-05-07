//
//  State.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import ReSwift
import ReSwiftRouter

struct State: StateType, HasNavigationState {
    var navigationState: NavigationState
    var partState: PartState
    var paymentState: PaymentState
}
