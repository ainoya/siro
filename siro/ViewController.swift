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
            self.keyDown(with: $0)
            return $0
        }
        textField.string = ""
        // Do any additional setupa after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.command] where event.keyCode == 36 || event.keyCode == 76:
            print("command-enter")
            AppDelegate.slackService?.postMessage(
                message: textField.string,
                success: { _ in
                    DispatchQueue.main.async {
                        self.textField.string = ""
                        AppDelegate.popover.performClose(nil)
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
            
        case _ where event.keyCode == 53:
            AppDelegate.popover.performClose(nil)
        default:
            break
        }
//        print("key = " + (event.charactersIgnoringModifiers
//            ?? ""))
//        print("ncharacter = " + (event.characters ?? ""))
//        print("keycode \(event.keyCode)")
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
      fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
