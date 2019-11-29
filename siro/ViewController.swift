//
//  ViewController.swift
//  siro
//
//  Created by nainoya on 2019/11/27.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var textField: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            if self.myKeyDown(with: $0) {
                return nil
            } else {
                return $0
            }
        }
        textField.string = ""
        // Do any additional setupa after loading the view.
    }
    
    @IBAction func closeButton(_ sender: NSButton) {
        AppDelegate.popover.performClose(nil)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func myKeyDown(with event: NSEvent) -> Bool {
        guard let locWindow = self.view.window,
           NSApplication.shared.keyWindow === locWindow else { return false }
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.command] where event.keyCode == 36 || event.keyCode == 76:
            AppDelegate.slackService?.postMessage(
                message: textField.string,
                success: { _ in
                    DispatchQueue.main.async {
                        self.textField.string = ""
                        //                        AppDelegate.popover.performClose(nil)
                    }
            },
                failure: { e in
                    DispatchQueue.main.async {
                        let a = NSAlert()
                        a.alertStyle = .critical
                        a.messageText = "failed posting message to slack: \(e)"
                        a.runModal()
                    }
            }
            )
            return true
        case _ where event.keyCode == 53:
            AppDelegate.popover.performClose(nil)
            return true
        default:
            return false
        }
    }
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}


extension ViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("StatusBarWindow")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
