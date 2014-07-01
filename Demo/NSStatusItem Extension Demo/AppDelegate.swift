//
//  AppDelegate.swift
//  NSStatusItem Extension Demo
//
//  Copyright (c) 2014 Cai, Zhi-Wei & Anfa Sam. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Cocoa

protocol NSStatusItemViewDelegate {
    func statusItemView(view: NSStatusItemView, draggingEntered      sender: NSDraggingInfo!) -> NSDragOperation
    func statusItemView(view: NSStatusItemView, draggingEnded        sender: NSDraggingInfo!)
    func statusItemView(view: NSStatusItemView, draggingExited       sender: NSDraggingInfo!)
    func statusItemView(view: NSStatusItemView, performDragOperation sender: NSDraggingInfo!) -> Bool
}

class AppDelegate: NSObject, NSApplicationDelegate, NSStatusItemViewDelegate {
    
    var statusMenuItem: NSStatusItem!
    
    @IBOutlet var window: NSWindow
    @IBOutlet var button: NSButton
    @IBOutlet var field:  NSTextField
    @IBOutlet var statusMenu: NSMenu
    
    func applicationWillFinishLaunching(aNotification: NSNotification?) {
        
        println("Hello World!")
        
        let icon     = NSImage(named: "MenuIcon")
        let iconAlt  = NSImage(named: "MenuIconHighlight")
        let iconDrag = NSImage(named: "MenuIconDragged")
        
        statusMenuItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(NSVariableStatusItemLength))
        statusMenuItem.initialize(statusMenu)
        
        statusMenuItem.setImage(icon)
        statusMenuItem.setAlternateImage(iconAlt)
        statusMenuItem.setDragImage(iconDrag)
        
        statusMenuItem.title = "Test 🚀"
        
        statusMenuItem.setHighlightMode(true)
        statusMenuItem.setViewDelegate(self)
        statusMenuItem.view.registerForDraggedTypes([
            NSFilenamesPboardType,
            NSURLPboardType
        ])
        
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        window.level = 5 // kCGFloatingWindowLevelKey
    }
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    // MARK: NSStatusItemViewDelegate protocol
    
    func statusItemView(view: NSStatusItemView, draggingEntered sender: NSDraggingInfo!) -> NSDragOperation {
        println("Drag entered!")
        return NSDragOperation.Copy
    }
    
    func statusItemView(view: NSStatusItemView, draggingExited sender: NSDraggingInfo!) {
        println("Dragging exit")
    }
    
    func statusItemView(view: NSStatusItemView, draggingEnded sender: NSDraggingInfo!) {
        println("Drag ended!")
    }
    
    func statusItemView(view: NSStatusItemView, performDragOperation sender: NSDraggingInfo!) -> Bool {
        println("Drag performed!")
        return true
    }
    
    // MARK: IBActions
    
    @IBAction func setTitle(sender : AnyObject) {
        statusMenuItem.title = sender.stringValue
    }
    
    @IBAction func switchEnabled(sender : AnyObject) {
        statusMenuItem.enabled = sender.state == NSOnState
    }
    
}

