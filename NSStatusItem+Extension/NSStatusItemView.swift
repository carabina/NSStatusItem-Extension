//
//  NSStatusItemView.swift
//  NSStatusItem Extension
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

class NSStatusItemView: NSView, NSMenuDelegate {
    
    var parentStatusItem:   NSStatusItem?
    var statusMenu:         NSMenu!
    
    var highlighted:        Bool                    = false
    var doesHighlight:      Bool                    = false
    var isDragged:          Bool                    = false
    var enabled:            Bool                    = true
    
    var image:              NSImage? {
        didSet {
            needsDisplay = true
        }
    }
    var alternateImage:     NSImage? {
        didSet {
            needsDisplay = true
        }
    }
    var dragImage:          NSImage? {
        didSet {
            needsDisplay = true
        }
    }
    var originalImage:      NSImage? {
        didSet {
            needsDisplay = true
        }
    }
    var title:              String? {
        didSet {
            let font  = NSFont.menuBarFontOfSize(NSFont.systemFontSize())
            let color = NSColor.controlTextColor()
            var paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = NSTextAlignment.CenterTextAlignment
            
            let attributes = NSDictionary(
                objects: [
                    font,
                    color,
                    paragraphStyle
                ],
                forKeys: [
                    NSFontAttributeName,
                    NSForegroundColorAttributeName,
                    NSParagraphStyleAttributeName
                ]
            )
            
            let attrTitle = NSAttributedString(
                string: title,
                attributes: attributes
            )
            
            attributedTitle = attrTitle
            needsDisplay = true
            adjustSize()
        }
    }
    var attributedTitle:    NSAttributedString? {
        didSet {
            needsDisplay = true
        }
    }
    var animFrames:         NSArray? {
        didSet {
            needsDisplay = true
        }
    }
    var animThread:         NSThread?
    var animFrameIndex:     NSInteger = -1
    
    var delegate:           NSStatusItemViewDelegate!
    var menuDelegate:       NSMenuDelegate!

    init(statusItem: NSStatusItem!) {
        let length = statusItem.length == CGFloat(NSVariableStatusItemLength) ? CGFloat(32.0) : statusItem.length
        let frame  = NSMakeRect(
            0,
            0,
            length,
            NSStatusBar.systemStatusBar().thickness
        )
        super.init(frame: frame)
        if self != nil {
            parentStatusItem = statusItem
            parentStatusItem!.addObserver(
                self,
                forKeyPath: "length",
                options:    NSKeyValueObservingOptions.New,
                context:    nil
            )
            animFrameIndex = -1
        }
    }
    
    deinit {
        parentStatusItem!.removeObserver(
            self,
            forKeyPath: "length"
        )
        title               = nil
        attributedTitle     = nil
        image               = nil
        alternateImage      = nil
        dragImage           = nil
        animFrames          = nil
        animThread          = nil
        delegate            = nil
        originalImage       = nil
        parentStatusItem    = nil
    }
    
    func adjustSize() {
        if parentStatusItem!.length == CGFloat(NSVariableStatusItemLength) {
            var newFrame = frame
            newFrame.size.width = image!.size.width + attributedTitle!.size.width + 16
            frame = newFrame
        }
    }
    
    func observeValueForKeyPath(keyPath: String, object: NSStatusItem, change: NSDictionary, context: voidPtr) {
        if parentStatusItem! == object && keyPath == "length" {
            if parentStatusItem!.length != CGFloat(NSVariableStatusItemLength) {
                var newFrame = frame
                newFrame.size.width = parentStatusItem!.length
                frame = newFrame
            } else {
                adjustSize()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Overrides
    
    override func rightMouseDown(theEvent: NSEvent!) {
        mouseDown(theEvent)
    }
    
    override func rightMouseUp(theEvent: NSEvent!) {
        mouseUp(theEvent)
    }
    
    override func mouseDown(theEvent: NSEvent!) {
        if parentStatusItem!.isEnabled() {
            highlighted = true
            needsDisplay = true
            parentStatusItem!.popUpStatusItemMenu(parentStatusItem!.menu)
            highlighted = false
            needsDisplay = true
        }
    }
    
    override func mouseUp(theEvent: NSEvent!) {
        highlighted = false
        needsDisplay = true
    }
    
    // MARK: NSMenu Delegate
    
    func menuWillOpen(aMenu: NSMenu!) {
        highlighted = true
        needsDisplay = true
        
        if menuDelegate?.respondsToSelector(Selector("menuDidClose:")) {
            menuDelegate.menuWillOpen!(aMenu)
        }
    }
    
    func menuDidClose(aMenu: NSMenu!) {
        highlighted = false
        needsDisplay = true
        
        if menuDelegate?.respondsToSelector(Selector("menuDidClose:")) {
            menuDelegate.menuDidClose!(aMenu)
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        var drawnImage = NSImage()
        if highlighted == true && doesHighlight == true {
            NSColor.selectedMenuItemColor().set()
            NSBezierPath.fillRect(bounds)
            if alternateImage {
                drawnImage = alternateImage!
            }
        } else {
            if isDragged == true {
                drawnImage = dragImage!
            } else {
                if animFrameIndex >= 0 && animFrameIndex < animFrames!.count {
                    drawnImage = animFrames!.objectAtIndex(animFrameIndex) as NSImage
                } else {
                    if image {
                        drawnImage = image!
                    }
                }
            }
        }
        
        var centeredRect = NSMakeRect(
            0,
            0,
            0,
            0
        )
        if drawnImage != nil {
            centeredRect = NSMakeRect(
                0,
                0,
                drawnImage.size.width,
                drawnImage.size.height
            )
            
            if attributedTitle {
                centeredRect.origin.x = 4
            } else {
                centeredRect.origin.x = NSMidX(bounds) - (drawnImage.size.width / 2)
            }
            
            centeredRect.origin.y = NSMidY(bounds) - (drawnImage.size.height / 2)
            centeredRect = NSIntegralRect(centeredRect)
            
            if highlighted == false {
                var shadow = NSShadow()
                shadow.shadowColor      = NSColor(calibratedWhite: 1.0, alpha: 0.6)
                shadow.shadowBlurRadius = CGFloat(0.0)
                shadow.shadowOffset     = NSMakeSize(0, -1)
                shadow.set()
            }
            
            drawnImage.drawInRect(
                centeredRect,
                fromRect: NSZeroRect,
                operation: NSCompositingOperation.CompositeSourceOver,
                fraction: 1.0
            )
        }
        
        if attributedTitle {
            var titleRect = NSMakeRect(
                centeredRect.size.width + 4,
                centeredRect.origin.y - 2,
                bounds.size.width - (centeredRect.size.width + 4),
                bounds.size.height - centeredRect.origin.y
            )
            
            var attrTitle = attributedTitle!.mutableCopy() as NSMutableAttributedString
            
            if highlighted == true && doesHighlight == true {
                attrTitle.addAttribute(
                    NSForegroundColorAttributeName,
                    value: NSColor.selectedMenuItemTextColor(),
                    range: NSMakeRange(0, attrTitle.length)
                )
            } else {
                var textShadow = NSShadow()
                textShadow.shadowColor  = NSColor(calibratedWhite: 1.0, alpha: 0.6)
                textShadow.shadowOffset = NSMakeSize(0, -1)
                attrTitle.addAttribute(
                    NSShadowAttributeName,
                    value: textShadow,
                    range: NSMakeRange(0, attrTitle.length)
                )
            }
            attrTitle.drawInRect(titleRect)
        }
    }
    
    // MARK: NSDraggingDestination protocol
    
    override func draggingEntered(sender: NSDraggingInfo!) -> NSDragOperation {
        isDragged    = true
        needsDisplay = true
        return delegate.statusItemView(self, draggingEntered: sender)
    }
    
    override func draggingEnded(sender: NSDraggingInfo!) {
        isDragged    = false
        needsDisplay = true
    }
    
   override func draggingExited(sender: NSDraggingInfo!) {
        isDragged    = false
        needsDisplay = true
        delegate.statusItemView(self, draggingExited: sender)
    }
    
    override func performDragOperation(sender: NSDraggingInfo!) -> Bool {
        isDragged    = false
        needsDisplay = true
        return delegate.statusItemView(self, performDragOperation: sender)
    }
    
    func startAnimation() {
        animThread = NSThread(
            target: self,
            selector: Selector("animationLoop"),
            object: nil
        )
        animThread!.start()
    }
    
    func stopAnimation() {
        var threadDict = animThread!.threadDictionary
        threadDict.setValue(
            NSNumber(bool: true),
            forKey: "ThreadShouldExitNow"
        )
    }
    
    func isAnimating() -> Bool {
        return nil != animThread && animFrameIndex >= -1
    }
    
    func animationLoop() {
        var moreWorkToDo = true
        var exitNow      = false
        
        var threadDict = NSThread.currentThread().threadDictionary
        threadDict.setValue(
            NSNumber(bool: exitNow),
            forKey: "ThreadShouldExitNow"
        )
        
        animFrameIndex = 0
        
        var fps = useconds_t((1.0/24.0) * 1000000) // 24fps
        while moreWorkToDo == true && exitNow == false {
            needsDisplay = true
            ++animFrameIndex
            if animFrameIndex >= animFrames!.count {
                animFrameIndex = 0;
            }
            usleep(fps)
            exitNow = (threadDict.valueForKey("ThreadShouldExitNow").boolValue || 0 == animFrames!.count)
        }
        
        animFrameIndex = -1;
        animThread!.cancel()
        animThread = nil
        
    }
}