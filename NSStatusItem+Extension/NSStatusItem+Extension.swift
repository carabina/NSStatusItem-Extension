//
//  NSStatusItem+Extension.swift
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

extension NSStatusItem {
    
    func initialize(aMenu: NSMenu!) {
        var aView = NSStatusItemView(statusItem: self)
        menu = aMenu
        if aView != nil {
            view = aView
            menu.delegate = aView
        }
    }
    
    func setAllowsDragging(dragging: Bool) {
        
    }
    
    func setDraggingTypes(types: NSArray) {
        
    }
    
    func draggingTypes() -> NSArray? {
        return nil
    }
    
    func frame() -> NSRect {
        return view.window.frame
    }
    
    func _setMenu(aMenu: NSMenu!) {
        menu = aMenu
        menu.delegate = view as NSMenuDelegate
    }
    
    func _setMenuDelegate(aMenuDelegate: NSMenuDelegate!) {
        (view as NSStatusItemView).menuDelegate = aMenuDelegate
    }
    
    func setViewDelegate(aDelegate: NSStatusItemViewDelegate!) {
        (view as NSStatusItemView).delegate = aDelegate
    }
    
    // MARK: Overrides
    
    func setImage(anImage: NSImage!) {
        (view as NSStatusItemView).image = anImage
    }
    
    func setAlternateImage(anImage: NSImage!) {
        (view as NSStatusItemView).alternateImage = anImage
    }
    
    func setDragImage(anImage: NSImage!) {
        (view as NSStatusItemView).dragImage = anImage
    }
    
    func setOriginalImage(anImage: NSImage!) {
        (view as NSStatusItemView).originalImage = anImage
    }
    
    func setAnimFrames(theAnimFrames: NSArray!) {
        (view as NSStatusItemView).animFrames = theAnimFrames
    }
    
    func setHighlightMode(theHighlightMode: Bool) {
        (view as NSStatusItemView).doesHighlight = theHighlightMode
    }
    
    func setTitle(aTitle: String!) {
        (view as NSStatusItemView).title = aTitle
    }
    
    func setAttributedTitle(anAttrTitle: NSAttributedString) {
        (view as NSStatusItemView).attributedTitle = anAttrTitle
    }
    
    func setToolTip(aToolTip: String!) {
        (view as NSStatusItemView).toolTip = aToolTip
    }
    
    func isEnabled() -> Bool {
        return (view as NSStatusItemView).enabled
    }
    
    func setEnabled(isEnabled: Bool) {
        (view as NSStatusItemView).enabled = isEnabled
    }
    
    func startAnimation() {
        (view as NSStatusItemView).startAnimation()
    }
    
    func stopAnimation() {
        (view as NSStatusItemView).stopAnimation()
    }
    
    func isAnimating() -> Bool {
        return (view as NSStatusItemView).isAnimating()
    }
    
}
