//
//  PaymentActions.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/07.
//  Copyright © 2017年 blk. All rights reserved.
//

import Foundation
import ReSwift

struct AddPaymentAction: Action {
    var id: String
    var itemId: String?
    var name: String?
    var price: Int
    var store: String?
    var date: Date?
}
