//
//  SuprressKeySound.swift
//  siro
//
//  Created by nainoya on 2019/11/27.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Cocoa

class View: NSView {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}
