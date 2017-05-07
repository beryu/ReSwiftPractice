//
//  PartAction.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

struct FetchPartAction: Action {
    var id: String
}

struct SetPartAction: Action {
    var id: String
    var name: String?
    var description: String?
    var price: Int
}
