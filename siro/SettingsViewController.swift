//
//  SettingsViewController.swift
//  siro
//
//  Created by nainoya on 2019/11/27.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var slackToken: NSSecureTextField!
    @IBOutlet weak var slackChannel: NSTextField!
    
    @IBOutlet weak var slackTokenText: NSTextField!
    @IBAction func postMessageTest(_ sender: Any) {
        self.configureSlackService()
        AppDelegate.slackService?.postMessage(
            message: "This is test!!",
            success: { e in
                DispatchQueue.main.async {
                    let a = NSAlert()
                    a.alertStyle = .informational
                    a.messageText = "success!"
                    a.runModal()
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
    }
    
    override func viewDidAppear() {
        self.view.window?.delegate = self
//        NSApp.setActivationPolicy(.regular)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
//        NSApp.setActivationPolicy(.accessory)
        return true
    }


    @IBAction func save(_ sender: Any) {
        self.configureSlackService()
    }
    
    private func configureSlackService() {
        let s = SlackService(token: slackToken.stringValue, channel: slackChannel.stringValue)
        AppDelegate.slackService = s
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let s = AppDelegate.slackService
        slackChannel.stringValue = s?.channel ?? ""
        slackToken.stringValue = s?.token ?? ""
        self.view.window?.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
}
