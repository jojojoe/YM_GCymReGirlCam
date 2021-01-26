//
//  Extension.swift
//  TagPost
//
//  Created by Di on 2019/3/19.
//  Copyright © 2019 Di. All rights reserved.
//

import CommonCrypto
import SwifterSwift
import Then

public extension Int {
    func k() -> String {
        if self >= 1000 {
            var sign: String {
                return self >= 0 ? "" : "-"
            }
            let abs = Swift.abs(self)
            if abs >= 1000, abs < 1_000_000 {
                return String(format: "\(sign)%.1fK", abs.double / 1000.0)
            }
            return String(format: "\(sign)%.1fM", abs.double / 1_000_000.0)
        }
        return string
    }
}

public extension UIDevice {
    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }
}

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
