//
//  ViewController.swift
//  Test-Mac
//
//  Created by Archie You on 2021/1/14.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class SharedInstance: NSObject {
    static let shared = SharedInstance()
    var window = NSWindow()
}

class CV: NSCollectionView {
    override var acceptsFirstResponder: Bool {
        return true
    }
}

class A: NSObject {
    var B: Bool {
        didSet {
            print("B")
        }
    }
    override init() {
        B = true
        print("init")
        super.init()
    }
}

class ViewController: NSViewController {
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var v1: MouseView!
    @IBOutlet weak var v2: MouseView!
    @IBOutlet weak var roundView: RoundSameSideCornerView!
    @IBOutlet weak var iconView: FontelloIcon!
    @IBOutlet weak var label: FontelloLabelWithText!
    
    var fw = FloatingPanel()
    
    var shortcut = GlobalShortcutHander()
    var testDrawingBoard = TestDrawingBoard()
    
    static var count = 0
    
    let testWindowController = TestListWindowController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v1.wantsLayer = true
        v2.wantsLayer = true
        v1.layer?.backgroundColor = NSColor.red.cgColor
        v2.layer?.backgroundColor = NSColor.blue.cgColor
        
        roundView.cornerDirection = .antidiagonal
        view.wantsLayer = true
        
//        let font = NSFont(name: "momentum-ui-icons", size: 16)
//        print(font?.description)
//        let a = NSMutableAttributedString(string: "test", attributes: nil)
//        leftButton.attributedTitle = a
//
//        let v3 = NSView(frame: NSMakeRect(0, 0, 100, 100))
//        let v4 = NSView(frame: NSMakeRect(0, 0, 100, 100))
//        v4.wantsLayer = true
//        v4.layer?.backgroundColor = .black
//        view.addSubview(v3)
//        v3.addSubview(v4)
//        v3.isHidden = true
//
//
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//            print("view \(v3.isHidden) \(v4.visibleRect.isEmpty) \(self.view.window!.isVisible)")
//        }
        
//        let timer = Timer(timeInterval: 1, repeats: true) { _ in
//            ViewController.count += 1;
//            print(ViewController.count)
//         }
//        RunLoop.current.add(timer, forMode: .common)
        
        iconView.iconName = "I"
        iconView.iconSize = 20
        iconView.yOffset = 35
        iconView.layer?.cornerRadius = 30
        iconView.layer?.backgroundColor = NSColor.blue.cgColor
        
        setupLabel()
        
        testWindowController.registerTestCases(cases: testDrawingBoard)
        
        testWindowController.window?.makeKeyAndOrderFront(self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
//        print("viewWillAppear")
        SharedInstance.shared.window = self.view.window!
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        print("viewWillDisappear")
    }
    
    override func flagsChanged(with event: NSEvent) {
//        NSEventModifierFlags(rawValue: 65536) NSEventModifierFlags(rawValue: 131072)
//        capsLock down
//        57 NSEventModifierFlags(rawValue: 65536)
//        capsLock Up
//        57 NSEventModifierFlags(rawValue: 0)
//        shift down
//        56 NSEventModifierFlags(rawValue: 131072)
//        shift up
//        56 NSEventModifierFlags(rawValue: 0)
//        shift down with capsLock
//        56 NSEventModifierFlags(rawValue: 196608)
//        shift up with capsLock
//        56 NSEventModifierFlags(rawValue: 65536)
        if event.keyCode == kVK_Shift || event.keyCode == kVK_RightShift {
            print("\(event.modifierFlags.intersection(.deviceIndependentFlagsMask).rawValue & NSEvent.ModifierFlags.shift.rawValue == NSEvent.ModifierFlags.shift.rawValue)")
        }
    }
    
    @IBAction func onLeftButton(_ sender: Any) {
        print("onLeftButton")
//        let wc = MyWindow()
//        wc.showWindow(self)
//        NSApp.runModal(for: wc!.window!)
//        SPARK_LOG_DEBUG("\(wc.window?.windowNumber)")
//        wc = nil
        
//        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) {_ in
//            NSScreen.screens.forEach { print("\($0.frame)") }
//        }
        
//        let testWindow = TestWindow()
//        testWindow.test()
        
//        testWindowController.showWindow(self)
    }
    
    @IBAction func onRightButton(_ sender: Any) {
        print("onRightButton")
//        shortcut.registerAnswerCallHotKey(self, selectorName: "test")
    }
    
    @objc func test() {
        print("test")
    }

    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        print("test")
        return false
    }
    
    private func setupLabel() {
        label.labelText = "Hold  \u{fa0a}  to select multiple applications."
        label.boldText = "\u{fa0a}"
//        label.boldTextFont = .systemFont(ofSize: 20)
        label.boldTextFont = NSFont(name: "momentum-ui-icons", size: 20)
        
        label.fontSize = 16
        label.spacing = 8
        
        label.iconColour = .black
        label.textColour = .black
        label.boldTextBackgroundColor = .gray
    }
}
