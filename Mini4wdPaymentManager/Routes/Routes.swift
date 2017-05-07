//
//  Routes.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import UIKit
import ReSwiftRouter

let topViewRoute: RouteElementIdentifier = "Top"
let addPayemntViewRoute: RouteElementIdentifier = "AddPayment"

class RootRoutable: Routable {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func setToTopViewController() -> Routable {
        let storyboard = UIStoryboard(name: "TopViewController", bundle: nil)
        self.window.rootViewController = storyboard.instantiateViewController(withIdentifier: "TopViewController")
        return TopViewRoutable(self.window.rootViewController!)
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        completionHandler()
        return self.setToTopViewController()
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {
        completionHandler()
    }
}

class TopViewRoutable: Routable {
    let viewController: UIViewController

    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                          animated: Bool,
                          completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        let storyboard = UIStoryboard(name: "TopViewController", bundle: nil)
        let topVC = storyboard.instantiateViewController(withIdentifier: "TopViewController")
        (self.viewController as! UINavigationController).pushViewController(topVC, animated: true)
        return TopViewRoutable(self.viewController) // FIXME: Correct Routable class
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                         animated: Bool,
                         completionHandler: @escaping RoutingCompletionHandler) {
        completionHandler()
    }
}
