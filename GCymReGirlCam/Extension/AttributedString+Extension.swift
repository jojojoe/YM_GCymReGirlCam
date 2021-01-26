//
//  NSAttributedString+Extension.swift
//  Roadshow
//
//  Created by Di on 2018/11/19.
//  Copyright © 2018 GuruClub. All rights reserved.
//

import Foundation
import UIKit

public class Attribute {
    let text: String
    private var font: UIFont = UIFont.systemFont(ofSize: 14)
    private var color: UIColor = UIColor.white
    private var lineSpacing: CGFloat = 0
    private var link: URL?
    private var single: Bool = false
    private var alignment: NSTextAlignment = .left

    public init(_ text: String) {
        self.text = text
    }

    var config: [NSAttributedString.Key: Any] {
        var keys: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font,
            .paragraphStyle: NSMutableParagraphStyle()
                .then {
                    $0.lineSpacing = lineSpacing
                    $0.alignment = alignment
                },
            .strikethroughStyle: single ? NSUnderlineStyle.single.rawValue : 0,
        ]
        if let link = self.link {
            keys[.link] = link
        }
        return keys
    }
}

public extension Attribute {
    @discardableResult
    func font(_ value: CGFloat, _ bold: Bool = false) -> Self {
        font = bold ? UIFont.boldSystemFont(ofSize: value) : UIFont.systemFont(ofSize: value)
        return self
    }

    @discardableResult
    func font(_ value: CGFloat, _ fontName: UIFont.FontNames) -> Self {
        font = UIFont.custom(value, name: fontName)
        return self
    }

    @discardableResult
    func font(_ value: UIFont) -> Self {
        font = value
        return self
    }

    @discardableResult
    func color(_ value: String) -> Self {
        color = UIColor(hexString: value) ?? .white
        return self
    }

    @discardableResult
    func color(_ value: UIColor) -> Self {
        color = value
        return self
    }

    @discardableResult
    func lineSpacing(_ value: CGFloat) -> Self {
        lineSpacing = value
        return self
    }

    @discardableResult
    func link(_ value: URL?) -> Self {
        link = value
        return self
    }

    @discardableResult
    func single(_ value: Bool = true) -> Self {
        single = value
        return self
    }

    @discardableResult
    func alignment(_ value: NSTextAlignment) -> Self {
        alignment = value
        return self
    }
}

public extension NSAttributedString {
    convenience init(_ attributesConfig: [Attribute]) {
        let mutableAttributedString = NSMutableAttributedString()
        attributesConfig.forEach {
            mutableAttributedString.append(NSAttributedString(string: $0.text, attributes: $0.config))
        }
        self.init(attributedString: mutableAttributedString)
    }
}

public extension String {
    var singleStyle: NSAttributedString {
        let textRange = NSMakeRange(0, count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        return attributedText
    }
}
