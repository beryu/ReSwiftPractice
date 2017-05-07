//
//  PaymentState.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/07.
//  Copyright © 2017年 blk. All rights reserved.
//

import ReSwift

struct PaymentState: StateType {
    var payments: [Payment]
}

struct Payment {
    var id: String
    var itemId: String?
    var name: String?
    var price: Int?
    var store: String?
    var date: Date?
}
