//
//  AppDelegate.swift
//  siro
//
//  Created by nainoya on 2019/11/27.
//  Copyright © 2019 ainoya.tokyo. All rights reserved.
//

import Cocoa
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    static let popover = NSPopover()
    let hotKey = HotKey(key: .m, modifiers: [.control, .shift])
    static var slackService: SlackService? = SlackService.restore()
    
    @IBOutlet weak var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            //            button.title = "🐣"
            button.image = NSImage(named:NSImage.Name("StatusBarImage"))
            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        AppDelegate.popover.contentViewController = ViewController.freshController()
        AppDelegate.popover.animates = false
        
        hotKey.keyDownHandler = {
            self.showPopover(sender: nil)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any?) {
        print("event \(NSApp.currentEvent!.type)")
        switch NSApp.currentEvent!.type {
        case .rightMouseUp:
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        default:
            if AppDelegate.popover.isShown {
                closePopover(sender: sender)
            } else {
                showPopover(sender: sender)
            }
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY )
        }
    }
    
    func closePopover(sender: Any?) {
        AppDelegate.popover.performClose(sender)
    }
    
    
    var windowController : NSWindowController!
    
    
    @IBAction func quit(_ sender: Any) {
        let _ = NSApplication.terminate(_:)
    }
    
    @IBAction func showSiroSettings(_ sender: Any) {
        let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
        windowController = mainStoryBoard.instantiateController(withIdentifier: "Settings") as? NSWindowController
        // make initial settings before showing the window
        windowController.showWindow(self)
    }
}

