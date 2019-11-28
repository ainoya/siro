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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
//            button.title = "🐣"
            button.image = NSImage(named:NSImage.Name("StatusBarImage"))
            button.action = #selector(togglePopover(_:))
        }
        AppDelegate.popover.contentViewController = ViewController.freshController()
        AppDelegate.popover.animates = false
        
        hotKey.keyDownHandler = {
            print("detected globalhotkey")
            self.showPopover(sender: nil)
        }
        
        constructMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any?) {
        print("toggle")
        if AppDelegate.popover.isShown {
            print("toggle close")
            closePopover(sender: sender)
        } else {
            print("toggle off")
            showPopover(sender: sender)
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
    
    func constructMenu() {
      let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Settings", action: #selector(showSettings(_:)), keyEquivalent: "s"))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit Siro", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }
    
    var windowController : NSWindowController!

    @objc func showSettings(_ sender: Any?) {
        let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
        windowController = mainStoryBoard.instantiateController(withIdentifier: "Settings") as? NSWindowController
        let settingsController = windowController.window!.contentViewController as! SettingsViewController
        // make initial settings before showing the window
        windowController.showWindow(self)
    }
}

