//
//  HyperLinkTextField.swift
//  siro
//
//  Created by nainoya on 2019/11/28.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Cocoa

@IBDesignable
class HyperlinkTextField: NSTextField {
    @IBInspectable var href: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.attributedStringValue = NSAttributedString(string: self.stringValue, attributes: attributes)
    }

    override func mouseDown(with event: NSEvent) {
        NSWorkspace.shared.open(URL(string: self.href)!)
    }
}
