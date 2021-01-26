//
//  UIViewControllerExtension.swift
//  TagPost
//
//  Created by Di on 2019/3/18.
//  Copyright © 2019 Di. All rights reserved.
//

import UIKit

extension UIViewController {
    func withNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}

// MARK: - Route

public extension UIViewController {
    @objc
    var rootVC: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    @objc
    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }

//    var visibleChildVC: UIViewController? {
//        let vc = topMost(of: rootVC)
//        if let child = vc?.children.first {
//            return child
//        }
//        return vc
//    }

    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }

    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }

    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        return viewController
    }

    func present(_ controller: UIViewController, _: Bool = false) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }

    func presentDissolve(_ controller: UIViewController,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }

    func presentFullScreen(_ controller: UIViewController,
                           animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }
}
